pageextension 50184 AllowedSEc extends "Allowed Sections"
{
    layout
    {
        // Add changes to page layout here
        addafter("Vendor No")
        {
            field("Vendor Name"; VendorName)
            {
                ApplicationArea = All;
                Editable = false;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        VendorName := '';
        if Vendors.get(rec."Vendor No") then begin

            VendorName := Vendors.Name;
        end;

    end;

    var
        myInt: Integer;
        Vendors: Record Vendor;
        VendorName: Text[100];
}