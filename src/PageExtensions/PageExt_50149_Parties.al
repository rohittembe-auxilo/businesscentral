pageextension 50149 Parties extends "Parties"
{
    layout
    {
        // Add changes to page layout here
        addafter("P.A.N. Status")
        {
            field("Bank Code"; Rec."Bank Code")
            {
                ApplicationArea = All;
            }
            field("Bank Account No"; Rec."Bank Account No")
            {
                ApplicationArea = All;
            }
            field(IFSC; Rec.IFSC)
            {
                ApplicationArea = All;
            }
            field("Bank Email"; Rec."Bank Email")
            {
                ApplicationArea = All;
            }

            field("Bank Name"; Rec."Bank Name")
            {
                ApplicationArea = All;
            }
            field("Bank Address"; Rec."Bank Address")
            {
                ApplicationArea = All;
            }
            field("Bank Address2"; Rec."Bank Address2")
            {
                ApplicationArea = All;
            }
            field("Bank Branch No"; Rec."Bank Branch No")
            {
                ApplicationArea = All;
            }
            field("Payment Method code"; Rec."Payment Method code")
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