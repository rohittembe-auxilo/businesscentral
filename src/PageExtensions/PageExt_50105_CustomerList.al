pageextension 50105 CustomerList extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Responsibility Center")
        {
            field("Balance"; Rec."Balance")
            {
                ApplicationArea = All;
            }
            field("Balance at Date"; Rec."Balance at Date")
            {
                ApplicationArea = All;
            }
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = All;
            }
            field(Attachments; Rec.Attachments)
            {
                ApplicationArea = all;
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