Page 50117 "ALM Sheet1"
{
    PageType = List;
    SourceTable = "ALM Sheet1";
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
                field("RBI Code"; Rec."RBI Code")
                {
                    ApplicationArea = Basic;
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                }
                field("Sr No."; Rec."Sr No.")
                {
                    ApplicationArea = Basic;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = Basic;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic;
                }
                field(ROI; Rec.ROI)
                {
                    ApplicationArea = Basic;
                }
                field("Opening Balance"; Rec."Opening Balance")
                {
                    ApplicationArea = Basic;
                }
                field(Disbursement; Rec.Disbursement)
                {
                    ApplicationArea = Basic;
                }
                field(Principal; Rec.Principal)
                {
                    ApplicationArea = Basic;
                }
                field("Interest Due"; Rec."Interest Due")
                {
                    ApplicationArea = Basic;
                }
                field(Installment; Rec.Installment)
                {
                    ApplicationArea = Basic;
                }
                field("Closing Balance"; Rec."Closing Balance")
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
                    Xmlport.Run(50101, true, false);
                end;
            }
        }
    }
}

