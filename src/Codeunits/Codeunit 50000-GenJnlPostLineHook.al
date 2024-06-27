codeunit 50000 "Gen. Jnl.-Post Line Hook"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", OnAfterCopyGLEntryFromGenJnlLine, '', false, false)]
    local procedure "OnAfterCopyGLEntryFromGenJnlLine"(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry.Comment := GenJournalLine.Comment;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", OnAfterCopyVendLedgerEntryFromGenJnlLine, '', false, false)]
    local procedure "OnAfterCopyVendLedgerEntryFromGenJnlLine"(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        //VendorLedgerEntry.PoT := GenJournalLine.PoT;
        VendorLedgerEntry.Comment := GenJournalLine.Comment;
        VendorLedgerEntry."Bank Account No." := GenJournalLine."Bank Account No.";
        VendorLedgerEntry."Bank Account Name" := GenJournalLine."Bank Account Name";
        VendorLedgerEntry."Bank Account IFSC" := GenJournalLine."Bank Account IFSC";
        VendorLedgerEntry."Bank Account E-Mail" := GenJournalLine."Bank Account E-Mail";
        VendorLedgerEntry."PO Type" := GenJournalLine."PO Type";
        VendorLedgerEntry."PO Sub Type" := GenJournalLine."PO Sub Type";
        VendorLedgerEntry."E-Mail 2" := GenJournalLine."E-Mail 2";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", OnAfterCopyFromGenJnlLine, '', false, false)]
    local procedure "OnAfterCopyFromGenJnlLine"(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        vendor: Record vendor;
    begin
        BankAccountLedgerEntry."Bank Account Code" := GenJournalLine."Bank Account Code";
        BankAccountLedgerEntry."VenBank Account No." := GenJournalLine."Bank Account No.";
        BankAccountLedgerEntry."Bank Account Name" := GenJournalLine."Bank Account Name";
        BankAccountLedgerEntry."Bank Account IFSC" := GenJournalLine."Bank Account IFSC";
        BankAccountLedgerEntry."Bank Account E-Mail" := GenJournalLine."Bank Account E-Mail";
        BankAccountLedgerEntry."E-Mail 2" := GenJournalLine."E-Mail 2";
        //CCIT AN 30122022
        IF GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::Vendor THEN //AND "Source Code" = 'PURCHASES' THEN
          BEGIN
            if vendor.Get(GenJournalLine."Bal. Account No.") then
                BankAccountLedgerEntry.Description := Vendor.Name;
        END
        //CCIT AN 30122022
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeInsertGlobalGLEntry, '', false, false)]
    // local procedure "OnBeforeInsertGlobalGLEntry"(var GlobalGLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register")
    // var
    //     PPI: Record "Purch. Inv. Header";
    //     PPI2: Record "Purch. Inv. Header";
    //     PPL: Record "Purch. Inv. Line";
    // begin
    //     PPL.RESET();
    //     PPL.SETRANGE("Document No.", GlobalGLEntry."Document No.");
    //     PPL.SETFILTER("Deferral Code", '<>%1', '');
    //     IF PPL.FINDSET THEN BEGIN
    //         REPEAT
    //             PPI.RESET();
    //             PPI.SETRANGE("No.", GlobalGLEntry."Document No.");
    //             PPI.SETFILTER("Posting Date", '=%1', GlobalGLEntry."Posting Date");
    //             IF PPI.FINDSET() THEN
    //                 REPEAT
    //                     GlobalGLEntry.INSERT(TRUE);
    //                     OnAfterInsertGlobalGLEntry(GlobalGLEntry);
    //                 UNTIL PPI.NEXT = 0;

    //             PPI2.RESET();
    //             PPI2.SETRANGE("No.", GlobalGLEntry."Document No.");
    //             PPI2.SETFILTER("Posting Date", '<>%1', GlobalGLEntry."Posting Date");
    //             IF PPI2.FINDSET() THEN
    //                 REPEAT
    //                     DeferralGLEntries.LOCKTABLE;
    //                     IF DeferralGLEntries.FINDLAST THEN BEGIN
    //                         DeffNextEntryNo := DeferralGLEntries."Entry No." + 1;
    //                         DeffNextTransactionNo := DeferralGLEntries."Transaction No." + 1;
    //                     END ELSE BEGIN
    //                         DeffNextEntryNo := 1;
    //                         DeffNextTransactionNo := 1;
    //                     END;
    //                     DeferralGLEntries.INIT;
    //                     DeferralGLEntries.CopyFromGenJnlLine(GlobalGLEntry);
    //                     DeferralGLEntries."Entry No." := DeffNextEntryNo;
    //                     DeferralGLEntries."Transaction No." := DeffNextTransactionNo;
    //                     DeferralGLEntries.INSERT(TRUE);
    //                 UNTIL PPI2.NEXT = 0;

    //         UNTIL PPL.NEXT = 0;
    //     END ELSE BEGIN
    //         GlobalGLEntry.INSERT(TRUE);
    //         OnAfterInsertGlobalGLEntry(GlobalGLEntry);
    //     END;
    // end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInsertGlobalGLEntry, '', false, false)]
    local procedure "OnAfterInsertGlobalGLEntry"(var GLEntry: Record "G/L Entry"; var TempGLEntryBuf: Record "G/L Entry"; var NextEntryNo: Integer; GenJnlLine: Record "Gen. Journal Line")
    var
        PPI: Record "Purch. Inv. Header";
        PPI2: Record "Purch. Inv. Header";
        PPL: Record "Purch. Inv. Line";
        DeferralGLEntries: Record "Deferral G/L Entries";
        TempDeferralGLEntriesPreview: Record "Deferral G/L Entries" temporary;
        Vendor: Record "Vendor Ledger Entry";
        DeffNextEntryNo: Integer;
        DeffNextTransactionNo: Integer;
        GenJnlLine2: Record "Gen. Journal Line";
        FALedgEntry: Record "FA Ledger Entry";
    begin
        PPL.RESET();
        PPL.SETRANGE("Document No.", GLEntry."Document No.");
        PPL.SETFILTER("Deferral Code", '<>%1', '');
        IF PPL.FINDSET THEN BEGIN
            REPEAT
                PPI2.RESET();
                PPI2.SETRANGE("No.", GLEntry."Document No.");
                PPI2.SETFILTER("Posting Date", '<>%1', GLEntry."Posting Date");
                IF PPI2.FINDSET() THEN
                    REPEAT
                        DeferralGLEntries.LOCKTABLE;
                        IF DeferralGLEntries.FINDLAST THEN BEGIN
                            DeffNextEntryNo := DeferralGLEntries."Entry No." + 1;
                            DeffNextTransactionNo := DeferralGLEntries."Transaction No." + 1;
                        END ELSE BEGIN
                            DeffNextEntryNo := 1;
                            DeffNextTransactionNo := 1;
                        END;
                        DeferralGLEntries.INIT;
                        DeferralGLEntries.CopyFromGenJnlLine(GLEntry);
                        DeferralGLEntries."Entry No." := DeffNextEntryNo;
                        DeferralGLEntries."Transaction No." := DeffNextTransactionNo;
                        DeferralGLEntries.INSERT(TRUE);
                        TempDeferralGLEntriesPreview.TransferFields(DeferralGLEntries);
                        TempDeferralGLEntriesPreview.Insert;
                    UNTIL PPI2.NEXT = 0;

            UNTIL PPL.NEXT = 0;
        END;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInitGLEntry, '', false, false)]
    local procedure "OnAfterInitGLEntry"(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Amount: Decimal; AddCurrAmount: Decimal; UseAddCurrAmount: Boolean; var CurrencyFactor: Decimal; var GLRegister: Record "G/L Register")
    begin
        GLEntry.Comment := GenJournalLine.Comment;//CCit-TK-151119
        GLEntry."GSTCredit 50%" := GenJournalLine."GSTCredit 50%"; //CCIT AN GST 50%
        //GLEntry."GST Bill-to/BuyFrom State Code" := GenJournalLine."GST Bill-to/BuyFrom State Code";//CCIT-TK-281119
        GLEntry."Approver ID" := GenJournalLine."Approver ID";
        //GLEntry."Party Code" := GenJournalLine."Party Code";//CCIT AN 13092023
        GLEntry."Party Name" := GenJournalLine."Party Name";//CCIT AN 13092023
        GLEntry."Related Party Transaction" := GenJournalLine."Related party transaction";//CCIT AN 13092023
        GLEntry."PO Type" := GenJournalLine."PO Type";//CCIT AN 21092023
        GLEntry."PO Sub Type" := GenJournalLine."PO Sub Type"; //CCIT AN 21092023
        //LMS
        //FnCreateGSTLedgerEntryFormLMS(GenJournalLine, GLEntry."Transaction No.");
        //LMS
    end;

    local procedure FnCreateGSTLedgerEntryFormLMS(LCRecGnlJnlLine: Record "Gen. Journal Line"; LCTransactionNo: Integer)
    var
        LCRecGSTLedgerEntry: Record "GST Ledger Entry";
        LCGSTEntryNo: Integer;
        LCRecGLAccount: Record "G/L Account";
    begin
        //LMS
        IF LCRecGnlJnlLine."Account Type" <> LCRecGnlJnlLine."Account Type"::"G/L Account" THEN
            EXIT;
        IF LCRecGLAccount.GET(LCRecGnlJnlLine."Account No.") THEN BEGIN
            IF LCRecGLAccount."GST Ledger Type" = LCRecGLAccount."GST Ledger Type"::" " THEN
                EXIT;
        END;
        IF LCRecGSTLedgerEntry.FINDLAST THEN
            LCGSTEntryNo := LCRecGSTLedgerEntry."Entry No." + 1
        ELSE
            LCGSTEntryNo := 1;
        LCRecGSTLedgerEntry.INIT;
        LCRecGSTLedgerEntry."Entry No." := LCGSTEntryNo;
        LCRecGSTLedgerEntry."Posting Date" := LCRecGnlJnlLine."Posting Date";
        LCRecGSTLedgerEntry."Document No." := LCRecGnlJnlLine."Document No.";
        LCRecGSTLedgerEntry."Document Type" := LCRecGSTLedgerEntry."Document Type"::Invoice;
        LCRecGSTLedgerEntry."Transaction Type" := LCRecGSTLedgerEntry."Transaction Type"::Sales;
        LCRecGSTLedgerEntry."GST Base Amount" := LCRecGnlJnlLine."GST TDS/TCS Base Amount";
        LCRecGSTLedgerEntry."Source Type" := LCRecGSTLedgerEntry."Source Type"::Customer;
        LCRecGSTLedgerEntry."User ID" := USERID;
        LCRecGSTLedgerEntry."Source Code" := 'SALES';
        LCRecGSTLedgerEntry."Transaction No." := LCTransactionNo;
        IF LCRecGLAccount.GET(LCRecGnlJnlLine."Account No.") THEN BEGIN
            IF LCRecGLAccount."GST Ledger Type" = LCRecGLAccount."GST Ledger Type"::CGST THEN
                LCRecGSTLedgerEntry."GST Component Code" := 'CGST';
            IF LCRecGLAccount."GST Ledger Type" = LCRecGLAccount."GST Ledger Type"::IGST THEN
                LCRecGSTLedgerEntry."GST Component Code" := 'IGST';
            IF LCRecGLAccount."GST Ledger Type" = LCRecGLAccount."GST Ledger Type"::SGST THEN
                LCRecGSTLedgerEntry."GST Component Code" := 'SGST';
        END;
        LCRecGSTLedgerEntry."GST Amount" := ABS(LCRecGnlJnlLine."Amount (LCY)");
        LCRecGSTLedgerEntry."Entry Type" := LCRecGSTLedgerEntry."Entry Type"::"Initial Entry";
        LCRecGSTLedgerEntry.INSERT;
        FnCreateDetailGSTLedgerEntryFormLMS(LCRecGnlJnlLine, LCTransactionNo);
        //LMS
    end;

    local procedure FnCreateDetailGSTLedgerEntryFormLMS(LCRecGnlJnlLine: Record "Gen. Journal Line"; LCTransactionNo: Integer)
    var
        LCRecGSTDetailLedgerEntry: Record "Detailed GST Ledger Entry";
        LCGSTDetEntryNo: Integer;
        LCRecGLAccount: Record "G/L Account";
        LCRecLocation: Record "Location";
    begin
        IF LCRecGSTDetailLedgerEntry.FINDLAST THEN
            LCGSTDetEntryNo := LCRecGSTDetailLedgerEntry."Entry No." + 1
        ELSE
            LCGSTDetEntryNo := 1;

        LCRecGSTDetailLedgerEntry.INIT;
        LCRecGSTDetailLedgerEntry."Entry No." := LCGSTDetEntryNo;
        LCRecGSTDetailLedgerEntry."Entry Type" := LCRecGSTDetailLedgerEntry."Entry Type"::"Initial Entry";
        LCRecGSTDetailLedgerEntry."Transaction Type" := LCRecGSTDetailLedgerEntry."Transaction Type"::Sales;
        LCRecGSTDetailLedgerEntry."Document Type" := LCRecGSTDetailLedgerEntry."Document Type"::Invoice;
        LCRecGSTDetailLedgerEntry."Document No." := LCRecGnlJnlLine."Document No.";
        LCRecGSTDetailLedgerEntry."Posting Date" := LCRecGnlJnlLine."Posting Date";
        LCRecGSTDetailLedgerEntry."Source Type" := LCRecGSTDetailLedgerEntry."Source Type"::Customer;
        LCRecGSTDetailLedgerEntry."HSN/SAC Code" := LCRecGnlJnlLine."HSN/SAC Code";
        //CCIT Aux-0001 25/07/2019 Start
        LCRecGSTDetailLedgerEntry."Shortcut Dimention 8 Code" := LCRecGnlJnlLine."Shortcut Dimension 8";
        //CCIT Aux-00001 25/07/2019 End;

        IF LCRecGLAccount.GET(LCRecGnlJnlLine."Account No.") THEN BEGIN
            IF LCRecGLAccount."GST Ledger Type" = LCRecGLAccount."GST Ledger Type"::CGST THEN BEGIN
                LCRecGSTDetailLedgerEntry."GST Component Code" := 'CGST';
                LCRecGSTDetailLedgerEntry."GST Jurisdiction Type" := LCRecGSTDetailLedgerEntry."GST Jurisdiction Type"::Intrastate;
            END;
            IF LCRecGLAccount."GST Ledger Type" = LCRecGLAccount."GST Ledger Type"::IGST THEN BEGIN
                LCRecGSTDetailLedgerEntry."GST Component Code" := 'IGST';
                LCRecGSTDetailLedgerEntry."GST Jurisdiction Type" := LCRecGSTDetailLedgerEntry."GST Jurisdiction Type"::Interstate;
            END;
            IF LCRecGLAccount."GST Ledger Type" = LCRecGLAccount."GST Ledger Type"::SGST THEN BEGIN
                LCRecGSTDetailLedgerEntry."GST Component Code" := 'SGST';
                LCRecGSTDetailLedgerEntry."GST Jurisdiction Type" := LCRecGSTDetailLedgerEntry."GST Jurisdiction Type"::Intrastate;
            END;
        END;
        LCRecGSTDetailLedgerEntry."GST Group Code" := LCRecGnlJnlLine."GST Group Code";
        IF LCRecGnlJnlLine."GST TDS/TCS Base Amount" <> 0 THEN
            LCRecGSTDetailLedgerEntry."GST %" := ABS(LCRecGnlJnlLine."Amount (LCY)" / LCRecGnlJnlLine."GST TDS/TCS Base Amount" * 100);
        LCRecGSTDetailLedgerEntry."GST Base Amount" := LCRecGnlJnlLine."GST TDS/TCS Base Amount";
        LCRecGSTDetailLedgerEntry."GST Amount" := ABS(LCRecGnlJnlLine."Amount (LCY)");
        LCRecGSTDetailLedgerEntry.Quantity := 1;
        LCRecGSTDetailLedgerEntry."G/L Account No." := LCRecGnlJnlLine."Account No.";
        // LCRecGSTDetailLedgerEntry."User ID" := USERID;
        LCRecGSTDetailLedgerEntry."Document Line No." := LCRecGnlJnlLine."Line No.";
        // LCRecGSTDetailLedgerEntry."Nature of Supply" := LCRecGSTDetailLedgerEntry."Nature of Supply"::B2B;
        IF LCRecLocation.GET(LCRecGnlJnlLine."Location Code") THEN
            LCRecGSTDetailLedgerEntry."Location  Reg. No." := LCRecLocation."GST Registration No.";
        LCRecGSTDetailLedgerEntry."GST Group Type" := LCRecGSTDetailLedgerEntry."GST Group Type"::Service;
        LCRecGSTDetailLedgerEntry."Transaction No." := LCTransactionNo;
        // LCRecGSTDetailLedgerEntry."Original Doc. Type" := LCRecGSTDetailLedgerEntry."Original Doc. Type"::Invoice;
        // LCRecGSTDetailLedgerEntry."Original Doc. No." := LCRecGnlJnlLine."Document No.";
        LCRecGSTDetailLedgerEntry."GST Rounding Precision" := 0.01;
        LCRecGSTDetailLedgerEntry."GST Rounding Type" := LCRecGSTDetailLedgerEntry."GST Rounding Type"::Nearest;
        LCRecGSTDetailLedgerEntry."Location Code" := LCRecGnlJnlLine."Location Code";
        LCRecGSTDetailLedgerEntry."GST Customer Type" := LCRecGSTDetailLedgerEntry."GST Customer Type"::Unregistered;
        // LCRecGSTDetailLedgerEntry."Location State Code" := LCRecGnlJnlLine."Location State Code";
        // LCRecGSTDetailLedgerEntry."Buyer/Seller State Code" := LCRecGnlJnlLine."GST Bill-to/BuyFrom State Code";
        LCRecGSTDetailLedgerEntry.INSERT;
    end;

    procedure PostFixedAsset50Per(GenJnlLine: Record "Gen. Journal Line"; GLReg: Record "G/L Register")
    var
        GLEntry: Record "G/L Entry";
        GLEntry2: Record "G/L Entry";
        TempFAGLPostBuf: Record "FA G/L Posting Buffer" temporary;
        FAGLPostBuf: Record "FA G/L Posting Buffer";
        VATPostingSetup: Record "VAT Posting Setup";
        FAJnlPostLine: Codeunit "FA Jnl.-Post Line";
        FAAutomaticEntry: Record "FA Class";
        ShortcutDim1Code: Code[20];
        ShortcutDim2Code: Code[20];
        Correction2: Boolean;
        NetDisposalNo: Integer;
        DimensionSetID: Integer;
        VATEntryGLEntryNo: Integer;
        FALedgEntry: Record "FA Ledger Entry";
        NextEntryNo: Integer;
    begin
        // IF GenJnlLine."Excise Posting" THEN BEGIN
        //     PostExcise(GenJnlLine);
        //     EXIT;
        // END;
        // IF "Deferred Claim FA Excise" THEN
        //     ReverseDeferredExciseCapItems(GenJnlLine);

        //  InitGLEntry(GenJnlLine,GLEntry,'',"Amount (LCY)","Source Currency Amount",TRUE,"System-Created Entry");
        //  GLEntry."Gen. Posting Type" := "Gen. Posting Type";
        //  GLEntry."Bal. Account Type" := "Bal. Account Type";
        //  GLEntry."Bal. Account No." := "Bal. Account No.";
        //  InitTax(GenJnlLine,GLEntry);
        //  GLEntry2 := GLEntry;
        //CCIT AN ++
        //IF NextEntryNo = 0 THEN BEGIN
        FALedgEntry.LOCKTABLE;
        IF FALedgEntry.FINDLAST THEN
            NextEntryNo := FALedgEntry."Entry No.";
        NextEntryNo := NextEntryNo + 1;
        FALedgEntry."Entry No." := NextEntryNo;
        // FALedgEntry."G/L Entry No." := NewGLEntryNo;
        FALedgEntry.Amount := GenJnlLine.Amount;
        FALedgEntry."Debit Amount" := GenJnlLine."Debit Amount";
        FALedgEntry."Credit Amount" := GenJnlLine."Credit Amount";
        FALedgEntry.Quantity := 0;
        FALedgEntry."User ID" := USERID;
        FALedgEntry."Source Code" := GenJnlLine."Source Code";
        //FALedgEntry."Transaction No." := TransactionNo;
        FALedgEntry."VAT Amount" := -GenJnlLine."VAT Amount";
        FALedgEntry."Amount (LCY)" := -GenJnlLine."Amount (LCY)";
        FALedgEntry.Correction := NOT GenJnlLine.Correction;
        FALedgEntry."No. Series" := '';
        FALedgEntry."Journal Batch Name" := '';
        FALedgEntry."FA No./Budgeted FA No." := '';
        FALedgEntry.INSERT(TRUE);
        //END;
        //CCIT AN --
        //FAJnlPostLine.GenJnlPostLine(
        //GenJnlLine,GLEntry2.Amount,GLEntry2."VAT Amount",NextTransactionNo,NextEntryNo,GLReg."No.");
        ShortcutDim1Code := GenJnlLine."Shortcut Dimension 1 Code";
        ShortcutDim2Code := GenJnlLine."Shortcut Dimension 2 Code";
        DimensionSetID := GenJnlLine."Dimension Set ID";
        Correction2 := GenJnlLine.Correction;
    END;
    // WITH TempFAGLPostBuf DO
    //  IF FAJnlPostLine.FindFirstGLAcc(TempFAGLPostBuf) THEN
    //    REPEAT
    //      GenJnlLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
    //      GenJnlLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
    //      GenJnlLine."Dimension Set ID" := "Dimension Set ID";
    //      GenJnlLine.Correction := Correction;
    //      FADimAlreadyChecked := "FA Posting Group" <> '';
    //      CheckDimValueForDisposal(GenJnlLine,"Account No.");
    //
    //      IF "Original General Journal Line" THEN
    //        InitGLEntry(GenJnlLine,GLEntry,"Account No.",Amount,GLEntry2."Additional-Currency Amount",TRUE,TRUE)
    //      ELSE BEGIN
    //        CheckNonAddCurrCodeOccurred('');
    //        InitGLEntry(GenJnlLine,GLEntry,"Account No.",Amount,0,FALSE,TRUE);
    //      END;
    //      FADimAlreadyChecked := FALSE;
    //      GLEntry.CopyPostingGroupsFromGLEntry(GLEntry2);
    //      GLEntry."VAT Amount" := GLEntry2."VAT Amount";
    //      GLEntry."Bal. Account Type" := GLEntry2."Bal. Account Type";
    //      GLEntry."Bal. Account No." := GLEntry2."Bal. Account No.";
    //      GLEntry."FA Entry Type" := "FA Entry Type";
    //      GLEntry."FA Entry No." := "FA Entry No.";
    //      IF "Net Disposal" THEN
    //        NetDisposalNo := NetDisposalNo + 1
    //      ELSE
    //        NetDisposalNo := 0;
    //      IF "Automatic Entry" AND NOT "Net Disposal" THEN
    //        FAAutomaticEntry.AdjustGLEntry(GLEntry);
    //      IF NetDisposalNo > 1 THEN
    //        GLEntry."VAT Amount" := 0;
    //      IF "FA Posting Group" <> '' THEN BEGIN
    //        FAGLPostBuf := TempFAGLPostBuf;
    //        FAGLPostBuf."Entry No." := NextEntryNo;
    //        FAGLPostBuf.INSERT;
    //      END;
    //      InsertGLEntry(GenJnlLine,GLEntry,TRUE);
    //      IF (VATEntryGLEntryNo = 0) AND (GLEntry."Gen. Posting Type" <> GLEntry."Gen. Posting Type"::" ") THEN
    //        VATEntryGLEntryNo := GLEntry."Entry No.";
    //    UNTIL FAJnlPostLine.GetNextGLAcc(TempFAGLPostBuf) = 0;
    // GenJnlLine."Shortcut Dimension 1 Code" := ShortcutDim1Code;
    // GenJnlLine."Shortcut Dimension 2 Code" := ShortcutDim2Code;
    // GenJnlLine."Dimension Set ID" := DimensionSetID;
    // GenJnlLine.Correction := Correction2;
    // GLEntry := GLEntry2;
    // IF VATEntryGLEntryNo = 0 THEN
    //  VATEntryGLEntryNo := GLEntry."Entry No.";
    // TempGLEntryBuf."Entry No." := VATEntryGLEntryNo; // Used later in InsertVAT(): GLEntryVATEntryLink.InsertLink(TempGLEntryBuf."Entry No.",VATEntry."Entry No.")
    // PostTax(GenJnlLine,GLEntry);
    // PostVATTablePurchaseTax(GenJnlLine);


    //FAJnlPostLine.UpdateRegNo(GLReg."No.");
    //GenJnlLine.OnMoveGenJournalLine(GLEntry.RECORDID);


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeInsertDtldVendLedgEntry, '', false, false)]
    local procedure "OnBeforeInsertDtldVendLedgEntry"(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GLRegister: Record "G/L Register")
    begin
        //21092023++
        DtldVendLedgEntry."PO Type" := GenJournalLine."PO Type";
        DtldVendLedgEntry."PO Sub Type" := GenJournalLine."PO Sub Type";
        //21092023--
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeShowInconsistentEntries, '', false, false)]
    local procedure "OnBeforeShowInconsistentEntries"(TempGLEntryPrevie: Record "G/L Entry" temporary; var IsHandled: Boolean)
    begin
        Page.Run(Page::"G/L Entries Preview", TempGLEntryPrevie);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnVendPostApplyVendLedgEntryOnBeforeFinishPosting, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnVendPostApplyVendLedgEntryOnBeforeFinishPosting"(var GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
    end;

    //TDSEntry."Rev. TDS Transaction No." := "Rev. TDS Transaction No."; //CCIT AN 10022023 Carry trans no.

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInsertGLEntry, '', false, false)]
    local procedure OnAfterInsertGLEntry(var Sender: Codeunit "Gen. Jnl.-Post Line"; GLEntry: Record "G/L Entry"; GenJnlLine: Record "Gen. Journal Line"; TempGLEntryBuf: Record "G/L Entry" temporary; CalcAddCurrResiduals: Boolean)
    var
        GLBudgetEntry: Record "G/L Budget Entry";
        GLBudgetName: Record "G/L Budget Name";
        DimensionSetEntry: Record "Dimension Set Entry";
        NewPostingDate: Date;
        DimSetID: Integer;
        PurchInvHeader: Record "Purch. Inv. Header";
        continue: Boolean;
    begin
        continue := false;
        if PurchInvHeader.Get(GLEntry."Document No.") then
            continue := true;

        if (GenJnlLine."Journal Template Name" <> '') and (GenJnlLine."Journal Batch Name" <> '') then
            continue := true;

        if not continue then
            exit;

        GLBudgetName.Reset();
        if GLBudgetName.FindSet() then
            repeat
                NewPostingDate := CalcDate('CM+1d-1M', GLEntry."Posting Date");

                GLBudgetEntry.Reset();
                GLBudgetEntry.SetRange("Budget Name", GLBudgetName.Name);
                GLBudgetEntry.SetRange("G/L Account No.", GLEntry."G/L Account No.");
                GLBudgetEntry.SetRange(Date, NewPostingDate);
                //GLBudgetEntry.SetRange("Dimension Set ID", DimSetID);

                if DimensionSetEntry.Get(GLEntry."Dimension Set ID", 'BRANCHES') then
                    GLBudgetEntry.SetRange("Global Dimension 1 Code", DimensionSetEntry."Dimension Value Code");

                if DimensionSetEntry.Get(GLEntry."Dimension Set ID", 'BUSINESS SEGMENTS') then
                    GLBudgetEntry.SetRange("Global Dimension 2 Code", DimensionSetEntry."Dimension Value Code");

                if DimensionSetEntry.Get(GLEntry."Dimension Set ID", GLBudgetName."Budget Dimension 1 Code") then
                    GLBudgetEntry.SetRange("Budget Dimension 1 Code", DimensionSetEntry."Dimension Value Code");

                if DimensionSetEntry.Get(GLEntry."Dimension Set ID", GLBudgetName."Budget Dimension 2 Code") then
                    GLBudgetEntry.SetRange("Budget Dimension 2 Code", DimensionSetEntry."Dimension Value Code");

                if DimensionSetEntry.Get(GLEntry."Dimension Set ID", GLBudgetName."Budget Dimension 3 Code") then
                    GLBudgetEntry.SetRange("Budget Dimension 3 Code", DimensionSetEntry."Dimension Value Code");

                IF GLBudgetEntry.FindFirst() then begin
                    GLBudgetEntry."Remaining Amount" := GLBudgetEntry."Remaining Amount" - GLEntry.Amount;
                    GLBudgetEntry.Modify();
                end;
            until GLBudgetName.Next() = 0;
    end;

    var
        myInt: Integer;
        TempDeferralGLEntriesPreview: Record "Deferral G/L Entries" temporary;
}