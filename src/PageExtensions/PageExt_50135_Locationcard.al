pageextension 50135 LocationCard extends "Location Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Code)
        {

            field("Blocked Location"; Rec."Blocked Location")
            {
                ApplicationArea = All;

            }
        }
        addafter("Location ARN No.")
        {
            field("RCM Invoice No. Nos."; Rec."RCM Invoice No. Nos.")
            {
                ApplicationArea = All;
            }
            field("RCM payment No. Nos."; Rec."RCM payment No. Nos.")
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