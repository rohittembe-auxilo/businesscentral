Page 50112 "ALM Subpage"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "ALM Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("RBI Code"; Rec."RBI Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("RBI Code SUM"; Rec."RBI Code SUM")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Desc; Rec.Desc)
                {
                    ApplicationArea = Basic;
                }
                field("BS Figure"; Rec."BS Figure")
                {
                    ApplicationArea = Basic;
                }
                field("1 to 7 days"; Rec."1 to 7 days")
                {
                    ApplicationArea = Basic;
                }
                field("8 to 14 days"; Rec."8 to 14 days")
                {
                    ApplicationArea = Basic;
                }
                field("15 to 1 Month"; Rec."15 to 1 Month")
                {
                    ApplicationArea = Basic;
                }
                field("1 Month to 2 Months"; Rec."1 Month to 2 Months")
                {
                    ApplicationArea = Basic;
                }
                field("2 Month to 3 Months"; Rec."2 Month to 3 Months")
                {
                    ApplicationArea = Basic;
                }
                field("3 Month To 6 Months"; Rec."3 Month To 6 Months")
                {
                    ApplicationArea = Basic;
                }
                field("6 Month To 1 Year"; Rec."6 Month To 1 Year")
                {
                    ApplicationArea = Basic;
                }
                field("1 Year to 3 Year"; Rec."1 Year to 3 Year")
                {
                    ApplicationArea = Basic;
                }
                field("3 year to 5 Years"; Rec."3 year to 5 Years")
                {
                    ApplicationArea = Basic;
                }
                field("Over 5 Years"; Rec."Over 5 Years")
                {
                    ApplicationArea = Basic;
                }
                field(Difference; Rec.Difference)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //CCIT AN ++
        Clear(Rec.Difference);
        Clear(Total);

        ALMLines.Reset();
        ALMLines.SetRange("Document No.", Rec."Document No.");
        ALMLines.SetRange("Line No.", Rec."Line No.");
        ALMLines.SetRange(Source, Rec.Source);
        //ALMLines.SETFILTER(Source,'<>%1','');
        if ALMLines.Find('-') then begin
            Total := ALMLines."1 to 7 days" + ALMLines."8 to 14 days" + ALMLines."15 to 1 Month" + ALMLines."1 Month to 2 Months" + ALMLines."2 Month to 3 Months"
                     + ALMLines."3 Month To 6 Months" + ALMLines."6 Month To 1 Year" + ALMLines."1 Year to 3 Year" + ALMLines."3 year to 5 Years" + ALMLines."Over 5 Years";
        end;

        Rec.Difference := Total - Rec."BS Figure";
        //CCIT AN --
        //CCIT AN 03012023 Covert into thousand lakhs n crore
        ALMHeader.Reset();
        ALMHeader.SetRange("Document No.", Rec."Document No.");
        if ALMHeader.FindSet then
            repeat
                if ALMHeader."Lac/Cr. ALM Sheet" = ALMHeader."lac/cr. alm sheet"::Hundred then begin
                    if Rec."BS Figure" = 0 then
                        Rec."BS Figure" := 0
                    else
                        Rec."BS Figure" := Rec."BS Figure" / 100;

                    if Rec."1 to 7 days" = 0 then
                        Rec."1 to 7 days" := 0
                    else
                        Rec."1 to 7 days" := Rec."1 to 7 days" / 100;

                    if Rec."8 to 14 days" = 0 then
                        Rec."8 to 14 days" := 0
                    else
                        Rec."8 to 14 days" := Rec."8 to 14 days" / 100;

                    if Rec."15 to 1 Month" = 0 then
                        Rec."15 to 1 Month" := 0
                    else
                        Rec."15 to 1 Month" := Rec."15 to 1 Month" / 100;

                    if Rec."1 Month to 2 Months" = 0 then
                        Rec."1 Month to 2 Months" := 0
                    else
                        Rec."1 Month to 2 Months" := Rec."1 Month to 2 Months" / 100;

                    if Rec."2 Month to 3 Months" = 0 then
                        Rec."2 Month to 3 Months" := 0
                    else
                        Rec."2 Month to 3 Months" := Rec."2 Month to 3 Months" / 100;

                    if Rec."3 Month To 6 Months" = 0 then
                        Rec."3 Month To 6 Months" := 0
                    else
                        Rec."3 Month To 6 Months" := Rec."3 Month To 6 Months" / 100;

                    if Rec."6 Month To 1 Year" = 0 then
                        Rec."6 Month To 1 Year" := 0
                    else
                        Rec."6 Month To 1 Year" := Rec."6 Month To 1 Year" / 100;

                    if Rec."1 Year to 3 Year" = 0 then
                        Rec."1 Year to 3 Year" := 0
                    else
                        Rec."1 Year to 3 Year" := Rec."1 Year to 3 Year" / 100;

                    if Rec."3 year to 5 Years" = 0 then
                        Rec."3 year to 5 Years" := 0
                    else
                        Rec."3 year to 5 Years" := Rec."3 year to 5 Years" / 100;

                    if Rec."Over 5 Years" = 0 then
                        Rec."Over 5 Years" := 0
                    else
                        Rec."Over 5 Years" := Rec."Over 5 Years" / 100;

                    if Rec.Difference = 0 then
                        Rec.Difference := 0
                    else
                        Rec.Difference := Rec.Difference / 100;
                end;

                if ALMHeader."Lac/Cr. ALM Sheet" = ALMHeader."lac/cr. alm sheet"::Thousand then begin
                    if Rec."BS Figure" = 0 then
                        Rec."BS Figure" := 0
                    else
                        Rec."BS Figure" := Rec."BS Figure" / 1000;

                    if Rec."1 to 7 days" = 0 then
                        Rec."1 to 7 days" := 0
                    else
                        Rec."1 to 7 days" := Rec."1 to 7 days" / 1000;

                    if Rec."8 to 14 days" = 0 then
                        Rec."8 to 14 days" := 0
                    else
                        Rec."8 to 14 days" := Rec."8 to 14 days" / 1000;

                    if Rec."15 to 1 Month" = 0 then
                        Rec."15 to 1 Month" := 0
                    else
                        Rec."15 to 1 Month" := Rec."15 to 1 Month" / 1000;

                    if Rec."1 Month to 2 Months" = 0 then
                        Rec."1 Month to 2 Months" := 0
                    else
                        Rec."1 Month to 2 Months" := Rec."1 Month to 2 Months" / 1000;

                    if Rec."2 Month to 3 Months" = 0 then
                        Rec."2 Month to 3 Months" := 0
                    else
                        Rec."2 Month to 3 Months" := Rec."2 Month to 3 Months" / 1000;

                    if Rec."3 Month To 6 Months" = 0 then
                        Rec."3 Month To 6 Months" := 0
                    else
                        Rec."3 Month To 6 Months" := Rec."3 Month To 6 Months" / 1000;

                    if Rec."6 Month To 1 Year" = 0 then
                        Rec."6 Month To 1 Year" := 0
                    else
                        Rec."6 Month To 1 Year" := Rec."6 Month To 1 Year" / 1000;

                    if Rec."1 Year to 3 Year" = 0 then
                        Rec."1 Year to 3 Year" := 0
                    else
                        Rec."1 Year to 3 Year" := Rec."1 Year to 3 Year" / 1000;

                    if Rec."3 year to 5 Years" = 0 then
                        Rec."3 year to 5 Years" := 0
                    else
                        Rec."3 year to 5 Years" := Rec."3 year to 5 Years" / 1000;

                    if Rec."Over 5 Years" = 0 then
                        Rec."Over 5 Years" := 0
                    else
                        Rec."Over 5 Years" := Rec."Over 5 Years" / 1000;

                    if Rec.Difference = 0 then
                        Rec.Difference := 0
                    else
                        Rec.Difference := Rec.Difference / 1000;

                end;

                if ALMHeader."Lac/Cr. ALM Sheet" = ALMHeader."lac/cr. alm sheet"::Lakhs then begin
                    if Rec."BS Figure" = 0 then
                        Rec."BS Figure" := 0
                    else
                        Rec."BS Figure" := Rec."BS Figure" / 100000;

                    if Rec."1 to 7 days" = 0 then
                        Rec."1 to 7 days" := 0
                    else
                        Rec."1 to 7 days" := Rec."1 to 7 days" / 100000;

                    if Rec."8 to 14 days" = 0 then
                        Rec."8 to 14 days" := 0
                    else
                        Rec."8 to 14 days" := Rec."8 to 14 days" / 100000;

                    if Rec."15 to 1 Month" = 0 then
                        Rec."15 to 1 Month" := 0
                    else
                        Rec."15 to 1 Month" := Rec."15 to 1 Month" / 100000;

                    if Rec."1 Month to 2 Months" = 0 then
                        Rec."1 Month to 2 Months" := 0
                    else
                        Rec."1 Month to 2 Months" := Rec."1 Month to 2 Months" / 100000;

                    if Rec."2 Month to 3 Months" = 0 then
                        Rec."2 Month to 3 Months" := 0
                    else
                        Rec."2 Month to 3 Months" := Rec."2 Month to 3 Months" / 100000;

                    if Rec."3 Month To 6 Months" = 0 then
                        Rec."3 Month To 6 Months" := 0
                    else
                        Rec."3 Month To 6 Months" := Rec."3 Month To 6 Months" / 100000;

                    if Rec."6 Month To 1 Year" = 0 then
                        Rec."6 Month To 1 Year" := 0
                    else
                        Rec."6 Month To 1 Year" := Rec."6 Month To 1 Year" / 100000;

                    if Rec."1 Year to 3 Year" = 0 then
                        Rec."1 Year to 3 Year" := 0
                    else
                        Rec."1 Year to 3 Year" := Rec."1 Year to 3 Year" / 100000;

                    if Rec."3 year to 5 Years" = 0 then
                        Rec."3 year to 5 Years" := 0
                    else
                        Rec."3 year to 5 Years" := Rec."3 year to 5 Years" / 100000;

                    if Rec."Over 5 Years" = 0 then
                        Rec."Over 5 Years" := 0
                    else
                        Rec."Over 5 Years" := Rec."Over 5 Years" / 100000;

                    if Rec.Difference = 0 then
                        Rec.Difference := 0
                    else
                        Rec.Difference := Rec.Difference / 100000;
                end;

                if ALMHeader."Lac/Cr. ALM Sheet" = ALMHeader."lac/cr. alm sheet"::Crore then begin
                    if Rec."BS Figure" = 0 then
                        Rec."BS Figure" := 0
                    else
                        Rec."BS Figure" := Rec."BS Figure" / 10000000;

                    if Rec."1 to 7 days" = 0 then
                        Rec."1 to 7 days" := 0
                    else
                        Rec."1 to 7 days" := Rec."1 to 7 days" / 10000000;

                    if Rec."8 to 14 days" = 0 then
                        Rec."8 to 14 days" := 0
                    else
                        Rec."8 to 14 days" := Rec."8 to 14 days" / 10000000;

                    if Rec."15 to 1 Month" = 0 then
                        Rec."15 to 1 Month" := 0
                    else
                        Rec."15 to 1 Month" := Rec."15 to 1 Month" / 10000000;

                    if Rec."1 Month to 2 Months" = 0 then
                        Rec."1 Month to 2 Months" := 0
                    else
                        rec."1 Month to 2 Months" := Rec."1 Month to 2 Months" / 10000000;

                    if Rec."2 Month to 3 Months" = 0 then
                        Rec."2 Month to 3 Months" := 0
                    else
                        Rec."2 Month to 3 Months" := Rec."2 Month to 3 Months" / 10000000;

                    if Rec."3 Month To 6 Months" = 0 then
                        Rec."3 Month To 6 Months" := 0
                    else
                        Rec."3 Month To 6 Months" := Rec."3 Month To 6 Months" / 10000000;

                    if Rec."6 Month To 1 Year" = 0 then
                        Rec."6 Month To 1 Year" := 0
                    else
                        Rec."6 Month To 1 Year" := Rec."6 Month To 1 Year" / 10000000;

                    if Rec."1 Year to 3 Year" = 0 then
                        Rec."1 Year to 3 Year" := 0
                    else
                        Rec."1 Year to 3 Year" := Rec."1 Year to 3 Year" / 10000000;

                    if Rec."3 year to 5 Years" = 0 then
                        Rec."3 year to 5 Years" := 0
                    else
                        Rec."3 year to 5 Years" := Rec."3 year to 5 Years" / 10000000;

                    if Rec."Over 5 Years" = 0 then
                        Rec."Over 5 Years" := 0
                    else
                        Rec."Over 5 Years" := Rec."Over 5 Years" / 10000000;

                    if Rec.Difference = 0 then
                        Rec.Difference := 0
                    else
                        Rec.Difference := Rec.Difference / 10000000;
                end;

            until ALMHeader.Next = 0;
        //CCIT AN 03012023 Covert into thousand lakhs n crore
    end;

    var
        ALMLines: Record "ALM Lines";
        SourceCode: Code[250];
        MemorandumAmount: Decimal;
        GLAmount: Decimal;
        GLEntry: Record "G/L Entry";
        Total: Decimal;
        ALMHeader: Record "ALM Header";
}

