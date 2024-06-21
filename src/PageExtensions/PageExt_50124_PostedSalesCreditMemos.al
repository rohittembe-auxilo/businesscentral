pageextension 50124 PostedSalesCreditMemos extends "Posted Sales Credit Memos"
{
    layout
    {
        // Add changes to page layout here
        addafter("No. Printed")
        {
            field(Attachments; Rec.Attachments)
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter("&Print")
        {
            action("Print Invoice Customize")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    SalesCrMemoHeader.RESET;
                    SalesCrMemoHeader.SETRANGE("No.", rec."No.");
                    IF SalesCrMemoHeader.FINDFIRST THEN
                        REPORT.RUNMODAL(50004, TRUE, FALSE, SalesCrMemoHeader);


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
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
}