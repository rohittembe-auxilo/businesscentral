pageextension 50101 LocationList extends "Location List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Name")
        {
            field("Blocked Location"; Rec."Blocked Location")
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