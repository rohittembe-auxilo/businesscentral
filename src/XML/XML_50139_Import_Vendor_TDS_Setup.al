xmlport 50139 Import_Vendor_TDS_Setup
{
    Format = VariableText;
    FieldDelimiter = '"';
    FieldSeparator = ',';
    schema
    {
        textelement(root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Vendor_TDS_Details';
                MinOccurs = Once;
                AutoSave = false;
                textattribute(VendorNo)
                {

                }
                textattribute(TDSSection)
                {

                }
                textattribute(DefaultSection)
                {

                }

                textattribute(ThresholdOverlook)
                {

                }
                textattribute(SurchargeOverlook)
                {

                }
                textattribute(TextSection)
                {

                }
                textattribute(ConessionalCode)
                {

                }
                textattribute(CertificateNo)
                {

                }
                textattribute(StartDate)
                {

                }
                textattribute(EndDate)
                {
                }
                trigger OnAfterInsertRecord()
                var
                    AllowedSections: Record "Allowed Sections";
                    TDSConcessionalCode: Record "TDS Concessional Code";
                begin
                    AllowedSections.Init();
                    AllowedSections.Validate("Vendor No", VendorNo);
                    AllowedSections.Validate("TDS Section", TDSSection);
                    Evaluate(AllowedSections."Default Section", DefaultSection);
                    AllowedSections.Validate("Default Section");
                    Evaluate(AllowedSections."Threshold Overlook", ThresholdOverlook);
                    AllowedSections.Validate("Threshold Overlook");
                    Evaluate(AllowedSections."Surcharge Overlook", SurchargeOverlook);
                    AllowedSections.Validate("Surcharge Overlook");
                    AllowedSections.Insert();

                    TDSConcessionalCode.Init();
                    TDSConcessionalCode.Validate("Vendor No.", VendorNo);
                    TDSConcessionalCode.Validate("Section", TextSection);
                    TDSConcessionalCode.Validate("Concessional Code", ConessionalCode);
                    TDSConcessionalCode.Validate("Certificate No.", CertificateNo);
                    Evaluate(TDSConcessionalCode."Start Date", StartDate);
                    TDSConcessionalCode.Validate("Start Date");
                    Evaluate(TDSConcessionalCode."End Date", EndDate);
                    TDSConcessionalCode.Validate("End Date");
                    TDSConcessionalCode.Insert();
                end;
            }
        }
    }
    trigger OnPostXmlPort()
    begin
        Message('Vendor TDS setup uploaded successfully');
    end;
}