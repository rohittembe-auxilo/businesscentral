<<<<<<< HEAD
pageextension 50179 Vendorlist extends "Vendor List"
=======
pageextension 50179 VendorList extends "Vendor List"
>>>>>>> main
{
    layout
    {
        // Add changes to page layout here
<<<<<<< HEAD
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
=======
    }

    actions
    {
        // Add changes to page actions here
        addafter("Ledger E&ntries")
        {
            action("Import TDS Concessional Code")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Xmlport.Run(50139);
                end;
            }
            action("Import Allowed Sections")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Xmlport.Run(50140);
                end;
            }
        }
    }
>>>>>>> main
}