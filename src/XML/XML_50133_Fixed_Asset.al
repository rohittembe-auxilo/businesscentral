
xmlport 50133 "Import Fixed Asset header"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Fixed Asset"; "Fixed Asset")
            {
                XmlName = 'FixedAsset';
                fieldelement(FixedAsset_No; "Fixed Asset"."No.")
                {
                }
                fieldelement(FixedAsset_Description; "Fixed Asset".Description)
                {
                }
                fieldelement(FA_Class_code; "Fixed Asset"."FA Class Code")
                {
                }
                fieldelement(FA_Sub_class_Code; "Fixed Asset"."FA Subclass Code")
                {
                }
                fieldelement(FA_Location; "Fixed Asset"."FA Location Code")
                {
                    MinOccurs = zero;
                }
                fieldelement(SerialNo; "Fixed Asset"."Serial No.")
                {
                }
                fieldelement(FAPostingGroup; "Fixed Asset"."FA Posting Group")
                {
                }
                fieldelement(GenProdPostingGroup; "Fixed Asset"."Gen. Prod. Posting Group")
                {
                }
                fieldelement(GST_Group; "Fixed Asset"."GST Group Code")

                {
                    MinOccurs = zero;
                }
                fieldelement(HSC; "Fixed Asset"."HSN/SAC Code")
                {
                    MinOccurs = zero;
                }
                fieldelement(GST_Credit; "Fixed Asset"."GST Credit")
                {
                    MinOccurs = zero;
                }
                fieldelement(AssetTagNo; "Fixed Asset"."Asset Tag no.")
                {
                    MinOccurs = zero;
                }

                //line

                textelement(Depreciation_Book_Code)
                {
                }
                textelement(Depreciation_Method)
                {
                }
                textelement("statingDate")
                {
                    MinOccurs = Zero;
                }
                textelement(No_of_DepreciationYear)
                {
                    MinOccurs = Zero;
                }
                textelement(No_of_DepreciationMonths)
                {
                    MinOccurs = Zero;
                }
                textelement(Declining_Balance)
                {
                    MinOccurs = Zero;
                }
                textelement(FA_Posting_Group)
                {
                }
                textelement("EndingDate")
                {
                    MinOccurs = Zero;
                }
                textelement(Description)
                {
                }

                trigger OnAfterInsertRecord()
                var
                    FADepreciationBook: Record "FA Depreciation Book";
                    "LineNo.": Integer;
                    Declining_Balance1: Decimal;
                    No_of_DepreciationYear1: Decimal;
                    No_of_DepreciationMonth1: Decimal;
                    statingDate1: Date;
                    FA_Class_code1: Code[15];
                begin
                    FADepreciationBook.Init();
                    FADepreciationBook.Validate("FA No.", "Fixed Asset"."No.");
                    FADepreciationBook.Validate("Depreciation Book Code", Depreciation_Book_Code);
                    FADepreciationBook.Validate("FA Posting Group", FA_Posting_Group);
                    if Depreciation_Method = 'Straight-Line' then
                        FADepreciationBook.Validate("Depreciation Method", FADepreciationBook."Depreciation Method"::"Straight-Line")
                    else
                        if Depreciation_Method = 'Declining-Balance 1' then
                            FADepreciationBook.Validate("Depreciation Method", FADepreciationBook."Depreciation Method"::"Declining-Balance 1")
                        else
                            if Depreciation_Method = 'Declining-Balance 2' then
                                FADepreciationBook.Validate("Depreciation Method", FADepreciationBook."Depreciation Method"::"Declining-Balance 2")
                            else
                                if Depreciation_Method = 'DB1/SL' then
                                    FADepreciationBook.Validate("Depreciation Method", FADepreciationBook."Depreciation Method"::"DB1/SL")
                                else
                                    if Depreciation_Method = 'DB2/SL' then
                                        FADepreciationBook.Validate("Depreciation Method", FADepreciationBook."Depreciation Method"::"DB2/SL")
                                    else
                                        if Depreciation_Method = 'User-Defined' then
                                            FADepreciationBook.Validate("Depreciation Method", FADepreciationBook."Depreciation Method"::"User-Defined")
                                        else
                                            if Depreciation_Method = 'Manual' then
                                                FADepreciationBook.Validate("Depreciation Method", FADepreciationBook."Depreciation Method"::Manual);

                    Evaluate(statingDate1, statingDate);
                    FADepreciationBook.Validate("Depreciation Starting Date", statingDate1);
                    Evaluate(No_of_DepreciationYear1, No_of_DepreciationYear);
                    FADepreciationBook.Validate("No. of Depreciation Years", No_of_DepreciationYear1);
                    Evaluate(No_of_DepreciationMonth1, No_of_DepreciationMonths);
                    FADepreciationBook.Validate("No. of Depreciation Months", No_of_DepreciationMonth1);
                    Evaluate(Declining_Balance1, Declining_Balance);
                    FADepreciationBook.Validate("Declining-Balance %", Declining_Balance1);
                    FADepreciationBook.Validate("FA Posting Group", FA_Posting_Group);
                    Evaluate(FADepreciationBook."Depreciation Ending Date", EndingDate);
                    FADepreciationBook.Validate("Depreciation Ending Date");
                    FADepreciationBook.Validate(Description, Description);
                    FADepreciationBook.Insert();
                    FADepreciationBook.Modify();
                end;
            }
        }
    }
    trigger OnPostXmlPort()
    begin
        Message('FA uploaded successfully');
    end;
}