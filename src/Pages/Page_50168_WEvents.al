page 50168 WorkflowEvents
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Workflow Event";

    layout
    {
        area(Content)
        {
            repeater("General")
            {
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;

                }
                field("Function Name"; Rec."Function Name")
                {
                    ApplicationArea = All;
                }
                field(Rec; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}