pageextension 50172 CustomerCard extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Gen. Bus. Posting Group")
        {
            field("Shortcut Dimension 3"; Rec."Shortcut Dimension 3")
            {
                ApplicationArea = All;
            }
            field("Balance at Date"; Rec."Balance at Date")
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