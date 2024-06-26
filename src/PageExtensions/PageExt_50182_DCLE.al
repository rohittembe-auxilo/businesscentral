pageextension 50182 DCLE extends "Detailed Cust. Ledg. Entries"
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
}