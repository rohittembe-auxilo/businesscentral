XmlPort 50112 "Dimvale update"
{
    Format = VariableText;
    TextEncoding = UTF16;

    schema
    {
        textelement(root)
        {
            tableelement("Dimension Value"; "Dimension Value")
            {
                XmlName = 'DimValue';
                fieldelement(DImCode; "Dimension Value"."Dimension Code")
                {
                }
                fieldelement(Codes; "Dimension Value".Code)
                {
                }
                fieldelement(Name; "Dimension Value".Name)
                {
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
    var
    //    testfile: Record File;
    begin
        if GuiAllowed then
            Message('Dimensions Uploaded successfully')
    end;

    var
        EntryNo: Integer;
        PLCLog: Record "PLC Logs";
}

