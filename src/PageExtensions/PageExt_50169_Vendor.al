pageextension 50169 vendor extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Balance (LCY)")
        {

            field("Blocked Reason"; Rec."Blocked Reason")
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

            field("Last Modified Date Time"; Rec."Last Modified Date Time")
            {
                ApplicationArea = All;
            }
            field(Balance; Rec.Balance)
            { ApplicationArea = all; }
            field("Net Change"; Rec."Net Change")
            { ApplicationArea = all; }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = all;
            }
            field("Related party transaction"; Rec."Related party transaction")
            {
                ApplicationArea = all;
            }
            field("GRN Qty"; Rec."GRN Qty")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 3"; Rec."Shortcut Dimension 3")
            {
                ApplicationArea = all;
            }
            field("LMS Vendor No"; Rec."LMS Vendor No")
            {
                ApplicationArea = All;

            }
            field("Incoming Document Entry No."; Rec."Incoming Document Entry No.")
            {
                ApplicationArea = all;
            }
            field("E-Mail 2"; Rec."E-Mail 2")
            {
                ApplicationArea = All;
            }
            field("Mobile No"; Rec."Mobile No")
            {
                ApplicationArea = All;
            }
            field("Address 3"; Rec."Address 3")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Bank Accounts")
        {
            action("GL Accounts")
            {
                ApplicationArea = All;
                RunObject = page "Vendor G/L Account";
                RunPageLink = "Vendor No" = FIELD("No.");
                trigger OnAction()
                begin


                end;
            }
        }
    }

    var
        myInt: Integer;
}