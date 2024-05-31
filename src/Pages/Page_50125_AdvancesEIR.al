Page 50125 "Advances EIR"
{
    PageType = List;
    SourceTable = "Advances EIR";
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
                field(LAN; rec.LAN)
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Rev Unmort"; rec."Rev Unmort")
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
                    Xmlport.Run(50010, true, false);
                end;
            }
        }
    }
}

