pageextension 50183 DVLE extends "Detailed Vendor Ledg. Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter(Amount)
        {
            field(Attachments; Rec.Attachments)
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
        ghj: Page "TDS Rates";
}