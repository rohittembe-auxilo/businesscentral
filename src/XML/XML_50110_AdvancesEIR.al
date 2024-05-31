XmlPort 50110 "Advances EIR"
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
            tableelement("Advances EIR"; "Advances EIR")
            {
                XmlName = 'AdvancesEIR';
                fieldelement(DocNo; "Advances EIR"."Document No.")
                {
                }
                fieldelement(LineNo; "Advances EIR"."Line No.")
                {
                }
                fieldelement(LAN; "Advances EIR".LAN)
                {
                }
                fieldelement(PostingDate; "Advances EIR"."Posting Date")
                {
                }
                fieldelement(REvUnmort; "Advances EIR"."Rev Unmort")
                {
                }
                fieldelement(RBICode; "Advances EIR"."RBI Code")
                {
                }
                fieldelement(Status; "Advances EIR".Status)
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

