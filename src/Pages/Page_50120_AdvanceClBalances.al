Page 50120 "Advance Cl Balances"
{
    PageType = List;
    SourceTable = "Advance Cl Balances";
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
                field("RBI Code"; Rec."RBI Code")
                {
                    ApplicationArea = Basic;
                }
                field(FINReference; Rec.FINReference)
                {
                    ApplicationArea = Basic;
                }
                field("Customer Name"; rec."Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Sch Date"; rec."Sch Date")
                {
                    ApplicationArea = Basic;
                }
                field("Closing Balance"; rec."Closing Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Sch Method"; rec."Sch Method")
                {
                    ApplicationArea = Basic;
                }
                field("Q Date"; rec."Q Date")
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
                    Xmlport.Run(50005, true, false);
                end;
            }
        }
    }
}

