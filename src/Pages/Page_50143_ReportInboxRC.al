Page 50143 "Report Inbox RC"
{
    Caption = 'Report Inbox';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {

            label("Trial Balance")
            {
                ApplicationArea = Basic;
            }
        }

    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                ApplicationArea = Basic;
                Caption = 'Open';
                Image = TestReport;
                RunObject = Report "Trial Balance";
                RunPageMode = View;
                ShortCutKey = 'Return';
            }
        }
    }

    trigger OnOpenPage()
    begin
        //"Trial Balance" := 'Trial Balance';
    end;

    var
        "Trial Balance": Report "Trial Balance";
}

