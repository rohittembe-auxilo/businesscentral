Report 50116 "Vendor Ledger"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VendorLedger.rdl';

    Caption = 'Vendor - Ledger';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Date Filter";
            column(ReportForNavId_3182; 3182)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(CompanyAddr_1_; CompanyAddr[1])
            {
            }
            column(CompanyAddr_2_______CompanyAddr_3_______CompanyAddr_4_; CompanyAddr[2] + '  ' + CompanyAddr[3] + '  ' + CompanyAddr[4])
            {
            }
            column(for_the_period_________VendDateFilter; VendDateFilter)
            {
            }
            column(Vendor_TABLECAPTION__________VendFilter; Vendor.TableCaption + ': ' + VendFilter)
            {
            }
            column(BalanceCaption; BalanceCaption)
            {
            }
            column(CreditCaption; CreditCaption)
            {
            }
            column(DebitCaption; DebitCaption)
            {
            }
            column(VendName; Vendor.Name)
            {
            }
            column(Vendor_Name; Name)
            {
            }
            column(Vendor__No__; "No.")
            {
            }
            column(ABS_StartBalanceLCY_; Abs(StartBalanceLCY))
            {
                AutoFormatType = 1;
            }
            column(DrCrBalanceText; DrCrBalanceText)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Vendor_LedgerCaption; Vendor_LedgerCaptionLbl)
            {
            }
            column(All_amounts_are_in_LCYCaption; All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(This_report_also_includes_vendors_that_only_have_balances_Caption; This_report_also_includes_vendors_that_only_have_balances_CaptionLbl)
            {
            }
            column(Document_No_Caption; Document_No_CaptionLbl)
            {
            }
            column(Posting_DateCaption; Posting_DateCaptionLbl)
            {
            }
            column(Vendor_Bill_No__Cheque_No_Caption; Vendor_Bill_No__Cheque_No_CaptionLbl)
            {
            }
            column(DateCaption; DateCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Opening_BalanceCaption; Opening_BalanceCaptionLbl)
            {
            }
            column(Vendor_Date_Filter; Format("Date Filter", 0, '<Day,2>-<Month Text,3>-<Year4>'))
            {
            }
            column(Vendor_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(PrintDetail; PrintDetail)
            {
            }
            column(PrintVoucherNarr; PrintVoucherNarr)
            {
            }
            column(PrintLineNarr; PrintLineNarr)
            {
            }
            column(Vendor_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = field("No."), "Posting Date" = field("Date Filter"), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Date Filter" = field("Date Filter");
                DataItemTableView = sorting("Vendor No.", "Posting Date");
                RequestFilterFields = "Document No.";
                column(ReportForNavId_4114; 4114)
                {
                }
                column(Vendor_Ledger_Entry__Posting_Date_; Format("Posting Date", 0, '<Day,2>-<Month Text,3>-<Year4>'))
                {
                }
                column(Vendor_Ledger_Entry__Document_No__; "Document No.")
                {
                }
                column(ABS_VendorBalance_; Abs(VendorBalance))
                {
                    AutoFormatType = 1;
                }
                column(VendDBAmount; VendDBAmount)
                {
                }
                column(VendCRAmount; VendCRAmount)
                {
                }
                column(ControlAccountName; ControlAccountName)
                {
                }
                column(VendInvChequeNo; VendInvChequeNo)
                {
                }
                column(VendInvChequedate; VendInvChequedate)
                {
                }
                column(DrCrBalanceText_Control1000000020; DrCrBalanceText)
                {
                }
                column(Vendor_Ledger_Entry_Entry_No_; "Entry No.")
                {
                }
                column(Vendor_Ledger_Entry_Vendor_No_; "Vendor No.")
                {
                }
                column(Vendor_Ledger_Entry_Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(Vendor_Ledger_Entry_Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }
                column(Vendor_Ledger_Entry_Date_Filter; Format("Date Filter", 0, '<Day,2>-<Month Text,3>-<Year4>'))
                {
                }
                column(Vendor_Ledger_Entry_Transaction_No_; "Transaction No.")
                {
                }
                dataitem(Integerloop; "Integer")
                {
                    DataItemTableView = sorting(Number) order(ascending);
                    column(ReportForNavId_2952; 2952)
                    {
                    }
                    column(AccountName; AccountName)
                    {
                    }
                    column(ABS_DetailAmt_; Abs(DetailAmt))
                    {
                    }
                    column(DrCrText; DrCrText)
                    {
                    }
                    column(Integerloop_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        DrCrText := '';

                        if Number > 1 then
                            GLEntry.Next;


                        DetailAmt := 0;
                        DetailAmt := GLEntry.Amount;
                        if DetailAmt > 0 then
                            DrCrText := 'Dr';
                        if DetailAmt < 0 then
                            DrCrText := 'Cr';
                        AccountName := Daybook.FindGLAccName(GLEntry."Source Type", GLEntry."Entry No.", GLEntry."Source No.", GLEntry."G/L Account No.");//a
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, GLEntry.Count);


                        //IF GLEntry.COUNT = 1 THEN
                        //  CurrReport.BREAK;
                    end;
                }
                dataitem("Posted Narration"; "Posted Narration")
                {
                    DataItemLink = "Entry No." = field("Entry No.");
                    DataItemTableView = sorting("Entry No.", "Transaction No.", "Line No.") order(ascending);
                    column(ReportForNavId_5326; 5326)
                    {
                    }
                    column(Posted_Narration_Narration; Narration)
                    {
                    }
                    column(Posted_Narration_Entry_No_; "Entry No.")
                    {
                    }
                    column(Posted_Narration_Transaction_No_; "Transaction No.")
                    {
                    }
                    column(Posted_Narration_Line_No_; "Line No.")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        if not PrintLineNarr then
                            CurrReport.Break;
                    end;
                }
                dataitem("Posted Narration1"; "Posted Narration")
                {
                    DataItemLink = "Transaction No." = field("Transaction No.");
                    DataItemTableView = sorting("Entry No.", "Transaction No.", "Line No.") where("Entry No." = filter(0));
                    column(ReportForNavId_9552; 9552)
                    {
                    }
                    column(Posted_Narration1_Narration; Narration)
                    {
                    }
                    column(Posted_Narration1_Entry_No_; "Entry No.")
                    {
                    }
                    column(Posted_Narration1_Transaction_No_; "Transaction No.")
                    {
                    }
                    column(Posted_Narration1_Line_No_; "Line No.")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        if not PrintVoucherNarr then
                            CurrReport.Break;
                    end;
                }
                dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
                {
                    DataItemLink = "No." = field("Document No.");
                    DataItemTableView = sorting("No.") order(ascending);
                    column(ReportForNavId_3733; 3733)
                    {
                    }
                    column(Purch__Inv__Header__Posting_Description_; "Posting Description")
                    {
                    }
                    column(Purch__Inv__Header__Purch__Inv__Header__Narration; '')
                    {
                    }
                    column(Purch__Inv__Header_No_; "No.")
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    //NMS 25Mar09 start
                    //GLEntry.SETRANGE(GLEntry."Document No.","Vendor Ledger Entry"."Document No.");
                    GLEntry.SetRange(GLEntry."Transaction No.", "Vendor Ledger Entry"."Transaction No.");
                    if GLEntry.FindFirst then;

                    if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."document type"::Payment then begin
                        BankLedger.Reset;
                        BankLedger.SetRange(BankLedger."Document No.", "Vendor Ledger Entry"."Document No.");
                        if BankLedger.FindFirst then
                            if BankAcc.Get(BankLedger."Bank Account No.") then
                                ControlAccountName := BankAcc.Name;
                    end else begin
                        NewGLEntry.Reset;
                        NewGLEntry.SetRange(NewGLEntry."Document No.", "Vendor Ledger Entry"."Document No.");
                        if NewGLEntry.FindFirst then begin
                            NewGLEntry.CalcFields(NewGLEntry."G/L Account Name");
                            ControlAccountName := NewGLEntry."G/L Account Name";
                        end;
                    end;

                    if "Vendor Ledger Entry"."Document Type" = "Vendor Ledger Entry"."document type"::Payment then begin
                        recBankAccountLedgerEntry.Reset;
                        recBankAccountLedgerEntry.SetRange(recBankAccountLedgerEntry."Document No.", "Vendor Ledger Entry"."Document No.");
                        if recBankAccountLedgerEntry.FindFirst then begin
                            VendInvChequeNo := recBankAccountLedgerEntry."Cheque No.";
                            VendInvChequedate := recBankAccountLedgerEntry."Cheque Date";
                        end;
                    end else begin
                        recPurchaseInvHeader.Reset;
                        recPurchaseInvHeader.SetRange(recPurchaseInvHeader."No.", "Vendor Ledger Entry"."Document No.");
                        if recPurchaseInvHeader.FindFirst then begin
                            VendInvChequeNo := recPurchaseInvHeader."Vendor Invoice No.";
                            VendInvChequedate := recPurchaseInvHeader."Document Date";
                        end;
                    end;


                    //NMS 25Mar09 end

                    CalcFields(Amount, "Remaining Amount", "Amount (LCY)", "Remaining Amt. (LCY)");
                    CalcFields("Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");
                    VendLedgEntryExists := true;
                    //NMS start
                    VendAmount := "Amount (LCY)";
                    VendDBAmount := "Debit Amount (LCY)";
                    VendCRAmount := "Credit Amount (LCY)";
                    VendRemainAmount := "Remaining Amt. (LCY)";
                    VendorBalance := VendorBalance + "Amount (LCY)";
                    VendCurrencyCode := '';

                    //NMS End
                    VendBalanceLCY := VendBalanceLCY + "Amount (LCY)";
                    //VendBalance := VendBalance + Amount;

                    if ("Document Type" = "document type"::Payment) or ("Document Type" = "document type"::Refund) then
                        VendEntryDueDate := 0D
                    else
                        VendEntryDueDate := "Due Date";

                    TotDBAmount := TotDBAmount + VendDBAmount;
                    TotCRAmount := TotCRAmount + VendCRAmount;
                    //MESSAGE(FORMAT((AccountName)));
                end;

                trigger OnPreDataItem()
                begin
                    VendLedgEntryExists := false;
                    CurrReport.CreateTotals(VendAmount, "Amount (LCY)");
                    CurrReport.CreateTotals(VendDBAmount, "Debit Amount (LCY)");        // vikas 030206
                    CurrReport.CreateTotals(VendCRAmount, "Credit Amount (LCY)");       // vikas 030206

                    GLEntry.Reset;//NMS 25Mar09
                    GLEntry.SetCurrentkey("Transaction No.");
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(ABS_VendorBalance__Control1000000029; Abs(VendorBalance))
                {
                    AutoFormatType = 1;
                }
                column(Vendor_Name_Control1000000031; Vendor.Name)
                {
                }
                column(DrCrBalanceText_Control1000000022; DrCrBalanceText)
                {
                }
                column(Closing_BalanceCaption; Closing_BalanceCaptionLbl)
                {
                }
                column(Integer_Number; Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not VendLedgEntryExists and ((StartBalanceLCY = 0) or ExcludeBalanceOnly) then begin
                        StartBalanceLCY := 0;
                        CurrReport.Skip;
                    end;
                    // vikas 030306
                    if not VendLedgEntryExists and ((StartBalance = 0) or ExcludeBalanceOnly) then begin
                        StartBalance := 0;
                        CurrReport.Skip;
                    end;
                    // vikas 030306
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //Vendor.SETFILTER(Vendor."No.",VendNo);
                StartBalanceLCY := 0;
                StartBalAdjLCY := 0;
                StartBalance := 0;              // vikas 030306
                StartBalAdj := 0;               // vikas 030306
                VendorBalance := 0;

                if VendDateFilter <> '' then begin
                    if GetRangeMin("Date Filter") <> 0D then begin
                        SetRange("Date Filter", 0D, GetRangeMin("Date Filter") - 1);
                        CalcFields("Net Change (LCY)");
                        CalcFields("Net Change");                        // vikas 030306
                        StartBalanceLCY := -1 * "Net Change (LCY)";   // Madhav 13-05-2006 -1 * is added as the CalcFormula contain (-)ve sign
                        StartBalance := -1 * "Net Change";                  // vikas 030306
                    end;
                    SetFilter("Date Filter", VendDateFilter);
                    CalcFields("Net Change (LCY)");
                    CalcFields("Net Change");                      // vikas 030306
                    StartBalAdjLCY := -1 * "Net Change (LCY)";     // Madhav 13-05-2006 -1 * is added as the CalcFormula contain (-)ve sign
                    StartBalAdj := -1 * "Net Change";                 // vikas 030306
                    VendorLedgerEntry.SetCurrentkey("Vendor No.", "Posting Date");
                    VendorLedgerEntry.SetRange("Vendor No.", Vendor."No.");
                    VendorLedgerEntry.SetFilter("Posting Date", VendDateFilter);
                    if VendorLedgerEntry.Find('-') then
                        repeat
                            VendorLedgerEntry.SetFilter("Date Filter", VendDateFilter);
                            VendorLedgerEntry.CalcFields("Amount (LCY)");
                            VendorLedgerEntry.CalcFields(Amount);                 // vikas 030306
                            StartBalAdjLCY := StartBalAdjLCY - VendorLedgerEntry."Amount (LCY)";
                            StartBalAdj := StartBalAdj - VendorLedgerEntry.Amount;
                        until VendorLedgerEntry.Next = 0;
                end;
                CurrReport.PrintonlyIfDetail := ExcludeBalanceOnly or (StartBalanceLCY = 0);
                CurrReport.PrintonlyIfDetail := ExcludeBalanceOnly or (StartBalance = 0);           // vikas 030306
                VendBalanceLCY := StartBalanceLCY + StartBalAdjLCY;
                VendBalance := StartBalance + StartBalAdj;                        // vikas 030306

                if not PrintAmountsInLCY then
                    VendorBalance := StartBalance
                else                                        // vikas 030306
                    VendorBalance := StartBalanceLCY;

                if StartBalanceLCY > 0 then
                    DrCrBalanceText := 'Dr'
                else
                    DrCrBalanceText := 'Cr';
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                CurrReport.CreateTotals("Vendor Ledger Entry"."Amount (LCY)", StartBalanceLCY, Correction, ApplicationRounding);
                CurrReport.CreateTotals("Vendor Ledger Entry"."Debit Amount (LCY)", "Vendor Ledger Entry"."Credit Amount (LCY)");
                CurrReport.CreateTotals(StartBalance, StartBalAdj, Correct, AppRounding);

                companyInfo.Get;
                FormatAddr.Company(CompanyAddr, companyInfo);

                //Vendor.SETFILTER(Vendor."No.",VendNo);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintLineNarr; PrintLineNarr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Line Narration';
                    }
                    field(PrintVoucherNarr; PrintVoucherNarr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Vouche rNarration';
                    }
                    field(PrintDetail; PrintDetail)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Detail';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        //PrintExcel:=TRUE;
    end;

    trigger OnPostReport()
    begin
        if PrintExcel then
            ViewBook('', '');
    end;

    trigger OnPreReport()
    begin
        // **MWORLD1.00**CUSTMISC**003**270311**AM   start

        if PrintExcel then begin
            CreateBook;
            companyInfo.Get;
            FormatAddr.Company(CompanyAddr, companyInfo);
            PrintCell(ColNo, RowNo, CompanyAddr[1], 0, 1, true, false, false, '');
            PrintCell(ColNo, RowNo, CompanyAddr[2], 1, 0, false, false, false, '');
            PrintCell(ColNo, RowNo, CompanyAddr[3], 1, 0, false, false, false, '');
            PrintCell(ColNo, RowNo, CompanyAddr[4], 5, 1, false, false, false, '');
            PrintCell(ColNo, RowNo, Format(Today), -7, 1, false, false, false, '');

            PrintCell(ColNo, RowNo, 'Vendor Ledger for the period', 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, Vendor.GetFilter(Vendor."Date Filter"), -1, 1, true, false, false, '');
            PrintCell(ColNo, RowNo, 'Vendor No', 1, 0, false, false, false, '');
            PrintCell(ColNo, RowNo, Vendor.GetFilter(Vendor."No."), -1, 2, true, false, false, '');
            PrintCell(ColNo, RowNo, 'All Amounts are in LCY', 0, 1, false, false, false, '');
            PrintCell(ColNo, RowNo, 'This report also includes vendors that only have balances.', 0, 2, false, false, false, '');

            //PrintCell(ColNo,RowNo,'Date Filter :',1,0,FALSE,FALSE,FALSE,'');
            //PrintCell(ColNo,RowNo,Vendor.GETFILTER(Vendor."Date Filter"),-3,2,FALSE,FALSE,FALSE,'');

            PrintCell(ColNo, RowNo, 'Posting Date', 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, 'Document No.', 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, 'Description', 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, 'Vendor Bill No./Cheque No.', 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, 'Date', 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, 'Debit Amount(LCY)', 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, 'Credit Amount(LCY)', 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, 'Balance (LCY)', 1, 0, true, false, false, '');
            //**MWORLD1.00**CUSTMISC**060511**MD Start
            grecGnlLedSetup.Get;
            PrintCell(ColNo, RowNo, grecGnlLedSetup."Shortcut Dimension 1 Code", 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, grecGnlLedSetup."Shortcut Dimension 2 Code", 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, grecGnlLedSetup."Shortcut Dimension 3 Code", 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, grecGnlLedSetup."Shortcut Dimension 4 Code", 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, grecGnlLedSetup."Shortcut Dimension 5 Code", 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, grecGnlLedSetup."Shortcut Dimension 6 Code", 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, grecGnlLedSetup."Shortcut Dimension 7 Code", 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, 'Employee Code', 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, 'FD Code', 1, 0, true, false, false, '');
            PrintCell(ColNo, RowNo, 'Telephone Code', -17, 1, true, false, false, '');
            //**MWORLD1.00**CUSTMISC**060511**MD End

        end;

        // **MWORLD1.00**CUSTMISC**003**270311**AM   end

        VendFilter := Vendor.GetFilters;
        VendDateFilter := Vendor.GetFilter("Date Filter");

        with "Vendor Ledger Entry" do
            if PrintAmountsInLCY then begin
                AmountCaption := FieldCaption("Amount (LCY)");
                //**CFL1.00.49**CUSTMISC**003**210708**Nitin Start
                /*Code Commented
                DebitCaption := FIELDCAPTION("Debit Amount (LCY)");            // vikas 030306
                CreditCaption := FIELDCAPTION("Credit Amount (LCY)");          // vikas 030306
                */
                DebitCaption := 'Debit Amt. (LCY)';
                CreditCaption := 'Credit Amt. (LCY)';
                //**CFL1.00.49**CUSTMISC**003**210708**Nitin End
                RemainingAmtCaption := FieldCaption("Remaining Amt. (LCY)");
                BalanceCaption := Vendor.FieldCaption(Vendor."Balance (LCY)");            //  vikas 030306
            end else begin
                AmountCaption := FieldCaption(Amount);
                DebitCaption := FieldCaption("Debit Amount");            // vikas 030306
                CreditCaption := FieldCaption("Credit Amount");          // vikas 030306
                RemainingAmtCaption := FieldCaption("Remaining Amount");
                BalanceCaption := Vendor.FieldCaption(Vendor.Balance);            //  vikas 030306
            end;

    end;

    var
        Text000: label 'Period: %1';
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VendFilter: Text[250];
        VendDateFilter: Text[30];
        VendAmount: Decimal;
        VendRemainAmount: Decimal;
        VendBalanceLCY: Decimal;
        VendEntryDueDate: Date;
        StartBalanceLCY: Decimal;
        StartBalAdjLCY: Decimal;
        Correction: Decimal;
        ApplicationRounding: Decimal;
        ExcludeBalanceOnly: Boolean;
        PrintAmountsInLCY: Boolean;
        PrintOnlyOnePerPage: Boolean;
        VendLedgEntryExists: Boolean;
        AmountCaption: Text[30];
        RemainingAmtCaption: Text[30];
        VendCurrencyCode: Code[10];
        "----vikas -----": Integer;
        StartBalance: Decimal;
        StartBalAdj: Decimal;
        Correct: Decimal;
        AppRounding: Decimal;
        BalanceCaption: Text[40];
        VendBalance: Decimal;
        VendDBAmount: Decimal;
        VendCRAmount: Decimal;
        VendorBalance: Decimal;
        TotDBAmount: Decimal;
        TotCRAmount: Decimal;
        DebitCaption: Text[40];
        CreditCaption: Text[40];
        Text001: label 'Appln Rounding:';
        Text002: label 'Application Rounding';
        CompanyAddr: array[8] of Text[50];
        companyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        App2DocNo: Text[1024];
        BankLedger: Record "Bank Account Ledger Entry";
        ok: Boolean;
        DBCR: Text[2];
        "--JDIL---": Integer;
        PrintLineNarr: Boolean;
        PrintVoucherNarr: Boolean;
        GLEntry: Record "G/L Entry";
        FirstRecord: Boolean;
        DrCrText: Text[2];
        ControlAccountName: Text[50];
        AccountName: Text[50];
        DetailAmt: Decimal;
        PrintDetail: Boolean;
        Text16500: label 'As per Details';
        Daybook: Report "Day Book";
        NewGLEntry: Record "G/L Entry";
        BankAcc: Record "Bank Account";
        recPurchaseInvHeader: Record "Purch. Inv. Header";
        VendInvChequeNo: Code[50];
        VendInvChequedate: Date;
        recBankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        DrCrBalanceText: Text[2];
        grecGnlLedSetup: Record "General Ledger Setup";
        "--Automation--": Integer;
        ColumnName: Text[30];
        x: Integer;
        grecexcelbuffer: Record "Excel Buffer";
        ColNo: Integer;
        RowNo: Integer;
        PrintExcel: Boolean;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Vendor_LedgerCaptionLbl: label 'Vendor Ledger';
        All_amounts_are_in_LCYCaptionLbl: label 'All amounts are in LCY';
        This_report_also_includes_vendors_that_only_have_balances_CaptionLbl: label 'This report also includes vendors that only have balances.';
        Document_No_CaptionLbl: label 'Document No.';
        Posting_DateCaptionLbl: label 'Posting Date';
        Vendor_Bill_No__Cheque_No_CaptionLbl: label 'Vendor Bill No./Cheque No.';
        DateCaptionLbl: label 'Date';
        DescriptionCaptionLbl: label 'Description';
        Opening_BalanceCaptionLbl: label 'Opening Balance';
        Closing_BalanceCaptionLbl: label 'Closing Balance';
        VendNo: Code[20];


    procedure CreateBook()
    begin
        /*IF NOT CREATE(XlApp,TRUE) THEN
           ERROR('');
        XlApp.Visible(FALSE);
        XlWrkbk := XlApp.Workbooks.Add;
        Xlwrksht := XlWrkbk.Worksheets.Add;
         */
        ColNo := 1;
        RowNo := 1;

    end;


    procedure PrintCell(Column: Integer; Row: Integer; Text: Text[100]; IncCol: Integer; IncRow: Integer; IsBold: Boolean; IsItalic: Boolean; IsUnderline: Boolean; NumberFormat: Text[30])
    var
        xlUnderlineStyleSingle: Text[30];
    begin
        x := Column;
        ColID();
        /*
        IF NumberFormat <> '' THEN
           Xlwrksht.Range(FORMAT(ColumnName)+FORMAT(Row)).NumberFormat := NumberFormat;
        
        Xlwrksht.Range(FORMAT(ColumnName)+FORMAT(Row)).Value:=Text;
        IF IsBold THEN
           Xlwrksht.Range(FORMAT(ColumnName)+FORMAT(Row)).Font.Bold :=TRUE;
        IF IsItalic THEN
           Xlwrksht.Range(FORMAT(ColumnName)+FORMAT(Row)).Font.Italic :=TRUE;
        IF IsUnderline THEN
           Xlwrksht.Range(FORMAT(ColumnName)+FORMAT(Row)).Font.Underline := TRUE;
         */
        ColNo += IncCol;
        RowNo += IncRow;

    end;


    procedure ColID()
    var
        i: Integer;
        y: Integer;
        c: Char;
        t: Text[30];
    begin
        ColumnName := '';
        while x > 26 do begin
            y := x MOD 26;
            if y = 0 then
                y := 26;
            c := 64 + y;
            i := i + 1;
            t[i] := c;
            x := (x - y) DIV 26;
        end;
        if x > 0 then begin
            c := 64 + x;
            i := i + 1;
            t[i] := c;
        end;
        for x := 1 to i do
            ColumnName[x] := t[1 + i - x];
    end;


    procedure ViewBook(BookName: Text[30]; SheetName: Text[30])
    begin
        /*IF BookName <> '' THEN
        XlWrkbk.SaveAs(BookName);
        IF SheetName <> '' THEN
        Xlwrksht.Name :=SheetName;
        XlApp.Visible(TRUE);
        XlApp.UserControl(TRUE);
        CLEAR(XlApp);
         */

    end;


    procedure SetDocumentNo(DocNo: Code[20])
    begin
        VendNo := DocNo;
    end;
}

