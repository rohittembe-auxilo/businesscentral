Page 50147 "EIR List"
{
    CardPageID = EIR;
    Editable = false;
    PageType = List;
    SourceTable = "EIR Header";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate EIR")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                var
                    EIRHeader: Record "EIR Header";
                    EIRHeader2: Record "EIR Header";
                begin
                    ProgressWindow.Open('Processing EIR No. #1#######');
                    k := 1;
                    EIRHeader.Reset();
                    EIRHeader.SetCurrentkey("EIR Calculated");
                    EIRHeader.SetRange("EIR Calculated", false);
                    /*//IF EIRHeader.FINDSET THEN REPEAT
                        EIR(EIRHeader);
                        EIRHeader."EIR Calculated":= TRUE;
                        EIRHeader.MODIFY;
                        ProgressWindow.UPDATE(1,EIRHeader."No.");*/
                    if EIRHeader.FindFirst then
                        repeat // CCIT AN 24Jan23
                            EIR(EIRHeader);
                            EIRHeader2.Get(EIRHeader."No.");
                            EIRHeader2."EIR Calculated" := true;
                            EIRHeader2.Modify;
                            ProgressWindow.Update(1, EIRHeader."No.");
                            Commit;
                        until EIRHeader.Next = 0;
                    ProgressWindow.Close;
                    Message('EIR Calculated');

                end;
            }
            action("Import EIR")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    Xmlport.Run(50121, true, true);
                end;
            }
            action("Export EIR")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    Xmlport.Run(50122, true);
                end;
            }
            action("Update Cost")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    Xmlport.Run(50123, true);
                end;
            }
            action("Summary EIR")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    Report.Run(50006, true, false);
                end;
            }
            action("Calculate EIR_new")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                var
                    EIRHeader: Record "EIR Header";
                begin
                    ProgressWindow.Open('Processing EIR No. #1#######');
                    k := 1;
                    EIRHeader.Reset();
                    EIRHeader.SetRange("EIR Calculated", false);
                    if EIRHeader.FindSet then
                        repeat
                            EIR_k(EIRHeader);
                            EIRHeader."EIR Calculated" := true;
                            EIRHeader.Modify;
                            ProgressWindow.Update(1, EIRHeader."No.");
                            Commit;
                        until EIRHeader.Next = 0;
                    ProgressWindow.Close;
                    Message('EIR Calculated');
                end;
            }
        }
    }

    var
        ProgressWindow: Dialog;
        k: Integer;

    local procedure CalculateEIR(EIRHeader: Record "EIR Header")
    var
        EIRLine: Record "EIR Line";
        EIRLine1: Record "EIR Line";
        EIRLine2: Record "EIR Line";
        DayDiff: Integer;
    begin
        EIRLine.Reset;
        EIRLine.SetRange("Document No.", EIRHeader."No.");
        if EIRLine.FindSet then
            repeat

                EIRLine."SCH Date Out" := EIRLine."SCH Date";
                EIRLine."Revised Disburshment Amt" := EIRLine."Disb Amount" - EIRLine.Cost;
                EIRLine."Repay Amount Out" := EIRLine."Repay Amount";
                EIRLine."Closing Balance Out" := EIRLine."Opening Balance" + EIRLine."Revised Disburshment Amt" - EIRLine."Repay Amount Out" + EIRLine.Interest;
                EIRLine.Unamortization := EIRLine.Cost;
                EIRLine.Modify;
            until EIRLine.Next = 0;
    end;

    local procedure CalculateDayDiff(FirstDate: Date; SecondDate: Date) DayDiff: Integer
    var
        Day: Integer;
        FirstDayDiff: Integer;
        SecondDayDiff: Integer;
        MonthDiff: Integer;
    begin
        Day := Date2dmy(FirstDate, 1);
        FirstDayDiff := 30 - Day;
        SecondDayDiff := Date2dmy(SecondDate, 1);
        DayDiff := FirstDayDiff + SecondDayDiff;
        MonthDiff := Date2dmy(SecondDate, 2) - Date2dmy(FirstDate, 2);
        if MonthDiff = 0 then
            DayDiff := DayDiff - 30;
        if MonthDiff > 1 then
            DayDiff := DayDiff + (MonthDiff - 1) * 30;
    end;

    local procedure CalculateEIR2(EIRHeader: Record "EIR Header")
    var
        EIRLine: Record "EIR Line";
        EIRLine1: Record "EIR Line";
        EIRLine2: Record "EIR Line";
        DayDiff: Integer;
    begin
        EIRLine1.Reset();
        EIRLine1.SetRange("Document No.", EIRHeader."No.");
        if EIRLine1.FindSet then
            repeat
                EIRLine2.Reset();
                EIRLine2.SetRange("Document No.", EIRHeader."No.");
                EIRLine2.SetFilter("Line No.", '>%1', EIRLine1."Line No.");
                if EIRLine2.FindSet then begin
                    EIRLine2."Opening Balance" := EIRLine1."Closing Balance Out";
                    DayDiff := CalculateDayDiff(EIRLine1."SCH Date Out", EIRLine2."SCH Date Out");
                    //EIRLine2.Interest:= ((EIRLine2."Opening Balance"*(EIRLine2.EIR/100))/360)*DayDiff;
                    EIRLine2.Interest := ((EIRLine2."Opening Balance" * (EIRLine1.EIR / 100)) / 360) * DayDiff;
                    EIRLine2."Closing Balance Out" := EIRLine2."Opening Balance" + EIRLine2."Revised Disburshment Amt" - EIRLine2."Repay Amount Out" + EIRLine2.Interest;
                    EIRLine2.Amortization := EIRLine2.Interest - EIRLine2."Profit Calculation" - EIRLine2."CPZ Amount";
                    EIRLine2."Cumulative Amortization" := EIRLine2.Amortization + EIRLine1."Cumulative Amortization";
                    EIRLine2.Unamortization := EIRLine1.Unamortization - EIRLine2.Amortization;
                    EIRLine2.Modify;

                end;

            until EIRLine1.Next = 0;
    end;

    local procedure FindLastCB(EIRHeader: Record "EIR Header") LastCB: Decimal
    var
        EIRLine: Record "EIR Line";
    begin
        EIRLine.Reset();
        EIRLine.SetRange("Document No.", EIRHeader."No.");
        if EIRLine.FindLast then
            LastCB := EIRLine."Closing Balance Out";
    end;

    local procedure FillEIR(EIR: Decimal; EIRHeader: Record "EIR Header")
    var
        EIRLine: Record "EIR Line";
    begin
        EIRLine.Reset();
        EIRLine.SetRange("Document No.", EIRHeader."No.");
        if EIRLine.Find('-') then
            repeat
                EIRLine.EIR := EIR;
                EIRLine.Modify();
            until EIRLine.Next = 0;
    end;

    local procedure EIR(EIRHeader: Record "EIR Header")
    var
        LastClosingBalance: Decimal;
        i: Decimal;
        j: Decimal;
        k: Decimal;
    begin
        i := 1;
        CalculateEIR(EIRHeader);
        LastClosingBalance := -1;

        while LastClosingBalance < 0 do begin
            //FillEIR(i,EIRHeader);
            FillAndAddEIRDiff(i, EIRHeader);//added by Kritika
            i := i + 1;
            CalculateEIR2(EIRHeader);
            LastClosingBalance := FindLastCB(EIRHeader);
        end;


        i := i - 2;
        j := 1;
        j := j / 10;
        i := i + j;
        k := 2;

        while LastClosingBalance <> 0 do begin

            CalculateEIR3(i, EIRHeader);
            LastClosingBalance := FindLastCB(EIRHeader);

            if LastClosingBalance < 0 then begin
                i := i + j;
                // k:=k+1;

            end else if LastClosingBalance > 0 then begin
                i := i - j;
                j := j / 10;
                k := 2;

            end;

            if (LastClosingBalance > 0) and (LastClosingBalance < 0.0001) then
                exit;

        end;


    end;

    local procedure CalculateEIR3(i: Decimal; EIRHeader: Record "EIR Header")
    var
        LastClosingBalance: Decimal;
        k: Integer;
    begin
        //FillEIR(i,EIRHeader);
        FillAndAddEIRDiff(i, EIRHeader);
        CalculateEIR2(EIRHeader)
    end;

    local procedure FillAndAddEIRDiff(EIR: Decimal; EIRHeader: Record "EIR Header")
    var
        EIRLine: Record "EIR Line";
        diffVal: Decimal;
        prevEIR: Decimal;
    begin
        //added by Kritika
        Clear(prevEIR);
        Clear(diffVal);
        EIRLine.Reset();
        EIRLine.SetRange("Document No.", EIRHeader."No.");
        if EIRLine.FindSet then begin
            prevEIR := EIRLine."Calculated Rate";
            repeat
                diffVal += EIRLine."Calculated Rate" - prevEIR;
                EIRLine.EIR := EIR + diffVal;
                EIRLine.Modify();
                prevEIR := EIRLine."Calculated Rate";
            until EIRLine.Next = 0;
        end;
    end;

    local procedure EIR_k(EIRHeader: Record "EIR Header")
    var
        LastClosingBalance: Decimal;
        i: Decimal;
        j: Decimal;
        k: Decimal;
    begin
        i := 1;
        LastClosingBalance := -1;

        while LastClosingBalance < 0 do begin
            FillAndAddEIRDiff_k(i, EIRHeader);//added by Kritika
            i := i + 1;
            LastClosingBalance := FindLastCB(EIRHeader);
        end;


        i := i - 2;
        j := 1;
        j := j / 10;
        i := i + j;
        k := 2;

        while LastClosingBalance <> 0 do begin
            FillAndAddEIRDiff_k(i, EIRHeader);//added by Kritika
            LastClosingBalance := FindLastCB(EIRHeader);
            if LastClosingBalance < 0 then begin
                i := i + j;
            end else if LastClosingBalance > 0 then begin
                i := i - j;
                j := j / 10;
                k := 2;
            end;

            if (LastClosingBalance > 0) and (LastClosingBalance < 0.0001) then
                exit;
        end;


    end;

    local procedure FillAndAddEIRDiff_k(EIR: Decimal; EIRHeader: Record "EIR Header")
    var
        EIRLine: Record "EIR Line";
        diffVal: Decimal;
        line: Decimal;
        prevEIRCalc: Decimal;
        prevLineUnamortization: Decimal;
        prevLineClosingBal: Decimal;
        prevLineSCHDate: Date;
        prevLineCumulativeAmortization: Decimal;
        DayDiff: Integer;
        prevEIR: Decimal;
    begin
        //added by Kritika
        Clear(prevEIRCalc);
        Clear(diffVal);
        Clear(prevLineClosingBal);
        Clear(prevLineCumulativeAmortization);
        Clear(prevLineSCHDate);
        Clear(prevLineUnamortization);
        Clear(prevEIR);
        EIRLine.Reset();
        EIRLine.SetRange("Document No.", EIRHeader."No.");
        if EIRLine.FindSet then begin
            prevEIRCalc := EIRLine."Calculated Rate";
            prevLineClosingBal := 0;
            prevEIR := EIRLine.EIR;
            repeat
                diffVal += EIRLine."Calculated Rate" - prevEIRCalc;
                EIRLine.EIR := EIR + diffVal;
                if prevLineClosingBal <> 0 then begin
                    EIRLine."Opening Balance" := prevLineClosingBal;
                    DayDiff := CalculateDayDiff(prevLineSCHDate, EIRLine."SCH Date Out");
                    //EIRLine.Interest:= ((EIRLine."Opening Balance"*(EIRLine.EIR/100))/360)*DayDiff;
                    EIRLine.Interest := ((EIRLine."Opening Balance" * (prevEIR / 100)) / 360) * DayDiff;
                    EIRLine."Closing Balance Out" := EIRLine."Opening Balance" + EIRLine."Revised Disburshment Amt" - EIRLine."Repay Amount Out" + EIRLine.Interest;
                    EIRLine.Amortization := EIRLine.Interest - EIRLine."Profit Calculation" - EIRLine."CPZ Amount";
                    EIRLine."Cumulative Amortization" := EIRLine.Amortization + prevLineCumulativeAmortization;
                    EIRLine.Unamortization := prevLineUnamortization - EIRLine.Amortization;
                end;



                EIRLine.Modify();
                prevEIRCalc := EIRLine."Calculated Rate";
                prevLineCumulativeAmortization := EIRLine."Cumulative Amortization";
                prevLineSCHDate := EIRLine."SCH Date Out";
                prevLineUnamortization := EIRLine.Unamortization;
                prevLineClosingBal := EIRLine."Closing Balance Out";
                prevEIR := EIRLine.EIR;
            until EIRLine.Next = 0;


        end;
    end;
}

