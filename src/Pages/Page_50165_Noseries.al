page 50165 Noseries
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "No. Series";


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; rec.Code)
                {
                    ApplicationArea = All;

                }
                field("Date Order"; Rec."Date Order")
                {
                    ApplicationArea = all;
                }
                field("Default Nos."; Rec."Default Nos.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
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
                var
                    sdd: Page "No. Series";
                begin

                end;
            }
        }
    }
}