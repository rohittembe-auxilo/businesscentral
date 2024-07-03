pageextension 50142 PurchaseOrderList extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        // Add changes to page actions here
        addafter("Co&mments")
        {

            action("Upload CSV")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                    XMLPORT.RUN(50118, TRUE, TRUE);

                end;
            }

            action(PurchaseOrderXmlport)
            {
                ApplicationArea = all;
                Image = Import;
                Promoted = true;
                PromotedCategory = New;
                trigger OnAction()
                var
                    customer: Record Customer;
                begin
                    //v                Xmlport.Run(50109, false, true);
                end;
            }



        }

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
        modify(PostAndPrint)
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

        addafter(SendApprovalRequest)
        {
            action("Send approval Request Batch")
            {

                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request Batch';
                Image = SendApprovalRequest;
                ToolTip = 'Request approval Request Batch.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    if PurchaseHeader.FindSet then
                        repeat
                            if ApprovalsMgmt.CheckPurchaseApprovalPossible(PurchaseHeader) then
                                ApprovalsMgmt.OnSendPurchaseDocForApproval(PurchaseHeader);
                        Until PurchaseHeader.Next = 0;
                end;
            }


        }

    }




    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //CCIT-PRI
        CLEAR(UserDept);
        RecUserDep.RESET;
        RecUserDep.SETRANGE(RecUserDep."User ID", USERID);
        IF RecUserDep.FINDFIRST THEN
            REPEAT
                UserDept := UserDept + '|' + (RecUserDep.Department);
            UNTIL RecUserDep.NEXT = 0;

        rec.SETFILTER("Shortcut Dimension 3 Code", DELCHR(UserDept, '<', '|'));
        //CCIT-PRI
    end;

    var
        myInt: Integer;
        PostingDateEditable: Boolean;
        UserDept: Code[1024];
        RecUserDep: Record "User Department";
        PurchaseHeader: Record "Purchase Header";
}