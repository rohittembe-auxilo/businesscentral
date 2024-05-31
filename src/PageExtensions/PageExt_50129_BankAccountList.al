pageextension 50129 BankAccountList extends "Bank Account List"
{
    layout
    {
        // Add changes to page layout here
        addafter("SWIFT Code")
        {
            field("Net Change (LCY)"; Rec."Net Change (LCY)")
            {
                ApplicationArea = All;
            }
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = All;
            }
            field("Bank Branch No."; Rec."Bank Branch No.")
            {
                ApplicationArea = All;
            }
            field("Balance Last Statement"; Rec."Balance Last Statement")
            {
                ApplicationArea = All;
            }
            field("Balance at Date (LCY)"; Rec."Balance at Date (LCY)")
            {
                ApplicationArea = All;
            }
            field("Balance at Date"; Rec."Balance at Date")
            {
                ApplicationArea = All;
            }
            field("Balance (LCY)"; Rec."Balance (LCY)")
            {
                ApplicationArea = All;
            }
            field("Balance"; Rec."Balance")
            {
                ApplicationArea = All;
            }
            field("Amount"; Rec."Amount")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here

    }

    var
        myInt: Integer;
}