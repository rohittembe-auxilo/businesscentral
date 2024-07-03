pageextension 50143 PurchaseInvoices extends "Purchase Invoices"
{
    layout
    {
        // Add changes to page layout here
        addafter("Location Code")
        {
            field("GST Amount"; Rec."GST Amount")
            {
                ApplicationArea = All;
            }
            field("TDS Amount"; Rec."TDS Amount")
            {
                ApplicationArea = All;
            }
            /*   field("Amount to Vendor"; rec."Amount to Vendor")
               {
                   ApplicationArea = All;
               }
               */
            field(State; Rec.State)
            {
                ApplicationArea = All;
            }
            field(Comment; Rec.Comment)
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
            {
                ApplicationArea = All;
            }


        }

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

                    XMLPORT.RUN(50018, TRUE, TRUE);

                end;
            }

        }

        modify(PostBatch)
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

        rec.SETFILTER("Shortcut Dimension 3 code", DELCHR(UserDept, '<', '|'));
        //CCIT-PRI
    end;

    var
        myInt: Integer;
        PostingDateEditable: Boolean;
        UserDept: Code[1024];
        RecUserDep: Record "User Department";
        PurchaseHeader: Record "Purchase Header";
}