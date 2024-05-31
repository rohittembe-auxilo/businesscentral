pageextension 50118 VendLedgEntriesPreview extends "Vend. Ledg. Entries Preview"
{
    layout
    {
        // Add changes to page layout here
        addafter("Reason Code")
        {

            field("Related Party Transaction"; Rec."Related Party Transaction")
            {
                ApplicationArea = All;
            }
            field("PO Type"; Rec."PO Type")
            {
                ApplicationArea = All;
            }
            field("PO Sub Type"; Rec."PO Sub Type")
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
        RecVendor: Record 23;
        RecCustomer: Record 18;
}