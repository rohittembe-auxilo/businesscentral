pageextension 50112 SalesInvoiceSubform extends "Sales Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("VAT Prod. Posting Group")
        {
            /*    field("GST Base Amount"; Rec."GST Base Amount")
                {
                    ApplicationArea = All;
                }
                field("Assessable Value"; Rec."Assessable Value")
                {
                    ApplicationArea = All;
                }
                */
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}