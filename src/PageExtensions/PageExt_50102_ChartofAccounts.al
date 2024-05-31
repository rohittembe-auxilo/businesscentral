pageextension 50102 ChartofAccounts extends "Chart of Accounts"
{
    layout
    {
        // Add changes to page layout here
        addafter("Name")
        {
            field("Shortcut Dimension 3"; Rec."Shortcut Dimension 3")
            {
                ApplicationArea = All;
            }
            field("Balance at Date Memorandum"; Rec."Balance at Date Memorandum")
            {
                ApplicationArea = All;
            }
            field("Net Change Memorandum"; Rec."Net Change Memorandum")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        CLEAR(UserDept);
        RecUserDep.RESET;
        RecUserDep.SETRANGE(RecUserDep."User ID", USERID);
        IF RecUserDep.FINDFIRST THEN
            REPEAT
                UserDept := UserDept + '|' + (RecUserDep.Department);
            UNTIL RecUserDep.NEXT = 0;

        rec.SETFILTER("Shortcut Dimension 3", DELCHR(UserDept, '<', '|'));
    END;



    var
        UserDept: Text[1024];
        RecUserDep: Record "User Department";
}