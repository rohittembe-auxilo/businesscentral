pageextension 50145 UserCard extends "User Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Full Name")
        {
            /*  field("User Code"; Rec."User Code")
              {
                  ApplicationArea = All;
              }
              field("Old User ID"; Rec."Old User ID")
              {
                  ApplicationArea = All;
              }
              */
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}