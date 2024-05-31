codeunit 50009 "WorkflowRequestPageHandlingHk"
{
    Permissions = tabledata "Approval Entry" = rimd;

    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Request Page Handling", OnAfterInsertRequestPageFields, '', false, false)]
    local procedure OnAfterInsertRequestPageFields()
    begin
        //CCIT Vikas
        InsertGLAccountReqPageFields;
        InsertBankAccountReqPageFields;
        //>> ST
        //InsertTaxJournalLineReqPageFields;
        //<< ST
        InsertUserSetupReqPageFields; //CCIT AN 16022023
        InsertPOLinesReqPageFields; //CCI AN 24072023 PO Bulk
    end;

    local procedure "---GLAccount-----"()
    begin
    end;

    local procedure InsertGLAccountReqPageFields()
    var
        WorkflowRequestPageHandling: Codeunit "Workflow Request Page Handling";
        GLAccount: Record "G/L Account";
    begin
        InsertReqPageField(DATABASE::"G/L Account", GLAccount.FIELDNO("No."));
        InsertReqPageField(DATABASE::"G/L Account", GLAccount.FIELDNO(Blocked));
        //InsertReqPageField(DATABASE::"Fixed Asset",FixedAsset.FIELDNO("Credit Limit (LCY)"));
        //InsertReqPageField(DATABASE::"Fixed Asset",FixedAsset.FIELDNO("Payment Method Code"));
        //InsertReqPageField(DATABASE::"Fixed Asset",FixedAsset.FIELDNO("Gen. Bus. Posting Group"));
        //InsertReqPageField(DATABASE::"Fixed Asset",FixedAsset.FIELDNO("Customer Posting Group"));
    end;

    local procedure "---Bank Account-----"()
    begin
    end;

    local procedure InsertBankAccountReqPageFields()
    var
        BankAccount: Record "Bank Account";
    begin
        InsertReqPageField(DATABASE::"Bank Account", BankAccount.FIELDNO("No."));
        InsertReqPageField(DATABASE::"Bank Account", BankAccount.FIELDNO(Blocked));
        //InsertReqPageField(DATABASE::"Fixed Asset",FixedAsset.FIELDNO("Credit Limit (LCY)"));
        //InsertReqPageField(DATABASE::"Fixed Asset",FixedAsset.FIELDNO("Payment Method Code"));
        //InsertReqPageField(DATABASE::"Fixed Asset",FixedAsset.FIELDNO("Gen. Bus. Posting Group"));
        //InsertReqPageField(DATABASE::"Fixed Asset",FixedAsset.FIELDNO("Customer Posting Group"));
    end;

    local procedure "---User Setup----"()
    begin
    end;

    local procedure InsertUserSetupReqPageFields()
    var
        UserSetup: Record "User Setup";
    begin
        InsertReqPageField(DATABASE::"User Setup", UserSetup.FIELDNO("User ID"));
        InsertReqPageField(DATABASE::"User Setup", UserSetup.FIELDNO(Blocked));
    end;

    local procedure "---TDS Adjustment---"()
    begin
    end;

    //>> ST
    // local procedure InsertTaxJournalLineReqPageFields()
    // var
    //     TaxJournalLine: Record "Tax Journal Line";
    // begin
    //     InsertReqPageField(DATABASE::"Tax Journal Line", TaxJournalLine.FIELDNO("Document Type"));
    //     InsertReqPageField(DATABASE::"Tax Journal Line", TaxJournalLine.FIELDNO("Account Type"));
    //     InsertReqPageField(DATABASE::"Tax Journal Line", TaxJournalLine.FIELDNO("Account No."));
    //     InsertReqPageField(DATABASE::"Tax Journal Line", TaxJournalLine.FIELDNO(Amount));
    // end;
    //<< ST

    local procedure "---Bulk PO----"()
    begin
    end;

    local procedure InsertPOLinesReqPageFields()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        InsertReqPageField(DATABASE::"Purchase Header", PurchaseHeader.FIELDNO("Document Type"));
        InsertReqPageField(DATABASE::"Purchase Header", PurchaseHeader.FIELDNO("No."));
        InsertReqPageField(DATABASE::"Purchase Header", PurchaseHeader.FIELDNO("Posting Date"));
        InsertReqPageField(DATABASE::"Purchase Header", PurchaseHeader.FIELDNO(Amount));
    end;

    local procedure InsertReqPageField(TableId: Integer; FieldId: Integer)
    var
        DynamicRequestPageField: Record "Dynamic Request Page Field";
    begin
        IF NOT DynamicRequestPageField.GET(TableId, FieldId) THEN
            CreateReqPageField(TableId, FieldId);
    end;

    local procedure CreateReqPageField(TableId: Integer; FieldId: Integer)
    var
        DynamicRequestPageField: Record "Dynamic Request Page Field";
    begin
        DynamicRequestPageField.INIT;
        DynamicRequestPageField.VALIDATE("Table ID", TableId);
        DynamicRequestPageField.VALIDATE("Field ID", FieldId);
        DynamicRequestPageField.INSERT;
    end;

}