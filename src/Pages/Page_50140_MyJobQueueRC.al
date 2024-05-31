Page 50140 "My Job Queue RC"
{
    Caption = 'My Job Queue RC';
    Editable = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Job Queue Entry";
    SourceTableView = sorting("Last Ready State");
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Object Caption to Run"; rec."Object Caption to Run")
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = StatusIsError;
                    Visible = false;
                }
                field("Parameter String"; rec."Parameter String")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = StatusIsError;
                }
                field(Status; rec.Status)
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = StatusIsError;
                }
                field("Earliest Start Date/Time"; rec."Earliest Start Date/Time")
                {
                    ApplicationArea = Basic;
                }
                field("Expiration Date/Time"; rec."Expiration Date/Time")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Job Queue Category Code"; rec."Job Queue Category Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
            group(Control18)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowError)
            {
                ApplicationArea = Basic;
                Caption = 'Show Error';
                Image = Error;

                trigger OnAction()
                begin
                    //v   ShowErrorMessage;
                end;
            }
            action(Cancel)
            {
                ApplicationArea = Basic;
                Caption = 'Delete';
                Image = Delete;

                trigger OnAction()
                begin
                    //       Cancel;
                end;
            }
            action(Restart)
            {
                ApplicationArea = Basic;
                Caption = 'Restart';
                Image = Start;

                trigger OnAction()
                begin
                    //     Restart;
                end;
            }
            action(ShowRecord)
            {
                ApplicationArea = Basic;
                Caption = 'Show Record';
                Image = ViewDetails;

                trigger OnAction()
                begin
                    //    LookupRecordToProcess;
                end;
            }
            action(ScheduleReport)
            {
                ApplicationArea = Basic;
                Caption = 'Schedule a Report';
                Image = "report";

                trigger OnAction()
                begin
                    //    CurrPage.PingPong.Stop;
                    Page.RunModal(Page::"Schedule a Report");
                    //     CurrPage.PingPong.Ping(1000);
                end;
            }
            action(EditJob)
            {
                ApplicationArea = Basic;
                Caption = 'Edit Job';
                Image = Edit;
                // RunObject = Page UnknownPage673;
                RunPageOnRec = true;
                ShortCutKey = 'Return';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //  StatusIsError := Status = Status::Error;
    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID",USERID);
        AddInReady := false;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if AddInReady then
            //      CurrPage.PingPong.Stop;
            exit(true);
    end;

    var
        //   PrevLastJobQueueEntry: Record UnknownRecord472;
        [InDataSet]
        StatusIsError: Boolean;
        AddInReady: Boolean;
}

