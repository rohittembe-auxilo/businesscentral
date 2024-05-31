Page 50127 "Monthly Schedules"
{
    PageType = List;
    SourceTable = "Monthly Schedule";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; rec.Name)
                {
                    ApplicationArea = Basic;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Edit Monthly Schedule")
            {
                ApplicationArea = Basic;
                Caption = 'Edit Monthly Schedule';
                Image = EditForecast;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Return';

                trigger OnAction()
                var
                    MonthlySchedule: Page "Monthly Schedule";
                begin
                    MonthlySchedule.SetName(rec.Name);
                    MonthlySchedule.Run;
                end;
            }
        }
    }
}

