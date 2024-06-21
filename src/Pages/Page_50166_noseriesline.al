page 50166 noseriesline
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "No. Series Line";


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Rec; Rec."Ending No.")
                {
                    ApplicationArea = All;


                }
                field("Increment-by No."; Rec."Increment-by No.")
                {
                    ApplicationArea = all;

                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
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