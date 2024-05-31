pageextension 50136 TransferOrderSubform extends "Transfer Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Transfer Price")
        {
            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
                ApplicationArea = All;
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
                ApplicationArea = all;
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