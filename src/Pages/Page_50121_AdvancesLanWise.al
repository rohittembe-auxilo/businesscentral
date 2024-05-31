Page 50121 "Advances LanWise"
{
    PageType = List;
    SourceTable = "Advances LanWise";
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
                field("SCH Date"; rec."SCH Date")
                {
                    ApplicationArea = Basic;
                }
                field("Calculated Rate"; rec."Calculated Rate")
                {
                    ApplicationArea = Basic;
                }
                field("Repay Amount"; rec."Repay Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Balance For PFTCAL"; rec."Balance For PFTCAL")
                {
                    ApplicationArea = Basic;
                }
                field(DisbAmount; rec.DisbAmount)
                {
                    ApplicationArea = Basic;
                }
                field(PrincipalSchd; rec.PrincipalSchd)
                {
                    ApplicationArea = Basic;
                }
                field(ProfitSchd; rec.ProfitSchd)
                {
                    ApplicationArea = Basic;
                }
                field("CPZA Amount"; rec."CPZA Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Closing Balance"; rec."Closing Balance")
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
                    Xmlport.Run(50006, true, false);
                end;
            }
        }
    }
}

