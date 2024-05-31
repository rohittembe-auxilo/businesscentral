Page 50122 "Advances Cust ID"
{
    PageType = List;
    SourceTable = "Advances Cust ID";
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
                field("RBI Code"; rec."RBI Code")
                {
                    ApplicationArea = Basic;
                }
                field("FIN Reference"; rec."FIN Reference")
                {
                    ApplicationArea = Basic;
                }
                field("Cust ID"; rec."Cust ID")
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
                    Xmlport.Run(50007, true, false);
                end;
            }
        }
    }
}

