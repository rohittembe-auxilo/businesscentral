pageextension 50164 PurchaseOrder extends "Purchase Order"
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
            field(State; Rec.State)
            {
                ApplicationArea = All;
            }
            field("Approver ID"; Rec."Approver ID")
            { ApplicationArea = All; }
            field("Approver Date"; Rec."Approver Date")
            { ApplicationArea = All; }
            field("PO Type"; Rec."PO Type")
            { ApplicationArea = All; }

            field("PO Sub Type"; Rec."PO Sub Type")
            { ApplicationArea = All; }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
            }
            field("Vendor GSTIN No."; Rec."Vendor GSTIN No.")
            {
                ApplicationArea = All;
            }
            field("Location GSTIN No."; Rec."Location GSTIN No.")
            {
                ApplicationArea = all;
            }
            field("RCM Invoice No."; Rec."RCM Invoice No.")
            {
                ApplicationArea = All;
            }

        }

    }

    actions
    {
        // Add changes to page actions here
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                PL: Record "Purchase Line";
            begin
                //CCIt-PRI
                Rec.TESTFIELD("Shortcut Dimension 1 Code");
                Rec.TESTFIELD("Shortcut Dimension 2 Code");
                PL.RESET;
                PL.SETRANGE(PL."Document No.", rec."No.");
                IF PL.FINDFIRST THEN
                    PL.TESTFIELD(PL."Location Code");

            end;
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

                IF rec."Short Closed" THEN
                    Error('Purchase Order %1 is Short Closed.', rec."No.");

                if Location.Get(rec."Location Code") then begin
                    if Location."Blocked Location" = true then
                        Error('Location is blocked');
                end;

            end;
        }
        addafter(Post)
        {
            action("Short Closed")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    RecPurchLine: Record "Purchase Line";
                //  Text001: TextConst  'Do you want to short closed order %1 ?';
                begin
                    IF NOT CONFIRM('Do you want to short closed order %1 ?', FALSE, rec."No.") THEN
                        EXIT;
                    RecPurchLine.RESET;
                    RecPurchLine.SETRANGE(RecPurchLine."Document No.", rec."No.");
                    RecPurchLine.SETFILTER("Qty. to Receive", '<>%1', 0);
                    IF RecPurchLine.FINDFIRST THEN
                        REPEAT
                            RecPurchLine."Outstanding Quantity" := 0;
                            RecPurchLine."Outstanding Qty. (Base)" := 0;
                            RecPurchLine.MODIFY;
                        UNTIL RecPurchLine.NEXT = 0;
                    rec."Short Closed" := TRUE;
                    //CCIT-PRI


                end;
            }
            action("Term & Condition")
            {
                ApplicationArea = all;
                caption = 'Term & Condition';
                Image = ViewPage;

                RunObject = Page "Term and Condition";
                RunPageLink = "No." = field("No.");

                trigger OnAction()
                var
                    myInt: Integer;
                    trmC: page 50126;
                begin

                    //   "No." = field("No."),
                    //   "Document Line No." = const(0);

                    // trmC.RunModal();
                    // page.RunModal(page::"Term and Condition", true, true, Rec);
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //CCIT-PRI
        IF rec."Short Closed" = TRUE THEN
            IsEditable := FALSE
        ELSE
            IsEditable := TRUE;

        //CCIT-PRI
        IF rec.Status = rec.Status::Open THEN
            PostingDateEditable := TRUE
        ELSE
            PostingDateEditable := FALSE;


    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        IF Rec."Short Closed" = TRUE THEN
            IsEditable := FALSE
        ELSE
            IsEditable := TRUE;

    end;

    var
        IsEditable: Boolean;
        PostingDateEditable: Boolean;
}