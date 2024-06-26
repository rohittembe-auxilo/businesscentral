xmlport 50139 Import_TDS_Concessional_Code
{
    Format = VariableText;
    FieldDelimiter = '"';
    FieldSeparator = ',';
    schema
    {
        textelement(root)
        {
            tableelement(TDSConcessionalCode; "TDS Concessional Code")
            {
                fieldattribute(VendorNo; TDSConcessionalCode."Vendor No.")
                {

                }
                fieldattribute(Section; TDSConcessionalCode.Section)
                {

                }
                fieldattribute(ConcessionalCode; TDSConcessionalCode."Concessional Code")
                {

                }

                fieldattribute(CertificateNo; TDSConcessionalCode."Certificate No.")
                {

                }
                fieldattribute(StartDate; TDSConcessionalCode."Start Date")
                {

                }
                fieldattribute(EndDate; TDSConcessionalCode."End Date")
                {

                }
            }
        }
    }


    trigger OnPostXmlPort()
    begin
        Message('TDS concessional codes uploaded successfully');
    end;
}