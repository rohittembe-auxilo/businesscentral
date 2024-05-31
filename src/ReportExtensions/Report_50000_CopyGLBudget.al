reportextension 50000 CopyGLBudget extends "Copy G/L Budget"
{
    dataset
    {
        // Add changes to dataitems and columns here
    }

    requestpage
    {
        // Add changes to the requestpage here
        layout
        {
            addafter(ColumnDim)
            {
                field(ConversionFactor; ConversionFactor)
                {
                    ApplicationArea = Suit;
                    Caption = 'Conversion Factor';
                }
            }
        }
    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'mylayout.rdl';
        }
    }

    var
        ConversionFactor: Decimal;
}