pageextension 50165 PurchaseInvoice extends "Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter("Shortcut Dimension 2 Code")
        {
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
            field("Bank Account Code"; Rec."Bank Account Code")
            {
                ApplicationArea = All;
            }
            field("Bank Account No."; Rec."Bank Account No.")
            {
                ApplicationArea = All;
            }
            field("Bank Account Name"; Rec."Bank Account Name")
            {
                ApplicationArea = All;
            }
            field("Bank Account IFSC"; Rec."Bank Account IFSC")
            {
                ApplicationArea = All;
            }
            field("Bank Account Email"; Rec."Bank Account Email")
            {
                ApplicationArea = All;
            }
            field(PHComment; Rec.PHComment)
            {
                ApplicationArea = All;
            }
            field(MSME; Rec.MSME)
            {
                ApplicationArea = All;
            }
            field("MSME No."; Rec."MSME No.")
            {
                ApplicationArea = All;
            }
            field("MSME Type"; Rec."MSME Type")
            {
                ApplicationArea = All;
            }
            field("Posting No."; Rec."Posting No.")
            {
                ApplicationArea = All;
            }
            field("Purch. Order No."; Rec."Purch. Order No.")
            {
                ApplicationArea = All;
            }



        }
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
                location: Record Location;
            begin
                //CCIT AN
                UserSetup.RESET();
                UserSetup.SETRANGE("User ID", USERID);
                UserSetup.SETRANGE(Blocked, TRUE);
                IF UserSetup.FINDFIRST THEN
                    ERROR('This User Is Blocked, Can not Post This Invoice ');

                Rec.TESTFIELD("Bank Account Code");

                IF Rec.Status <> Rec.Status::Released THEN
                    ERROR('Can not post status should be released');
                if Location.Get(rec."Location Code") then begin
                    if Location."Blocked Location" = true then
                        Error('Location is blocked');
                end;
            End;
        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        IF Rec.Status = Rec.Status::Open THEN
            PostingDateEditable := TRUE
        ELSE
            PostingDateEditable := FALSE;

    end;

    var
        myInt: Integer;
        PostingDateEditable: Boolean;
}