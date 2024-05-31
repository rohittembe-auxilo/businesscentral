/*pageextension 50146 NODNOC extends "NOD/NOC"
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