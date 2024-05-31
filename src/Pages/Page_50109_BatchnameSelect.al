Page 50109 "Batch name Select"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            field("Batch Name"; BatchName)
            {
                ApplicationArea = Basic;
                Caption = 'Batch Name';
                TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = const('GENERAL'),
                                                                 Name = filter(<> 'LMS DIRECT'));
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        IF BatchName = '' THEN
            ERROR('Please select batch name');

        //   CheckGLInterfaceLines.SetbatchName(BatchName)
    end;

    var
        BatchName: Text;
    //      CheckGLInterfaceLines: Codeunit 279;
}


