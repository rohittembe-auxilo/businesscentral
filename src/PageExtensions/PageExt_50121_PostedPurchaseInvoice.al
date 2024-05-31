pageextension 50121 PostedPurchaseInvoice extends "Posted Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter("Posting Date")
        {
            field("PHComment"; Rec."PHComment")
            {
                ApplicationArea = All;
            }
            field("RCM Invoice No."; Rec."RCM Invoice No.")
            {
                ApplicationArea = All;
            }
            field("RCM Payment No."; Rec."RCM Payment No.")
            {
                ApplicationArea = All;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
            }
            field("MSME"; Rec."MSME")
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
            field("Approver ID"; Rec."Approver ID")
            {
                ApplicationArea = All;
            }
            field("Approver Date"; Rec."Approver Date")
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
        // Add changes to page actions here\
        addafter(Print)
        {
            action("Purchase Invoice New")
            {
                ApplicationArea = All;
                RunObject = report "Purchase Invoice";

            }
        }
    }






    var
        myInt: Integer;
        PostingDateEditable: Boolean;
}