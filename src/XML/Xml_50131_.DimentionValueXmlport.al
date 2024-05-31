#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50131 "Dimention_ValueXmlport"
{

    Format = VariableText;
    Caption = 'Dimention_ValueXmlport';


    schema
    {
        textelement(root)
        {
            tableelement("Dimension Value"; "Dimension Value")
            {
                XmlName = 'Dimention_Value';
                fieldelement(Dimention_Code; "Dimension Value"."Dimension Code")
                {
                    //MinOccurs = Zero;
                }
                fieldelement(Code; "Dimension Value".Code)
                {
                    //MinOccurs = Zero;
                }
                fieldelement(Name; "Dimension Value".Name)
                {
                    // MinOccurs = Zero;
                }
                fieldelement(Dimention_value_Type; "Dimension Value"."Dimension Value Type")
                {
                    MinOccurs = Zero;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
    trigger OnPostXmlPort()
    begin
        Message(' uploaded successfully');
    end;
}

