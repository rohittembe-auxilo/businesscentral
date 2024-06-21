Page 50146 EIR
{
    PageType = Card;
    SourceTable = "EIR Header";


    layout
    {
        area(content)
        {
            group(General)
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
            part(Lines; "EIR Subpage")
            {
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
            }
            part("EIR Subpage"; "EIR Subpage")
            {
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        area(creation)
        {
            action("Calculate EIR")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    EIR;
                    Message('EIR Calculated');
                end;
            }
            action("Delete All LAN")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    if Confirm('Do you want to delete all LAN ', true) then begin
                        if EIRHeader.FindFirst then
                            EIRHeader.DeleteAll(true);
                    end;
                end;
            }
            action(test)
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    CalculateEIR();
                end;
            }
            action("Calculate EIR_new")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    EIR_k;
                    Message('EIR Calculated');
                end;
            }
        }
    }

    var
        interest: Decimal;
        EIRHeader: Record "EIR Header";

    local procedure CalculateEIR()
    var
        EIRLine: Record "EIR Line";
        EIRLine1: Record "EIR Line";
        EIRLine2: Record "EIR Line";
        DayDiff: Integer;
    begin
        EIRLine.Reset;
        EIRLine.SetRange("Document No.", rec."No.");
        if EIRLine.Find('-') then
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

    local procedure CalculateEIR2()
    var
        EIRLine: Record "EIR Line";
        EIRLine1: Record "EIR Line";
        EIRLine2: Record "EIR Line";
        DayDiff: Integer;
    begin
        EIRLine1.Reset();
        EIRLine1.SetRange("Document No.", rec."No.");
        if EIRLine1.Find('-') then
            repeat
                EIRLine2.Reset();
                EIRLine2.SetRange("Document No.", rec."No.");
                EIRLine2.SetFilter("Line No.", '>%1', EIRLine1."Line No.");
                if EIRLine2.Find('-') then begin
                    EIRLine2."Opening Balance" := EIRLine1."Closing Balance Out";
                    DayDiff := CalculateDayDiff(EIRLine1."SCH Date Out", EIRLine2."SCH Date Out");
                    EIRLine2.Interest := ((EIRLine2."Opening Balance" * (EIRLine1.EIR / 100)) / 360) * DayDiff;
                    EIRLine2."Closing Balance Out" := EIRLine2."Opening Balance" + EIRLine2."Revised Disburshment Amt" - EIRLine2."Repay Amount Out" + EIRLine2.Interest;
                    EIRLine2.Amortization := EIRLine2.Interest - EIRLine2."Profit Calculation" - EIRLine2."CPZ Amount";
                    EIRLine2."Cumulative Amortization" := EIRLine2.Amortization + EIRLine1."Cumulative Amortization";
                    EIRLine2.Unamortization := EIRLine1.Unamortization - EIRLine2.Amortization;
                    EIRLine2.Modify;

                end;

            until EIRLine1.Next = 0;
    end;

    local procedure FindLastCB() LastCB: Decimal
    var
        EIRLine: Record "EIR Line";
    begin
        EIRLine.Reset();
        EIRLine.SetRange("Document No.", rec."No.");
        if EIRLine.FindLast then
            LastCB := EIRLine."Closing Balance Out";
    end;

    local procedure FillEIR(EIR: Decimal)
    var
        EIRLine: Record "EIR Line";
        diffVal: Decimal;
        prevEIR: Decimal;
    begin
        EIRLine.Reset();
        EIRLine.SetRange("Document No.", rec."No.");
        if EIRLine.Find('-') then
            repeat
                EIRLine.EIR := EIR;
                EIRLine.Modify();
            until EIRLine.Next = 0;
    end;

    local procedure EIR()
    var
        LastClosingBalance: Decimal;
        i: Decimal;
        j: Decimal;
        k: Decimal;
    begin
        i := 1;
        //CalculateEIR;
        LastClosingBalance := -1;

        while LastClosingBalance < 0 do begin
            //FillEIR(i);//commented by Kritika
            FillAndAddEIRDiff(i);
            i := i + 1;
            CalculateEIR2;
            LastClosingBalance := FindLastCB;
            if (LastClosingBalance > 0) and (i = 2) then
                Error('...');

        end;


        i := i - 2;
        j := 1;
        j := j / 10;
        i := i + j;
        k := 2;

        while LastClosingBalance <> 0 do begin

            CalculateEIR3(i);
            LastClosingBalance := FindLastCB;

            if LastClosingBalance < 0 then begin
                i := i + j;
                // k:=k+1;

            end else if LastClosingBalance > 0 then begin
                i := i - j;
                j := j / 10;
                k := 2;

            end;

            /*//<<added by kritika start
            IF (LastClosingBalance = 0) OR ((LastClosingBalance >0) AND (LastClosingBalance <0.0001))THEN
              AddEIRDiff; //>>added by kritika start*/

            if (LastClosingBalance > 0) and (LastClosingBalance < 0.0001) then
                exit;

        end;



    end;

    local procedure CalculateEIR3(i: Decimal)
    var
        LastClosingBalance: Decimal;
        k: Integer;
    begin
        //FillEIR(i);//commented by kritika
        FillAndAddEIRDiff(i);//added by Kritika
        CalculateEIR2;
    end;

    local procedure CalculateEIR4(i: Decimal)
    var
        LastClosingBalance: Decimal;
        k: Integer;
    begin
        LastClosingBalance := -1;

        while LastClosingBalance < 0 do begin
            //FillEIR(i);//commented by kritika
            FillAndAddEIRDiff(i);//added by Kritika
            i := i + 0.00001;
            CalculateEIR2;
            LastClosingBalance := FindLastCB;
        end;
    end;

    local procedure FillAndAddEIRDiff(EIR: Decimal)
    var
        EIRLine: Record "EIR Line";
        diffVal: Decimal;
        prevEIR: Decimal;
    begin
        //added by Kritika
        Clear(prevEIR);
        Clear(diffVal);
        EIRLine.Reset();
        EIRLine.SetRange("Document No.", rec."No.");
        if EIRLine.Find('-') then begin
            prevEIR := EIRLine."Calculated Rate";
            repeat
                diffVal += EIRLine."Calculated Rate" - prevEIR;
                EIRLine.EIR := EIR + diffVal;
                EIRLine.Modify();
                prevEIR := EIRLine."Calculated Rate";
            until EIRLine.Next = 0;
        end;
    end;

    local procedure EIR_k()
    var
        LastClosingBalance: Decimal;
        i: Decimal;
        j: Decimal;
        k: Decimal;
    begin
        i := 1;
        LastClosingBalance := -1;

        while LastClosingBalance < 0 do begin
            FillAndAddEIRDiff_k(i);
            i := i + 1;
            LastClosingBalance := FindLastCB;
            if (LastClosingBalance > 0) and (i = 2) then
                Error('...');
        end;

        i := i - 2;
        j := 1;
        j := j / 10;
        i := i + j;
        k := 2;

        while LastClosingBalance <> 0 do begin
            FillAndAddEIRDiff_k(i);
            LastClosingBalance := FindLastCB;
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

    local procedure FillAndAddEIRDiff_k(EIR: Decimal)
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
        Clear(prevEIR);
        Clear(prevEIRCalc);
        Clear(diffVal);
        Clear(prevLineClosingBal);
        Clear(prevLineCumulativeAmortization);
        Clear(prevLineSCHDate);
        Clear(prevLineUnamortization);
        EIRLine.Reset();
        EIRLine.SetRange("Document No.", rec."No.");
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

    local procedure CalculateEIR3_k(i: Decimal)
    var
        LastClosingBalance: Decimal;
        k: Integer;
    begin
        //FillEIR(i);//commented by kritika
        FillAndAddEIRDiff_k(i);//added by Kritika
        //CalculateEIR2_k();
    end;

    local procedure CalculateEIR2_k()
    var
        EIRLine: Record "EIR Line";
        EIRLine1: Record "EIR Line";
        EIRLine2: Record "EIR Line";
        DayDiff: Integer;
    begin
        EIRLine1.Reset();
        EIRLine1.SetRange("Document No.", rec."No.");
        if EIRLine1.Find('-') then
            repeat
                EIRLine2.Reset();
                EIRLine2.SetRange("Document No.", rec."No.");
                EIRLine2.SetFilter("Line No.", '>%1', EIRLine1."Line No.");
                if EIRLine2.Find('-') then begin
                    EIRLine2."Opening Balance" := EIRLine1."Closing Balance Out";
                    DayDiff := CalculateDayDiff(EIRLine1."SCH Date Out", EIRLine2."SCH Date Out");
                    EIRLine2.Interest := ((EIRLine2."Opening Balance" * (EIRLine2.EIR / 100)) / 360) * DayDiff;
                    EIRLine2."Closing Balance Out" := EIRLine2."Opening Balance" + EIRLine2."Revised Disburshment Amt" - EIRLine2."Repay Amount Out" + EIRLine2.Interest;
                    EIRLine2.Amortization := EIRLine2.Interest - EIRLine2."Profit Calculation" - EIRLine2."CPZ Amount";
                    EIRLine2."Cumulative Amortization" := EIRLine2.Amortization + EIRLine1."Cumulative Amortization";
                    EIRLine2.Unamortization := EIRLine1.Unamortization - EIRLine2.Amortization;
                    EIRLine2.Modify;

                end;

            until EIRLine1.Next = 0;
    end;
}

