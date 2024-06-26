pageextension 50179 VendorList extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
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
}