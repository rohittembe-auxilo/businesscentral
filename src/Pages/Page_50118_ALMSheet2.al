Page 50118 "ALM Sheet2"
{
    PageType = List;
    SourceTable = "ALM Sheet2";
    ApplicationArea = All;
    UsageCategory = Lists;

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
                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = Basic;
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(Unamort; Rec.Unamort)
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
            action("Import Sheet")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    Xmlport.Run(50102, true, false);
                end;
            }
        }
    }
}

