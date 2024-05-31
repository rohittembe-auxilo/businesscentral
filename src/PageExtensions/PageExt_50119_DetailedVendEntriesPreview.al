pageextension 50119 DetailedVendEntriesPreview extends "Detailed Vend. Entries Preview"
{
    layout
    {
        // Add changes to page layout here
        addafter("Vendor Ledger Entry No.")
        {


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
        RecVendor: Record 23;
        RecCustomer: Record 18;
}