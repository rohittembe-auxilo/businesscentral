XmlPort 50107 "Advances CustID"
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
            tableelement("Advances Cust ID"; "Advances Cust ID")
            {
                XmlName = 'AdvancesCustWise';
                fieldelement(DocNo; "Advances Cust ID"."Document No.")
                {
                }
                fieldelement(LineNo; "Advances Cust ID"."Line No.")
                {
                }
                fieldelement(RBICode; "Advances Cust ID"."RBI Code")
                {
                }
                fieldelement(FINReference; "Advances Cust ID"."FIN Reference")
                {
                }
                fieldelement(CustID; "Advances Cust ID"."Cust ID")
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
        //  AdvanceCLBalance: Record UnknownRecord50007;
        "LineNo.": Integer;
        DDate: Date;
}

