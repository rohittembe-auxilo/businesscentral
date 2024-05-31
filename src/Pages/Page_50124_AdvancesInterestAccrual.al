Page 50124 "Advances Interest Accrual"
{
    PageType = List;
    SourceTable = "Advances Interest Accrual";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Line No."; rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Row Labels"; rec."Row Labels")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Sum Of Interest Accrual"; rec."Sum Of Interest Accrual")
                {
                    ApplicationArea = Basic;
                }
                field("RBI Code"; rec."RBI Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status; rec.Status)
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
                    Xmlport.Run(50009, true, false);
                end;
            }
        }
    }
}

