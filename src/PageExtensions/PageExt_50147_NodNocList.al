/*pageextension 50147 NODNOCList extends "NOD / NOC List"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            field("Name"; Rec."Name")
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
*/