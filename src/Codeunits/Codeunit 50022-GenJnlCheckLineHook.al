codeunit 50022 "Gen. Jnl.-Check Line Hook"
{
    trigger OnRun()
    begin

    end;

    var
        GenJnlTemplate: Record "Gen. Journal Template";
        ApplicationAreaMgmt: Codeunit "Application Area Mgmt.";
        Text006: Label '%1 + %2 must be -%3.';
        Text009: Label 'must have a different sign than %1';
        Text010: Label '%1 %2 and %3 %4 is not allowed.';
        EmployeeBalancingDocTypeErr: Label 'must be empty or set to Payment when Balancing Account Type field is set to Employee';
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"VendEntry-Apply Posted Entries", OnBeforeApply, '', false, false)]
    local procedure OnBeforeApply(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var DocumentNo: Code[20]; var ApplicationDate: Date)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", OnBeforeCheckBalAccountNo, '', false, false)]
    local procedure OnBeforeCheckBalAccountNo(var Sender: Codeunit "Gen. Jnl.-Check Line"; var GenJnlLine: Record "Gen. Journal Line"; var CheckDone: Boolean)
    var
        ICPartner: Record "IC Partner";
        Customer: Record Customer;
        Vendor: Record Vendor;
        Employee: Record Employee;
    begin
        case GenJnlLine."Bal. Account Type" of
            GenJnlLine."Bal. Account Type"::"G/L Account":
                begin
                    if ((GenJnlLine."Bal. Gen. Bus. Posting Group" <> '') or (GenJnlLine."Bal. Gen. Prod. Posting Group" <> '') or
                        (GenJnlLine."Bal. VAT Bus. Posting Group" <> '') or (GenJnlLine."Bal. VAT Prod. Posting Group" <> '')) and
                        not ApplicationAreaMgmt.IsSalesTaxEnabled()
                    then
                        GenJnlLine.TestField("Bal. Gen. Posting Type", ErrorInfo.Create());

                    GenJnlCheckLine.CheckBalGenProdPostingGroupWhenAdjustForPmtDisc(GenJnlLine);

                    if (GenJnlLine."Bal. Gen. Posting Type" <> GenJnlLine."Bal. Gen. Posting Type"::" ") and
                        (GenJnlLine."VAT Posting" = GenJnlLine."VAT Posting"::"Automatic VAT Entry")
                    then begin
                        if GenJnlLine."Bal. VAT Amount" + GenJnlLine."Bal. VAT Base Amount" <> -GenJnlLine.Amount then
                            Error(
                                ErrorInfo.Create(
                                    StrSubstNo(
                                        Text006, GenJnlLine.FieldCaption(GenJnlLine."Bal. VAT Amount"), GenJnlLine.FieldCaption(GenJnlLine."Bal. VAT Base Amount"),
                                        GenJnlLine.FieldCaption(GenJnlLine.Amount)),
                                    true,
                                    GenJnlLine,
                                    GenJnlLine.FieldNo("Bal. VAT Amount")));
                        if GenJnlLine."Currency Code" <> '' then
                            if GenJnlLine."Bal. VAT Amount (LCY)" + GenJnlLine."Bal. VAT Base Amount (LCY)" <> -GenJnlLine."Amount (LCY)" then
                                Error(
                                    ErrorInfo.Create(
                                        StrSubstNo(
                                            Text006, GenJnlLine.FieldCaption("Bal. VAT Amount (LCY)"),
                                            GenJnlLine.FieldCaption("Bal. VAT Base Amount (LCY)"), GenJnlLine.FieldCaption("Amount (LCY)")),
                                                            true,
                                    GenJnlLine,
                                    GenJnlLine.FieldNo("Bal. VAT Amount (LCY)")));
                    end;
                end;
            GenJnlLine."Bal. Account Type"::Customer, GenJnlLine."Bal. Account Type"::Vendor, GenJnlLine."Bal. Account Type"::Employee:
                begin
                    GenJnlLine.TestField("Bal. Gen. Posting Type", 0, ErrorInfo.Create());
                    GenJnlLine.TestField("Bal. Gen. Bus. Posting Group", '', ErrorInfo.Create());
                    GenJnlLine.TestField("Bal. Gen. Prod. Posting Group", '', ErrorInfo.Create());
                    GenJnlLine.TestField("Bal. VAT Bus. Posting Group", '', ErrorInfo.Create());
                    GenJnlLine.TestField("Bal. VAT Prod. Posting Group", '', ErrorInfo.Create());

                    CheckBalAccountType(GenJnlLine);

                    CheckBalDocType(GenJnlLine);

                    if ((GenJnlLine.Amount > 0) xor (GenJnlLine."Sales/Purch. (LCY)" < 0)) and (GenJnlLine.Amount <> 0) and (GenJnlLine."Sales/Purch. (LCY)" <> 0) then
                        GenJnlLine.FieldError("Sales/Purch. (LCY)", ErrorInfo.Create(StrSubstNo(Text009, GenJnlLine.FieldCaption(Amount)), true));
                    //>> ST
                    //CheckJobNoIsEmpty(GenJnlLine);
                    GenJnlLine.TestField("Job No.", '', ErrorInfo.Create());
                    //<< ST

                    //>> ST
                    //CheckICPartner(GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.", GenJnlLine."Document Type", GenJnlLine);
                    case GenJnlLine."Account Type" of
                        GenJnlLine."Account Type"::Customer:
                            if Customer.Get(GenJnlLine."Account No.") then begin
                                Customer.CheckBlockedCustOnJnls(Customer, GenJnlLine."Document Type", true);
                                if (Customer."IC Partner Code" <> '') and (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) and
                                   ICPartner.Get(Customer."IC Partner Code")
                                then
                                    ICPartner.CheckICPartnerIndirect(Format(GenJnlLine."Account Type"), GenJnlLine."Account No.");
                            end;
                        GenJnlLine."Account Type"::Vendor:
                            if Vendor.Get(GenJnlLine."Account No.") then begin
                                Vendor.CheckBlockedVendOnJnls(Vendor, GenJnlLine."Document Type", true);
                                if (Vendor."IC Partner Code" <> '') and (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) and
                                   ICPartner.Get(Vendor."IC Partner Code")
                                then
                                    ICPartner.CheckICPartnerIndirect(Format(GenJnlLine."Account Type"), GenJnlLine."Account No.");
                            end;
                        GenJnlLine."Account Type"::Employee:
                            if Employee.Get(GenJnlLine."Account No.") then
                                Employee.CheckBlockedEmployeeOnJnls(true)
                    end;
                    //<< ST
                end;
            GenJnlLine."Bal. Account Type"::"Bank Account":
                begin
                    GenJnlLine.TestField("Bal. Gen. Posting Type", 0, ErrorInfo.Create());
                    GenJnlLine.TestField("Bal. Gen. Bus. Posting Group", '', ErrorInfo.Create());
                    GenJnlLine.TestField("Bal. Gen. Prod. Posting Group", '', ErrorInfo.Create());
                    GenJnlLine.TestField("Bal. VAT Bus. Posting Group", '', ErrorInfo.Create());
                    GenJnlLine.TestField("Bal. VAT Prod. Posting Group", '', ErrorInfo.Create());
                    if (GenJnlLine.Amount > 0) and (GenJnlLine."Bank Payment Type" = "Bank Payment Type"::"Computer Check") then
                        GenJnlLine.TestField("Check Printed", true, ErrorInfo.Create());

                    //>> ST
                    //CheckElectronicPaymentFields(GenJnlLine);

                    if (GenJnlLine."Bank Payment Type" = GenJnlLine."Bank Payment Type"::"Electronic Payment") or
                       (GenJnlLine."Bank Payment Type" = GenJnlLine."Bank Payment Type"::"Electronic Payment-IAT")
                    then begin
                        GenJnlLine.TestField("Exported to Payment File", true, ErrorInfo.Create());
                        GenJnlLine.TestField("Check Transmitted", true, ErrorInfo.Create());
                    end;
                    //<< ST
                end;
            GenJnlLine."Bal. Account Type"::"IC Partner":
                begin
                    ICPartner.Get(GenJnlLine."Bal. Account No.");
                    ICPartner.CheckICPartner();
                    if GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany then
                        GenJnlLine.FieldError("Bal. Account Type", ErrorInfo.Create());
                end;
        end;
        CheckDone := true;
    end;

    local procedure CheckBalAccountType(GenJnlLine: Record "Gen. Journal Line")
    var
        IsHandled: Boolean;
    begin
        if ((GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer) and
            (GenJnlLine."Gen. Posting Type" = GenJnlLine."Gen. Posting Type"::Purchase)) or
           ((GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor) and
            (GenJnlLine."Gen. Posting Type" = GenJnlLine."Gen. Posting Type"::Sale))
        then
            Error(
                ErrorInfo.Create(
                    StrSubstNo(
                        Text010,
                        GenJnlLine.FieldCaption("Bal. Account Type"), GenJnlLine."Bal. Account Type",
                        GenJnlLine.FieldCaption("Gen. Posting Type"), GenJnlLine."Gen. Posting Type"),
                    true,
                    GenJnlLine));

        IsHandled := true;
    end;

    local procedure CheckBalDocType(GenJnlLine: Record "Gen. Journal Line")
    var
        IsPayment: Boolean;
        IsHandled: Boolean;
    begin
        if GenJnlLine."Document Type" <> GenJnlLine."Document Type"::" " then begin
            if (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Employee) and not
               (GenJnlLine."Document Type" in [GenJnlLine."Document Type"::Payment, GenJnlLine."Document Type"::" "])
            then
                GenJnlLine.FieldError("Document Type", ErrorInfo.Create(EmployeeBalancingDocTypeErr, true));

            IsPayment := GenJnlLine."Document Type" in [GenJnlLine."Document Type"::Payment, GenJnlLine."Document Type"::"Credit Memo"];
            if IsPayment = (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Customer) then
                GenJnlCheckLine.ErrorIfNegativeAmt(GenJnlLine)
            else
                GenJnlCheckLine.ErrorIfPositiveAmt(GenJnlLine);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", OnBeforeRunCheck, '', false, false)]
    local procedure OnBeforeRunCheck(var Sender: Codeunit "Gen. Jnl.-Check Line"; var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        if (GenJournalLine."Journal Batch Name" <> '') and (GenJournalLine."Journal Template Name" <> '') then begin
            GenJournalBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");
            if GenJournalBatch."Comments Mandatory" then
                GenJournalLine.TestField(Comment);

            if GenJournalBatch."Ext. Docuemnt No. Mandatory" then
                GenJournalLine.TestField("External Document No.");
        end;
    end;


    var
        myInt: Integer;
}