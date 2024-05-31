Page 50138 "My Vendors RC"
{
    Caption = 'My Vendors';
    PageType = ListPart;
    SourceTable = Vendor;
    SourceTableView = sorting("No.")
                      order(ascending)
                      where(Balance = filter(<> 0));
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(No; Vendor."No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No';

                    trigger OnValidate()
                    begin
                        GetVendor;
                    end;
                }
                field("Phone No."; Vendor."Phone No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Phone No.';
                    Editable = false;
                    // ExtendedDatatype = PhoneNo;
                }
                field(Name; Vendor.Name)
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                    Editable = false;
                }
                field(BalanceLCY; Vendor."Balance (LCY)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Balance (LCY)';
                    Editable = false;
                    Visible = true;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetVendor;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(Vendor);
    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID",USERID);
    end;

    var
        Vendor: Record Vendor;

    local procedure GetVendor()
    begin
        Clear(Vendor);

        if Vendor.Get(rec."No.") then
            Vendor.CalcFields("Balance (LCY)");
    end;
}

