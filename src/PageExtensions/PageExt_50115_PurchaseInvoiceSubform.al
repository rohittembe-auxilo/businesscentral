pageextension 50115 PurchaseInvoiceSubforms extends "Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Description")
        {
            field("Comments"; Rec."Comments")
            {
                ApplicationArea = All;
            }
            /*    field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                }
                */


            field("Comment"; Rec."Comment")
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