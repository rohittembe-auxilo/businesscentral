codeunit 50028 ReversalMgmt
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeIsDateNotAllowed', '', false, false)]
    local procedure OnBeforeIsDateNotAllowed(PostingDate: Date; SetupRecordID: RecordId; GenJnlBatch: Record "Gen. Journal Batch"; var DateIsNotAllowed: Boolean; var IsHandled: Boolean)
    var
        GenJournalLine: Record "Gen. Journal Line";
        RecRef: RecordRef;
    begin
        //RecRef.Open(Database::"Fixed Asset");
        // RecRef.Get(SetupRecordID);
        // SetupRecordID.GetRecord().SetTable(GenJournalLine);
        // if GenJournalLine."Reversing Entry" then
        //     IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustEntry-Apply Posted Entries", 'OnBeforePostUnApplyCustomerCommit', '', false, false)]
    local procedure OnBeforePostUnApplyCustomerCommit(var HideProgressWindow: Boolean; PreviewMode: Boolean; DetailedCustLedgEntry2: Record "Detailed Cust. Ledg. Entry"; DocNo: Code[20]; PostingDate: Date; CommitChanges: Boolean; var IsHandled: Boolean);
    var
        GLEntry: Record "G/L Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlLine: Record "Gen. Journal Line";
        DateComprReg: Record "Date Compr. Register";
        TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        Window: Dialog;
        AddCurrChecked: Boolean;
        MaxPostingDate: Date;
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        MaxPostingDate := 0D;
        GLEntry.LockTable();
        DtldCustLedgEntry.LockTable();
        CustLedgEntry.LockTable();
        CustLedgEntry.Get(DetailedCustLedgEntry2."Cust. Ledger Entry No.");
        if GenJnlBatch.Get(CustLedgEntry."Journal Templ. Name", CustLedgEntry."Journal Batch Name") then;
        //>> ST
        //CheckPostingDate(ApplyUnapplyParameters, MaxPostingDate);
        //<< ST
        if PostingDate < DetailedCustLedgEntry2."Posting Date" then
            Error(MustNotBeBeforeErr);

        if DetailedCustLedgEntry2."Transaction No." = 0 then begin
            DtldCustLedgEntry.SetCurrentKey("Application No.", "Customer No.", "Entry Type");
            DtldCustLedgEntry.SetRange("Application No.", DetailedCustLedgEntry2."Application No.");
        end else begin
            DtldCustLedgEntry.SetCurrentKey("Transaction No.", "Customer No.", "Entry Type");
            DtldCustLedgEntry.SetRange("Transaction No.", DetailedCustLedgEntry2."Transaction No.");
        end;
        DtldCustLedgEntry.SetRange("Customer No.", DetailedCustLedgEntry2."Customer No.");
        DtldCustLedgEntry.SetFilter("Entry Type", '<>%1', DtldCustLedgEntry."Entry Type"::"Initial Entry");
        DtldCustLedgEntry.SetRange(Unapplied, false);
        if DtldCustLedgEntry.Find('-') then
            repeat
                if not AddCurrChecked then begin
                    CheckAdditionalCurrency(PostingDate, DtldCustLedgEntry."Posting Date");
                    AddCurrChecked := true;
                end;
                CheckReversal(DtldCustLedgEntry."Cust. Ledger Entry No.");
                if DtldCustLedgEntry."Transaction No." <> 0 then
                    CheckUnappliedEntries(DtldCustLedgEntry);
            until DtldCustLedgEntry.Next() = 0;

        DateComprReg.CheckMaxDateCompressed(MaxPostingDate, 0);

        GLSetup.GetRecordOnce();
        SourceCodeSetup.Get();
        CustLedgEntry.Get(DetailedCustLedgEntry2."Cust. Ledger Entry No.");
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine."VAT Reporting Date" := GenJnlLine."Posting Date";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := DetailedCustLedgEntry2."Customer No.";
        GenJnlLine.Correction := true;
        GenJnlLine.CopyCustLedgEntry(CustLedgEntry);
        GenJnlLine."Source Code" := SourceCodeSetup."Unapplied Sales Entry Appln.";
        GenJnlLine."Source Currency Code" := DetailedCustLedgEntry2."Currency Code";
        GenJnlLine."System-Created Entry" := true;
        if GLSetup."Journal Templ. Name Mandatory" then begin
            GenJnlLine."Journal Template Name" := GLSetup."Apply Jnl. Template Name";
            GenJnlLine."Journal Batch Name" := GLSetup."Apply Jnl. Batch Name";
        end;
        if not HideProgressWindow then
            Window.Open(UnapplyingMsg);

        CollectAffectedLedgerEntries(TempCustLedgerEntry, DetailedCustLedgEntry2);
        GenJnlPostLine.UnapplyCustLedgEntry(GenJnlLine, DetailedCustLedgEntry2);
        RunCustExchRateAdjustment(GenJnlLine, TempCustLedgerEntry);

        if PreviewMode then
            GenJnlPostPreview.ThrowError();

        if CommitChanges then
            Commit();
        if not HideProgressWindow then
            Window.Close();
        IsHandled := true;
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

    procedure CheckReversal(CustLedgEntryNo: Integer)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.Get(CustLedgEntryNo);
        if CustLedgEntry.Reversed then
            Error(CannotUnapplyInReversalErr, CustLedgEntryNo);
    end;

    local procedure CheckUnappliedEntries(DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    var
        LastTransactionNo: Integer;
        IsHandled: Boolean;
    begin
        if DtldCustLedgEntry."Entry Type" = DtldCustLedgEntry."Entry Type"::Application then begin
            LastTransactionNo := FindLastApplTransactionEntry(DtldCustLedgEntry."Cust. Ledger Entry No.");
            IsHandled := false;
            if not IsHandled then
                if (LastTransactionNo <> 0) and (LastTransactionNo <> DtldCustLedgEntry."Transaction No.") then
                    Error(UnapplyAllPostedAfterThisEntryErr, DtldCustLedgEntry."Cust. Ledger Entry No.");
        end;
        LastTransactionNo := FindLastTransactionNo(DtldCustLedgEntry."Cust. Ledger Entry No.");
        if (LastTransactionNo <> 0) and (LastTransactionNo <> DtldCustLedgEntry."Transaction No.") then
            Error(LatestEntryMustBeApplicationErr, DtldCustLedgEntry."Cust. Ledger Entry No.");
    end;

    local procedure FindLastApplTransactionEntry(CustLedgEntryNo: Integer): Integer
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        LastTransactionNo: Integer;
    begin
        DtldCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type");
        DtldCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgEntryNo);
        DtldCustLedgEntry.SetRange("Entry Type", DtldCustLedgEntry."Entry Type"::Application);
        LastTransactionNo := 0;
        if DtldCustLedgEntry.Find('-') then
            repeat
                if (DtldCustLedgEntry."Transaction No." > LastTransactionNo) and not DtldCustLedgEntry.Unapplied then
                    LastTransactionNo := DtldCustLedgEntry."Transaction No.";
            until DtldCustLedgEntry.Next() = 0;
        exit(LastTransactionNo);
    end;

    local procedure CollectAffectedLedgerEntries(var TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary; DetailedCustLedgEntry2: Record "Detailed Cust. Ledg. Entry")
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        TempCustLedgerEntry.DeleteAll();

        if DetailedCustLedgEntry2."Transaction No." = 0 then begin
            DetailedCustLedgEntry.SetCurrentKey("Application No.", "Customer No.", "Entry Type");
            DetailedCustLedgEntry.SetRange("Application No.", DetailedCustLedgEntry2."Application No.");
        end else begin
            DetailedCustLedgEntry.SetCurrentKey("Transaction No.", "Customer No.", "Entry Type");
            DetailedCustLedgEntry.SetRange("Transaction No.", DetailedCustLedgEntry2."Transaction No.");
        end;
        DetailedCustLedgEntry.SetRange("Customer No.", DetailedCustLedgEntry2."Customer No.");
        DetailedCustLedgEntry.SetFilter("Entry Type", '<>%1', DetailedCustLedgEntry."Entry Type"::"Initial Entry");
        DetailedCustLedgEntry.SetRange(Unapplied, false);
        if DetailedCustLedgEntry.FindSet() then
            repeat
                TempCustLedgerEntry."Entry No." := DetailedCustLedgEntry."Cust. Ledger Entry No.";
                if TempCustLedgerEntry.Insert() then;
            until DetailedCustLedgEntry.Next() = 0;
    end;

    local procedure RunCustExchRateAdjustment(var GenJnlLine: Record "Gen. Journal Line"; var TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary)
    var
        ExchRateAdjmtRunHandler: Codeunit "Exch. Rate Adjmt. Run Handler";
        IsHandled: Boolean;
    begin
        ExchRateAdjmtRunHandler.RunCustExchRateAdjustment(GenJnlLine, TempCustLedgerEntry);
    end;

    local procedure FindLastTransactionNo(CustLedgEntryNo: Integer): Integer
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        LastTransactionNo: Integer;
    begin
        DtldCustLedgEntry.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type");
        DtldCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgEntryNo);
        DtldCustLedgEntry.SetRange(Unapplied, false);
        DtldCustLedgEntry.SetFilter(
            "Entry Type", '<>%1&<>%2',
            DtldCustLedgEntry."Entry Type"::"Unrealized Loss", DtldCustLedgEntry."Entry Type"::"Unrealized Gain");
        LastTransactionNo := 0;
        if DtldCustLedgEntry.FindSet() then
            repeat
                if LastTransactionNo < DtldCustLedgEntry."Transaction No." then
                    LastTransactionNo := DtldCustLedgEntry."Transaction No.";
            until DtldCustLedgEntry.Next() = 0;
        exit(LastTransactionNo);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        MustNotBeBeforeErr: Label 'The posting date entered must not be before the posting date on the Cust. Ledger Entry.';
        CannotUnapplyInReversalErr: Label 'You cannot unapply Cust. Ledger Entry No. %1 because the entry is part of a reversal.';
        CannotUnapplyExchRateErr: Label 'You cannot unapply the entry with the posting date %1, because the exchange rate for the additional reporting currency has been changed.';
        UnapplyAllPostedAfterThisEntryErr: Label 'Before you can unapply this entry, you must first unapply all application entries in Cust. Ledger Entry No. %1 that were posted after this entry.';
        UnapplyingMsg: Label 'Unapplying and posting...';
        LatestEntryMustBeApplicationErr: Label 'The latest Transaction No. must be an application in Cust. Ledger Entry No. %1.';
}