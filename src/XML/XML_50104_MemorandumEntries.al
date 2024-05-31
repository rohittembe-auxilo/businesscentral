XmlPort 50104 "Memorandum Entries"
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
            tableelement("Memorandom Entry"; "Memorandom Entry")
            {
                XmlName = 'MemorandumEntries';
                fieldelement(DocNo; "Memorandom Entry"."Document No.")
                {
                }
                fieldelement(Desc; "Memorandom Entry".Description)
                {
                }
                fieldelement(PostingDate; "Memorandom Entry"."Posting Date")
                {
                }
                fieldelement(DocType; "Memorandom Entry"."Document Type")
                {
                }
                fieldelement(GLAccNo; "Memorandom Entry"."G/L Account No.")
                {
                    FieldValidate = yes;
                }
                fieldelement(Amount; "Memorandom Entry".Amount)
                {
                    FieldValidate = yes;
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
        Message('Done..');
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
        EIRHeader: Record "EIR Header";
        EIRLine: Record "EIR Line";
        EirLine2: Record "EIR Line";
        //ALMSheet: Record UnknownRecord50004;
        "LineNo.": Integer;
        DDate: Date;
}

