Page 50126 "Advances ECL"
{
    PageType = List;
    SourceTable = "Advances ECL";
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
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Cust ID"; rec."Cust ID")
                {
                    ApplicationArea = Basic;
                }
                field(Stage; rec.Stage)
                {
                    ApplicationArea = Basic;
                }
                field(ECL; rec.ECL)
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
                    Xmlport.Run(50011, true, false);
                end;
            }
        }
    }
}

