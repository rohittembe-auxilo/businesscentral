pageextension 50179 Vendorlist extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Payments (LCY)")
        {
            field(Attachments; Rec.Attachments)
            {
                ApplicationArea = All;
                Editable = false;
            }

            field(Balance; Rec.Balance)
            {
                ApplicationArea = All;
                Editable = false;

            }
            field("Balance at Date"; Rec."Balance at Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("MSME No."; Rec."MSME No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("P.A.N. No."; Rec."P.A.N. No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("GST Registration No."; Rec."GST Registration No.")
            {
                ApplicationArea = All;
                Editable = false;

            }
            field("State Code"; Rec."State Code")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("GST Vendor Type"; Rec."GST Vendor Type")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = all;
                Editable = false;

            }
            field(MSME; Rec.MSME)
            {
                ApplicationArea = all;
                Editable = false;
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