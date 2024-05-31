XmlPort 50124 "LMS Vendor Date Import"
{
    Format = VariableText;

    schema
    {
        textelement(LMSDATA)
        {
            tableelement("LMS Vendor Data Stagings"; "LMS Vendor Data Stagings")
            {
                XmlName = 'LMSVENDORDATA';
                fieldattribute(No; "LMS Vendor Data Stagings"."No.")
                {
                }
                fieldattribute(Name; "LMS Vendor Data Stagings".Name)
                {
                }
                fieldattribute(Address; "LMS Vendor Data Stagings".Address)
                {
                }
                fieldattribute(Address2; "LMS Vendor Data Stagings"."Address 2")
                {
                }
                fieldattribute(City; "LMS Vendor Data Stagings".City)
                {
                }
                fieldattribute(Contact; "LMS Vendor Data Stagings".Contact)
                {
                }
                fieldattribute(PhoneNo; "LMS Vendor Data Stagings"."Phone No.")
                {
                }
                fieldattribute(GlobalDIM1; "LMS Vendor Data Stagings"."Global Dimension 1 Code")
                {
                }
                fieldattribute(GlobalDIM2; "LMS Vendor Data Stagings"."Global Dimension 2 Code")
                {
                }
                fieldattribute(VendPostGr; "LMS Vendor Data Stagings"."Vendor Posting Group")
                {
                }
                fieldattribute(PayTermCode; "LMS Vendor Data Stagings"."Payment Terms Code")
                {
                }
                fieldattribute(Country; "LMS Vendor Data Stagings"."Country/Region Code")
                {
                }
                fieldattribute(PayMetCode; "LMS Vendor Data Stagings"."Payment Method Code")
                {
                }
                fieldattribute(GenBusPostGr; "LMS Vendor Data Stagings"."Gen. Bus. Posting Group")
                {
                }
                fieldattribute(PostCode; "LMS Vendor Data Stagings"."Post Code")
                {
                }
                fieldattribute(EMail; "LMS Vendor Data Stagings"."E-Mail")
                {
                }
                fieldattribute(PanNo; "LMS Vendor Data Stagings"."P.A.N. No.")
                {
                }
                fieldattribute(StateCode; "LMS Vendor Data Stagings"."State Code")
                {
                }
                fieldattribute(Structure; "LMS Vendor Data Stagings".Structure)
                {
                }
                fieldattribute(GSTregNo; "LMS Vendor Data Stagings"."GST Registration No.")
                {
                }
                fieldattribute(GstVendType; "LMS Vendor Data Stagings"."GST Vendor Type")
                {
                }
                fieldattribute(NoSer; "LMS Vendor Data Stagings"."No. Series")
                {
                }
                fieldattribute(VendBankCode; "LMS Vendor Data Stagings".VendorBankCode)
                {
                }
                fieldattribute(BankName; "LMS Vendor Data Stagings"."Bank Name")
                {
                }
                fieldattribute(AccNo; "LMS Vendor Data Stagings"."Account No")
                {
                }
                fieldattribute(IFSC; "LMS Vendor Data Stagings"."IFSC Code")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    EntryNo += 1;
                end;

                trigger OnBeforeInsertRecord()
                begin
                    "LMS Vendor Data Stagings"."Entry No" := EntryNo;
                    //ERROR('%1',EntryNo);

                    if PLCLog.FindLast then
                        "LMS Vendor Data Stagings"."PLC Log No." := PLCLog."Entry No."
                    else
                        "LMS Vendor Data Stagings"."PLC Log No." := 1;
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

    trigger OnPreXmlPort()
    begin
        RecLMVendor.Reset;
        if RecLMVendor.FindLast then
            EntryNo := RecLMVendor."Entry No" + 1
        else
            EntryNo := 1;
    end;

    var
        RecLMVendor: Record "LMS Vendor Data Stagings";
        PLCLog: Record "PLC Logs";
        EntryNo: Integer;
}

