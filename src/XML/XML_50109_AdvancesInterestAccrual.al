XmlPort 50109 "Advances Interest Accrual"
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
            tableelement("Advances Interest Accrual"; "Advances Interest Accrual")
            {
                XmlName = 'AdvancesInterestAccrual';
                fieldelement(DocNo; "Advances Interest Accrual"."Document No.")
                {
                }
                fieldelement(LineNo; "Advances Interest Accrual"."Line No.")
                {
                }
                fieldelement(RowLabels; "Advances Interest Accrual"."Row Labels")
                {
                }
                fieldelement(PostingDate; "Advances Interest Accrual"."Posting Date")
                {
                }
                fieldelement(SumOfInteresrAccrual; "Advances Interest Accrual"."Sum Of Interest Accrual")
                {
                }
                fieldelement(RBICode; "Advances Interest Accrual"."RBI Code")
                {
                }
                fieldelement(Status; "Advances Interest Accrual".Status)
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
        //   AdvanceCLBalance: Record UnknownRecord50007;
        "LineNo.": Integer;
        DDate: Date;
}

