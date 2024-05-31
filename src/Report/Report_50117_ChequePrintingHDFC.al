Report 50117 "Cheque Printing -HDFC"
{
    Caption = 'Cheque Printing - Bank of Baroda';
    Permissions = TableData "Bank Account" = m;
    RDLCLayout = './Layouts/ChequePrintingHDFC.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(VoidGenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Posting Date";
            trigger OnPreDataItem();
            begin
                if UseCheckNo = '' then
                    Error(Text001);
                if TestPrint then
                    CurrReport.Break;
                if not ReprintChecks then
                    CurrReport.Break;
                if (GetFilter("Line No.") <> '') or (GetFilter("Document No.") <> '') then
                    Error(
                      Text002, FieldCaption("Line No."), FieldCaption("Document No."));
                SetRange("Bank Payment Type", "bank payment type"::"Computer Check");
                SetRange("Check Printed", true);
                //	ReportForNav.OnPreDataItem('VoidGenJnlLine',VoidGenJnlLine);
            end;

            trigger OnAfterGetRecord();
            begin
                CheckManagement.VoidCheck(VoidGenJnlLine);
            end;

        }
        dataitem(GenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            dataitem(CheckPages; Integer)
            {
                DataItemTableView = sorting(Number);
                dataitem(PrintSettledLoop; Integer)
                {
                    DataItemTableView = sorting(Number);
                    trigger OnPreDataItem();
                    begin
                        if not TestPrint then
                            if FirstPage then begin
                                FoundLast := true;
                                case ApplyMethod of
                                    Applymethod::OneLineOneEntry:
                                        FoundLast := false;
                                    Applymethod::OneLineID:
                                        case BalancingType of
                                            Balancingtype::Customer:
                                                begin
                                                    CustLedgEntry.Reset;
                                                    CustLedgEntry.SetCurrentkey("Customer No.", Open, Positive);
                                                    CustLedgEntry.SetRange("Customer No.", BalancingNo);
                                                    CustLedgEntry.SetRange(Open, true);
                                                    CustLedgEntry.SetRange(Positive, true);
                                                    CustLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := not CustLedgEntry.Find('-');
                                                    if FoundLast then begin
                                                        CustLedgEntry.SetRange(Positive, false);
                                                        FoundLast := not CustLedgEntry.Find('-');
                                                        FoundNegative := true;
                                                    end else
                                                        FoundNegative := false;
                                                end;
                                            Balancingtype::Vendor:
                                                begin
                                                    VendLedgEntry.Reset;
                                                    VendLedgEntry.SetCurrentkey("Vendor No.", Open, Positive);
                                                    VendLedgEntry.SetRange("Vendor No.", BalancingNo);
                                                    VendLedgEntry.SetRange(Open, true);
                                                    VendLedgEntry.SetRange(Positive, true);
                                                    VendLedgEntry.SetRange("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := not VendLedgEntry.Find('-');
                                                    if FoundLast then begin
                                                        VendLedgEntry.SetRange(Positive, false);
                                                        FoundLast := not VendLedgEntry.Find('-');
                                                        FoundNegative := true;
                                                    end else
                                                        FoundNegative := false;
                                                end;
                                        end;
                                    Applymethod::MoreLinesOneEntry:
                                        FoundLast := false;
                                end;
                            end
                            else
                                FoundLast := false;
                        //		ReportForNav.OnPreDataItem('PrintSettledLoop',PrintSettledLoop);
                    end;

                    trigger OnAfterGetRecord();
                    begin
                        if not TestPrint then begin
                            if FoundLast then begin
                                if RemainingAmount <> 0 then begin
                                    DocType := Text015;
                                    DocNo := '';
                                    ExtDocNo := '';
                                    LineAmount := RemainingAmount;
                                    LineAmount2 := RemainingAmount;
                                    LineDiscount := 0;
                                    RemainingAmount := 0;
                                end else
                                    CurrReport.Break;
                            end else begin
                                case ApplyMethod of
                                    Applymethod::OneLineOneEntry:
                                        begin
                                            case BalancingType of
                                                Balancingtype::Customer:
                                                    begin
                                                        CustLedgEntry.Reset;
                                                        CustLedgEntry.SetCurrentkey("Document No.", "Document Type", "Customer No.");
                                                        CustLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        CustLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        CustLedgEntry.SetRange("Customer No.", BalancingNo);
                                                        CustLedgEntry.Find('-');
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                    end;
                                                Balancingtype::Vendor:
                                                    begin
                                                        VendLedgEntry.Reset;
                                                        VendLedgEntry.SetCurrentkey("Document No.", "Document Type", "Vendor No.");
                                                        VendLedgEntry.SetRange("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        VendLedgEntry.SetRange("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        VendLedgEntry.SetRange("Vendor No.", BalancingNo);
                                                        VendLedgEntry.Find('-');
                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                    end;
                                            end;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                            FoundLast := true;
                                        end;
                                    Applymethod::OneLineID:
                                        begin
                                            case BalancingType of
                                                Balancingtype::Customer:
                                                    begin
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                        FoundLast := (CustLedgEntry.Next = 0) or (RemainingAmount <= 0);
                                                        if FoundLast and not FoundNegative then begin
                                                            CustLedgEntry.SetRange(Positive, false);
                                                            FoundLast := not CustLedgEntry.Find('-');
                                                            FoundNegative := true;
                                                        end;
                                                    end;
                                                Balancingtype::Vendor:
                                                    begin
                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                        FoundLast := (VendLedgEntry.Next = 0) or (RemainingAmount <= 0);
                                                        if FoundLast and not FoundNegative then begin
                                                            VendLedgEntry.SetRange(Positive, false);
                                                            FoundLast := not VendLedgEntry.Find('-');
                                                            FoundNegative := true;
                                                        end;
                                                    end;
                                            end;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                        end;
                                    Applymethod::MoreLinesOneEntry:
                                        begin
                                            CurrentLineAmount := GenJnlLine2.Amount;
                                            LineAmount2 := CurrentLineAmount;
                                            if GenJnlLine2."Applies-to ID" <> '' then
                                                Error(
                                                  Text016 +
                                                  Text017);
                                            GenJnlLine2.TestField("Check Printed", false);
                                            GenJnlLine2.TestField("Bank Payment Type", GenJnlLine2."bank payment type"::"Computer Check");
                                            if GenJnlLine2."Applies-to Doc. No." = '' then begin
                                                DocType := Text015;
                                                DocNo := '';
                                                ExtDocNo := '';
                                                LineAmount := CurrentLineAmount;
                                                LineDiscount := 0;
                                            end else begin
                                                case BalancingType of
                                                    Balancingtype::"G/L Account":
                                                        begin
                                                            DocType := Format(GenJnlLine2."Document Type");
                                                            DocNo := GenJnlLine2."Document No.";
                                                            ExtDocNo := GenJnlLine2."External Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                        end;
                                                    Balancingtype::Customer:
                                                        begin
                                                            CustLedgEntry.Reset;
                                                            CustLedgEntry.SetCurrentkey("Document No.", "Document Type", "Customer No.");
                                                            CustLedgEntry.SetRange("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                            CustLedgEntry.SetRange("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                            CustLedgEntry.SetRange("Customer No.", BalancingNo);
                                                            CustLedgEntry.Find('-');
                                                            CustUpdateAmounts(CustLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                        end;
                                                    Balancingtype::Vendor:
                                                        begin
                                                            VendLedgEntry.Reset;
                                                            VendLedgEntry.SetCurrentkey("Document No.", "Document Type", "Vendor No.");
                                                            VendLedgEntry.SetRange("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                            VendLedgEntry.SetRange("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                            VendLedgEntry.SetRange("Vendor No.", BalancingNo);
                                                            VendLedgEntry.Find('-');
                                                            VendUpdateAmounts(VendLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                        end;
                                                    Balancingtype::"Bank Account":
                                                        begin
                                                            DocType := Format(GenJnlLine2."Document Type");
                                                            DocNo := GenJnlLine2."Document No.";
                                                            ExtDocNo := GenJnlLine2."External Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                        end;
                                                end;
                                            end;
                                            FoundLast := GenJnlLine2.Next = 0;
                                        end;
                                end;
                            end;
                            TotalLineAmount := TotalLineAmount + LineAmount2;
                            TotalLineDiscount := TotalLineDiscount + LineDiscount;
                        end else begin
                            if FoundLast then
                                CurrReport.Break;
                            FoundLast := true;
                            DocType := Text018;
                            DocNo := Text010;
                            ExtDocNo := Text010;
                            LineAmount := 0;
                            LineDiscount := 0;
                        end;
                    end;

                }
                dataitem(PrintCheck; Integer)
                {
                    DataItemTableView = sorting(Number);
                    MaxIteration = 1;
                    column(DescriptionLine_1__________DescriptionLine_2________; DescriptionLine[1])
                    {
                    }
                    column(ChecktoName_______; ChecktoName + '**')
                    {
                    }
                    column(CheckAmountText_______; '**' + CheckAmountText + '**')
                    {
                    }
                    column(Check_date; CheckDate)
                    {
                    }
                    column(A_c_PayeeCaption; txtAddPayAccount)
                    {
                    }
                    trigger OnPreDataItem();
                    begin
                        //ReportForNavSetShowOutput(NOT blnAccPayee) ;
                        //ReportForNavSetShowOutput(blnAccPayee) ;
                        //			ReportForNav.OnPreDataItem('PrintCheck',PrintCheck);
                    end;

                    trigger OnAfterGetRecord();
                    var
                        Decimals: Decimal;
                    begin
                        if not TestPrint then begin
                            with GenJnlLine do begin
                                CheckLedgEntry.Init;
                                CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                                CheckLedgEntry."Posting Date" := "Posting Date";
                                CheckLedgEntry."Document Type" := "Document Type";
                                CheckLedgEntry."Document No." := "Document No.";
                                CheckLedgEntry.Description := Description;
                                CheckLedgEntry."Bank Payment Type" := "Bank Payment Type";
                                CheckLedgEntry."Bal. Account Type" := BalancingType;
                                CheckLedgEntry."Bal. Account No." := BalancingNo;
                                if FoundLast then begin
                                    if TotalLineAmount < 0 then
                                        Error(
                                          Text020,
                                          UseCheckNo, TotalLineAmount);
                                    CheckLedgEntry."Entry Status" := CheckLedgEntry."entry status"::Printed;
                                    CheckLedgEntry.Amount := TotalLineAmount - TDSAmount - WorkTaxAmount;
                                end else begin
                                    CheckLedgEntry."Entry Status" := CheckLedgEntry."entry status"::Voided;
                                    CheckLedgEntry.Amount := 0;
                                end;
                                CheckLedgEntry."Check Date" := "Cheque Date";
                                CheckLedgEntry."Check No." := UseCheckNo;
                                CheckManagement.InsertCheck(CheckLedgEntry, RecordIdToPrint);   //check
                                if FoundLast then begin
                                    if BankAcc2."Currency Code" <> '' then
                                        Currency.Get(BankAcc2."Currency Code")
                                    else
                                        Currency.InitRoundingPrecision;
                                    Decimals := CheckLedgEntry.Amount - ROUND(CheckLedgEntry.Amount, 1, '<');
                                    if StrLen(Format(Decimals)) < StrLen(Format(Currency."Amount Rounding Precision")) then
                                        if Decimals = 0 then
                                            CheckAmountText := Format(CheckLedgEntry.Amount, 0, 0)
                                        /* +COPYSTR(FORMAT(0.01),2,1) +PADSTR('',STRLEN(FORMAT(Currency."Amount Rounding Precision"))-2,'0')*/ // CCIT-PRI-Comment
                                        else
                                            CheckAmountText := Format(CheckLedgEntry.Amount, 0, 0) +
                                              PadStr('', StrLen(Format(Currency."Amount Rounding Precision")) - StrLen(Format(Decimals)), '0')
                                    else
                                        CheckAmountText := Format(CheckLedgEntry.Amount, 0, 0);
                                    // ofclrsw11 Begin  // above statement changed with following lines
                                    //	  CheckAmountText := rptCheck.IndianDigitSeparator(CheckLedgEntry.Amount, 2) ;
                                    // ofclrsw11 End
                                    //	  rptCheck.FormatNoTextNew(DescriptionLine,CheckLedgEntry.Amount,BankAcc2."Currency Code"); //CCIT-PRI
                                    VoidText := '';
                                end else begin
                                    Clear(CheckAmountText);
                                    Clear(DescriptionLine);
                                    DescriptionLine[1] := Text021 + '' + DescriptionLine[1];
                                    // DescriptionLine[2] := DescriptionLine[1];
                                    VoidText := Text022;
                                end;
                            end;
                        end else begin
                            with GenJnlLine do begin
                                CheckLedgEntry.Init;
                                CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                                CheckLedgEntry."Posting Date" := "Posting Date";
                                CheckLedgEntry."Document No." := "Document No.";
                                CheckLedgEntry.Description := Text023;
                                CheckLedgEntry."Bank Payment Type" := "bank payment type"::"Computer Check";
                                CheckLedgEntry."Entry Status" := CheckLedgEntry."entry status"::"Test Print";
                                CheckLedgEntry."Check Date" := "Cheque Date";
                                CheckLedgEntry."Check No." := UseCheckNo;
                                CheckManagement.InsertCheck(CheckLedgEntry, RecordIdToPrint); //check
                                CheckAmountText := Text024;
                                DescriptionLine[1] := Text025;
                                DescriptionLine[2] := DescriptionLine[1];
                                VoidText := Text022;
                            end;
                        end;
                        ChecksPrinted := ChecksPrinted + 1;
                        FirstPage := false;

                    end;

                }
                trigger OnPreDataItem();
                begin
                    FirstPage := true;
                    FoundLast := false;
                    TotalLineAmount := 0;
                    TotalLineDiscount := 0;
                    //		ReportForNav.OnPreDataItem('CheckPages',CheckPages);
                end;

                trigger OnAfterGetRecord();
                begin
                    if FoundLast then
                        CurrReport.Break;
                    UseCheckNo := IncStr(UseCheckNo);
                    if not TestPrint then
                        CheckNoText := UseCheckNo
                    else
                        CheckNoText := Text011;
                end;

                trigger OnPostDataItem();
                begin
                    if not TestPrint then begin
                        if UseCheckNo <> GenJnlLine."Document No." then begin
                            GenJnlLine3.Reset;
                            GenJnlLine3.SetCurrentkey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                            GenJnlLine3.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3.SetRange("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3.SetRange("Document No.", UseCheckNo);
                            if GenJnlLine3.Find('-') then
                                GenJnlLine3.FieldError("Document No.", StrSubstNo(Text013, UseCheckNo));
                        end;
                        if ApplyMethod <> Applymethod::MoreLinesOneEntry then begin
                            GenJnlLine3 := GenJnlLine;
                            GenJnlLine3."Cheque No." := UseCheckNo;
                            GenJnlLine3."Check Printed" := true;
                            GenJnlLine3.Modify;
                        end else begin
                            if GenJnlLine2.Find('-') then begin
                                HighestLineNo := GenJnlLine2."Line No.";
                                repeat
                                    if GenJnlLine2."Line No." > HighestLineNo then
                                        HighestLineNo := GenJnlLine2."Line No.";
                                    GenJnlLine3 := GenJnlLine2;
                                    GenJnlLine3.TestField("Posting No. Series", '');
                                    GenJnlLine3."Bal. Account No." := '';
                                    GenJnlLine3."Bank Payment Type" := GenJnlLine3."bank payment type"::" ";
                                    GenJnlLine3."Cheque No." := UseCheckNo;
                                    GenJnlLine3."Check Printed" := true;
                                    GenJnlLine3.Validate(Amount);
                                    GenJnlLine3.Modify;
                                until GenJnlLine2.Next = 0;
                            end;
                            GenJnlLine3.Reset;
                            GenJnlLine3 := GenJnlLine;
                            GenJnlLine3.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3."Line No." := HighestLineNo;
                            if GenJnlLine3.Next = 0 then
                                GenJnlLine3."Line No." := HighestLineNo + 10000
                            else begin
                                while GenJnlLine3."Line No." = HighestLineNo + 1 do begin
                                    HighestLineNo := GenJnlLine3."Line No.";
                                    if GenJnlLine3.Next = 0 then
                                        GenJnlLine3."Line No." := HighestLineNo + 20000;
                                end;
                                GenJnlLine3."Line No." := (GenJnlLine3."Line No." + HighestLineNo) DIV 2;
                            end;
                            GenJnlLine3.Init;
                            GenJnlLine3.Validate("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3."Document Type" := GenJnlLine."Document Type";
                            GenJnlLine3."Cheque No." := UseCheckNo;
                            GenJnlLine3."Account Type" := GenJnlLine3."account type"::"Bank Account";
                            GenJnlLine3.Validate("Account No.", BankAcc2."No.");
                            if BalancingType <> Balancingtype::"G/L Account" then
                                GenJnlLine3.Description := StrSubstNo(Text014, SelectStr(BalancingType + 1, Text062), BalancingNo);
                            GenJnlLine3.Validate(Amount, -TotalLineAmount);
                            GenJnlLine3."Bank Payment Type" := GenJnlLine3."bank payment type"::"Computer Check";
                            GenJnlLine3."Check Printed" := true;
                            GenJnlLine3."Source Code" := GenJnlLine."Source Code";
                            GenJnlLine3."Reason Code" := GenJnlLine."Reason Code";
                            GenJnlLine3."Allow Zero-Amount Posting" := true;
                            GenJnlLine3."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
                            GenJnlLine3."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
                            GenJnlLine3.Insert;
                            /*
                            JournalLineDimension.SETRANGE("Table ID",DATABASE::"Gen. Journal Line");
                            JournalLineDimension.SETRANGE("Journal Template Name",GenJnlLine."Journal Template Name");
                            JournalLineDimension.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
                            JournalLineDimension.SETRANGE("Journal Line No.",GenJnlLine."Line No.");
                            DimensionManagement.MoveJnlLineDimToJnlLineDim(JournalLineDimension,
                              DATABASE::"Gen. Journal Line",
                              GenJnlLine3."Journal Template Name",
                              GenJnlLine3."Journal Batch Name",
                              GenJnlLine3."Line No.");
                              */
                        end;
                    end;
                    BankAcc2."Last Check No." := UseCheckNo;
                    BankAcc2.Modify;
                    Commit;
                    Clear(CheckManagement);

                end;

            }
            trigger OnPreDataItem();
            begin
                GenJnlLine.Copy(VoidGenJnlLine);
                CompanyInfo.Get;
                txtCompanyName := CompanyInfo.Name;
                if not TestPrint then begin
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                    BankAcc2.Get(BankAcc2."No.");
                    BankAcc2.TestField(Blocked, false);
                    Copy(VoidGenJnlLine);
                    SetRange("Bank Payment Type", "bank payment type"::"Computer Check");
                    SetRange("Check Printed", false);
                    SetFilter("Cheque Date", '<>%1', 0D);
                end else begin
                    Clear(CompanyAddr);
                    for i := 1 to 5 do
                        CompanyAddr[i] := Text003;
                end;
                ChecksPrinted := 0;
                SetRange("Account Type", GenJnlLine."account type"::"Fixed Asset");
                if Find('-') then
                    GenJnlLine.FieldError("Account Type");
                SetRange("Account Type");
                //	ReportForNav.OnPreDataItem('GenJnlLine',GenJnlLine);
            end;

            trigger OnAfterGetRecord();
            begin
                if OneCheckPrVendor and (GenJnlLine."Currency Code" <> '') and
                   (GenJnlLine."Currency Code" <> Currency.Code)
                then begin
                    Currency.Get(GenJnlLine."Currency Code");
                    Currency.TestField("Conv. LCY Rndg. Debit Acc.");
                    Currency.TestField("Conv. LCY Rndg. Credit Acc.");
                end;
                if not TestPrint then begin
                    if Amount = 0 then
                        CurrReport.Skip;
                    //TESTFIELD("Bal. Account Type","Bal. Account Type"::"Bank Account");
                    if "Bal. Account Type" = "bal. account type"::"Bank Account" then
                        if "Bal. Account No." <> BankAcc2."No." then begin
                            if "Account Type" <> "account type"::"Bank Account" then
                                CurrReport.Skip
                            else
                                if "Account No." <> BankAcc2."No." then
                                    CurrReport.Skip
                        end;
                    if (("Bal. Account No." <> '') and
                        ("Bal. Account Type" = "bal. account type"::"Bank Account"))
                        or
                        (("Account No." <> '') and
                        ("Account Type" = "account type"::"Bank Account"))
                           then begin
                        BalancingType := "Account Type";
                        BalancingNo := "Account No.";
                        // RSW
                        if ("Account Type" = "account type"::"Bank Account") and ("Bal. Account Type" = "bal. account type"::"Bank Account") then
                            RemainingAmount := Amount
                        else
                            if ("Account Type" = "account type"::"Bank Account") then
                                RemainingAmount := -Amount
                            else
                                RemainingAmount := Amount;
                        //v	TDSAmount := Abs("Total TDS/TCS Incl. SHE CESS");
                        //v	WorkTaxAmount := Abs("Work Tax Amount");
                        if OneCheckPrVendor then begin
                            ApplyMethod := Applymethod::MoreLinesOneEntry;
                            GenJnlLine2.Reset;
                            GenJnlLine2.SetCurrentkey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                            GenJnlLine2.SetRange("Journal Template Name", "Journal Template Name");
                            GenJnlLine2.SetRange("Journal Batch Name", "Journal Batch Name");
                            GenJnlLine2.SetRange("Posting Date", "Posting Date");
                            GenJnlLine2.SetRange("Document No.", "Document No.");
                            GenJnlLine2.SetRange("Account Type", "Account Type");
                            GenJnlLine2.SetRange("Account No.", "Account No.");
                            GenJnlLine2.SetRange("Bal. Account Type", "Bal. Account Type");
                            GenJnlLine2.SetRange("Bal. Account No.", "Bal. Account No.");
                            GenJnlLine2.SetRange("Bank Payment Type", "Bank Payment Type");
                            GenJnlLine2.Find('-');
                            RemainingAmount := 0;
                        end else
                            if "Applies-to Doc. No." <> '' then
                                ApplyMethod := Applymethod::OneLineOneEntry
                            else
                                if "Applies-to ID" <> '' then
                                    ApplyMethod := Applymethod::OneLineID
                                else
                                    ApplyMethod := Applymethod::Payment;
                    end else
                        if "Account No." = '' then
                            FieldError("Account No.", Text004);
                    //	ELSE
                    //	  FIELDERROR("Bal. Account No.",Text004);
                    ChecktoName := '';
                    Clear(CheckToAddr);
                    ContactText := '';
                    Clear(SalesPurchPerson);
                    case BalancingType of
                        Balancingtype::"G/L Account":
                            begin
                                //   ChecktoName := GenJnlLine.Description Original CCIT
                                ChecktoName := GenJnlLine."Payer Information";
                            end;
                        Balancingtype::Customer:
                            begin
                                Cust.Get(BalancingNo);
                                if Cust.Blocked = Cust.Blocked::All then
                                    Error(Text064, Cust.FieldCaption(Blocked), Cust.Blocked, Cust.TableCaption, Cust."No.");
                                Cust.Contact := '';
                                // ChecktoName := GenJnlLine.Description;
                                ChecktoName := GenJnlLine."Payer Information";
                                FormatAddr.Customer(CheckToAddr, Cust);
                                if BankAcc2."Currency Code" <> "Currency Code" then
                                    Error(Text005);
                                if Cust."Salesperson Code" <> '' then begin
                                    ContactText := Text006;
                                    SalesPurchPerson.Get(Cust."Salesperson Code");
                                end;
                            end;
                        Balancingtype::Vendor:
                            begin
                                Vend.Get(BalancingNo);
                                if Vend.Blocked in [Vend.Blocked::All, Vend.Blocked::Payment] then
                                    Error(Text064, Vend.FieldCaption(Blocked), Vend.Blocked, Vend.TableCaption, Vend."No.");
                                Vend.Contact := '';
                                //  ChecktoName := GenJnlLine.Description;	Original CCIT
                                ChecktoName := GenJnlLine."Payer Information";
                                FormatAddr.Vendor(CheckToAddr, Vend);
                                if BankAcc2."Currency Code" <> "Currency Code" then
                                    Error(Text005);
                                if Vend."Purchaser Code" <> '' then begin
                                    ContactText := Text007;
                                    SalesPurchPerson.Get(Vend."Purchaser Code");
                                end;
                            end;
                        Balancingtype::"Bank Account":
                            begin
                                BankAcc.Get(BalancingNo);
                                BankAcc.TestField(Blocked, false);
                                BankAcc.Contact := '';
                                //  ChecktoName := GenJnlLine.Description;  Original CCIT
                                ChecktoName := GenJnlLine."Payer Information";
                                FormatAddr.BankAcc(CheckToAddr, BankAcc);
                                if BankAcc2."Currency Code" <> BankAcc."Currency Code" then
                                    Error(Text008);
                                if BankAcc."Our Contact Code" <> '' then begin
                                    ContactText := Text009;
                                    SalesPurchPerson.Get(BankAcc."Our Contact Code");
                                end;
                            end;
                    end;
                    //AR//
                    Day := Date2dmy("Cheque Date", 1);
                    Month := Date2dmy("Cheque Date", 2);
                    Year := Date2dmy("Cheque Date", 3);
                    Date := Dmy2date(Day, Month, Year);
                    txtDate := CopyStr(Format(Date), 1, 6);
                    CheckDateText := Format("Cheque Date", 0, '<Day,2>-<Month,2>-<Year>');
                    DT1 := CopyStr(CheckDateText, 1, 1);
                    DT2 := CopyStr(CheckDateText, 2, 1);
                    MN1 := CopyStr(CheckDateText, 4, 1);
                    MN2 := CopyStr(CheckDateText, 5, 1);
                    YR1 := '2';
                    YR2 := '0';
                    YR3 := CopyStr(CheckDateText, 7, 1);
                    YR4 := CopyStr(CheckDateText, 8, 1);
                    CheckDate := DT1 + '   ' + DT2 + '   ' + MN1 + '   ' + MN2 + '   ' + YR1 + '   ' + YR2 + '   ' + YR3 + '   ' + YR4;
                    //v	decTDSAmount := "Total TDS/TCS Incl. SHE CESS";
                end else begin
                    if ChecksPrinted > 0 then
                        CurrReport.Break;
                    BalancingType := Balancingtype::Vendor;
                    BalancingNo := Text010;
                    ChecktoName := '';
                    Clear(CheckToAddr);
                    for i := 1 to 5 do
                        CheckToAddr[i] := Text003;
                    ContactText := '';
                    Clear(SalesPurchPerson);
                    CheckNoText := Text011;
                    CheckDateText := Text012;
                    decTDSAmount := 0;
                end;
                if AddPayAccount = false then begin
                    txtAddPayAccount := 'A/c Payee';
                end;
            end;

        }
    }
    requestpage
    {
        SaveValues = false;
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Bank Account"; BankAcc2."No.")
                    {
                        ApplicationArea = Basic;
                        TableRelation = "Bank Account";

                        trigger OnValidate()
                        begin
                            if recBankAccount.Get(BankAcc2."No.") then
                                UseCheckNo := recBankAccount."Last Check No.";
                        end;
                    }
                    field("Last Check No."; UseCheckNo)
                    {
                        ApplicationArea = Basic;
                    }
                    field("One Check Vendor Document No."; OneCheckPrVendor)
                    {
                        ApplicationArea = Basic;
                    }
                    field("Not Add Payee Account"; AddPayAccount)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Not Add Payee Account';
                    }
                    field("Reprint Checks"; ReprintChecks)
                    {
                        ApplicationArea = Basic;
                    }
                    field("Test Print"; TestPrint)
                    {
                        ApplicationArea = Basic;
                    }
                    field("Preprinted Stub"; PreprintedStub)
                    {
                        ApplicationArea = Basic;
                    }
                }
            }
        }

    }

    trigger OnPreReport()
    begin
    end;

    var
        Text000: label 'Preview is not allowed.';
        Text001: label 'Last Check No. must be filled in.';
        Text002: label 'Filters on %1 and %2 are not allowed.';
        Text003: label 'XXXXXXXXXXXXXXXX';
        Text004: label 'must be entered.';
        Text005: label 'The Bank Account and the General Journal Line must have the same currency.';
        Text006: label 'Salesperson';
        Text007: label 'Purchaser';
        Text008: label 'Both Bank Accounts must have the same currency.';
        Text009: label 'Our Contact';
        Text010: label 'XXXXXXXXXX';
        Text011: label 'XXXX';
        Text012: label 'XX.XXXXXXXXXX.XXXX';
        Text013: label '%1 already exists.';
        Text014: label 'Check for %1 %2';
        Text015: label 'Payment';
        Text016: label 'In the Check report, One Check per Vendor and Document No.\';
        Text017: label 'must not be activated when Applies-to ID is specified in the journal lines.';
        Text018: label 'XXX';
        Text019: label 'Total';
        Text020: label 'The total amount of check %1 is %2. The amount must be positive.';
        Text021: label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022: label 'NON-NEGOTIABLE';
        Text023: label 'Test print';
        Text024: label 'XXXX.XX';
        Text025: label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text026: label 'ZERO';
        Text027: label 'HUNDRED';
        Text028: label 'AND';
        Text029: label '%1 results in a written number that is too long.';
        Text030: label ' is already applied to %1 %2 for customer %3.';
        Text031: label ' is already applied to %1 %2 for vendor %3.';
        Text032: label 'ONE';
        Text033: label 'TWO';
        Text034: label 'THREE';
        Text035: label 'FOUR';
        Text036: label 'FIVE';
        Text037: label 'SIX';
        Text038: label 'SEVEN';
        Text039: label 'EIGHT';
        Text040: label 'NINE';
        Text041: label 'TEN';
        Text042: label 'ELEVEN';
        Text043: label 'TWELVE';
        Text044: label 'THIRTEEN';
        Text045: label 'FOURTEEN';
        Text046: label 'FIFTEEN';
        Text047: label 'SIXTEEN';
        Text048: label 'SEVENTEEN';
        Text049: label 'EIGHTEEN';
        Text050: label 'NINETEEN';
        Text051: label 'TWENTY';
        Text052: label 'THIRTY';
        Text053: label 'FORTY';
        Text054: label 'FIFTY';
        Text055: label 'SIXTY';
        Text056: label 'SEVENTY';
        Text057: label 'EIGHTY';
        Text058: label 'NINETY';
        Text059: label 'THOUSAND';
        Text060: label 'MILLION';
        Text061: label 'BILLION';
        Text1280000: label 'LAKH';
        Text1280001: label 'CRORE';
        CompanyInfo: Record "Company Information";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlLine3: Record "Gen. Journal Line";
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        Vend: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAcc: Record "Bank Account";
        BankAcc2: Record "Bank Account";
        CheckLedgEntry: Record "Check Ledger Entry";
        Currency: Record Currency;
        FormatAddr: Codeunit "Format Address";
        CheckManagement: Codeunit CheckManagement;
        DimensionManagement: Codeunit DimensionManagement;
        CompanyAddr: array[8] of Text[50];
        CheckToAddr: array[8] of Text[50];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        BalancingType: Option "G/L Account",Customer,Vendor,"Bank Account";
        BalancingNo: Code[20];
        ContactText: Text[30];
        CheckNoText: Text[30];
        CheckDateText: Text[30];
        CheckAmountText: Text[30];
        DescriptionLine: array[2] of Text[80];
        DocType: Text[30];
        DocNo: Text[30];
        ExtDocNo: Text[30];
        VoidText: Text[30];
        LineAmount: Decimal;
        LineDiscount: Decimal;
        TotalLineAmount: Decimal;
        TotalLineDiscount: Decimal;
        RemainingAmount: Decimal;
        CurrentLineAmount: Decimal;
        UseCheckNo: Code[20];
        FoundLast: Boolean;
        ReprintChecks: Boolean;
        TestPrint: Boolean;
        FirstPage: Boolean;
        OneCheckPrVendor: Boolean;
        FoundNegative: Boolean;
        ApplyMethod: Option Payment,OneLineOneEntry,OneLineID,MoreLinesOneEntry;
        ChecksPrinted: Integer;
        HighestLineNo: Integer;
        PreprintedStub: Boolean;
        TotalText: Text[10];
        DocDate: Date;
        i: Integer;
        Text062: label 'G/L Account,Customer,Vendor,Bank Account';
        CurrencyCode2: Code[10];
        NetAmount: Text[30];
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        LineAmount2: Decimal;
        Text063: label 'Net Amount %1';
        GLSetup: Record "General Ledger Setup";
        Text064: label '%1 must not be %2 for %3 %4.';
        TDSAmount: Decimal;
        WorkTaxAmount: Decimal;
        ReasonCode: Record "Reason Code";
        strText: Text[500];
        ExtDocDate: Date;
        ChecktoName: Text[100];
        decTDSAmount: Decimal;
        txtPrecision2: Text[50];
        txtNarration: Text[250];
        rptCheck: Report Check;
        txtCompanyName: Text[100];
        cdAccountNumber: Code[30];
        blnAccPayee: Boolean;
        A_c_PayeeCaptionLbl: label 'A/c Payee';
        recBankAccount: Record "Bank Account";
        Daycheck: Integer;
        monthcheck: Integer;
        yearcheck: Integer;
        DT1: Text[30];
        DT2: Text[30];
        MN1: Text[30];
        MN2: Text[30];
        YR1: Text[30];
        YR2: Text[30];
        YR3: Text[30];
        YR4: Text[30];
        Year: Integer;
        Date: Date;
        Month: Integer;
        txtDate: Text[30];
        Day: Integer;
        CheckDate: Text[50];
        AddPayAccount: Boolean;
        txtAddPayAccount: Text[50];
        RecordIdToPrint: RecordID;

    local procedure CustUpdateAmounts(var CustLedgEntry2: Record "Cust. Ledger Entry"; RemainingAmount2: Decimal)
    begin
        if (ApplyMethod = Applymethod::OneLineOneEntry) or
           (ApplyMethod = Applymethod::MoreLinesOneEntry)
        then begin
            GenJnlLine3.Reset;
            GenJnlLine3.SetCurrentkey(
              "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SetRange("Account Type", GenJnlLine3."account type"::Customer);
            GenJnlLine3.SetRange("Account No.", CustLedgEntry2."Customer No.");
            GenJnlLine3.SetRange("Applies-to Doc. Type", CustLedgEntry2."Document Type");
            GenJnlLine3.SetRange("Applies-to Doc. No.", CustLedgEntry2."Document No.");
            if ApplyMethod = Applymethod::OneLineOneEntry then
                GenJnlLine3.SetFilter("Line No.", '<>%1', GenJnlLine."Line No.")
            else
                GenJnlLine3.SetFilter("Line No.", '<>%1', GenJnlLine2."Line No.");
            if CustLedgEntry2."Document Type" <> CustLedgEntry2."document type"::" " then
                if GenJnlLine3.Find('-') then
                    GenJnlLine3.FieldError(
                      "Applies-to Doc. No.",
                      StrSubstNo(
                        Text030,
                        CustLedgEntry2."Document Type", CustLedgEntry2."Document No.",
                        CustLedgEntry2."Customer No."));
        end;
        DocType := Format(CustLedgEntry2."Document Type");
        DocNo := CustLedgEntry2."Document No.";
        ExtDocNo := CustLedgEntry2."External Document No.";
        DocDate := CustLedgEntry2."Posting Date";
        CurrencyCode2 := CustLedgEntry2."Currency Code";
        ExtDocDate := CustLedgEntry2."Document Date";
        CustLedgEntry2.CalcFields("Remaining Amount");
        LineAmount := -(CustLedgEntry2."Remaining Amount" - CustLedgEntry2."Remaining Pmt. Disc. Possible" -
          CustLedgEntry2."Accepted Payment Tolerance");
        LineAmount2 :=
          ROUND(
            ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, LineAmount),
            Currency."Amount Rounding Precision");
        if ((CustLedgEntry2."Document Type" = CustLedgEntry2."document type"::Invoice) and
           (GenJnlLine."Posting Date" <= CustLedgEntry2."Pmt. Discount Date") and
           (LineAmount2 <= RemainingAmount2)) or CustLedgEntry2."Accepted Pmt. Disc. Tolerance"
        then begin
            LineDiscount := -CustLedgEntry2."Remaining Pmt. Disc. Possible";
            if CustLedgEntry2."Accepted Payment Tolerance" <> 0 then
                LineDiscount := LineDiscount - CustLedgEntry2."Accepted Payment Tolerance";
        end else begin
            if RemainingAmount2 >=
               ROUND(
                -(ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                  CustLedgEntry2."Remaining Amount")), Currency."Amount Rounding Precision")
            then
                LineAmount2 :=
                  ROUND(
                    -(ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                      CustLedgEntry2."Remaining Amount")), Currency."Amount Rounding Precision")
            else begin
                LineAmount2 := RemainingAmount2;
                LineAmount :=
                  ROUND(
                    ExchangeAmt(CustLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                    LineAmount2), Currency."Amount Rounding Precision");
            end;
            LineDiscount := 0;
        end;
    end;

    local procedure VendUpdateAmounts(var VendLedgEntry2: Record "Vendor Ledger Entry"; RemainingAmount2: Decimal)
    begin
        if (ApplyMethod = Applymethod::OneLineOneEntry) or
           (ApplyMethod = Applymethod::MoreLinesOneEntry)
        then begin
            GenJnlLine3.Reset;
            GenJnlLine3.SetCurrentkey(
              "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SetRange("Account Type", GenJnlLine3."account type"::Vendor);
            GenJnlLine3.SetRange("Account No.", VendLedgEntry2."Vendor No.");
            GenJnlLine3.SetRange("Applies-to Doc. Type", VendLedgEntry2."Document Type");
            GenJnlLine3.SetRange("Applies-to Doc. No.", VendLedgEntry2."Document No.");
            if ApplyMethod = Applymethod::OneLineOneEntry then
                GenJnlLine3.SetFilter("Line No.", '<>%1', GenJnlLine."Line No.")
            else
                GenJnlLine3.SetFilter("Line No.", '<>%1', GenJnlLine2."Line No.");
            if VendLedgEntry2."Document Type" <> VendLedgEntry2."document type"::" " then
                if GenJnlLine3.Find('-') then
                    GenJnlLine3.FieldError(
                      "Applies-to Doc. No.",
                      StrSubstNo(
                        Text031,
                        VendLedgEntry2."Document Type", VendLedgEntry2."Document No.",
                        VendLedgEntry2."Vendor No."));
        end;
        DocType := Format(VendLedgEntry2."Document Type");
        DocNo := VendLedgEntry2."Document No.";
        ExtDocNo := VendLedgEntry2."External Document No.";
        DocDate := VendLedgEntry2."Posting Date";
        CurrencyCode2 := VendLedgEntry2."Currency Code";
        ExtDocDate := VendLedgEntry2."Document Date";
        VendLedgEntry2.CalcFields("Remaining Amount");
        LineAmount := -(VendLedgEntry2."Remaining Amount" - VendLedgEntry2."Remaining Pmt. Disc. Possible" -
          VendLedgEntry2."Accepted Payment Tolerance");
        LineAmount2 :=
          ROUND(
            ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, LineAmount),
            Currency."Amount Rounding Precision");
        if (((VendLedgEntry2."Document Type" = VendLedgEntry2."document type"::Invoice) or
           (VendLedgEntry2."Document Type" = VendLedgEntry2."document type"::"Credit Memo")) and
           (GenJnlLine."Posting Date" <= VendLedgEntry2."Pmt. Discount Date") and
           (LineAmount2 <= RemainingAmount2)) or VendLedgEntry2."Accepted Pmt. Disc. Tolerance"
        then begin
            LineDiscount := -VendLedgEntry2."Remaining Pmt. Disc. Possible";
            if VendLedgEntry2."Accepted Payment Tolerance" <> 0 then
                LineDiscount := LineDiscount - VendLedgEntry2."Accepted Payment Tolerance";
        end else begin
            if RemainingAmount2 >=
                ROUND(
                 -(ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                   VendLedgEntry2."Amount to Apply")), Currency."Amount Rounding Precision")
             then begin
                LineAmount2 :=
                  ROUND(
                    -(ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                      VendLedgEntry2."Amount to Apply")), Currency."Amount Rounding Precision");
                LineAmount :=
                  ROUND(
                    ExchangeAmt(VendLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                    LineAmount2), Currency."Amount Rounding Precision");
            end else begin
                LineAmount2 := RemainingAmount2;
                LineAmount :=
                  ROUND(
                    ExchangeAmt(VendLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                    LineAmount2), Currency."Amount Rounding Precision");
            end;
            LineDiscount := 0;
        end;
    end;

    procedure InitializeRequest(BankAcc: Code[20]; LastCheckNo: Code[20]; NewOneCheckPrVend: Boolean; NewReprintChecks: Boolean; NewTestPrint: Boolean; NewPreprintedStub: Boolean)
    begin
        if BankAcc <> '' then
            if BankAcc2.Get(BankAcc) then begin
                UseCheckNo := LastCheckNo;
                OneCheckPrVendor := NewOneCheckPrVend;
                ReprintChecks := NewReprintChecks;
                TestPrint := NewTestPrint;
                PreprintedStub := NewPreprintedStub;
            end;
    end;

    procedure ExchangeAmt(PostingDate: Date; CurrencyCode: Code[10]; CurrencyCode2: Code[10]; Amount: Decimal) Amount2: Decimal
    begin
        if (CurrencyCode <> '') and (CurrencyCode2 = '') then
            Amount2 :=
              CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                PostingDate, CurrencyCode, Amount, CurrencyExchangeRate.ExchangeRate(PostingDate, CurrencyCode))
        else if (CurrencyCode = '') and (CurrencyCode2 <> '') then
            Amount2 :=
              CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                PostingDate, CurrencyCode2, Amount, CurrencyExchangeRate.ExchangeRate(PostingDate, CurrencyCode2))
        else if (CurrencyCode <> '') and (CurrencyCode2 <> '') and (CurrencyCode <> CurrencyCode2) then
            Amount2 := CurrencyExchangeRate.ExchangeAmtFCYToFCY(PostingDate, CurrencyCode2, CurrencyCode, Amount)
        else
            Amount2 := Amount;
    end;

    trigger OnInitReport();
    begin
        //	;ReportsForNavInit;
    end;

}
