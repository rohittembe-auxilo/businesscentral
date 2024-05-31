Page 50123 "Advances OD Report"
{
    PageType = List;
    SourceTable = "Advances OD Report";
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
                field(FINODSchdDate; rec.FINODSchdDate)
                {
                    ApplicationArea = Basic;
                }
                field(FINCURODDays; rec.FINCURODDays)
                {
                    ApplicationArea = Basic;
                }
                field(FINCURODPRI; rec.FINCURODPRI)
                {
                    ApplicationArea = Basic;
                }
                field(FINCURODPFT; rec.FINCURODPFT)
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
                    Xmlport.Run(50008, true, false);
                end;
            }
        }
    }
}

