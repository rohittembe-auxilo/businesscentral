
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
                fieldelement(GST_Credit; "Fixed Asset"."GST Credit")
                {
                    MinOccurs = zero;
                }
                fieldelement(GST_Group; "Fixed Asset"."GST Group Code")

                {
                    MinOccurs = zero;
                }
                fieldelement(HSC; "Fixed Asset"."HSN/SAC Code")
                {
                    MinOccurs = zero;
                }


                //line

                textelement(Depreciation_Book_Code)
                {
                }
                textelement(FA_Posting_Group)
                {
                }
                textelement(Depreciation_Method)
                {
                }
                textelement("statingDate")
                {
                    MinOccurs = Zero;
                }
                textelement(Declining_Balance)
                {
                    MinOccurs = Zero;
                }
                textelement(No_of_DepreciationYear)
                {
                    MinOccurs = Zero;
                }
                textelement(No)
                {
                }

                trigger OnAfterInsertRecord()
                var
                    FixedLine: Record 5612;
                    Fixedheader: Record 5600;
                    "LineNo.": Integer;
                    Declining_Balance1: Decimal;
                    No_of_DepreciationYear1: Decimal;
                    statingDate1: Date;
                    FA_Class_code1: Code[15];
                begin
                    FixedLine.Reset();
                    FixedLine.Init();
                    FixedLine."FA No." := Fixedheader."No.";
                    FixedLine.Validate("FA No.", No);
                    FixedLine.Validate("Depreciation Book Code", Depreciation_Book_Code);
                    FixedLine.Validate("FA Posting Group", FA_Posting_Group);
                    if Depreciation_Method = 'Straight-Line' then
                        Fixedline.Validate("Depreciation Method", Fixedline."Depreciation Method"::"Straight-Line")
                    else
                        if Depreciation_Method = 'Declining-Balance 1' then
                            Fixedline.Validate("Depreciation Method", Fixedline."Depreciation Method"::"Declining-Balance 1")
                        else
                            if Depreciation_Method = 'Declining-Balance 2' then
                                Fixedline.Validate("Depreciation Method", Fixedline."Depreciation Method"::"Declining-Balance 2")
                            else
                                if Depreciation_Method = 'DB1/SL' then
                                    Fixedline.Validate("Depreciation Method", Fixedline."Depreciation Method"::"DB1/SL")
                                else
                                    if Depreciation_Method = 'DB2/SL' then
                                        Fixedline.Validate("Depreciation Method", Fixedline."Depreciation Method"::"DB2/SL")
                                    else
                                        if Depreciation_Method = 'User-Defined' then
                                            Fixedline.Validate("Depreciation Method", Fixedline."Depreciation Method"::"User-Defined")
                                        else
                                            if Depreciation_Method = 'Manual' then
                                                Fixedline.Validate("Depreciation Method", Fixedline."Depreciation Method"::Manual);

                    Evaluate(statingDate1, statingDate);
                    Fixedline.Validate("Depreciation Starting Date", statingDate1);
                    //Evaluate(Declining_Balance1, Declining_Balance);
                    Fixedline.Validate("Declining-Balance %", Declining_Balance1);
                    Evaluate(No_of_DepreciationYear1, No_of_DepreciationYear);
                    Fixedline.Validate("No. of Depreciation Years", No_of_DepreciationYear1);
                    Fixedline.Insert();
                    FixedLine.Modify();

                end;

            }

        }




    }
    trigger OnPostXmlPort()
    begin
        Message('FA uploaded successfully');
    end;
}


