xmlport 50140 Import_Allowed_Sections
{
    Format = VariableText;
    FieldDelimiter = '"';
    FieldSeparator = ',';
    schema
    {
        textelement(root)
        {
            tableelement(AllowedSections; "Allowed Sections")
            {
                XmlName = 'Import_Allowed_Sections';
                MinOccurs = Once;
                fieldattribute(VendorNo; AllowedSections."Vendor No")
                {

                }
                fieldattribute(TDSSection; AllowedSections."TDS Section")
                {

                }
                fieldattribute(DefaultSection; AllowedSections."Default Section")
                {

                }

                fieldattribute(ThresholdOverlook; AllowedSections."Threshold Overlook")
                {

                }
                fieldattribute(SurchargeOverlook; AllowedSections."Surcharge Overlook")
                {

                }
            }
        }
    }
    trigger OnPostXmlPort()
    begin
        Message('Allowed sections uploaded successfully');
    end;
}