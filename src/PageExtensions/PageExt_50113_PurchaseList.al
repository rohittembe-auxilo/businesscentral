pageextension 50113 PurchaseList extends "Purchase List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Assigned User ID")
        {
            field("MSME"; Rec."MSME")
            {
                ApplicationArea = All;
            }
            field("MSME No."; Rec."MSME No.")
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