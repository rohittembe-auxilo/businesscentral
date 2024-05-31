pageextension 50150 TDSSetup extends "TDS Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Nil Pay TDS Document Nos.")
        {
            /* Vikas Migration        field("Non Lower Deduction %"; Rec."Non Lower Deduction %")
                    {
                        ApplicationArea = All;
                    }
                    field("Vendor Code"; Rec."Vendor Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Vendor Name"; Rec."Vendor Name")
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