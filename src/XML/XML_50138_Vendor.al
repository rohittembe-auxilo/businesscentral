#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50138 "Vendor Xmlport"
{
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement(Vendor; Vendor)
            {
                XmlName = 'Vendor';
                AutoSave = false;

                textelement(Name)
                {
                }
                textelement(NO)
                {
                }
                textelement(Address)
                {
                }
                textelement(Address2)
                {
                }
                textelement(City)
                {
                }
                textelement(Post_code)
                {
                }

                textelement(State)
                {
                }
                textelement(Country)
                {
                }
                textelement("E-mail")
                {
                }
                textelement(Phone_NO)
                {
                }
                textelement(Gen_bus_Posting_group)
                {
                    MinOccurs = Zero;
                }
                textelement(Vendor_Posting_Group)
                {
                    MinOccurs = Zero;
                }
                textelement(Payment_Term_Code)
                {
                    MinOccurs = Zero;
                }
                textelement(Access_Code)
                {
                    MinOccurs = Zero;
                }
                textelement(Pan_No)
                {
                    MinOccurs = Zero;
                }
                textelement("GST_Registration")
                {
                    MinOccurs = Zero;
                }

                textelement(GST_Vendor_Type)
                {
                    MinOccurs = Zero;
                }
                textelement(Location)
                {
                    MinOccurs = Zero;
                }
                trigger OnAfterInsertRecord()
                var
                    Recvendor: Record Vendor;
                    FixedLine: Record 5612;
                    Fixedheader: Record 5600;
                    "LineNo.": Integer;
                    Declining_Balance1: Decimal;
                    No_of_DepreciationYear1: Decimal;
                    statingDate1: Date;
                    FA_Class_code1: Code[15];
                    Noseriesmgmt: Codeunit NoSeriesManagement;
                    SalesnRecSetup: Record "Purchases & Payables Setup";
                    gstvendortype: Enum "GST Vendor Type";
                begin
                    Recvendor.Reset();
                    Recvendor.SetRange("No.", NO);
                    // Recvendor.SetRange("No.", DocNo);
                    if not Recvendor.Find('-') then begin
                        Clear(Recvendor);
                        SalesnRecSetup.get;
                        Recvendor.Init();

                        Recvendor."No." := NO;// Noseriesmgmt.GetNextNo(SalesnRecSetup."Vendor Nos.", Today, true);
                        // Recvendor.Validate("No.", NO);
                        Recvendor.Validate(Name, Name);

                        Recvendor.Validate("Address 2", Address2);
                        Recvendor.Validate(City, City);
                        Recvendor.Validate("Post Code", Post_code);

                        Recvendor.Validate("State Code", State);
                        Recvendor.Validate(County, Country);
                        Recvendor.Validate("E-Mail", "E-mail");
                        Recvendor.Validate("Phone No.", Phone_NO);
                        Recvendor.Validate("Gen. Bus. Posting Group", Gen_bus_Posting_group);
                        Recvendor.Validate("Vendor Posting Group", Vendor_Posting_Group);
                        Recvendor.Validate("Payment Terms Code", Payment_Term_Code);

                        // if GST_Vendor_Type = '' then
                        //     Recvendor."GST Vendor Type" := Recvendor."GST Vendor Type"::" "
                        // else
                        // if GST_Vendor_Type = 'Composite' then
                        //     Recvendor."GST Vendor Type" := Recvendor."GST Vendor Type"::Composite
                        // else
                        //     if GST_Vendor_Type = 'Exempted' then
                        //         Recvendor."GST Vendor Type" := Recvendor."GST Vendor Type"::Exempted
                        //     else
                        //         if GST_Vendor_Type = 'Import' then
                        //             Recvendor."GST Vendor Type" := Recvendor."GST Vendor Type"::Import
                        //         else
                        if GST_Registration <> '' then begin
                            if GST_Vendor_Type = 'Unregistered' then
                                error('GST Vendor type must be registered')
                        end;

                        Evaluate(gstvendortype, GST_Vendor_Type);
                        Recvendor.Validate("GST Vendor Type", gstvendortype);

                        // if GST_Vendor_Type = 'Registered' then
                        //     Recvendor."GST Vendor Type" := Recvendor."GST Vendor Type"::Registered
                        // else
                        //     if GST_Vendor_Type = 'Unregistered' then
                        //         Recvendor."GST Vendor Type" := Recvendor."GST Vendor Type"::Unregistered
                        //     else
                        //         if GST_Vendor_Type = 'SEZ' then
                        //             Recvendor."GST Vendor Type" := Recvendor."GST Vendor Type"::SEZ;


                        Recvendor.Validate(Address, Address);
                        Recvendor.Validate("P.A.N. No.", Pan_No);
                        Recvendor.Validate("GST Registration No.", GST_Registration);
                        Recvendor.Validate("Location Code", Location);
                        Recvendor.Validate("Assessee Code", Access_Code);

                        Recvendor.Insert(true);
                        Recvendor.Modify();
                    end;

                end;


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
        Message('Vendor uploaded successfully');
    end;
}
//  tableelement(Vendor; Vendor)
//             {
//                 XmlName = 'Vendor';
//                 fieldelement(NO; Vendor."No.")
//                 {
//                 }
//                 fieldelement(Name; Vendor.Name)
//                 {
//                 }
//                 fieldelement(Address; Vendor.Address)
//                 {
//                 }
//                 fieldelement(Address2; Vendor."Address 2")
//                 {
//                 }
//                 fieldelement(Post_code; Vendor."Post Code")
//                 {
//                 }
//                 fieldelement(City; Vendor.City)
//                 {
//                 }
//                 fieldelement(State; Vendor."State Code")
//                 {
//                 }
//                 fieldelement(Country; Vendor."Country/Region Code")
//                 {
//                 }
//                 fieldelement("E-mail"; Vendor."E-Mail")
//                 {
//                 }
//                 fieldelement(Phone_NO; Vendor."Phone No.")
//                 {
//                 }
//                 fieldelement(Gen_bus_Posting_group; Vendor."Gen. Bus. Posting Group")
//                 {
//                     MinOccurs = Zero;
//                 }
//                 fieldelement(Vendor_Posting_Group; Vendor."Vendor Posting Group")
//                 {
//                     MinOccurs = Zero;
//                 }
//                 fieldelement(Payment_Term_Code; Vendor."Payment Terms Code")
//                 {
//                     MinOccurs = Zero;
//                 }
//                 textelement(Access_Code)
//                 {
//                     MinOccurs = Zero;
//                 }
//                 fieldelement(Pan_No; Vendor."P.A.N. No.")
//                 {
//                     MinOccurs = Zero;
//                 }
//                 fieldelement("GST_Registration"; Vendor."GST Registration No.")
//                 {
//                     MinOccurs = Zero;
//                 }

//                 fieldelement(GST_Vendor_Type; Vendor."GST Vendor Type")
//                 {
//                     MinOccurs = Zero;
//                 }
//                 fieldelement(Location; Vendor."Location Code")
//                 {
//                     MinOccurs = Zero;
//                 }



