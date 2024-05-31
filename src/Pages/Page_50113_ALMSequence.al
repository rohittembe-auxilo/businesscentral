Page 50113 "ALM Sequence"
{
    PageType = List;
    SourceTable = "ALM Sequence";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Seq. No."; Rec."Seq. No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = Basic;
                }
                field("RBI Code"; Rec."RBI Code")
                {
                    ApplicationArea = Basic;
                }
                field("RBI Code SUM"; Rec."RBI Code SUM")
                {
                    ApplicationArea = Basic;
                }
                field(Source_Date_Range; Rec.Source_Date_Range)
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
            }
        }
    }

    actions
    {
    }
}

