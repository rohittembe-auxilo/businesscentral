pageextension 50116 UserSetup extends "User Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("User ID")
        {
            field("User Name"; Rec."User Name")
            {
                ApplicationArea = All;
            }
            field("Approver ID"; Rec."Approver ID")
            {
                ApplicationArea = All;
            }
            field("Approver Name"; Rec."Approver Name")
            {
                ApplicationArea = All;
            }
            field("Blocked"; Rec."Blocked")
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