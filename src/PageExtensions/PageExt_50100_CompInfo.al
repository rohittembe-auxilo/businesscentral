pageextension 50100 CompInfo extends "Company Information"
{
    layout
    {
        // Add changes to page layout here
        addafter("E-Mail")
        {
            field("Corporate Email ID"; Rec."Corporate Email ID")
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