pageextension 50139 SalesInvoiceList extends "Sales Invoice list"
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        // Add changes to page actions here

        modify(Post)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                UserSetup: Record "User Setup";
                Location: Record Location;
            begin
                UserSetup.RESET();
                UserSetup.SETRANGE("User ID", USERID);
                UserSetup.SETRANGE(Blocked, TRUE);
                IF UserSetup.FINDFIRST THEN
                    ERROR('This User Is Blocked, Can not Post This Invoice ');
                rec.TESTFIELD(Status, rec.Status::Released);//CCIT Vikas 16062020

                if Location.Get(rec."Location Code") then begin
                    if Location."Blocked Location" = true then
                        Error('Location is blocked');
                end;



            end;


        }
        modify(PostAndSend)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                UserSetup: Record "User Setup";
            begin
                UserSetup.RESET();
                UserSetup.SETRANGE("User ID", USERID);
                UserSetup.SETRANGE(Blocked, TRUE);
                IF UserSetup.FINDFIRST THEN
                    ERROR('This User Is Blocked, Can not Post This Invoice ');
                rec.TESTFIELD(Status, rec.Status::Released);//CCIT Vikas 16062020



            end;


        }

    }




    trigger OnOpenPage()
    var
        myInt: Integer;
    begin

        IF rec.Status = rec.Status::Open THEN
            PostingDateEditable := TRUE
        ELSE
            PostingDateEditable := FALSE;
    end;

    var
        myInt: Integer;
        PostingDateEditable: Boolean;
}