Page 50131 "G/L TDS"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "G/l Tds Nature Of Deduction";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("G/L account No"; Rec."G/L account No")
                {
                    ApplicationArea = Basic;
                }
                field("TDS NOD"; Rec."TDS NOD")
                {
                    ApplicationArea = Basic;
                }
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = Basic;
                }
                field("G/L account Name"; Rec."G/L Account Nmae")
                {
                    ApplicationArea = Basic;
                    Caption = 'G/L Account Name';
                }
            }
        }
    }


}

