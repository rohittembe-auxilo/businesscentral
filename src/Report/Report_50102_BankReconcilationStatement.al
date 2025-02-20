Report 50102 "Bank Reconcilation Statement"
{
    RDLCLayout = './Layouts/BankReconcilationStatement.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Bank Account Ledger Entry1"; "Bank Account Ledger Entry")
        {
            DataItemTableView = where("Source Code" = filter('BANKRCPTV|BANKPYMTV|GENJNL|CONTRAV'), Reversed = const(false), Amount = filter(<= 0));
            //  column(ReportForNavId_1000000000; 1000000000) { } // Autogenerated by ForNav - Do not delete
            column(BankAccNo11; BankAccNo1)
            {
            }
            column(SrNo; SrNo)
            {
            }
            column(ChequeNo_BankAccountLedgerEntry1; "Bank Account Ledger Entry1"."Cheque No.")
            {
            }
            column(ChequeDate_BankAccountLedgerEntry1; "Bank Account Ledger Entry1"."Cheque Date")
            {
            }
            column(Description_BankAccountLedgerEntry1; "Bank Account Ledger Entry1".Description)
            {
            }
            column(Amt; Amt)
            {
            }
            column(EntryNo; "Bank Account Ledger Entry1"."Entry No.")
            {
            }
            column(BalAsPerBAVal; BalAsPerBAVal)
            {
            }
            column(StmtEndingBal; StmtEndingBal)
            {
            }
            column(datestr; datestr)
            {
            }
            column(BankAccName; BankAccName)
            {
            }
            trigger OnPreDataItem();
            begin
                SetRange("Bank Account No.", BankAccNo1);
                SetFilter("Posting Date", '<=%1', StmtDate);
                // SETFILTER(Revise,'No');
                //   MESSAGE('%1',COUNT);
                SrNo := 0;
                Amt := 0;
                //MESSAGE('%1',BankAccNo1);
                //	ReportForNav.OnPreDataItem('BankAccountLedgerEntry1',"Bank Account Ledger Entry1");
            end;

            trigger OnAfterGetRecord();
            var
                BankAccStatementLine: Record "Bank Account Statement Line";
            begin
                Amt := 0; // Inserted by ForNAV
                          //Logic added to display unreconciled checks of statement period.
                if not "Bank Account Ledger Entry1".Open then begin
                    if BankAccStatementLine.Get("Bank Account Ledger Entry1"."Bank Account No.", "Bank Account Ledger Entry1"."Statement No.", "Bank Account Ledger Entry1"."Statement Line No.") then begin
                        if not (StmtDate <= BankAccStatementLine."Value Date") then
                            CurrReport.Skip;
                        if Date2dmy(StmtDate, 2) = Date2dmy(BankAccStatementLine."Value Date", 2) then
                            CurrReport.Skip;
                    end
                    else
                        CurrReport.Skip;
                end;
                ////
                SrNo += 1;
                if "Bank Account Ledger Entry1".Open then begin
                    if "Remaining Amount" < 0 then
                        Amt := "Remaining Amount" * (-1)
                    else
                        Amt := "Remaining Amount";
                end
                else begin
                    if "Bank Account Ledger Entry1".Amount < 0 then
                        Amt := "Bank Account Ledger Entry1".Amount * (-1)
                    else
                        Amt := "Bank Account Ledger Entry1".Amount;
                end;
            end;

        }
        dataitem("Bank Account Ledger Entry2"; "Bank Account Ledger Entry")
        {
            DataItemTableView = where("Source Code" = filter('BANKRCPTV|CONTRAV'), Amount = filter(> 0), Reversed = const(false));
            column(ReportForNavId_1000000009; 1000000009) { } // Autogenerated by ForNav - Do not delete
                                                              //	column(ReportForNav_BankAccountLedgerEntry2; ReportForNavWriteDataItem('BankAccountLedgerEntry2',"Bank Account Ledger Entry2")) {}
            column(SrNo1; SrNo1)
            {
            }
            column(Description_BankAccountLedgerEntry2; "Bank Account Ledger Entry2".Description)
            {
            }
            column(ChequeNo_BankAccountLedgerEntry2; "Bank Account Ledger Entry2"."Cheque No.")
            {
            }
            column(ChequeDate_BankAccountLedgerEntry2; "Bank Account Ledger Entry2"."Cheque Date")
            {
            }
            column(Amt1; Amt1)
            {
            }
            column(EntryNo1; "Bank Account Ledger Entry2"."Entry No.")
            {
            }
            column(BalAsPerBAVal2; BalAsPerBAVal2)
            {
            }
            column(StmtEndingBal2; StmtEndingBal2)
            {
            }
            trigger OnPreDataItem();
            begin
                SetRange("Bank Account No.", BankAccNo1);
                SetFilter("Posting Date", '<=%1', StmtDate);
                // SETFILTER(Revise,'No');
                SrNo1 := 0;
                Amt1 := 0;
                //	ReportForNav.OnPreDataItem('BankAccountLedgerEntry2',"Bank Account Ledger Entry2");
            end;

            trigger OnAfterGetRecord();
            var
                BankAccStatementLine: Record "Bank Acc. Reconciliation Line";
            begin
                Amt1 := 0; // Inserted by ForNAV
                           //Logic added to display unreconciled checks of statement period.
                if not "Bank Account Ledger Entry2".Open then begin
                    if BankAccStatementLine.Get("Bank Account Ledger Entry2"."Bank Account No.", "Bank Account Ledger Entry2"."Statement No.", "Bank Account Ledger Entry2"."Statement Line No.") then begin
                        if not (StmtDate <= BankAccStatementLine."Value Date") then
                            CurrReport.Skip;
                        if Date2dmy(StmtDate, 2) = Date2dmy(BankAccStatementLine."Value Date", 2) then
                            CurrReport.Skip;
                    end
                    else
                        CurrReport.Skip;
                end;
                ////
                SrNo1 += 1;
                if "Bank Account Ledger Entry2".Open then
                    Amt1 := "Remaining Amount"
                else
                    Amt1 := "Bank Account Ledger Entry2".Amount;
                BankAcc.Reset;
                BankAcc.SetRange(BankAcc."No.", BankAccNo1);
                if BankAcc.FindFirst then
                    BankAccName := BankAcc.Name;
                //MESSAGE('%1BankAccName-Loop1',BankAccName);
            end;

        }
    }
    requestpage
    {
        SaveValues = false;
        layout
        {
        }

    }
    labels
    {
        Title = 'Bank Reconciliation Statement as on';
        BalAsPerBA = 'Balance as per Bank Book';
        Unclearchck = 'Add : Uncleared Cheques';
        UnclearDep = 'Less : Uncleared Deposits';
        CorrBal = 'Corrected Balance';
        BalAsPerBS = 'Balance as per Bank Statement';
        Difference = 'Difference';
    }

    trigger OnPreReport()
    begin
        if StmtDate = 0D then
            Error('Statement Date should be filled..');
        BalAsPerBAVal := 0;
        BALedgerEntry.Reset;
        BALedgerEntry.SetRange(BALedgerEntry."Bank Account No.", BankAccNo1);
        BALedgerEntry.SetFilter(BALedgerEntry."Posting Date", '<=%1', StmtDate);
        // BALedgerEntry.SETRANGE(BALedgerEntry.Open,TRUE);
        if BALedgerEntry.FindFirst then
            repeat
                BalAsPerBAVal := BalAsPerBAVal + BALedgerEntry."Debit Amount" - BALedgerEntry."Credit Amount";
            until BALedgerEntry.Next = 0;
        // MESSAGE('StmtEnding%1 BalAsPerBaVal =%2' ,StmtEndingBal,BalAsPerBAVal);
        /*  RecBankAccLedEntry1.RESET;
          RecBankAccLedEntry1.SETFILTER("Source Code",'REVERSAL');
          RecBankAccLedEntry1.SETRANGE(Open,TRUE);
          RecBankAccLedEntry1.SETRANGE("Bank Account No.",BankAccNo1);
          RecBankAccLedEntry1.SETFILTER("Posting Date",'<=%1',StmtDate);
          IF RecBankAccLedEntry1.FINDFIRST THEN
             REPEAT
                RecBankAccLedEntry2.RESET;
                RecBankAccLedEntry2.SETRANGE("Document No.",RecBankAccLedEntry1."Document No.");
                IF RecBankAccLedEntry2.FINDFIRST THEN
                   REPEAT
                       RecBankAccLedEntry2.Revise := TRUE;
                       RecBankAccLedEntry2.MODIFY;
                   UNTIL RecBankAccLedEntry2.NEXT=0;
             UNTIL RecBankAccLedEntry1.NEXT=0;*/
        datestr := Format(StmtDate, 0, '<Day> <Month Text> <Year4>');
        //..CCIT-PRI
        BalAsPerBAVal2 := 0;
        BALedgerEntry2.Reset;
        BALedgerEntry2.SetRange(BALedgerEntry2."Bank Account No.", BankAccNo1);
        BALedgerEntry2.SetFilter(BALedgerEntry2."Posting Date", '<=%1', StmtDate);
        // BALedgerEntry.SETRANGE(BALedgerEntry.Open,TRUE);
        if BALedgerEntry2.FindFirst then
            repeat
                BalAsPerBAVal2 := BalAsPerBAVal2 + BALedgerEntry2."Debit Amount" - BALedgerEntry2."Credit Amount";
            until BALedgerEntry2.Next = 0;
        datestr2 := Format(StmtDate, 0, '<Day> <Month Text> <Year4>');
        //  MESSAGE('%1BankAccName-Loop1',BankAccName);
        //..

        //;ReportsForNavPre;

    end;

    var
        BankAccNo1: Code[20];
        StmtDate: Date;
        BALedgerEntry: Record "Bank Account Ledger Entry";
        BalAsPerBAVal: Decimal;
        SrNo: Integer;
        Amt: Decimal;
        SrNo1: Integer;
        Amt1: Decimal;
        RecBankAccLedEntry: Record "Bank Account Ledger Entry";
        datestr: Text;
        StmtEndingBal: Decimal;
        RecBankAccLedEntry1: Record "Bank Account Ledger Entry";
        RecBankAccLedEntry2: Record "Bank Account Ledger Entry";
        BALedgerEntry2: Record "Bank Account Ledger Entry";
        BalAsPerBAVal2: Decimal;
        datestr2: Text;
        StmtEndingBal2: Decimal;
        BankAcc: Record "Bank Account";
        BankAccName: Text[100];
        Unreconciled: Boolean;
        Reconciled: Boolean;

    procedure GetParameter(BankAccNo: Code[20]; Date: Date; StmtEndBal: Decimal)
    begin
        BankAccNo1 := BankAccNo;
        StmtDate := Date;
        StmtEndingBal := StmtEndBal;
        StmtEndingBal2 := StmtEndBal;
        BankAcc.Reset;
        BankAcc.SetRange(BankAcc."No.", BankAccNo1);
        if BankAcc.FindFirst then
            BankAccName := BankAcc.Name;
    end;

    trigger OnInitReport();
    begin
        //	;ReportsForNavInit;
    end;

    // --> Reports ForNAV Autogenerated code - do not delete or modify
    var
    //ReportForNav: Codeunit "ForNAV Report Management";
}
