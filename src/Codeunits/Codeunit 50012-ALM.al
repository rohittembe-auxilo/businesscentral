codeunit 50012 ALM
{
    // version CCIT-Vikas ALM
    trigger OnRun()
    begin
        MESSAGE('Done');
    end;

    var
        ALMSheet1: Record "ALM Sheet1";
        FirstDateOfNextMonth: Date;
        ALMSheet2: Record "ALM Sheet2";
        ALMSheet3: Record "ALM Sheet3";
        AdvanceLANWise: Record "Advances LanWise";

    procedure File1Calculation(ALMHeader: Record "ALM Header")
    var
        ALMLine: Record "ALM Lines";
    begin

        FirstDateOfNextMonth := CALCDATE('CM', ALMHeader."Ending Date") + 1;
        //MESSAGE('%1',LastDate);

        ALMLine.RESET();
        ALMLine.SETRANGE("Document No.", ALMHeader."Document No.");
        //ALMLine.SETRANGE("RBI Code",'Y010');
        IF ALMLine.FIND('-') THEN
            REPEAT

                //  1-7 Days
                // MESSAGE('1-7 %1--%2',LastDate+1,LastDate+7);
                ALMLine."1 to 7 days" := CalculateAmount(ALMHeader."Document No.", FirstDateOfNextMonth, FirstDateOfNextMonth + 6, ALMLine."RBI Code");
                //  7-14 Days'
                // MESSAGE('7-14 %1--%2',LastDate+8,LastDate+14);
                ALMLine."8 to 14 days" := CalculateAmount(ALMHeader."Document No.", FirstDateOfNextMonth + 7, FirstDateOfNextMonth + 13, ALMLine."RBI Code");
                //  15-1 Month
                //MESSAGE('14-30 %1--%2',LastDate+15,CALCDATE('CM',LastDate+1));
                ALMLine."15 to 1 Month" := CalculateAmount(ALMHeader."Document No.", FirstDateOfNextMonth + 14, CALCDATE('CM', FirstDateOfNextMonth), ALMLine."RBI Code");
                //  1 Month to 2 Month
                //MESSAGE('1-2 month %1--%2',CALCDATE('-CM',CALCDATE('CM',LastDate+1)+1),CALCDATE('CM',CALCDATE('CM',LastDate+1)+1));
                ALMLine."1 Month to 2 Months" := CalculateAmount(ALMHeader."Document No.", CALCDATE('1M', FirstDateOfNextMonth), CALCDATE('CM', CALCDATE('1M', FirstDateOfNextMonth)), ALMLine."RBI Code");

                //  2 Month to 3 Month
                ALMLine."2 Month to 3 Months" := CalculateAmount(ALMHeader."Document No.", CALCDATE('2M', FirstDateOfNextMonth), CALCDATE('CM', CALCDATE('2M', FirstDateOfNextMonth)), ALMLine."RBI Code");

                //  3 Month to 6 Month
                ALMLine."3 Month To 6 Months" := CalculateAmount(ALMHeader."Document No.", CALCDATE('3M', FirstDateOfNextMonth), CALCDATE('CM', CALCDATE('5M', FirstDateOfNextMonth)), ALMLine."RBI Code");

                //  6 Month to 1 Year
                ALMLine."6 Month To 1 Year" := CalculateAmount(ALMHeader."Document No.", CALCDATE('6M', FirstDateOfNextMonth), CALCDATE('1Y', FirstDateOfNextMonth), ALMLine."RBI Code");
                ALMLine."1 Year to 3 Year" := CalculateAmount(ALMHeader."Document No.", CALCDATE('1Y', FirstDateOfNextMonth), CALCDATE('3Y', FirstDateOfNextMonth) - 1, ALMLine."RBI Code");
                // MESSAGE('%1,%2,%3,%4',ALMHeader."Document No.",CALCDATE('1Y',FirstDateOfNextMonth),CALCDATE('3Y',FirstDateOfNextMonth)-1,ALMLine."RBI Code");
                // ALMLine."1 Year to 3 Year" :=CalculateAmount(ALMHeader."Document No.",CALCDATE('1Y',FirstDateOfNextMonth)+1,CALCDATE('3Y',FirstDateOfNextMonth),ALMLine."RBI Code");
                //ccit_Kj
                ALMLine."3 year to 5 Years" := CalculateAmount(ALMHeader."Document No.", CALCDATE('3Y', FirstDateOfNextMonth), CALCDATE('5Y', FirstDateOfNextMonth) - 1, ALMLine."RBI Code");
                ALMLine."Over 5 Years" := CalculateAmount(ALMHeader."Document No.", CALCDATE('5Y', FirstDateOfNextMonth), CALCDATE('25Y', FirstDateOfNextMonth) - 1, ALMLine."RBI Code");

                ALMLine.MODIFY;
            UNTIL ALMLine.NEXT = 0;


    end;

    local procedure CalculateAmount(DocumentNo: Code[20]; StartingDate: Date; EndingDate: Date; RBICode: Code[50]) Amount: Decimal
    begin
        CLEAR(Amount);
        ALMSheet1.RESET();
        ALMSheet1.SETRANGE("Document No.", DocumentNo);
        ALMSheet1.SETRANGE("Due Date", StartingDate, EndingDate);
        ALMSheet1.SETRANGE("RBI Code", RBICode);
        IF ALMSheet1.FIND('-') THEN
            REPEAT
                Amount := Amount + ALMSheet1.Principal;
            UNTIL ALMSheet1.NEXT = 0;
    end;

    procedure File2Calculation(ALMHeader: Record "ALM Header")
    var
        ALMLine: Record "ALM Lines";
    begin

        FirstDateOfNextMonth := CALCDATE('CM', ALMHeader."Ending Date") + 1;
        //MESSAGE('%1',LastDate);

        ALMLine.RESET();
        ALMLine.SETRANGE("Document No.", ALMHeader."Document No.");
        //ALMLine.SETRANGE("RBI Code",'Y010');
        IF ALMLine.FIND('-') THEN
            REPEAT

                //  1-7 Days
                // MESSAGE('1-7 %1--%2',LastDate+1,LastDate+7);
                ALMLine."1 to 7 days" := ALMLine."1 to 7 days" + CalculateAmountSheet2(ALMHeader."Document No.", FirstDateOfNextMonth, FirstDateOfNextMonth + 6, ALMLine."RBI Code");
                //  7-14 Days'
                // MESSAGE('7-14 %1--%2',LastDate+8,LastDate+14);
                ALMLine."8 to 14 days" := ALMLine."8 to 14 days" + CalculateAmountSheet2(ALMHeader."Document No.", FirstDateOfNextMonth + 7, FirstDateOfNextMonth + 13, ALMLine."RBI Code");
                //  15-1 Month
                //MESSAGE('14-30 %1--%2',LastDate+15,CALCDATE('CM',LastDate+1));
                ALMLine."15 to 1 Month" := ALMLine."15 to 1 Month" + CalculateAmountSheet2(ALMHeader."Document No.", FirstDateOfNextMonth + 14, CALCDATE('CM', FirstDateOfNextMonth), ALMLine."RBI Code");
                //  1 Month to 2 Month
                //MESSAGE('1-2 month %1--%2',CALCDATE('-CM',CALCDATE('CM',LastDate+1)+1),CALCDATE('CM',CALCDATE('CM',LastDate+1)+1));
                ALMLine."1 Month to 2 Months" := ALMLine."1 Month to 2 Months" + CalculateAmountSheet2(ALMHeader."Document No.", CALCDATE('1M', FirstDateOfNextMonth), CALCDATE('CM', CALCDATE('1M', FirstDateOfNextMonth)), ALMLine."RBI Code");

                //  2 Month to 3 Month
                ALMLine."2 Month to 3 Months" := ALMLine."2 Month to 3 Months" + CalculateAmountSheet2(ALMHeader."Document No.", CALCDATE('2M', FirstDateOfNextMonth), CALCDATE('CM', CALCDATE('2M', FirstDateOfNextMonth)), ALMLine."RBI Code");

                //  3 Month to 6 Month
                ALMLine."3 Month To 6 Months" := ALMLine."3 Month To 6 Months" + CalculateAmountSheet2(ALMHeader."Document No.", CALCDATE('3M', FirstDateOfNextMonth), CALCDATE('CM', CALCDATE('5M', FirstDateOfNextMonth)), ALMLine."RBI Code");

                //  6 Month to 1 Year
                ALMLine."6 Month To 1 Year" := ALMLine."6 Month To 1 Year" + CalculateAmountSheet2(ALMHeader."Document No.", CALCDATE('6M', FirstDateOfNextMonth), CALCDATE('1Y', FirstDateOfNextMonth), ALMLine."RBI Code");
                ALMLine."1 Year to 3 Year" := ALMLine."1 Year to 3 Year" + CalculateAmountSheet2(ALMHeader."Document No.", CALCDATE('1Y', FirstDateOfNextMonth), CALCDATE('3Y', FirstDateOfNextMonth) - 1, ALMLine."RBI Code");
                ALMLine."3 year to 5 Years" := ALMLine."3 year to 5 Years" + CalculateAmountSheet2(ALMHeader."Document No.", CALCDATE('3Y', FirstDateOfNextMonth), CALCDATE('5Y', FirstDateOfNextMonth) - 1, ALMLine."RBI Code");
                ALMLine."Over 5 Years" := ALMLine."Over 5 Years" + CalculateAmountSheet2(ALMHeader."Document No.", CALCDATE('5Y', FirstDateOfNextMonth), CALCDATE('25Y', FirstDateOfNextMonth) - 1, ALMLine."RBI Code");

                ALMLine.MODIFY;
            UNTIL ALMLine.NEXT = 0;

    end;

    local procedure CalculateAmountSheet2(DocumentNo: Code[20]; StartingDate: Date; EndingDate: Date; RBICode: Code[50]) Amount: Decimal
    begin
        CLEAR(Amount);
        ALMSheet2.RESET();
        ALMSheet2.SETRANGE("Document No.", DocumentNo);
        ALMSheet2.SETRANGE(Date, StartingDate, EndingDate);
        ALMSheet2.SETRANGE("RBI Code", RBICode);
        IF ALMSheet2.FIND('-') THEN
            REPEAT
                Amount := Amount + ALMSheet2.Unamort;
            UNTIL ALMSheet2.NEXT = 0;
    end;

    procedure File3Calculation(ALMHeader: Record "ALM Header")
    var
        ALMLine: Record "ALM Lines";
    begin

        FirstDateOfNextMonth := CALCDATE('CM', ALMHeader."Starting Date") + 1;
        //MESSAGE('%1',LastDate);

        ALMLine.RESET();
        ALMLine.SETRANGE("Document No.", ALMHeader."Document No.");
        //ALMLine.SETRANGE("RBI Code",'Y010');
        IF ALMLine.FIND('-') THEN
            REPEAT

                //  1-7 Days
                // MESSAGE('1-7 %1--%2',LastDate+1,LastDate+7);
                ALMLine."1 to 7 days" := ALMLine."1 to 7 days" + CalculateAmountSheet3(ALMHeader."Document No.", FirstDateOfNextMonth, FirstDateOfNextMonth + 6, ALMLine."RBI Code");
                //  7-14 Days'
                // MESSAGE('7-14 %1--%2',LastDate+8,LastDate+14);
                ALMLine."8 to 14 days" := ALMLine."8 to 14 days" + CalculateAmountSheet3(ALMHeader."Document No.", FirstDateOfNextMonth + 7, FirstDateOfNextMonth + 13, ALMLine."RBI Code");
                //  15-1 Month
                //MESSAGE('14-30 %1--%2',LastDate+15,CALCDATE('CM',LastDate+1));
                ALMLine."15 to 1 Month" := ALMLine."15 to 1 Month" + CalculateAmountSheet3(ALMHeader."Document No.", FirstDateOfNextMonth + 14, CALCDATE('CM', FirstDateOfNextMonth), ALMLine."RBI Code");
                //  1 Month to 2 Month
                //MESSAGE('1-2 month %1--%2',CALCDATE('-CM',CALCDATE('CM',LastDate+1)+1),CALCDATE('CM',CALCDATE('CM',LastDate+1)+1));
                ALMLine."1 Month to 2 Months" := ALMLine."1 Month to 2 Months" + CalculateAmountSheet3(ALMHeader."Document No.", CALCDATE('1M', FirstDateOfNextMonth), CALCDATE('CM', CALCDATE('1M', FirstDateOfNextMonth)), ALMLine."RBI Code");

                //  2 Month to 3 Month
                ALMLine."2 Month to 3 Months" := ALMLine."2 Month to 3 Months" + CalculateAmountSheet3(ALMHeader."Document No.", CALCDATE('2M', FirstDateOfNextMonth), CALCDATE('CM', CALCDATE('2M', FirstDateOfNextMonth)), ALMLine."RBI Code");

                //  3 Month to 6 Month
                ALMLine."3 Month To 6 Months" := ALMLine."3 Month To 6 Months" + CalculateAmountSheet3(ALMHeader."Document No.", CALCDATE('3M', FirstDateOfNextMonth), CALCDATE('CM', CALCDATE('5M', FirstDateOfNextMonth)), ALMLine."RBI Code");

                //  6 Month to 1 Year
                ALMLine."6 Month To 1 Year" := ALMLine."6 Month To 1 Year" + CalculateAmountSheet3(ALMHeader."Document No.", CALCDATE('6M', FirstDateOfNextMonth), CALCDATE('1Y', FirstDateOfNextMonth), ALMLine."RBI Code");
                ALMLine."1 Year to 3 Year" := ALMLine."1 Year to 3 Year" + CalculateAmountSheet3(ALMHeader."Document No.", CALCDATE('1Y', FirstDateOfNextMonth), CALCDATE('3Y', FirstDateOfNextMonth) - 1, ALMLine."RBI Code");
                ALMLine."3 year to 5 Years" := ALMLine."3 year to 5 Years" + CalculateAmountSheet3(ALMHeader."Document No.", CALCDATE('3Y', FirstDateOfNextMonth), CALCDATE('5Y', FirstDateOfNextMonth) - 1, ALMLine."RBI Code");
                ALMLine."Over 5 Years" := ALMLine."Over 5 Years" + CalculateAmountSheet3(ALMHeader."Document No.", CALCDATE('5Y', FirstDateOfNextMonth), CALCDATE('25Y', FirstDateOfNextMonth) - 1, ALMLine."RBI Code");

                ALMLine.MODIFY;
            UNTIL ALMLine.NEXT = 0;

    end;

    local procedure CalculateAmountSheet3(DocumentNo: Code[20]; StartingDate: Date; EndingDate: Date; RBICode: Code[50]) Amount: Decimal
    begin
        CLEAR(Amount);
        ALMSheet3.RESET();
        ALMSheet3.SETRANGE("Document No.", DocumentNo);
        ALMSheet3.SETRANGE(Date, StartingDate, EndingDate);
        ALMSheet3.SETRANGE("RBI Code", RBICode);
        IF ALMSheet3.FIND('-') THEN
            REPEAT
                Amount := Amount + ALMSheet3."Int Acc";
            UNTIL ALMSheet3.NEXT = 0;
    end;

    procedure File_AdvanceLAN_Calculation(ALMHeader: Record "ALM Header")
    var
        ALMLine: Record "ALM Lines";
    begin
        //CCIT_kj++
        FirstDateOfNextMonth := CALCDATE('CM', ALMHeader."Ending Date") + 1;
        //FirstDateOfNextMonth:=  CALCDATE('CM',ALMHeader."Starting Date")+1;
        //MESSAGE('%1',LastDate);

        ALMLine.RESET();
        ALMLine.SETRANGE("Document No.", ALMHeader."Document No.");
        //ALMLine.SETRANGE("RBI Code",'Y010');
        IF ALMLine.FIND('-') THEN
            REPEAT

                //  1-7 Days
                // MESSAGE('1-7 %1--%2',LastDate+1,LastDate+7);
                ALMLine."1 to 7 days" := ALMLine."1 to 7 days" + CalculateAmount_AdvanceLAN(ALMHeader."Document No.", FirstDateOfNextMonth, FirstDateOfNextMonth + 6, ALMLine."RBI Code");
                //  7-14 Days'
                // MESSAGE('7-14 %1--%2',LastDate+8,LastDate+14);
                ALMLine."8 to 14 days" := ALMLine."8 to 14 days" + CalculateAmount_AdvanceLAN(ALMHeader."Document No.", FirstDateOfNextMonth + 7, FirstDateOfNextMonth + 13, ALMLine."RBI Code");
                //  15-1 Month
                //MESSAGE('14-30 %1--%2',LastDate+15,CALCDATE('CM',LastDate+1));
                ALMLine."15 to 1 Month" := ALMLine."15 to 1 Month" + CalculateAmount_AdvanceLAN(ALMHeader."Document No.", FirstDateOfNextMonth + 14, CALCDATE('CM', FirstDateOfNextMonth), ALMLine."RBI Code");
                //  1 Month to 2 Month
                //MESSAGE('1-2 month %1--%2',CALCDATE('-CM',CALCDATE('CM',LastDate+1)+1),CALCDATE('CM',CALCDATE('CM',LastDate+1)+1));
                ALMLine."1 Month to 2 Months" := ALMLine."1 Month to 2 Months" + CalculateAmount_AdvanceLAN(ALMHeader."Document No.", CALCDATE('1M', FirstDateOfNextMonth), CALCDATE('CM', CALCDATE('1M', FirstDateOfNextMonth)), ALMLine."RBI Code");

                //  2 Month to 3 Month
                ALMLine."2 Month to 3 Months" := ALMLine."2 Month to 3 Months" + CalculateAmount_AdvanceLAN(ALMHeader."Document No.", CALCDATE('2M', FirstDateOfNextMonth), CALCDATE('CM', CALCDATE('2M', FirstDateOfNextMonth)), ALMLine."RBI Code");

                //  3 Month to 6 Month
                ALMLine."3 Month To 6 Months" := ALMLine."3 Month To 6 Months" + CalculateAmount_AdvanceLAN(ALMHeader."Document No.", CALCDATE('3M', FirstDateOfNextMonth), CALCDATE('CM', CALCDATE('5M', FirstDateOfNextMonth)), ALMLine."RBI Code");

                //  6 Month to 1 Year
                ALMLine."6 Month To 1 Year" := ALMLine."6 Month To 1 Year" + CalculateAmount_AdvanceLAN(ALMHeader."Document No.", CALCDATE('6M', FirstDateOfNextMonth), CALCDATE('1Y', FirstDateOfNextMonth), ALMLine."RBI Code");
                ALMLine."1 Year to 3 Year" := ALMLine."1 Year to 3 Year" + CalculateAmount_AdvanceLAN(ALMHeader."Document No.", CALCDATE('1Y', FirstDateOfNextMonth), CALCDATE('3Y', FirstDateOfNextMonth) - 1, ALMLine."RBI Code");
                ALMLine."3 year to 5 Years" := ALMLine."3 year to 5 Years" + CalculateAmount_AdvanceLAN(ALMHeader."Document No.", CALCDATE('3Y', FirstDateOfNextMonth), CALCDATE('5Y', FirstDateOfNextMonth) - 1, ALMLine."RBI Code");
                ALMLine."Over 5 Years" := ALMLine."Over 5 Years" + CalculateAmount_AdvanceLAN(ALMHeader."Document No.", CALCDATE('5Y', FirstDateOfNextMonth), CALCDATE('25Y', FirstDateOfNextMonth) - 1, ALMLine."RBI Code");

                ALMLine.MODIFY;
            UNTIL ALMLine.NEXT = 0;

        //CCIT_kj--
    end;

    local procedure CalculateAmount_AdvanceLAN(DocumentNo: Code[20]; StartingDate: Date; EndingDate: Date; RBICode: Code[50]) Amount: Decimal
    begin
        //CCIT_kj++
        CLEAR(Amount);
        AdvanceLANWise.RESET();
        AdvanceLANWise.SETRANGE("Document No.", DocumentNo);
        AdvanceLANWise.SETRANGE(AdvanceLANWise."SCH Date", StartingDate, EndingDate);
        //AdvanceLANWise.SETRANGE("SCH Date",StartingDate);
        AdvanceLANWise.SETRANGE("RBI Code", RBICode);
        IF AdvanceLANWise.FIND('-') THEN
            REPEAT
                Amount := Amount + AdvanceLANWise.PrincipalSchd;
            UNTIL AdvanceLANWise.NEXT = 0;
        //CCIT_kj--

    end;

    procedure File_RBISumCode(ALMHeader: Record "ALM Header")
    var
        ALMLine: Record "ALM Lines";
        RBISum2: Record "ALM Lines";
    begin
        ClearRBISum(ALMHeader."Document No.");
        ALMLine.RESET;
        ALMLine.SETRANGE("Document No.", ALMHeader."Document No.");
        ALMLine.SETFILTER("RBI Code SUM", '<>%1', '');
        IF ALMLine.FINDSET THEN
            REPEAT
                RBISum2.RESET;
                RBISum2.SETRANGE("Document No.", ALMLine."Document No.");
                RBISum2.SETFILTER("RBI Code", ALMLine."RBI Code SUM");
                IF RBISum2.FINDSET THEN
                    REPEAT
                        ALMLine."1 to 7 days" += RBISum2."1 to 7 days";
                        ALMLine."8 to 14 days" += RBISum2."8 to 14 days";
                        ALMLine."15 to 1 Month" += RBISum2."15 to 1 Month";
                        ALMLine."1 Month to 2 Months" += RBISum2."1 Month to 2 Months";
                        ALMLine."2 Month to 3 Months" += RBISum2."2 Month to 3 Months";
                        ALMLine."3 Month To 6 Months" += RBISum2."3 Month To 6 Months";
                        ALMLine."6 Month To 1 Year" += RBISum2."6 Month To 1 Year";
                        ALMLine."1 Year to 3 Year" += RBISum2."1 Year to 3 Year";
                        ALMLine."3 year to 5 Years" += RBISum2."3 year to 5 Years";
                        ALMLine."Over 5 Years" += RBISum2."Over 5 Years";
                        ALMLine.MODIFY
                      UNTIL RBISum2.NEXT = 0;
            UNTIL ALMLine.NEXT = 0;
    end;

    local procedure ClearRBISum(DoccNo: Code[20])
    var
        AlmLine: Record "ALM Lines";
    begin
        AlmLine.RESET;
        AlmLine.SETRANGE("Document No.", DoccNo);
        AlmLine.SETFILTER("RBI Code SUM", '<>%1', '');
        IF AlmLine.FINDSET THEN
            REPEAT
                AlmLine."1 to 7 days" := 0;
                AlmLine."8 to 14 days" := 0;
                AlmLine."15 to 1 Month" := 0;
                AlmLine."1 Month to 2 Months" := 0;
                AlmLine."2 Month to 3 Months" := 0;
                AlmLine."3 Month To 6 Months" := 0;
                AlmLine."6 Month To 1 Year" := 0;
                AlmLine."1 Year to 3 Year" := 0;
                AlmLine."3 year to 5 Years" := 0;
                AlmLine."Over 5 Years" := 0;
                AlmLine.MODIFY
              UNTIL AlmLine.NEXT = 0;
    end;
}

