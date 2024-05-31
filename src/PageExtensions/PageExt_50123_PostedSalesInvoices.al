pageextension 50123 PostedSalesInvoice extends "Posted Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter("Shortcut Dimension 2 Code")
        {
            field("Shortcut Dimension 3"; Rec."Shortcut Dimension 3")
            {
                ApplicationArea = All;
            }
            field("Approver ID"; Rec."Approver ID")
            {
                ApplicationArea = All;
            }
            field("Approver Date"; Rec."Approver Date")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 4"; Rec."Shortcut Dimension 4")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 5"; Rec."Shortcut Dimension 5")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 7"; Rec."Shortcut Dimension 7")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 6"; Rec."Shortcut Dimension 6")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 8"; Rec."Shortcut Dimension 8")
            {
                ApplicationArea = All;
            }

        }

    }

    actions
    {
        // Add changes to page actions here
        addafter(Print)
        {
            action("Print Invoice Customize")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    SalesInvHeader.RESET;
                    SalesInvHeader.SETRANGE("No.", rec."No.");
                    IF SalesInvHeader.FINDFIRST THEN
                        REPORT.RUNMODAL(50007, TRUE, FALSE, SalesInvHeader);


                end;
            }
        }
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
        SalesInvHeader: Record "Sales Invoice Header";
}