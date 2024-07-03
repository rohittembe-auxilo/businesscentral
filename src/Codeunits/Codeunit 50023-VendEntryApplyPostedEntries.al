codeunit 50023 VendEntryApplyPostedEntries
{
    trigger OnRun()
    begin

    end;

    var
        GLSetup: Record "General Ledger Setup";
        GenJnlBatch: Record "Gen. Journal Batch";
        VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";


        PostingApplicationMsg: Label 'Posting application...';
        MustNotBeBeforeErr: Label 'The posting date entered must not be before the posting date on the vendor ledger entry.';
        NoEntriesAppliedErr: Label 'Cannot post because you did not specify which entry to apply. You must specify an entry in the %1 field for one or more open entries.', Comment = '%1 - Caption of "Applies to ID" field of Gen. Journal Line';
        UnapplyPostedAfterThisEntryErr: Label 'Before you can unapply this entry, you must first unapply all application entries that were posted after this entry.';
        NoApplicationEntryErr: Label 'Vendor Ledger Entry No. %1 does not have an application entry.';
        UnapplyingMsg: Label 'Unapplying and posting...';
        UnapplyAllPostedAfterThisEntryErr: Label 'Before you can unapply this entry, you must first unapply all application entries in Vendor Ledger Entry No. %1 that were posted after this entry.';
        NotAllowedPostingDatesErr: Label 'Posting date is not within the range of allowed posting dates.';
        LatestEntryMustBeApplicationErr: Label 'The latest Transaction No. must be an application in Vendor Ledger Entry No. %1.';
        CannotUnapplyExchRateErr: Label 'You cannot unapply the entry with the posting date %1, because the exchange rate for the additional reporting currency has been changed.';
        CannotUnapplyInReversalErr: Label 'You cannot unapply Vendor Ledger Entry No. %1 because the entry is part of a reversal.';
        CannotApplyClosedEntriesErr: Label 'One or more of the entries that you selected is closed. You cannot apply closed entries.';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", OnBeforeDateNotAllowed, '', false, false)]
    local procedure OnBeforeDateNotAllowed(var Sender: Codeunit "Gen. Jnl.-Check Line"; GenJnlLine: Record "Gen. Journal Line"; var DateCheckDone: Boolean)
    begin
        if GenJnlLine."Source Code" = 'PURCHAPPL' then
            DateCheckDone := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"VendEntry-Apply Posted Entries", OnBeforePostUnApplyVendorCommit, '', false, false)]
    local procedure OnBeforePostUnApplyVendorCommit(var HideProgressWindow: Boolean; PreviewMode: Boolean; DetailedVendLedgEntry2: Record "Detailed Vendor Ledg. Entry"; DocNo: Code[20]; PostingDate: Date; CommitChanges: Boolean; var IsHandled: Boolean)
    var
        GLEntry: Record "G/L Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlLine: Record "Gen. Journal Line";
        DateComprReg: Record "Date Compr. Register";
        TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        Window: Dialog;
        AddCurrChecked: Boolean;
        MaxPostingDate: Date;
    begin
        MaxPostingDate := 0D;
        GLEntry.LockTable();
        DtldVendLedgEntry.LockTable();
        VendLedgEntry.LockTable();
        VendLedgEntry.Get(DetailedVendLedgEntry2."Vendor Ledger Entry No.");
        if GenJnlBatch.Get(VendLedgEntry."Journal Templ. Name", VendLedgEntry."Journal Batch Name") then;
        //CheckPostingDate(ApplyUnapplyParameters, MaxPostingDate);
        if PostingDate < DetailedVendLedgEntry2."Posting Date" then
            Error(MustNotBeBeforeErr);

        if DetailedVendLedgEntry2."Transaction No." = 0 then begin
            DtldVendLedgEntry.SetCurrentKey("Application No.", "Vendor No.", "Entry Type");
            DtldVendLedgEntry.SetRange("Application No.", DetailedVendLedgEntry2."Application No.");
        end else begin
            DtldVendLedgEntry.SetCurrentKey("Transaction No.", "Vendor No.", "Entry Type");
            DtldVendLedgEntry.SetRange("Transaction No.", DetailedVendLedgEntry2."Transaction No.");
        end;
        DtldVendLedgEntry.SetRange("Vendor No.", DetailedVendLedgEntry2."Vendor No.");
        DtldVendLedgEntry.SetFilter("Entry Type", '<>%1', DtldVendLedgEntry."Entry Type"::"Initial Entry");
        DtldVendLedgEntry.SetRange(Unapplied, false);
        if DtldVendLedgEntry.Find('-') then
            repeat
                if not AddCurrChecked then begin
                    CheckAdditionalCurrency(PostingDate, DtldVendLedgEntry."Posting Date");
                    AddCurrChecked := true;
                end;
                VendEntryApplyPostedEntries.CheckReversal(DtldVendLedgEntry."Vendor Ledger Entry No.");
                if DtldVendLedgEntry."Transaction No." <> 0 then
                    CheckUnappliedEntries(DtldVendLedgEntry);
            until DtldVendLedgEntry.Next() = 0;

        DateComprReg.CheckMaxDateCompressed(MaxPostingDate, 0);

        GLSetup.GetRecordOnce();
        SourceCodeSetup.Get();
        VendLedgEntry.Get(DetailedVendLedgEntry2."Vendor Ledger Entry No.");
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine."VAT Reporting Date" := GenJnlLine."Posting Date";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine."Account No." := DetailedVendLedgEntry2."Vendor No.";
        GenJnlLine.Correction := true;
        GenJnlLine.CopyVendLedgEntry(VendLedgEntry);
        GenJnlLine."Source Code" := SourceCodeSetup."Unapplied Purch. Entry Appln.";
        GenJnlLine."Source Currency Code" := DetailedVendLedgEntry2."Currency Code";
        GenJnlLine."System-Created Entry" := true;
        if GLSetup."Journal Templ. Name Mandatory" then begin
            GenJnlLine."Journal Template Name" := GLSetup."Apply Jnl. Template Name";
            GenJnlLine."Journal Batch Name" := GLSetup."Apply Jnl. Batch Name";
        end;
        if not HideProgressWindow then
            Window.Open(UnapplyingMsg);

        CollectAffectedLedgerEntries(TempVendorLedgerEntry, DetailedVendLedgEntry2);
        GenJnlPostLine.UnapplyVendLedgEntry(GenJnlLine, DetailedVendLedgEntry2);
        RunVendExchRateAdjustment(GenJnlLine, TempVendorLedgerEntry);

        if PreviewMode then
            GenJnlPostPreview.ThrowError();

        if CommitChanges then
            Commit();
        if not HideProgressWindow then
            Window.Close();
        IsHandled := true;
    end;

    local procedure CheckPostingDate(ApplyUnapplyParameters: Record "Apply Unapply Parameters"; var MaxPostingDate: Date)
    var
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
    begin
        GenJnlCheckLine.SetGenJnlBatch(GenJnlBatch);
        if GenJnlCheckLine.DateNotAllowed(ApplyUnapplyParameters."Posting Date") then
            Error(NotAllowedPostingDatesErr);

        if ApplyUnapplyParameters."Posting Date" > MaxPostingDate then
            MaxPostingDate := ApplyUnapplyParameters."Posting Date";
    end;

    local procedure CheckAdditionalCurrency(OldPostingDate: Date; NewPostingDate: Date)
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if OldPostingDate = NewPostingDate then
            exit;
        GLSetup.GetRecordOnce();
        if GLSetup."Additional Reporting Currency" <> '' then
            if CurrExchRate.ExchangeRate(OldPostingDate, GLSetup."Additional Reporting Currency") <>
               CurrExchRate.ExchangeRate(NewPostingDate, GLSetup."Additional Reporting Currency")
            then
                Error(CannotUnapplyExchRateErr, NewPostingDate);
    end;

    local procedure CheckUnappliedEntries(DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        LastTransactionNo: Integer;
        IsHandled: Boolean;
    begin
        if DtldVendLedgEntry."Entry Type" = DtldVendLedgEntry."Entry Type"::Application then begin
            LastTransactionNo := FindLastApplTransactionEntry(DtldVendLedgEntry."Vendor Ledger Entry No.");
            IsHandled := false;
            if not IsHandled then
                if (LastTransactionNo <> 0) and (LastTransactionNo <> DtldVendLedgEntry."Transaction No.") then
                    Error(UnapplyAllPostedAfterThisEntryErr, DtldVendLedgEntry."Vendor Ledger Entry No.");
        end;
        LastTransactionNo := FindLastTransactionNo(DtldVendLedgEntry."Vendor Ledger Entry No.");
        if (LastTransactionNo <> 0) and (LastTransactionNo <> DtldVendLedgEntry."Transaction No.") then
            Error(LatestEntryMustBeApplicationErr, DtldVendLedgEntry."Vendor Ledger Entry No.");
    end;

    local procedure CollectAffectedLedgerEntries(var TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary; DetailedVendorLedgEntry2: Record "Detailed Vendor Ledg. Entry")
    var
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        TempVendorLedgerEntry.DeleteAll();

        if DetailedVendorLedgEntry2."Transaction No." = 0 then begin
            DetailedVendorLedgEntry.SetCurrentKey("Application No.", "Vendor No.", "Entry Type");
            DetailedVendorLedgEntry.SetRange("Application No.", DetailedVendorLedgEntry2."Application No.");
        end else begin
            DetailedVendorLedgEntry.SetCurrentKey("Transaction No.", "Vendor No.", "Entry Type");
            DetailedVendorLedgEntry.SetRange("Transaction No.", DetailedVendorLedgEntry2."Transaction No.");
        end;
        DetailedVendorLedgEntry.SetRange("Vendor No.", DetailedVendorLedgEntry2."Vendor No.");
        DetailedVendorLedgEntry.SetFilter("Entry Type", '<>%1', DetailedVendorLedgEntry."Entry Type"::"Initial Entry");
        DetailedVendorLedgEntry.SetRange(Unapplied, false);
        if DetailedVendorLedgEntry.FindSet() then
            repeat
                TempVendorLedgerEntry."Entry No." := DetailedVendorLedgEntry."Vendor Ledger Entry No.";
                if TempVendorLedgerEntry.Insert() then;
            until DetailedVendorLedgEntry.Next() = 0;
    end;

    local procedure RunVendExchRateAdjustment(var GenJnlLine: Record "Gen. Journal Line"; var TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary)
    var
        ExchRateAdjmtRunHandler: Codeunit "Exch. Rate Adjmt. Run Handler";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        ExchRateAdjmtRunHandler.RunVendExchRateAdjustment(GenJnlLine, TempVendorLedgerEntry);
    end;

    local procedure FindLastApplTransactionEntry(VendLedgEntryNo: Integer): Integer
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        LastTransactionNo: Integer;
    begin
        DtldVendLedgEntry.SetCurrentKey("Vendor Ledger Entry No.", "Entry Type");
        DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgEntryNo);
        DtldVendLedgEntry.SetRange("Entry Type", DtldVendLedgEntry."Entry Type"::Application);
        LastTransactionNo := 0;
        if DtldVendLedgEntry.Find('-') then
            repeat
                if (DtldVendLedgEntry."Transaction No." > LastTransactionNo) and not DtldVendLedgEntry.Unapplied then
                    LastTransactionNo := DtldVendLedgEntry."Transaction No.";
            until DtldVendLedgEntry.Next() = 0;
        exit(LastTransactionNo);
    end;

    local procedure FindLastTransactionNo(VendLedgEntryNo: Integer): Integer
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        LastTransactionNo: Integer;
    begin
        DtldVendLedgEntry.SetCurrentKey("Vendor Ledger Entry No.", "Entry Type");
        DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgEntryNo);
        DtldVendLedgEntry.SetRange(Unapplied, false);
        DtldVendLedgEntry.SetFilter(
            "Entry Type", '<>%1&<>%2',
            DtldVendLedgEntry."Entry Type"::"Unrealized Loss", DtldVendLedgEntry."Entry Type"::"Unrealized Gain");
        LastTransactionNo := 0;
        if DtldVendLedgEntry.FindSet() then
            repeat
                if LastTransactionNo < DtldVendLedgEntry."Transaction No." then
                    LastTransactionNo := DtldVendLedgEntry."Transaction No.";
            until DtldVendLedgEntry.Next() = 0;
        exit(LastTransactionNo);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnBeforeCheckPostingDate', '', false, false)]
    local procedure OnBeforeCheckPostingDate(PostingDate: Date; Caption: Text[50]; EntryNo: Integer; var IsHandled: Boolean; var ReversalEntry: Record "Reversal Entry"; var MaxPostingDate: Date);
    begin
        IsHandled := true;
    end;
}