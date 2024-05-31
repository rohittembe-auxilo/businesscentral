XmlPort 50111 "Advances ECL"
{
    DefaultFieldsValidation = false;
    Direction = Both;
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = UTF16;

    schema
    {
        textelement(Root)
        {
            tableelement("Advances ECL"; "Advances ECL")
            {
                XmlName = 'AdvancesECL';
                fieldelement(DocNo; "Advances ECL"."Document No.")
                {
                }
                fieldelement(LineNo; "Advances ECL"."Line No.")
                {
                }
                fieldelement(RBICode; "Advances ECL"."RBI Code")
                {
                }
                fieldelement(PostingDate; "Advances ECL"."Posting Date")
                {
                }
                fieldelement(CustID; "Advances ECL"."Cust ID")
                {
                }
                fieldelement(Stage; "Advances ECL".Stage)
                {
                }
                fieldelement(ECL; "Advances ECL".ECL)
                {
                }
                fieldelement(Status; "Advances ECL".Status)
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
    begin
        Message('Processed successfully..');
    end;

    trigger OnPreXmlPort()
    begin
        cnt := 0;
        EIRCnt := 0;
    end;

    var
        lastEntryNo: Integer;
        cnt: Integer;
        EIRCnt: Integer;
        NewNo: Code[25];
        PrevNo: Code[25];
        // AdvanceCLBalance: Record UnknownRecord50007;
        "LineNo.": Integer;
        DDate: Date;
}

