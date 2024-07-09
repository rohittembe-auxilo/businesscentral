#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50137 "vendor_bank_account Xmlport"
{
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement("Vendor Bank Account"; "Vendor Bank Account")
            {
                XmlName = 'vendor_bank_account';
                MinOccurs = Once;
                fieldelement(Vendor_Code; "Vendor Bank Account"."Vendor No.")
                {
                }
                fieldelement(Name; "Vendor Bank Account".Name)
                {
                }
                fieldelement(Code; "Vendor Bank Account".Code)
                {
                }
                fieldelement(BankAccountAddress; "Vendor Bank Account".Address)
                {
                }
                fieldelement(BankAccountAddress2; "Vendor Bank Account"."Address 2")
                {
                }
                fieldelement(Post_Code; "Vendor Bank Account"."Post Code")
                {
                }
                fieldelement(City; "Vendor Bank Account".City)
                {
                }
                // fieldelement(State; "Vendor Bank Account"."Country/Region Code")
                // {
                // }
                fieldelement(Country; "Vendor Bank Account".County)
                {
                }
                fieldelement(Phone_No; "Vendor Bank Account"."Phone No.")
                {
                }
                fieldelement(Bank_Branch_No; "Vendor Bank Account"."Bank Branch No.")
                {
                }
                fieldelement(Bank_Acount_NO; "Vendor Bank Account"."Bank Account No.")
                {
                }
                fieldelement(IFSC; "Vendor Bank Account".IFSC)
                {
                    MinOccurs = Zero;
                }
                fieldelement(ReceiverA_ctype; "Vendor Bank Account"."Receiver A/c type")
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
                    SalesnRecSetup: Record "Sales & Receivables Setup";
                begin
                    Recvendor.Reset();
                    Recvendor.SetRange("No.", "Vendor Bank Account"."Vendor No.");
                    if Recvendor.Find('-') then begin
                        Recvendor.Validate(Blocked, Recvendor.Blocked::All);
                        Recvendor.Modify();
                    end;

                    //    SalesnRecSetup.Get();
                    //  Recvendor.Validate("No.", Noseriesmgmt.GetNextNo(SalesnRecSetup."Customer Nos.", Today, true));
                    //  Recvendor.Insert();
                    //  Recvendor.Modify();



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
        Message('vendor_bank_account uploaded successfully');
    end;
}

