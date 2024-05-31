/*Page 50111 ALM
{
    PageType = Document;
    SourceTable = "ALM Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Enabled = PageEditable;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Enabled = PageEditable;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                    Enabled = PageEditable;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                    Enabled = PageEditable;
                }
                field("Lac/Cr. ALM Sheet"; Rec."Lac/Cr. ALM Sheet")
                {
                    ApplicationArea = Basic;
                    Enabled = PageEditable;
                }
                field("Lock ALM Sheet"; Rec."Lock ALM Sheet")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = LockEnable;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Fill Sheet")
            {
                ApplicationArea = Basic;
                Enabled = PageEditable;

                trigger OnAction()
                var
                    ALMSequence: Record "ALM Sequence";
                    ALMLines: Record "ALM Lines";
                    Lineno: Integer;
                begin
                    if Confirm('Do you want to fill sheet') then begin
                        ALMLines.Reset;
                        ALMLines.SetRange("Document No.", Rec."Document No.");
                        if ALMLines.FindSet then
                            ALMLines.DeleteAll;


                        Lineno := 0;
                        ALMSequence.Reset();
                        if ALMSequence.FindFirst then
                            repeat
                                Lineno := Lineno + 10000;
                                ALMLines.Init();
                                ALMLines."Document No." := Rec."Document No.";
                                ALMLines."Line No." := Lineno;
                                ALMLines.Sequence := Format(ALMSequence."Seq. No.");
                                ALMLines.Desc := ALMSequence.Description;
                                ALMLines.Source := ALMSequence.Source;
                                ALMLines."RBI Code" := ALMSequence."RBI Code";
                                ALMLines."RBI Code SUM" := ALMSequence."RBI Code SUM"; //CCIT_kj
                                                                                       // ALMLine.Source_Date_Range := ALMSequence.Source_Date_Range;
                                ALMLines."1Month to 2 Months" := ALMSequence."1 Month to 2 Months";
                                ALMLines."1to 7 days" := ALMSequence."1 to 7 days";
                                ALMLines."1Year to 3 Year" := ALMSequence."1 Year to 3 Year";
                                ALMLines."2Month to 3 Months" := ALMSequence."2 Month to 3 Months";
                                ALMLines."3Month To 6 Months" := ALMSequence."3 Month To 6 Months";
                                ALMLines."3year to 5 Years" := ALMSequence."3 year to 5 Years";
                                ALMLines."6Month To 1 Year" := ALMSequence."6 Month To 1 Year";
                                ALMLines."8to 14 days" := ALMSequence."8 to 14 days";
                                ALMLines."Over5 Years" := ALMSequence."Over 5 Years";
                                ALMLines."15to 1 Month" := ALMSequence."15 to 1 Month";
                                ALMLines.Insert;
                            until ALMSequence.Next = 0;
                    end;
                    //CCIT AN 28112023+++
                    ActionEnable := true;
                    ActionEnableNPA := true;
                    ActionEnableNPALoss := true;
                end;
            }
            action(Calculate)
            {
                ApplicationArea = Basic;
                Enabled = PageEditable;

                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                    ALMLines: Record "ALM Lines";
                    ALMLine2: Record "ALM Lines";
                    ALMLine3: Record "ALM Lines";
                begin
                    ALMLines.Reset();
                    ALMLines.SetRange("Document No.", Rec."Document No.");
                    ALMLines.SetFilter(Source, '<>%1', '');
                    if ALMLines.Find('-') then
                        // BEGIN  //CCIT AN 29122022 BS Fig if source blank
                        repeat
                            SourceCode := ALMLines.Source;
                            Clear(MemorandumAmount);
                            Clear(GLAmount);
                            GLEntry.Reset();
                            GLEntry.SetFilter("G/L Account No.", SourceCode);
                            GLEntry.SetRange("Posting Date", Rec."Starting Date", Rec."Ending Date");
                            if GLEntry.Find('-') then
                                repeat
                                    GLAmount := GLAmount + GLEntry.Amount;
                                until GLEntry.Next = 0;

                            MemorandomEntry.Reset();
                            MemorandomEntry.SetFilter("G/L Account No.", SourceCode);
                            MemorandomEntry.SetRange("Posting Date", Rec."Starting Date", Rec."Ending Date");
                            MemorandomEntry.SetRange(Posted, true);
                            if MemorandomEntry.FindSet then
                                repeat
                                    MemorandumAmount := MemorandumAmount + MemorandomEntry.Amount;
                                until MemorandomEntry.Next = 0;

                            // ALMLines."BS Figure" := ABS(GLAmount) +ABS(MemorandumAmount);
                            ALMLines."BS Figure" := Abs(GLAmount + MemorandumAmount);  //CCIT AN 30122022
                            ALMLines.Modify;
                        until ALMLines.Next = 0;

                    CALM.File1Calculation(Rec);
                    CALM.File2Calculation(Rec);
                    CALM.File3Calculation(Rec);
                    //CALM.File_AdvanceLAN_Calculation(Rec); //CCIT_kj  //CCIT AN  commented for not updating RBICode Y1450

                    CALM.File_RBISumCode(Rec);//ccit_kj_08072022
                                              //CCIT AN 23022023
                    AdvancesInterestAccrual.RESET();
                    AdvancesInterestAccrual.SETRANGE("Document No.", rec."Document No.");
                    IF AdvancesInterestAccrual.FINDSET THEN
                        REPEAT
                            ALMLineAdd.RESET();
                            ALMLineAdd.SETRANGE("Document No.", AdvancesInterestAccrual."Document No.");
                            ALMLineAdd.SETFILTER("RBI Code", AdvancesInterestAccrual."RBI Code");
                            IF ALMLineAdd.FINDSET THEN
                                REPEAT
                                    ALMLineAdd."Over 5 Years" += AdvancesInterestAccrual."Sum Of Interest Accrual";
                                    ALMLineAdd.MODIFY;
                                UNTIL ALMLineAdd.NEXT = 0;
                            CurrPage.UPDATE;
                        UNTIL AdvancesInterestAccrual.NEXT = 0;
                    //EIR
                    AdvancesEIR.RESET();
                    AdvancesEIR.SETRANGE("Document No.", rec."Document No.");
                    IF AdvancesEIR.FINDSET THEN
                        REPEAT
                            ALMLineAdd2.RESET();
                            ALMLineAdd2.SETRANGE("Document No.", AdvancesEIR."Document No.");
                            ALMLineAdd2.SETFILTER("RBI Code", AdvancesEIR."RBI Code");
                            IF ALMLineAdd2.FINDSET THEN
                                REPEAT
                                    // CLEAR(ALMLines2."Over 5 Years");
                                    ALMLineAdd2."Over 5 Years" += AdvancesEIR."Rev Unmort";
                                    ALMLineAdd2.MODIFY;
                                UNTIL ALMLineAdd2.NEXT = 0;
                            CurrPage.UPDATE;
                        UNTIL AdvancesEIR.NEXT = 0;
                    //ECL
                    AdvancesECL.RESET();
                    AdvancesECL.SETRANGE("Document No.", rec."Document No.");
                    IF AdvancesECL.FINDSET THEN
                        REPEAT
                            ALMLineAdd3.RESET();
                            ALMLineAdd3.SETRANGE("Document No.", AdvancesECL."Document No.");
                            ALMLineAdd3.SETFILTER("RBI Code", AdvancesECL."RBI Code");
                            IF ALMLineAdd3.FINDSET THEN
                                REPEAT
                                    //CLEAR(ALMLines3."Over 5 Years");
                                    ALMLineAdd3."Over 5 Years" += AdvancesECL.ECL;
                                    ALMLineAdd3.MODIFY;
                                UNTIL ALMLineAdd3.NEXT = 0;
                            CurrPage.UPDATE;
                        UNTIL AdvancesECL.NEXT = 0;


                    //CCIT AN 23022023
                    Message('Done...');

                end;
            }
            action("Monthly Schedule")
            {
                ApplicationArea = Basic;
                Enabled = ActionEnable;
                Visible = false;

                trigger OnAction()
                var
                    MonthlySchedule: Report ;
                begin
                    //EVALUATE(FromDate,COPYSTR("Document No.",1,2)+'01'+ COPYSTR("Document No.",3,4)); //Standared Commented by AN 25Jan2023
                    Evaluate(FromDate, '01' + CopyStr(Rec."Document No.", 1, 2) + CopyStr(Rec."Document No.", 3, 4));//Change Date Format
                    FromDate := CalcDate('1M', FromDate);
                    Status := Status::Standard;
                    ActionEnable := false;
                    MonthlySchedule.SetStatus(Status, FromDate, Rec);
                    MonthlySchedule.Run;
                end;
            }
            action("Monthly Schedule NPA NonStandard")
            {
                ApplicationArea = Basic;
                Enabled = ActionEnableNPA;
                Visible = false;

                trigger OnAction()
                var
                    MonthlySchedule: Report UnknownReport50009;
                begin
                    //EVALUATE(FromDate,COPYSTR("Document No.",1,2)+'01'+ COPYSTR("Document No.",3,4)); //Standared Commented by AN 25Jan2023
                    Evaluate(FromDate, '01' + CopyStr(Rec."Document No.", 1, 2) + CopyStr(Rec."Document No.", 3, 4));//Change Date Format
                    FromDate := CalcDate('1M', FromDate);
                    Status := Status::"NPA-Non Standard";
                    ActionEnableNPA := false;
                    MonthlySchedule.SetStatus(Status, FromDate, Rec);
                    MonthlySchedule.Run;
                end;
            }
            action("Monthly Schedule NPA Loss")
            {
                ApplicationArea = Basic;
                Enabled = ActionEnableNPALoss;
                Visible = false;

                trigger OnAction()
                var
                    MonthlySchedule: Report UnknownReport50009;
                begin
                    //EVALUATE(FromDate,COPYSTR("Document No.",1,2)+'01'+ COPYSTR("Document No.",3,4)); //Standared Commented by AN 25Jan2023
                    Evaluate(FromDate, '01' + CopyStr(Rec."Document No.", 1, 2) + CopyStr(Rec."Document No.", 3, 4));//Change Date Format
                    FromDate := CalcDate('1M', FromDate);
                    Status := Status::"NPA-Doubtfull Loss";
                    ActionEnableNPALoss := false;
                    MonthlySchedule.SetStatus(Status, FromDate, Rec);
                    MonthlySchedule.Run;
                end;
            }
            action("Export Data")
            {
                ApplicationArea = Basic;
                Enabled = PageEditable;
                Visible = false;

                trigger OnAction()
                begin
                    ExcelBuffer.DeleteAll;
                    ALMHeader.Reset();
                    ALMHeader.SetRange("Document No.", Rec."Document No.");
                    if ALMHeader.Find('-') then begin
                        CreateHeader;
                        ALMLine.Reset();
                        ALMLine.SetRange("Document No.", ALMHeader."Document No.");
                        if ALMLine.Find('-') then
                            repeat
                                ExcelBuffer.NewRow;
                                ExcelBuffer.AddColumn(ALMLine."RBI Code", false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
                                ExcelBuffer.AddColumn(ALMLine."BS Figure", false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                                ExcelBuffer.AddColumn(ALMLine."1 to 7 days", false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                                ExcelBuffer.AddColumn(ALMLine."8 to 14 days", false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                                ExcelBuffer.AddColumn(ALMLine."15 to 1 Month", false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                                ExcelBuffer.AddColumn(ALMLine."1 Month to 2 Months", false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                                ExcelBuffer.AddColumn(ALMLine."2 Month to 3 Months", false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                                ExcelBuffer.AddColumn(ALMLine."3 Month To 6 Months", false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                                ExcelBuffer.AddColumn(ALMLine."6 Month To 1 Year", false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                                ExcelBuffer.AddColumn(ALMLine."1 Year to 3 Year", false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                                ExcelBuffer.AddColumn(ALMLine."3 year to 5 Years", false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                                ExcelBuffer.AddColumn(ALMLine."Over 5 Years", false, '', false, false, false, '', ExcelBuffer."cell type"::Number);
                            until ALMLine.Next = 0;
                        //vmig               ExcelBuffer.CreateBookAndOpenExcel('D:\CCIT\PURCHASE\ALM.xlsx', 'ALM', '', COMPANYNAME, UserId);
                    end;
                end;
            }
            action("Update ALM")
            {
                ApplicationArea = Basic;
                Enabled = PageEditable;
                Visible = false;

                trigger OnAction()
                begin
                    Xmlport.Run(50012, false, true);
                end;
            }
            action(GETRBI)
            {
                ApplicationArea = Basic;
                Enabled = false;
                Visible = false;

                trigger OnAction()
                var
                    CALCULATE: Codeunit "GLN Calculator";
                begin
                    //CALCULATE.File_RBISumCode(Rec);//ccit_kj_08072022
                end;
            }
            action(Calculate_Source_DateRange)
            {
                ApplicationArea = Basic;
                Enabled = PageEditable;

                trigger OnAction()
                var
                    RBISum2: Record "ALM Lines";
                begin
                    ALMLines1.Reset(); //CCIT_kj_Bucketting
                    ALMLines1.SetRange("Document No.", Rec."Document No.");
                    ALMLines1.SetFilter(Source, '<>%1', '');
                    if ALMLines1.FindSet then
                        repeat
                            if ALMLines1."1Month to 2 Months" <> '' then
                                ALMLines1."1 Month to 2 Months" := Create_SourceDateRange(Rec."Starting Date", Rec."Ending Date", ALMLines1."1Month to 2 Months");

                            if ALMLines1."1to 7 days" <> '' then
                                ALMLines1."1 to 7 days" := Create_SourceDateRange(Rec."Starting Date", Rec."Ending Date", ALMLines1."1to 7 days");

                            if ALMLines1."15to 1 Month" <> '' then
                                ALMLines1."15 to 1 Month" := Create_SourceDateRange(Rec."Starting Date", Rec."Ending Date", ALMLines1."15to 1 Month");

                            if ALMLines1."1Year to 3 Year" <> '' then
                                ALMLines1."1 Year to 3 Year" := Create_SourceDateRange(Rec."Starting Date", Rec."Ending Date", ALMLines1."1Year to 3 Year");

                            if ALMLines1."2Month to 3 Months" <> '' then
                                ALMLines1."2 Month to 3 Months" := Create_SourceDateRange(Rec."Starting Date", Rec."Ending Date", ALMLines1."2Month to 3 Months");

                            if ALMLines1."3Month To 6 Months" <> '' then
                                ALMLines1."3 Month To 6 Months" := Create_SourceDateRange(Rec."Starting Date", Rec."Ending Date", ALMLines1."3Month To 6 Months");

                            if ALMLines1."6Month To 1 Year" <> '' then
                                ALMLines1."6 Month To 1 Year" := Create_SourceDateRange(Rec."Starting Date", Rec."Ending Date", ALMLines1."6Month To 1 Year");

                            if ALMLines1."3year to 5 Years" <> '' then
                                ALMLines1."3 year to 5 Years" := Create_SourceDateRange(Rec."Starting Date", Rec."Ending Date", ALMLines1."3year to 5 Years");

                            if ALMLines1."8to 14 days" <> '' then
                                ALMLines1."8 to 14 days" := Create_SourceDateRange(Rec."Starting Date", Rec."Ending Date", ALMLines1."8to 14 days");

                            if ALMLines1."Over5 Years" <> '' then
                                ALMLines1."Over 5 Years" := Create_SourceDateRange(Rec."Starting Date", Rec."Ending Date", ALMLines1."Over5 Years");

                            ALMLines1.Modify;
                        until ALMLines1.Next = 0;

                    else IF ALMLines.Source_Date_Range = ALMLines.Source_Date_Range::"1 to 7 days" THEN
                        ALMLines."1 to 7 days" := ABS(GLAmount) + ABS(MemorandumAmount)
                    ELSE
                        IF ALMLines.Source_Date_Range = ALMLines.Source_Date_Range::"1 Year to 3 Year" THEN
                            ALMLines."1 Year to 3 Year" := ABS(GLAmount) + ABS(MemorandumAmount)
                        ELSE
                            IF ALMLines.Source_Date_Range = ALMLines.Source_Date_Range::"15 to 1 Month" THEN
                                ALMLines."15 to 1 Month" := ABS(GLAmount) + ABS(MemorandumAmount)
                            ELSE
                                IF ALMLines.Source_Date_Range = ALMLines.Source_Date_Range::"2 Month to 3 Months" THEN
                                    ALMLines."2 Month to 3 Months" := ABS(GLAmount) + ABS(MemorandumAmount)
                                ELSE
                                    IF ALMLines.Source_Date_Range = ALMLines.Source_Date_Range::"3 Month To 6 Months" THEN
                                        ALMLines."3 Month To 6 Months" := ABS(GLAmount) + ABS(MemorandumAmount)
                                    ELSE
                                        IF ALMLines.Source_Date_Range = ALMLines.Source_Date_Range::"3 year to 5 Years" THEN
                                            ALMLines."3 year to 5 Years" := ABS(GLAmount) + ABS(MemorandumAmount)
                                        ELSE
                                            IF ALMLines.Source_Date_Range = ALMLines.Source_Date_Range::"6 Month To 1 Year" THEN
                                                ALMLines."6 Month To 1 Year" := ABS(GLAmount) + ABS(MemorandumAmount)
                                            ELSE
                                                IF ALMLines.Source_Date_Range = ALMLines.Source_Date_Range::"8 to 14 days" THEN
                                                    ALMLines."8 to 14 days" := ABS(GLAmount) + ABS(MemorandumAmount)
                                                ELSE
                                                    IF ALMLines.Source_Date_Range = ALMLines.Source_Date_Range::"Over 5 Years" THEN
                                                        ALMLines."Over 5 Years" := ABS(GLAmount) + ABS(MemorandumAmount);
                    //CCIT_kj-----------

                    // ALMLines1.MODIFY;
                    // UNTIL ALMLines1.NEXT=0;}

                End;

                    action("Import Excel")
            {
                        ApplicationArea = Basic;
                        Enabled = PageEditable;

                trigger OnAction()
                begin
                    Xmlport.Run(50014, false, true);
                end;
            }
            action("BS Figure Calculate")
            {
                ApplicationArea = Basic;
                Enabled = PageEditable;

                trigger OnAction()
                var
                    ALMLine2: Record "ALM Lines";
                    ALMLine3: Record "ALM Lines";
                    newFiterStr: Text;
                    x: Integer;
                    filterVal: Text;
                begin
                    // CCIT AN 29122022 BS Fig if source blank start
                    ALMLine2.Reset();
                    ALMLine2.SetRange("Document No.", Rec."Document No.");
                    ALMLine2.SetFilter(Source, '=%1', '');
                    ALMLine2.SetFilter("RBI Code", '<>%1', '');
                    //ALMLine2.SETFILTER("RBI Code SUM",'<>%1','');
                    if ALMLine2.Find('-') then
                        repeat
                            Clear(BSValue);
                            RBIC := ALMLine2."RBI Code SUM";
                            newFiterStr := ConvertStr(ALMLine2."RBI Code SUM", '|', ',');
                            if not CalcFilteredBSFig(RBIC, newFiterStr, ALMLine2."Document No.") then;
                            //         ALMLine2."BS Figure" := RBIBsfigure;
                            ALMLine2."BS Figure" := BSValue;
                            ALMLine2.Modify;

                        until ALMLine2.Next = 0;
                    Message('Done..');

                    // CCIT AN 29122022 BS Fig if source blank start
                end;
            }
            action("Special RBI Sum")
            {
                ApplicationArea = Basic;
                Enabled = PageEditable;

                trigger OnAction()
                var
                    RBISum2: Record "ALM Lines";
                    ALMLineRec: Record "ALM Lines";
                    RBISum: Record "ALM Lines";
                begin
                    //CCIT AN Special Bucketing Sum  20jan2023
                    RBISum2.Reset;
                    RBISum2.SetRange("Document No.", Rec."Document No.");
                    RBISum2.SetFilter(Source, '=%1', '');
                    RBISum2.SetFilter("RBI Code", '<>%1', '');
                    RBISum2.SetFilter("RBI Code SUM", '<>%1', '');
                    if RBISum2.FindSet then
                        repeat
                            Clear(RBISum2."1 to 7 days");
                            Clear(RBISum2."8 to 14 days");
                            Clear(RBISum2."15 to 1 Month");
                            Clear(RBISum2."1 Month to 2 Months");
                            Clear(RBISum2."2 Month to 3 Months");
                            Clear(RBISum2."3 Month To 6 Months");
                            Clear(RBISum2."6 Month To 1 Year");
                            Clear(RBISum2."1 Year to 3 Year");
                            Clear(RBISum2."3 year to 5 Years");
                            Clear(RBISum2."Over 5 Years");

                            ALMLineRec.Reset();
                            ALMLineRec.SetRange("Document No.", RBISum2."Document No.");
                            ALMLineRec.SetFilter("RBI Code", RBISum2."RBI Code SUM");
                            if ALMLineRec.FindSet then
                                repeat
                                    //MESSAGE('%1', ALMLineRec."RBI Code");
                                    RBISum2."1 to 7 days" += ALMLineRec."1 to 7 days";
                                    RBISum2."8 to 14 days" += ALMLineRec."8 to 14 days";
                                    RBISum2."15 to 1 Month" += ALMLineRec."15 to 1 Month";
                                    RBISum2."1 Month to 2 Months" += ALMLineRec."1 Month to 2 Months";
                                    RBISum2."2 Month to 3 Months" += ALMLineRec."2 Month to 3 Months";
                                    RBISum2."3 Month To 6 Months" += ALMLineRec."3 Month To 6 Months";
                                    RBISum2."6 Month To 1 Year" += ALMLineRec."6 Month To 1 Year";
                                    RBISum2."1 Year to 3 Year" += ALMLineRec."1 Year to 3 Year";
                                    RBISum2."3 year to 5 Years" += ALMLineRec."3 year to 5 Years";
                                    RBISum2."Over 5 Years" += ALMLineRec."Over 5 Years";
                                    RBISum2.Modify;
                                until ALMLineRec.Next = 0;
                        until RBISum2.Next = 0;
                    CurrPage.Update;
                    //CCIT AN Special Bucketing Sum 20jan2023
                end;
            }
            action("RBI Sum Y530")
            {
                ApplicationArea = Basic;
                Enabled = PageEditable;

                trigger OnAction()
                var
                    RBISum2: Record "ALM Lines";
                    ALMLineRec: Record "ALM Lines";
                    RBISum: Record "ALM Lines";
                begin
                    //CCIT AN Bucketing Sum 22 feb 2024
                    RBISum2.Reset;
                    RBISum2.SetRange("Document No.", Rec."Document No.");    //RBISum2.SETFILTER(Source,'=%1','');
                    RBISum2.SetFilter("RBI Code", '=%1', 'Y530');    //RBISum2.SETFILTER("RBI Code SUM",'<>%1','');
                    if RBISum2.FindSet then
                        repeat
                            Clear(RBISum2."1 to 7 days");
                            Clear(RBISum2."8 to 14 days");
                            Clear(RBISum2."15 to 1 Month");
                            Clear(RBISum2."1 Month to 2 Months");
                            Clear(RBISum2."2 Month to 3 Months");
                            Clear(RBISum2."3 Month To 6 Months");
                            Clear(RBISum2."6 Month To 1 Year");
                            Clear(RBISum2."1 Year to 3 Year");
                            Clear(RBISum2."3 year to 5 Years");
                            Clear(RBISum2."Over 5 Years");

                            ALMLineRec.Reset();
                            ALMLineRec.SetRange("Document No.", RBISum2."Document No.");
                            ALMLineRec.SetFilter("RBI Code", RBISum2."RBI Code SUM");
                            if ALMLineRec.FindSet then
                                repeat
                                    RBISum2."1 to 7 days" += ALMLineRec."1 to 7 days";
                                    RBISum2."8 to 14 days" += ALMLineRec."8 to 14 days";
                                    RBISum2."15 to 1 Month" += ALMLineRec."15 to 1 Month";
                                    RBISum2."1 Month to 2 Months" += ALMLineRec."1 Month to 2 Months";
                                    RBISum2."2 Month to 3 Months" += ALMLineRec."2 Month to 3 Months";
                                    RBISum2."3 Month To 6 Months" += ALMLineRec."3 Month To 6 Months";
                                    RBISum2."6 Month To 1 Year" += ALMLineRec."6 Month To 1 Year";
                                    RBISum2."1 Year to 3 Year" += ALMLineRec."1 Year to 3 Year";
                                    RBISum2."3 year to 5 Years" += ALMLineRec."3 year to 5 Years";
                                    RBISum2."Over 5 Years" += ALMLineRec."Over 5 Years";
                                    RBISum2.Modify;
                                until ALMLineRec.Next = 0;
                        until RBISum2.Next = 0;
                    CurrPage.Update;
                    //CCIT AN Bucketing Sum 22feb 2024
                end;
            }
            action("Cumulative Calculates")
            {
                ApplicationArea = Basic;
                Enabled = PageEditable;

                trigger OnAction()
                var
                    ALMLine: Record "ALM Lines";
                    ALMLineRec: Record "ALM Lines";
                    ALMLine2: Record "ALM Lines";
                    ALMLineRec2: Record "ALM Lines";
                    ALMLine3: Record "ALM Lines";
                    ALMLineRec3: Record "ALM Lines";
                    ALMLine4: Record "ALM Lines";
                    ALMLineRec4: Record "ALM Lines";
                    ALMLine5: Record "ALM Lines";
                    ALMLineRec5: Record "ALM Lines";
                begin
                    ALMLine.Reset;
                    ALMLine.SetRange("Document No.", Rec."Document No.");
                    ALMLine.SetFilter(Source, '=%1', '');
                    ALMLine.SetFilter("RBI Code", 'Y1260');  //'<>%1','');
                    ALMLine.SetFilter("RBI Code SUM", '=%1', '');
                    if ALMLine.FindSet then
                        repeat
                            ALMLineRec.Reset();
                            ALMLineRec.SetRange("Document No.", ALMLine."Document No.");
                            ALMLineRec.SetFilter("RBI Code", 'Y1250'); //  RBISum2."RBI Code SUM");
                            if ALMLineRec.FindSet then
                                repeat
                                    ALMLine."1 to 7 days" := ALMLineRec."1 to 7 days";
                                    ALMLine."8 to 14 days" := ALMLineRec."8 to 14 days" + ALMLine."1 to 7 days";
                                    ALMLine."15 to 1 Month" := ALMLineRec."15 to 1 Month" + ALMLine."8 to 14 days";
                                    ALMLine."1 Month to 2 Months" := ALMLineRec."1 Month to 2 Months" + ALMLine."15 to 1 Month";
                                    ALMLine."2 Month to 3 Months" := ALMLineRec."2 Month to 3 Months" + ALMLine."1 Month to 2 Months";
                                    ALMLine."3 Month To 6 Months" := ALMLineRec."3 Month To 6 Months" + ALMLine."2 Month to 3 Months";
                                    ALMLine."6 Month To 1 Year" := ALMLineRec."6 Month To 1 Year" + ALMLine."3 Month To 6 Months";
                                    ALMLine."1 Year to 3 Year" := ALMLineRec."1 Year to 3 Year" + ALMLine."6 Month To 1 Year";
                                    ALMLine."3 year to 5 Years" := ALMLineRec."3 year to 5 Years" + ALMLine."1 Year to 3 Year";
                                    ALMLine."Over 5 Years" := ALMLineRec."Over 5 Years" + ALMLine."3 year to 5 Years";
                                    ALMLine.Modify;
                                until ALMLineRec.Next = 0;
                        until ALMLine.Next = 0;

                    ALMLine2.Reset;
                    ALMLine2.SetRange("Document No.", Rec."Document No.");
                    ALMLine2.SetFilter(Source, '=%1', '');
                    ALMLine2.SetFilter("RBI Code", 'Y1820');  //'<>%1','');
                    ALMLine2.SetFilter("RBI Code SUM", '=%1', '');
                    if ALMLine2.FindSet then
                        repeat
                            ALMLineRec2.Reset();
                            ALMLineRec2.SetRange("Document No.", ALMLine2."Document No.");
                            ALMLineRec2.SetFilter("RBI Code", 'Y1810'); //  RBISum2."RBI Code SUM");
                            if ALMLineRec2.FindSet then
                                repeat
                                    ALMLine2."1 to 7 days" := ALMLineRec2."1 to 7 days" - ALMLineRec."1 to 7 days";
                                    ALMLine2."8 to 14 days" := ALMLineRec2."8 to 14 days" - ALMLineRec."8 to 14 days";
                                    ALMLine2."15 to 1 Month" := ALMLineRec2."15 to 1 Month" - ALMLineRec."15 to 1 Month";
                                    ALMLine2."1 Month to 2 Months" := ALMLineRec2."1 Month to 2 Months" - ALMLineRec."1 Month to 2 Months";
                                    ALMLine2."2 Month to 3 Months" := ALMLineRec2."2 Month to 3 Months" - ALMLineRec."2 Month to 3 Months";
                                    ALMLine2."3 Month To 6 Months" := ALMLineRec2."3 Month To 6 Months" - ALMLineRec."3 Month To 6 Months";
                                    ALMLine2."6 Month To 1 Year" := ALMLineRec2."6 Month To 1 Year" - ALMLineRec."6 Month To 1 Year";
                                    ALMLine2."1 Year to 3 Year" := ALMLineRec2."1 Year to 3 Year" - ALMLineRec."1 Year to 3 Year";
                                    ALMLine2."3 year to 5 Years" := ALMLineRec2."3 year to 5 Years" - ALMLineRec."3 year to 5 Years";
                                    ALMLine2."Over 5 Years" := ALMLineRec2."Over 5 Years" - ALMLineRec."Over 5 Years";
                                    ALMLine2.Modify;
                                until ALMLineRec2.Next = 0;
                        until ALMLine2.Next = 0;

                    ALMLine3.Reset;
                    ALMLine3.SetRange("Document No.", Rec."Document No.");
                    ALMLine3.SetFilter(Source, '=%1', '');
                    ALMLine3.SetFilter("RBI Code", 'Y1830');  //'<>%1','');
                    ALMLine3.SetFilter("RBI Code SUM", '=%1', '');
                    if ALMLine3.FindSet then
                        repeat
                            ALMLineRec3.Reset();
                            ALMLineRec3.SetRange("Document No.", ALMLine3."Document No.");
                            ALMLineRec3.SetFilter("RBI Code", 'Y1820'); //  RBISum2."RBI Code SUM");
                            if ALMLineRec3.FindSet then
                                repeat
                                    ALMLine3."1 to 7 days" := ALMLineRec3."1 to 7 days";
                                    ALMLine3."8 to 14 days" := ALMLineRec3."8 to 14 days" + ALMLine3."1 to 7 days";
                                    ALMLine3."15 to 1 Month" := ALMLineRec3."15 to 1 Month" + ALMLine3."8 to 14 days";
                                    ALMLine3."1 Month to 2 Months" := ALMLineRec3."1 Month to 2 Months" + ALMLine3."15 to 1 Month";
                                    ALMLine3."2 Month to 3 Months" := ALMLineRec3."2 Month to 3 Months" + ALMLine3."1 Month to 2 Months";
                                    ALMLine3."3 Month To 6 Months" := ALMLineRec3."3 Month To 6 Months" + ALMLine3."2 Month to 3 Months";
                                    ALMLine3."6 Month To 1 Year" := ALMLineRec3."6 Month To 1 Year" + ALMLine3."3 Month To 6 Months";
                                    ALMLine3."1 Year to 3 Year" := ALMLineRec3."1 Year to 3 Year" + ALMLine3."6 Month To 1 Year";
                                    ALMLine3."3 year to 5 Years" := ALMLineRec3."3 year to 5 Years" + ALMLine3."1 Year to 3 Year";
                                    ALMLine3."Over 5 Years" := ALMLineRec3."Over 5 Years" + ALMLine3."3 year to 5 Years";
                                    ALMLine3.Modify;
                                until ALMLineRec3.Next = 0;
                        until ALMLine3.Next = 0;

                    ALMLine4.Reset;
                    ALMLine4.SetRange("Document No.", Rec."Document No.");
                    ALMLine4.SetFilter(Source, '=%1', '');
                    ALMLine4.SetFilter("RBI Code", 'Y1840');  //'<>%1','');
                    ALMLine4.SetFilter("RBI Code SUM", '=%1', '');
                    if ALMLine4.FindSet then
                        repeat
                            ALMLineRec4.Reset();
                            ALMLineRec4.SetRange("Document No.", ALMLine4."Document No.");
                            ALMLineRec4.SetFilter("RBI Code", 'Y1820'); //  RBISum2."RBI Code SUM");
                            if ALMLineRec4.FindSet then
                                repeat
                                    IF ALMLine."1 to 7 days" > 0 THEN
                                        ALMLine4."1 to 7 days" := ROUND((ALMLineRec4."1 to 7 days" / ALMLineRec."1 to 7 days") * 100);
                                    IF ALMLine."8 to 14 days" > 0 THEN
                                        ALMLine4."8 to 14 days" := ROUND((ALMLineRec4."8 to 14 days" / ALMLineRec."8 to 14 days") * 100);
                                    IF ALMLine."15 to 1 Month" > 0 THEN
                                        ALMLine4."15 to 1 Month" := ROUND((ALMLineRec4."15 to 1 Month" / ALMLineRec."15 to 1 Month") * 100);
                                    IF ALMLine."1 Month to 2 Months" > 0 THEN
                                        ALMLine4."1 Month to 2 Months" := ROUND((ALMLineRec4."1 Month to 2 Months" / ALMLineRec."1 Month to 2 Months") * 100);
                                    IF ALMLine."2 Month to 3 Months" > 0 THEN
                                        ALMLine4."2 Month to 3 Months" := ROUND((ALMLineRec4."2 Month to 3 Months" / ALMLineRec."2 Month to 3 Months") * 100);
                                    IF ALMLine."3 Month To 6 Months" > 0 THEN
                                        ALMLine4."3 Month To 6 Months" := ROUND((ALMLineRec4."3 Month To 6 Months" / ALMLineRec."3 Month To 6 Months") * 100);
                                    IF ALMLine."6 Month To 1 Year" > 0 THEN
                                        ALMLine4."6 Month To 1 Year" := ROUND((ALMLineRec4."6 Month To 1 Year" / ALMLineRec."6 Month To 1 Year") * 100);
                                    IF ALMLine."1 Year to 3 Year" > 0 THEN
                                        ALMLine4."1 Year to 3 Year" := ROUND((ALMLineRec4."1 Year to 3 Year" / ALMLineRec."1 Year to 3 Year") * 100);
                                    IF ALMLine."3 year to 5 Years" > 0 THEN
                                        ALMLine4."3 year to 5 Years" := ROUND((ALMLineRec4."3 year to 5 Years" / ALMLineRec."3 year to 5 Years") * 100);
                                    IF ALMLine."Over 5 Years" > 0 THEN
                                        ALMLine4."Over 5 Years" := ROUND((ALMLineRec4."Over 5 Years" / ALMLineRec."Over 5 Years") * 100);
                                    if ALMLineRec."1 to 7 days" > 0 then
                                        ALMLine4."1 to 7 days" := ROUND((ALMLineRec4."1 to 7 days" / ALMLineRec."1 to 7 days") * 100);
                                    if ALMLineRec."8 to 14 days" > 0 then
                                        ALMLine4."8 to 14 days" := ROUND((ALMLineRec4."8 to 14 days" / ALMLineRec."8 to 14 days") * 100);
                                    if ALMLineRec."15 to 1 Month" > 0 then
                                        ALMLine4."15 to 1 Month" := ROUND((ALMLineRec4."15 to 1 Month" / ALMLineRec."15 to 1 Month") * 100);
                                    if ALMLineRec."1 Month to 2 Months" > 0 then
                                        ALMLine4."1 Month to 2 Months" := ROUND((ALMLineRec4."1 Month to 2 Months" / ALMLineRec."1 Month to 2 Months") * 100);
                                    if ALMLineRec."2 Month to 3 Months" > 0 then
                                        ALMLine4."2 Month to 3 Months" := ROUND((ALMLineRec4."2 Month to 3 Months" / ALMLineRec."2 Month to 3 Months") * 100);
                                    if ALMLineRec."3 Month To 6 Months" > 0 then
                                        ALMLine4."3 Month To 6 Months" := ROUND((ALMLineRec4."3 Month To 6 Months" / ALMLineRec."3 Month To 6 Months") * 100);
                                    if ALMLineRec."6 Month To 1 Year" > 0 then
                                        ALMLine4."6 Month To 1 Year" := ROUND((ALMLineRec4."6 Month To 1 Year" / ALMLineRec."6 Month To 1 Year") * 100);
                                    if ALMLineRec."1 Year to 3 Year" > 0 then
                                        ALMLine4."1 Year to 3 Year" := ROUND((ALMLineRec4."1 Year to 3 Year" / ALMLineRec."1 Year to 3 Year") * 100);
                                    if ALMLineRec."3 year to 5 Years" > 0 then
                                        ALMLine4."3 year to 5 Years" := ROUND((ALMLineRec4."3 year to 5 Years" / ALMLineRec."3 year to 5 Years") * 100);
                                    if ALMLineRec."Over 5 Years" > 0 then
                                        ALMLine4."Over 5 Years" := ROUND((ALMLineRec4."Over 5 Years" / ALMLineRec."Over 5 Years") * 100);
                                    ALMLine4.Modify;
                                until ALMLineRec4.Next = 0;
                        until ALMLine4.Next = 0;

                    ALMLine5.Reset;
                    ALMLine5.SetRange("Document No.", Rec."Document No.");
                    ALMLine5.SetFilter(Source, '=%1', '');
                    ALMLine5.SetFilter("RBI Code", 'Y1850');
                    ALMLine5.SetFilter("RBI Code SUM", '=%1', '');
                    if ALMLine5.FindSet then
                        repeat
                            ALMLineRec5.Reset();
                            ALMLineRec5.SetRange("Document No.", ALMLine5."Document No.");
                            ALMLineRec5.SetFilter("RBI Code", 'Y1830');
                            if ALMLineRec5.FindSet then
                                repeat
                                    if ALMLine."1 to 7 days" > 0 then
                                        ALMLine5."1 to 7 days" := ROUND((ALMLineRec5."1 to 7 days" / ALMLine."1 to 7 days") * 100);
                                    if ALMLine."8 to 14 days" > 0 then
                                        ALMLine5."8 to 14 days" := ROUND((ALMLineRec5."8 to 14 days" / ALMLine."8 to 14 days") * 100);
                                    if ALMLine."15 to 1 Month" > 0 then
                                        ALMLine5."15 to 1 Month" := ROUND((ALMLineRec5."15 to 1 Month" / ALMLine."15 to 1 Month") * 100);
                                    if ALMLine."1 Month to 2 Months" > 0 then
                                        ALMLine5."1 Month to 2 Months" := ROUND((ALMLineRec5."1 Month to 2 Months" / ALMLine."1 Month to 2 Months") * 100);
                                    if ALMLine."2 Month to 3 Months" > 0 then
                                        ALMLine5."2 Month to 3 Months" := ROUND((ALMLineRec5."2 Month to 3 Months" / ALMLine."2 Month to 3 Months") * 100);
                                    if ALMLine."3 Month To 6 Months" > 0 then
                                        ALMLine5."3 Month To 6 Months" := ROUND((ALMLineRec5."3 Month To 6 Months" / ALMLine."3 Month To 6 Months") * 100);
                                    if ALMLine."6 Month To 1 Year" > 0 then
                                        ALMLine5."6 Month To 1 Year" := ROUND((ALMLineRec5."6 Month To 1 Year" / ALMLine."6 Month To 1 Year") * 100);
                                    if ALMLine."1 Year to 3 Year" > 0 then
                                        ALMLine5."1 Year to 3 Year" := ROUND((ALMLineRec5."1 Year to 3 Year" / ALMLine."1 Year to 3 Year") * 100);
                                    if ALMLine."3 year to 5 Years" > 0 then
                                        ALMLine5."3 year to 5 Years" := ROUND((ALMLineRec5."3 year to 5 Years" / ALMLine."3 year to 5 Years") * 100);
                                    if ALMLine."Over 5 Years" > 0 then
                                        ALMLine5."Over 5 Years" := ROUND((ALMLineRec5."Over 5 Years" / ALMLine."Over 5 Years") * 100);
                                    ALMLine5.Modify;
                                until ALMLineRec5.Next = 0;
                        until ALMLine5.Next = 0;

                    CurrPage.Update;
                    //CCIT AN Cumulative Bucketing Sum 03102023

                end;
            }
            group(Additioal)
            {
                Caption = 'Additioal';
                action("Add Adv. Int. Accrual")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnAction()
                    var
                        ALMLines1: Record "ALM Lines";
                    begin
                        AdvancesInterestAccrual.Reset();
                        AdvancesInterestAccrual.SetRange("Document No.", REc."Document No.");
                        if AdvancesInterestAccrual.FindSet then
                            repeat
                                ALMLines1.Reset();
                                ALMLines1.SetRange("Document No.", AdvancesInterestAccrual."Document No.");
                                ALMLines1.SetFilter("RBI Code", AdvancesInterestAccrual."RBI Code");
                                if ALMLines1.FindSet then
                                    repeat
                                        //CLEAR(ALMLines1."Over 5 Years");
                                        ALMLines1."Over 5 Years" += AdvancesInterestAccrual."Sum Of Interest Accrual";
                                        ALMLines1.Modify;
                                    until ALMLines1.Next = 0;
                                CurrPage.Update;
                            until AdvancesInterestAccrual.Next = 0;
                    end;
                }
                separator(Action1000000026)
                {
                }
                action("Add Adv. EIR")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnAction()
                    var
                        ALMLines2: Record "ALM Lines";
                    begin
                        AdvancesEIR.Reset();
                        AdvancesEIR.SetRange("Document No.", Rec."Document No.");
                        if AdvancesEIR.FindSet then
                            repeat
                                ALMLines2.Reset();
                                ALMLines2.SetRange("Document No.", AdvancesEIR."Document No.");
                                ALMLines2.SetFilter("RBI Code", AdvancesEIR."RBI Code");
                                if ALMLines2.FindSet then
                                    repeat
                                        //CLEAR(ALMLines2."Over 5 Years");
                                        ALMLines2."Over 5 Years" += AdvancesEIR."Rev Unmort";
                                        ALMLines2.Modify;
                                    until ALMLines2.Next = 0;
                                CurrPage.Update;
                            until AdvancesEIR.Next = 0;
                    end;
                }
                separator(Action1000000027)
                {
                }
                action("Add Adv. ECL")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnAction()
                    var
                        ALMLines3: Record "ALM Lines";
                    begin
                        AdvancesECL.Reset();
                        AdvancesECL.SetRange("Document No.", Rec."Document No.");
                        if AdvancesECL.FindSet then
                            repeat
                                ALMLines3.Reset();
                                ALMLines3.SetRange("Document No.", AdvancesECL."Document No.");
                                ALMLines3.SetFilter("RBI Code", AdvancesECL."RBI Code");
                                if ALMLines3.FindSet then
                                    repeat
                                        //CLEAR(ALMLines3."Over 5 Years");
                                        ALMLines3."Over 5 Years" += AdvancesECL.ECL;
                                        ALMLines3.Modify;
                                    until ALMLines3.Next = 0;
                                CurrPage.Update;
                            until AdvancesECL.Next = 0;
                    end;
                }
            }
            group("<Action58>")
            {
                Caption = 'Request Approval';
                Image = "Action";
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Enabled = OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category9;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.CheckALMApprovalsWorkflowEnabled(Rec) then
                            ApprovalsMgmt.OnSendALMForApproval(Rec);

                        ApprovalEntry.Reset();
                        ApprovalEntry.SetRange("Document No.", Rec."Document No.");
                        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                        ApprovalEntry.SetRange("Related to Change", false);
                        if ApprovalEntry.FindFirst then begin
                            OpenApprovalEntriesExist := false;
                            Rec."Lock ALM Sheet" := true;
                            CurrPage.Update;
                        end
                        else
                            OpenApprovalEntriesExist := true;
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category9;
                    Visible = false;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OnCancelALMApprovalRequest(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        //CCIT AN 03012023

        if Rec."Lock ALM Sheet" = true then begin
            PageEditable := false;
            LockEnable := false; //22022024
        end;
        //CCIT AN 03012023
    end;

    trigger OnOpenPage()
    begin
        //CCIT AN 03012023
        PageEditable := true;
        LockEnable := true;

        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", Rec."Document No.");
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SetRange("Related to Change", false);
        if ApprovalEntry.FindFirst then begin
            OpenApprovalEntriesExist := false;
            Rec."Lock ALM Sheet" := true;
            CurrPage.Update;
        end
        else
            OpenApprovalEntriesExist := true;
        // IF "LOCK ALM SHEET" = TRUE THEN
        //  BEGIN
        //    PAGEEDITABLE := FALSE;
        //    ACTIONENABLE := FALSE;
        //    ACTIONENABLENPA := FALSE;
        //    ACTIONENABLENPALOSS := FALSE;
        //    LOCKENABLE := FALSE;
        //  END;
    end;

    var
        MemorandomEntry: Record "Memorandom Entry";
        GLAmount: Decimal;
        MemorandumAmount: Decimal;
        SourceCode: Code[250];
        CALM: Codeunit 1607;
        Status: Option " ",Standard,"NPA-Non Standard","NPA-Doubtfull Loss";
        FromDate: Date;
        ALMHeader: Record "ALM Header";
        ALMLine: Record "ALM Lines";
        ExcelBuffer: Record "Excel Buffer";
        ALMSequence: Record "ALM Sequence";
        ALMLines1: Record "ALM Lines";
        SourceCode1: Code[250];
        MemorandomEntry1: Record "Memorandom Entry";
        GLAmount1: Decimal;
        MemorandumAmount1: Decimal;
        GLEntry1: Record "G/L Entry";
        ALMLineRec: Record "ALM Lines";
        RBIBsfigure: Decimal;
        RBIC: Code[250];
        BSValue: Decimal;
        PageEditable: Boolean;
        AdvancesInterestAccrual: Record "Advances Interest Accrual";
        AdvancesEIR: Record "Advances EIR";
        AdvancesECL: Record "Advances ECL";
        ALMLineAdd: Record "ALM Lines";
        ALMLineAdd2: Record "ALM Lines";
        ALMLineAdd3: Record "ALM Lines";
        ActionEnable: Boolean;
        ActionEnableNPA: Boolean;
        ActionEnableNPALoss: Boolean;
        LockEnable: Boolean;
        OpenApprovalEntriesExist: Boolean;
        OpenApprovalEntriesExist2: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        ApprovalEntry: Record "Approval Entry";

    local procedure CreateHeader()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('RBI Code', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('BS Figure', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('1 to 7 days', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('8 to 14 days', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('15 to 1 Month', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('1 Month to 2 Months', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('2 Month to 3 Months', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('3 Month To 6 Months', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('6 Month To 1 Year', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('1 Year to 3 Year', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('3 year to 5 Years', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
        ExcelBuffer.AddColumn('Over 5 Years', false, '', false, false, false, '', ExcelBuffer."cell type"::Text);
    end;

    local procedure Create_SourceDateRange(StartingDate: Date; EndingDate: Date; GLFilter: Text[250]): Decimal
    var
        ALMLines1: Record "ALM Lines";
        SourceCode1: Code[250];
        MemorandomEntry1: Record "Memorandom Entry";
        GLAmount1: Decimal;
        MemorandumAmount1: Decimal;
        GLEntry1: Record "G/L Entry";
    begin
        Clear(MemorandumAmount1);
        Clear(GLAmount1);
        GLEntry1.Reset();
        GLEntry1.SetCurrentkey("G/L Account No.", "Posting Date");
        GLEntry1.SetFilter("G/L Account No.", GLFilter);
        GLEntry1.SetRange("Posting Date", StartingDate, EndingDate);
        if GLEntry1.FindSet then
            repeat
                GLAmount1 := GLAmount1 + GLEntry1.Amount;

            until GLEntry1.Next = 0;

        MemorandomEntry1.Reset();
        MemorandomEntry1.SetCurrentkey("G/L Account No.", "Posting Date");
        MemorandomEntry1.SetFilter("G/L Account No.", GLFilter);
        MemorandomEntry1.SetRange("Posting Date", StartingDate, EndingDate);
        MemorandomEntry1.SetRange(Posted, true);
        if MemorandomEntry1.FindSet then
            repeat
                MemorandumAmount1 := MemorandumAmount1 + MemorandomEntry1.Amount;
            until MemorandomEntry1.Next = 0;


        exit(Abs(GLAmount1 + MemorandumAmount1));  // EXIT(ABS(GLAmount1) +ABS(MemorandumAmount1));  ABS(GLAmount + MemorandumAmount);
    end;

    [TryFunction]
    local procedure CalcFilteredBSFig(RBIC: Text; newFiterStr: Text; docuNum: Code[50])
    var
        x: Integer;
        ALMLine3: Record "ALM Lines";
        filterVal: Text;
    begin
        x := 1;
        while x <= StrLen(RBIC) do begin
            filterVal := SelectStr(x, newFiterStr);

            //CLEAR(BSValue);

            ALMLine3.Reset();
            ALMLine3.SetRange("Document No.", docuNum);
            ALMLine3.SetFilter("RBI Code", '=%1', filterVal);
            if ALMLine3.Find('-') then
                repeat
                    BSValue += ALMLine3."BS Figure";
                until ALMLine3.Next = 0;
            x += 1
        end;
    end;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        //OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
        //OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
        //MESSAGE('%1',OpenApprovalEntriesExist);
    end;
}
*/

