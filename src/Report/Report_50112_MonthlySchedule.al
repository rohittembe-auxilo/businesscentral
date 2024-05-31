Report 50112 "Monthly Schedule"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(General; "Integer")
        {
            MaxIteration = 1;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin


                ToDate := CalcDate('<25Y>', FromDate);

                if FromDate = 0D then
                    Error('Please select from date');

                if ToDate = 0D then
                    Error('Please select to date');

                if PrepaymentPer = 0 then
                    Error('Please select Prepayment Percentage');

                if (Status = Status::"NPA-Non Standard") or (Status = Status::"NPA-Doubtfull Loss") then
                    PrepaymentPer := 0;
                MakeExcelInfo;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("PrePayment Percentage"; PrepaymentPer)
                {
                    ApplicationArea = Basic;
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

    trigger OnPostReport()
    begin
        CreateExcelbook;
    end;

    trigger OnPreReport()
    begin

        Excelbuffer.DeleteAll;

        //kj++
        Clear(ECL1);
        Clear(EIR);
        Clear(OD_RepoAmnt);
        Clear(Accural_Amnt);
        //kj--
    end;

    var
        FromDate: Date;
        ToDate: Date;
        Excelbuffer: Record "Excel Buffer";
        StartingDate: Date;
        EndingDate: Date;
        AdvancesLanWise: Record "Advances LanWise";
        BucketCount: Integer;
        AdvanceClBalances: Record "Advance Cl Balances";
        AdvancesODReport: Record "Advances OD Report";
        AdvancesInterestAccrual: Record "Advances Interest Accrual";
        AdvancesEIR: Record "Advances EIR";
        AdvancesECL: Record "Advances ECL";
        PrepaymentPer: Decimal;
        ColIteration: Integer;
        FirstBucket: Boolean;
        OpeningBalance: Decimal;
        ClosingBalance: Decimal;
        PrePaymentAmount: Decimal;
        RepaymentAmount: Decimal;
        InterestCapitlised: Decimal;
        ExcelValue: Decimal;
        SummaryHeadingInserted: Boolean;
        Status: Option " ",Standard,"NPA-Non Standard","NPA-Doubtfull Loss";
        SummaryHeadingInsertedNPA: Boolean;
        BucketEndingDate: Date;
        ALMHeader: Record "ALM Header";
        AdvancesEIR_OpeningBal: Record "Advances EIR";
        AdvancesECL_OpeningBal: Record "Advances ECL";
        ECL1: Decimal;
        EIR: Decimal;
        OD_RepoAmnt: Decimal;
        Accural_Amnt: Decimal;


    procedure MakeExcelInfo()
    begin


        Excelbuffer.NewRow;
        Excelbuffer.AddColumn('Company Name', false, '', true, false, false, '', Excelbuffer."cell type"::Number);
        Excelbuffer.AddColumn(COMPANYNAME, false, '', false, false, false, '', Excelbuffer."cell type"::Number);
        Excelbuffer.NewRow;
        Excelbuffer.NewRow;
        StartingDate := FromDate;
        EndingDate := ToDate;
        FirstBucket := true;
        //MESSAGE('%1',StartingDate); //kj

        Excelbuffer.NewRow;
        Excelbuffer.AddColumn('', false, '', false, false, false, '', Excelbuffer."cell type"::Number);
        InsertHeadings;


        BucketCount := 1;
        ColIteration := 2;

        while StartingDate <= EndingDate do begin
            //Bucket
            if BucketCount = 1 then begin
                BucketEndingDate := CalcDate('<6D>', StartingDate);

            end else if BucketCount = 2 then begin
                BucketEndingDate := CalcDate('<6D>', StartingDate);


            end else if BucketCount > 2 then begin
                BucketEndingDate := CalcDate('CM', StartingDate);

            end;


            Excelbuffer.Validate("Row No.", 5);
            Excelbuffer.Validate("Column No.", ColIteration);
            Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
            Excelbuffer.Validate("Cell Value as Text", Format(StartingDate, 0, '<Month Text>') + '-' + Format(Date2dmy(StartingDate, 3)));
            Excelbuffer.Insert;

            //Opening Amount
            if FirstBucket = true then begin
                OpeningBalance := CalculateOpeningBalance(StartingDate, BucketEndingDate);  //kj_changes opening balance value
                Excelbuffer.Validate("Row No.", 6);
                Excelbuffer.Validate("Column No.", ColIteration);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(OpeningBalance));
                Excelbuffer.Insert;
                FirstBucket := false;

            end else begin
                OpeningBalance := ClosingBalance;
                Excelbuffer.Validate("Row No.", 6);
                Excelbuffer.Validate("Column No.", ColIteration);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(OpeningBalance));
                Excelbuffer.Insert;

            end;

            //Repayment Amount
            RepaymentAmount := CalCulatePrincipalSchdAmount(StartingDate, BucketEndingDate);
            Excelbuffer.Validate("Row No.", 7);
            Excelbuffer.Validate("Column No.", ColIteration);
            Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
            Excelbuffer.Validate("Cell Value as Text", Format(RepaymentAmount));
            Excelbuffer.Insert;



            //PrePayments
            if BucketCount = 1 then begin
                PrePaymentAmount := ((OpeningBalance * PrepaymentPer) / (12 * 100)) / 4;

            end else if BucketCount = 2 then begin
                PrePaymentAmount := ((OpeningBalance * PrepaymentPer) / (12 * 100)) / 4;

            end else if BucketCount = 3 then begin
                PrePaymentAmount := ((OpeningBalance * PrepaymentPer) / (12 * 100)) / 2;

            end else begin
                PrePaymentAmount := (OpeningBalance * PrepaymentPer) / (12 * 100);
            end;
            Excelbuffer.Validate("Row No.", 8);
            Excelbuffer.Validate("Column No.", ColIteration);
            Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
            Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
            Excelbuffer.Insert;



            //CPZA Amount
            InterestCapitlised := CalCulateCPZAAmount(StartingDate, BucketEndingDate);
            Excelbuffer.Validate("Row No.", 9);
            Excelbuffer.Validate("Column No.", ColIteration);
            Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
            Excelbuffer.Validate("Cell Value as Text", Format(InterestCapitlised));
            Excelbuffer.Insert;



            //Closing Amount
            ClosingBalance := OpeningBalance - PrePaymentAmount - RepaymentAmount + InterestCapitlised;
            Excelbuffer.Validate("Row No.", 10);
            Excelbuffer.Validate("Column No.", ColIteration);
            Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
            Excelbuffer.Validate("Cell Value as Text", Format(ClosingBalance));
            Excelbuffer.Insert;


            if Status = Status::Standard then  //CCIT AN 22feb2023
                InsertSummary(StartingDate, RepaymentAmount, PrePaymentAmount);
            if Status = Status::"NPA-Non Standard" then begin
                InsertSummaryNPAStd(StartingDate, RepaymentAmount, PrePaymentAmount);
            end else if Status = Status::"NPA-Doubtfull Loss" then begin
                InsertSummaryNPALoss(StartingDate, RepaymentAmount, PrePaymentAmount);
            end;


            ColIteration := ColIteration + 1;
            BucketCount := BucketCount + 1;
            StartingDate := BucketEndingDate + 1;




        end;
        if SummaryHeadingInserted = false then begin
            InsertSummaryHeading;
            if (Status = Status::"NPA-Non Standard") or (Status = Status::"NPA-Doubtfull Loss") then begin
                InsertSummaryHeadingNPA;
            end;
        end;


        /*
        Excelbuffer.NewRow;
        Excelbuffer.NewRow;
        Excelbuffer.NewRow;
        Excelbuffer.AddColumn('1 to 7 days',FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn('8 to 14 days',FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn('15 to 1 Month',FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn('1 Month to 2 Months',FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn('2 Month to 3 Months',FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn('3 Month To 6 Months',FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn('6 Month To 1 Year',FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn('1 Year to 3 Year',FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn('3 year to 5 Years',FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn('Over 5 Years',FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        
        
        Excelbuffer.NewRow;
        Excelbuffer.AddColumn(CalculateAmount(FromDate,FromDate+6),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn(CalculateAmount(FromDate+7,FromDate+13),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn(CalculateAmount(FromDate+14,CALCDATE('CM',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn(CalculateAmount(CALCDATE('1M',FromDate),CALCDATE('CM',CALCDATE('1M',FromDate))),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn(CalculateAmount(CALCDATE('2M',FromDate),CALCDATE('CM',CALCDATE('2M',FromDate))),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn(CalculateAmount(CALCDATE('3M',FromDate),CALCDATE('CM',CALCDATE('5M',FromDate))),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn(CalculateAmount(CALCDATE('6M',FromDate),CALCDATE('1Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn(CalculateAmount(CALCDATE('1Y',FromDate)+1,CALCDATE('3Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn(CalculateAmount(CALCDATE('3Y',FromDate)+1,CALCDATE('5Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn(CalculateAmount(CALCDATE('5Y',FromDate)+1,CALCDATE('25Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
         */

    end;


    procedure CreateExcelbook()
    begin
        // Excelbuffer.CreateBookAndOpenExcel('','Monthly Schedule','',COMPANYNAME,UserId);
        Excelbuffer.CreateNewBook('Monthly Schedule');
        Excelbuffer.WriteSheet('Monthly Schedule', CompanyName, UserId);
        Excelbuffer.CloseBook();
        Excelbuffer.OpenExcel();
        Error('');
    end;

    local procedure CalculateAmount(FromDates: Date; ToDates: Date) Amt: Decimal
    var
        AdvancesLanWise: Record "Advances LanWise";
    begin
        AdvancesLanWise.Reset();
        AdvancesLanWise.SetRange(Status, Status);
        AdvancesLanWise.SetRange("SCH Date", FromDates, ToDates);
        if AdvancesLanWise.FindSet then begin
            AdvancesLanWise.CalcSums(PrincipalSchd);
            Amt := AdvancesLanWise.PrincipalSchd;

        end;
    end;

    local procedure CalCulatePrincipalSchdAmount(FromDates: Date; ToDates: Date) Amt: Decimal
    begin
        AdvancesLanWise.Reset();
        AdvancesLanWise.SetRange(Status, Status);
        AdvancesLanWise.SetRange("SCH Date", FromDates, ToDates);
        if AdvancesLanWise.FindSet then begin
            AdvancesLanWise.CalcSums(PrincipalSchd);
            Amt := AdvancesLanWise.PrincipalSchd;

        end;
    end;

    local procedure CalCulateCPZAAmount(FromDates: Date; ToDates: Date) Amt: Decimal
    begin
        AdvancesLanWise.Reset();
        AdvancesLanWise.SetRange(Status, Status);
        AdvancesLanWise.SetRange("SCH Date", FromDates, ToDates);
        if AdvancesLanWise.FindSet then begin
            AdvancesLanWise.CalcSums("CPZA Amount");
            Amt := AdvancesLanWise."CPZA Amount";
        end;
    end;

    local procedure CalculateOpeningBalance(FromDates: Date; ToDates: Date) Amt: Decimal
    begin


        //+++_kj
        AdvancesECL_OpeningBal.Reset;
        AdvancesECL_OpeningBal.SetRange(Status, Status);
        // AdvancesECL_OpeningBal.SETRANGE("Posting Date",FromDates,ToDates);
        // AdvancesECL_OpeningBal.SETRANGE("Document No.",AdvanceClBalances."Document No.");
        // AdvancesECL_OpeningBal.SETRANGE("RBI Code",AdvanceClBalances."RBI Code");
        if AdvancesECL_OpeningBal.FindSet then begin
            //Repeat
            AdvancesECL_OpeningBal.CalcSums(ECL);
            ECL1 := ECL1 + AdvancesECL_OpeningBal.ECL;
            // UNTIL AdvancesECL_OpeningBal.NEXT = 0;
        end;

        AdvancesEIR_OpeningBal.Reset;
        AdvancesEIR_OpeningBal.SetRange(Status, Status);
        // AdvancesEIR_OpeningBal.SETRANGE("Posting Date",FromDates,ToDates);
        // AdvancesEIR_OpeningBal.SETRANGE("Document No.",AdvanceClBalances."Document No.");
        // AdvancesEIR_OpeningBal.SETRANGE("RBI Code",AdvanceClBalances."RBI Code");
        if AdvancesEIR_OpeningBal.FindSet then begin
            //REPEAT
            AdvancesEIR_OpeningBal.CalcSums("Rev Unmort");
            EIR := EIR + AdvancesEIR_OpeningBal."Rev Unmort";
            // UNTIL AdvancesEIR_OpeningBal.NEXT = 0;
        end;
        //---_kj




        //old calculation_CCIT_kj_20072022++++++++++++
        /*
        
        AdvanceClBalances.RESET;
        AdvanceClBalances.SETRANGE(Status,Status);
        //AdvanceClBalances.SETRANGE("Sch Date",FromDates,ToDates);
        IF AdvanceClBalances.FINDSET THEN BEGIN
           AdvanceClBalances.CALCSUMS("Closing Balance");
           Amt := AdvanceClBalances."Closing Balance"; //old calculation_CCIT_kj_20072022
          END;
          *///new changes Commented_ccit_kj
        AdvancesODReport.Reset();
        AdvancesODReport.SetRange(Status, Status);
        if AdvancesODReport.FindSet then begin
            AdvancesODReport.CalcSums(FINCURODPFT);  //CALCSUMS(FINCURODAMT);
            OD_RepoAmnt := OD_RepoAmnt + AdvancesODReport.FINCURODPFT;

        end;

        AdvancesInterestAccrual.Reset();
        AdvancesInterestAccrual.SetRange(Status, Status);
        if AdvancesInterestAccrual.FindSet then begin
            AdvancesInterestAccrual.CalcSums("Sum Of Interest Accrual");
            Accural_Amnt := Accural_Amnt + AdvancesInterestAccrual."Sum Of Interest Accrual";

        end;

        AdvanceClBalances.Reset;
        AdvanceClBalances.SetRange(Status, Status);
        //AdvanceClBalances.SETRANGE("Sch Date",FromDates,ToDates);
        if AdvanceClBalances.FindSet then begin
            AdvanceClBalances.CalcSums("Closing Balance");
            // Amt := AdvanceClBalances."Closing Balance"; //old calculation_CCIT_kj_20072022
            //+++_kj
            Amt := (AdvanceClBalances."Closing Balance" + EIR + OD_RepoAmnt + Accural_Amnt - ECL1);  //kj_ccit_Opening balance sum
                                                                                                     //---_kj
        end;

        /*
        AdvancesEIR.RESET();
        AdvancesEIR.SETRANGE(Status,Status);
        IF AdvancesEIR.FINDSET THEN BEGIN
           AdvancesEIR.CALCSUMS("Rev Unmort");
           Amt := Amt+ AdvancesEIR."Rev Unmort";
        
          END;
        
        AdvancesECL.RESET();
        AdvancesECL.SETRANGE(Status,Status);
        IF AdvancesECL.FINDSET THEN BEGIN
           AdvancesECL.CALCSUMS(ECL);
           Amt := Amt- AdvancesECL.ECL;
        
          END;*/ //old calculation_CCIT_kj_20072022---------------------------




    end;

    local procedure InsertHeadings()
    begin

        Excelbuffer.Validate("Row No.", 5);
        Excelbuffer.Validate("Column No.", 1);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
        Excelbuffer.Validate("Cell Value as Text", '');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 6);
        Excelbuffer.Validate("Column No.", 1);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
        Excelbuffer.Validate("Cell Value as Text", 'Opening');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 7);
        Excelbuffer.Validate("Column No.", 1);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
        Excelbuffer.Validate("Cell Value as Text", 'Repayment');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 8);
        Excelbuffer.Validate("Column No.", 1);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
        Excelbuffer.Validate("Cell Value as Text", 'Prepayment');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 9);
        Excelbuffer.Validate("Column No.", 1);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
        Excelbuffer.Validate("Cell Value as Text", 'Interest Capitalised');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 10);
        Excelbuffer.Validate("Column No.", 1);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
        Excelbuffer.Validate("Cell Value as Text", 'Closing Balance');
        Excelbuffer.Insert;
    end;

    local procedure InsertSummary(FromDates: Date; RepayAmt: Decimal; PreyPayAmt: Decimal)
    var
        AlmLine: Record "ALM Lines";
    begin
        AlmLine.Reset;
        AlmLine.SetRange("Document No.", ALMHeader."Document No.");
        AlmLine.SetRange("RBI Code", 'Y1450');
        if AlmLine.Find('-') then;


        if not Excelbuffer.Get(13, 1) then begin
            Excelbuffer.Validate("Row No.", 13);
            Excelbuffer.Validate("Column No.", 1);
            Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
            Excelbuffer.Validate("Cell Value as Text", 'Repayment');
            Excelbuffer.Insert;
            Excelbuffer.Validate("Row No.", 14);
            Excelbuffer.Validate("Column No.", 1);
            Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
            Excelbuffer.Validate("Cell Value as Text", 'Prepayment');
            Excelbuffer.Insert;
        end;



        if (FromDates >= FromDate) and (FromDates <= CalcDate('<6D>', FromDate)) then begin

            if Excelbuffer.Get(13, 2) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;
                Excelbuffer.Get(14, 2);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;

                AlmLine."1 to 7 days" := AlmLine."1 to 7 days" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end else begin
                Excelbuffer.Validate("Row No.", 13);
                Excelbuffer.Validate("Column No.", 2);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 14);
                Excelbuffer.Validate("Column No.", 2);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;

                AlmLine."1 to 7 days" := AlmLine."1 to 7 days" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;

        if (FromDates >= CalcDate('<7D>', FromDate)) and (FromDates <= CalcDate('<13D>', FromDate)) then begin

            if Excelbuffer.Get(13, 3) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;
                Excelbuffer.Get(14, 3);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;

                AlmLine."8 to 14 days" := AlmLine."8 to 14 days" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end else begin
                Excelbuffer.Validate("Row No.", 13);
                Excelbuffer.Validate("Column No.", 3);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 14);
                Excelbuffer.Validate("Column No.", 3);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;

                AlmLine."8 to 14 days" := AlmLine."8 to 14 days" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;

        if (FromDates >= CalcDate('<14D>', FromDate)) and (FromDates <= CalcDate('CM', FromDate)) then begin

            if Excelbuffer.Get(13, 4) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;
                Excelbuffer.Get(14, 4);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."15 to 1 Month" := AlmLine."15 to 1 Month" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end else begin
                Excelbuffer.Validate("Row No.", 13);
                Excelbuffer.Validate("Column No.", 4);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 14);
                Excelbuffer.Validate("Column No.", 4);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."15 to 1 Month" := AlmLine."15 to 1 Month" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;




        if (FromDates >= CalcDate('1M', FromDate)) and (FromDates <= CalcDate('CM', CalcDate('1M', FromDate))) then begin
            if Excelbuffer.Get(13, 5) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(14, 5);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."1 Month to 2 Months" := AlmLine."1 Month to 2 Months" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end else begin
                Excelbuffer.Validate("Row No.", 13);
                Excelbuffer.Validate("Column No.", 5);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 14);
                Excelbuffer.Validate("Column No.", 5);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."1 Month to 2 Months" := AlmLine."1 Month to 2 Months" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end;
        end;
        if (FromDates >= CalcDate('2M', FromDate)) and (FromDates <= CalcDate('CM', CalcDate('2M', FromDate))) then begin
            if Excelbuffer.Get(13, 6) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(14, 6);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."2 Month to 3 Months" := AlmLine."2 Month to 3 Months" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end else begin

                Excelbuffer.Validate("Row No.", 13);
                Excelbuffer.Validate("Column No.", 6);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 14);
                Excelbuffer.Validate("Column No.", 6);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."2 Month to 3 Months" := AlmLine."2 Month to 3 Months" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;
        if (FromDates >= CalcDate('3M', FromDate)) and (FromDates <= CalcDate('CM', CalcDate('5M', FromDate))) then begin
            if Excelbuffer.Get(13, 7) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(14, 7);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."3 Month To 6 Months" := AlmLine."3 Month To 6 Months" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end else begin
                Excelbuffer.Validate("Row No.", 13);
                Excelbuffer.Validate("Column No.", 7);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 14);
                Excelbuffer.Validate("Column No.", 7);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."3 Month To 6 Months" := AlmLine."3 Month To 6 Months" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;

        if (FromDates >= CalcDate('6M', FromDate)) and (FromDates <= CalcDate('11M', FromDate)) then begin
            if Excelbuffer.Get(13, 8) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(14, 8);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."6 Month To 1 Year" := AlmLine."6 Month To 1 Year" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end else begin
                Excelbuffer.Validate("Row No.", 13);
                Excelbuffer.Validate("Column No.", 8);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 14);
                Excelbuffer.Validate("Column No.", 8);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."6 Month To 1 Year" := AlmLine."6 Month To 1 Year" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;

        if (FromDates >= CalcDate('12M', FromDate)) and (FromDates <= CalcDate('-1D', CalcDate('3Y', FromDate))) then begin
            if Excelbuffer.Get(13, 9) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(14, 9);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;

                AlmLine."1 Year to 3 Year" := AlmLine."1 Year to 3 Year" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end else begin
                Excelbuffer.Validate("Row No.", 13);
                Excelbuffer.Validate("Column No.", 9);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 14);
                Excelbuffer.Validate("Column No.", 9);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;

                AlmLine."1 Year to 3 Year" := AlmLine."1 Year to 3 Year" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;

        if (FromDates >= CalcDate('3Y', FromDate)) and (FromDates <= CalcDate('-1D', CalcDate('5Y', FromDate))) then begin
            if Excelbuffer.Get(13, 10) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(14, 10);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end else begin
                Excelbuffer.Validate("Row No.", 13);
                Excelbuffer.Validate("Column No.", 10);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 14);
                Excelbuffer.Validate("Column No.", 10);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;


        if (FromDates >= CalcDate('5Y', FromDate)) and (FromDates <= CalcDate('25Y', FromDate)) then begin
            if Excelbuffer.Get(13, 11) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(14, 11);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end else begin
                Excelbuffer.Validate("Row No.", 13);
                Excelbuffer.Validate("Column No.", 11);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 14);
                Excelbuffer.Validate("Column No.", 11);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;
        //Excelbuffer.AddColumn(CalculateAmount(CALCDATE('6M',FromDate),CALCDATE('1Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        //Excelbuffer.AddColumn(CalculateAmount(CALCDATE('1Y',FromDate)+1,CALCDATE('3Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        //Excelbuffer.AddColumn(CalculateAmount(CALCDATE('3Y',FromDate)+1,CALCDATE('5Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        //Excelbuffer.AddColumn(CalculateAmount(CALCDATE('5Y',FromDate)+1,CALCDATE('25Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
    end;

    local procedure InsertSummaryHeading()
    begin


        SummaryHeadingInserted := true;

        Excelbuffer.Validate("Row No.", 12);
        Excelbuffer.Validate("Column No.", 2);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '1 to 7 days');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 12);
        Excelbuffer.Validate("Column No.", 3);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '8 to 14 days');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 12);
        Excelbuffer.Validate("Column No.", 4);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '15 days to 1 Month');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 12);
        Excelbuffer.Validate("Column No.", 5);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '1 Month to 2 Months');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 12);
        Excelbuffer.Validate("Column No.", 6);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '2 Month to 3 Months');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 12);
        Excelbuffer.Validate("Column No.", 7);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '3 Month To 6 Months');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 12);
        Excelbuffer.Validate("Column No.", 8);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '6 Month To 1 Year');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 12);
        Excelbuffer.Validate("Column No.", 9);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '1 Year to 3 Year');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 12);
        Excelbuffer.Validate("Column No.", 10);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '3 year to 5 Years');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 12);
        Excelbuffer.Validate("Column No.", 11);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", 'Over 5 Years');
        Excelbuffer.Insert;

    end;


    procedure SetStatus(Stat: Option " ",Standard,"NPA-Non Standard","NPA-Doubtfull Loss"; StartingDate: Date; AlmHeaders: Record "ALM Header")
    begin
        Status := Stat;
        FromDate := StartingDate;
        ALMHeader := AlmHeaders;
    end;

    local procedure InsertSummaryNPAStd(FromDates: Date; RepayAmt: Decimal; PreyPayAmt: Decimal)
    var
        AlmLine: Record "ALM Lines";
    begin

        AlmLine.Reset;
        AlmLine.SetRange("Document No.", ALMHeader."Document No.");
        AlmLine.SetRange("RBI Code", 'Y1510');
        if AlmLine.Find('-') then;


        if not Excelbuffer.Get(17, 1) then begin
            Excelbuffer.Validate("Row No.", 17);
            Excelbuffer.Validate("Column No.", 1);
            Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
            Excelbuffer.Validate("Cell Value as Text", 'Repayment');
            Excelbuffer.Insert;
            Excelbuffer.Validate("Row No.", 18);
            Excelbuffer.Validate("Column No.", 1);
            Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
            Excelbuffer.Validate("Cell Value as Text", 'Prepayment');
            Excelbuffer.Insert;
        end;



        if (FromDates >= FromDate) and (FromDates <= CalcDate('<6D>', FromDate)) then begin

            if Excelbuffer.Get(17, 2) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;
                Excelbuffer.Get(18, 2);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 2);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 2);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end;
        end;

        if (FromDates >= CalcDate('<7D>', FromDate)) and (FromDates <= CalcDate('<13D>', FromDate)) then begin

            if Excelbuffer.Get(17, 3) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;
                Excelbuffer.Get(18, 3);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 3);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 3);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;

        if (FromDates >= CalcDate('<14D>', FromDate)) and (FromDates <= CalcDate('CM', FromDate)) then begin

            if Excelbuffer.Get(17, 4) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;
                Excelbuffer.Get(18, 4);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 4);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 4);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;




        if (FromDates >= CalcDate('1M', FromDate)) and (FromDates <= CalcDate('CM', CalcDate('1M', FromDate))) then begin
            if Excelbuffer.Get(17, 5) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(18, 5);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 5);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 5);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end;
        end;
        if (FromDates >= CalcDate('2M', FromDate)) and (FromDates <= CalcDate('CM', CalcDate('2M', FromDate))) then begin
            if Excelbuffer.Get(17, 6) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(18, 6);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end else begin

                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 6);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 6);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;
        if (FromDates >= CalcDate('3M', FromDate)) and (FromDates <= CalcDate('CM', CalcDate('5M', FromDate))) then begin
            if Excelbuffer.Get(17, 7) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(18, 7);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 7);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 7);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;

        if (FromDates >= CalcDate('6M', FromDate)) and (FromDates <= CalcDate('11M', FromDate)) then begin
            if Excelbuffer.Get(17, 8) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(18, 8);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;


            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 8);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 8);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;

        if (FromDates >= CalcDate('12M', FromDate)) and (FromDates <= CalcDate('-1D', CalcDate('3Y', FromDate))) then begin
            if Excelbuffer.Get(17, 9) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(18, 9);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;

                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 9);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 9);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;

                AlmLine."3 year to 5 Years" := AlmLine."3 year to 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;

        if (FromDates >= CalcDate('3Y', FromDate)) and (FromDates <= CalcDate('-1D', CalcDate('5Y', FromDate))) then begin
            if Excelbuffer.Get(17, 10) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(18, 10);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine.Reset;
                AlmLine.SetRange("Document No.", ALMHeader."Document No.");
                AlmLine.SetRange("RBI Code", 'Y1520');
                if AlmLine.Find('-') then begin
                    AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                    AlmLine.Modify;
                end;

            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 10);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 10);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;

                AlmLine.Reset;
                AlmLine.SetRange("Document No.", ALMHeader."Document No.");
                AlmLine.SetRange("RBI Code", 'Y1520');
                if AlmLine.Find('-') then begin
                    AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                    AlmLine.Modify;
                end;
            end;
        end;


        if (FromDates >= CalcDate('5Y', FromDate)) and (FromDates <= CalcDate('25Y', FromDate)) then begin
            if Excelbuffer.Get(17, 11) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(18, 11);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;

                AlmLine.Reset;
                AlmLine.SetRange("Document No.", ALMHeader."Document No.");
                AlmLine.SetRange("RBI Code", 'Y1520');
                if AlmLine.Find('-') then begin
                    AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                    AlmLine.Modify;
                end;

            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 11);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 11);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;

                AlmLine.Reset;
                AlmLine.SetRange("Document No.", ALMHeader."Document No.");
                AlmLine.SetRange("RBI Code", 'Y1520');
                if AlmLine.Find('-') then begin
                    AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                    AlmLine.Modify;
                end;
            end;
        end;
        //Excelbuffer.AddColumn(CalculateAmount(CALCDATE('6M',FromDate),CALCDATE('1Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        //Excelbuffer.AddColumn(CalculateAmount(CALCDATE('1Y',FromDate)+1,CALCDATE('3Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        //Excelbuffer.AddColumn(CalculateAmount(CALCDATE('3Y',FromDate)+1,CALCDATE('5Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        //Excelbuffer.AddColumn(CalculateAmount(CALCDATE('5Y',FromDate)+1,CALCDATE('25Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
    end;

    local procedure InsertSummaryHeadingNPA()
    begin


        SummaryHeadingInserted := true;

        Excelbuffer.Validate("Row No.", 16);
        Excelbuffer.Validate("Column No.", 2);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '1 to 7 days');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 16);
        Excelbuffer.Validate("Column No.", 3);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '8 to 14 days');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 16);
        Excelbuffer.Validate("Column No.", 4);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '15 days to 1 Month');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 16);
        Excelbuffer.Validate("Column No.", 5);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '1 Month to 2 Months');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 16);
        Excelbuffer.Validate("Column No.", 6);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '2 Month to 3 Months');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 16);
        Excelbuffer.Validate("Column No.", 7);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '3 Month To 6 Months');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 16);
        Excelbuffer.Validate("Column No.", 8);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '6 Month To 1 Year');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 16);
        Excelbuffer.Validate("Column No.", 9);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '1 Year to 3 Year');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 16);
        Excelbuffer.Validate("Column No.", 10);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", '3 year to 5 Years');
        Excelbuffer.Insert;
        Excelbuffer.Validate("Row No.", 16);
        Excelbuffer.Validate("Column No.", 11);
        Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
        Excelbuffer.Validate("Cell Value as Text", 'Over 5 Years');
        Excelbuffer.Insert;

    end;

    local procedure InsertSummaryNPALoss(FromDates: Date; RepayAmt: Decimal; PreyPayAmt: Decimal)
    var
        AlmLine: Record "ALM Lines";
    begin

        AlmLine.Reset;
        AlmLine.SetRange("Document No.", ALMHeader."Document No.");
        AlmLine.SetRange("RBI Code", 'Y1540');
        if AlmLine.Find('-') then;


        if not Excelbuffer.Get(17, 1) then begin
            Excelbuffer.Validate("Row No.", 17);
            Excelbuffer.Validate("Column No.", 1);
            Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
            Excelbuffer.Validate("Cell Value as Text", 'Repayment');
            Excelbuffer.Insert;
            Excelbuffer.Validate("Row No.", 18);
            Excelbuffer.Validate("Column No.", 1);
            Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Text);
            Excelbuffer.Validate("Cell Value as Text", 'Prepayment');
            Excelbuffer.Insert;
        end;



        if (FromDates >= FromDate) and (FromDates <= CalcDate('<6D>', FromDate)) then begin

            if Excelbuffer.Get(17, 2) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;
                Excelbuffer.Get(18, 2);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;

                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;


            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 2);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 2);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end;
        end;

        if (FromDates >= CalcDate('<7D>', FromDate)) and (FromDates <= CalcDate('<13D>', FromDate)) then begin

            if Excelbuffer.Get(17, 3) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;
                Excelbuffer.Get(18, 3);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;


            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 3);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 3);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;

        if (FromDates >= CalcDate('<14D>', FromDate)) and (FromDates <= CalcDate('CM', FromDate)) then begin

            if Excelbuffer.Get(17, 4) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;
                Excelbuffer.Get(18, 4);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 4);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 4);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;




        if (FromDates >= CalcDate('1M', FromDate)) and (FromDates <= CalcDate('CM', CalcDate('1M', FromDate))) then begin
            if Excelbuffer.Get(17, 5) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(18, 5);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 5);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 5);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end;
        end;
        if (FromDates >= CalcDate('2M', FromDate)) and (FromDates <= CalcDate('CM', CalcDate('2M', FromDate))) then begin
            if Excelbuffer.Get(17, 6) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(18, 6);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end else begin

                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 6);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 6);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;
        if (FromDates >= CalcDate('3M', FromDate)) and (FromDates <= CalcDate('CM', CalcDate('5M', FromDate))) then begin
            if Excelbuffer.Get(17, 7) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(18, 7);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 7);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 7);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;

        if (FromDates >= CalcDate('6M', FromDate)) and (FromDates <= CalcDate('11M', FromDate)) then begin
            if Excelbuffer.Get(17, 8) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(18, 8);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 8);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 8);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;

        if (FromDates >= CalcDate('12M', FromDate)) and (FromDates <= CalcDate('-1D', CalcDate('3Y', FromDate))) then begin
            if Excelbuffer.Get(17, 9) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(18, 9);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 9);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 9);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;

        if (FromDates >= CalcDate('3Y', FromDate)) and (FromDates <= CalcDate('-1D', CalcDate('5Y', FromDate))) then begin
            if Excelbuffer.Get(17, 10) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(18, 10);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;

            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 10);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 10);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;
                AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                AlmLine.Modify;
            end;
        end;


        if (FromDates >= CalcDate('5Y', FromDate)) and (FromDates <= CalcDate('25Y', FromDate)) then begin
            if Excelbuffer.Get(17, 11) then begin
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + RepayAmt));
                Excelbuffer.Modify;

                Excelbuffer.Get(18, 11);
                Evaluate(ExcelValue, Excelbuffer."Cell Value as Text");
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(ExcelValue + PrePaymentAmount));
                Excelbuffer.Modify;
                AlmLine.Reset;
                AlmLine.SetRange("Document No.", ALMHeader."Document No.");
                AlmLine.SetRange("RBI Code", 'Y1550');
                if AlmLine.Find('-') then begin
                    AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                    AlmLine.Modify;
                end;

            end else begin
                Excelbuffer.Validate("Row No.", 17);
                Excelbuffer.Validate("Column No.", 11);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(RepayAmt));
                Excelbuffer.Insert;

                Excelbuffer.Validate("Row No.", 18);
                Excelbuffer.Validate("Column No.", 11);
                Excelbuffer.Validate("Cell Type", Excelbuffer."cell type"::Number);
                Excelbuffer.Validate("Cell Value as Text", Format(PrePaymentAmount));
                Excelbuffer.Insert;

                AlmLine.Reset;
                AlmLine.SetRange("Document No.", ALMHeader."Document No.");
                AlmLine.SetRange("RBI Code", 'Y1550');
                if AlmLine.Find('-') then begin
                    AlmLine."Over 5 Years" := AlmLine."Over 5 Years" + RepayAmt + PrePaymentAmount;
                    AlmLine.Modify;
                end;
            end;
        end;
        //Excelbuffer.AddColumn(CalculateAmount(CALCDATE('6M',FromDate),CALCDATE('1Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        //Excelbuffer.AddColumn(CalculateAmount(CALCDATE('1Y',FromDate)+1,CALCDATE('3Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        //Excelbuffer.AddColumn(CalculateAmount(CALCDATE('3Y',FromDate)+1,CALCDATE('5Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
        //Excelbuffer.AddColumn(CalculateAmount(CALCDATE('5Y',FromDate)+1,CALCDATE('25Y',FromDate)),FALSE,'',FALSE,FALSE,FALSE,'',Excelbuffer."Cell Type"::Number);
    end;
}

