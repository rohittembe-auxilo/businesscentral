pageextension 50186 FixedAssetCard extends "Fixed Asset Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("FA Location Code")
        {
            field("Asset Tag no."; Rec."Asset Tag no.")
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