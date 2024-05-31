XmlPort 50108 "Advances OD Report"
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
            tableelement("Advances OD Report"; "Advances OD Report")
            {
                XmlName = 'AdvancesODReport';
                fieldelement(DocNo; "Advances OD Report"."Document No.")
                {
                }
                fieldelement(LineNo; "Advances OD Report"."Line No.")
                {
                }
                fieldelement(RBICode; "Advances OD Report"."RBI Code")
                {
                }
                fieldelement(FINReference; "Advances OD Report"."FIN Reference")
                {
                }
                fieldelement(CustID; "Advances OD Report"."Cust ID")
                {
                }
                fieldelement(CustShortName; "Advances OD Report"."Cust Short Name")
                {
                }
                fieldelement(FInODSchdDate; "Advances OD Report".FINODSchdDate)
                {
                }
                fieldelement(FINCUrODDays; "Advances OD Report".FINCURODDays)
                {
                }
                fieldelement(FINCUrODAmount; "Advances OD Report".FINCURODAMT)
                {
                }
                fieldelement(FINCurODPRI; "Advances OD Report".FINCURODPRI)
                {
                }
                fieldelement(FInCurODPFT; "Advances OD Report".FINCURODPFT)
                {
                }
                fieldelement(Status; "Advances OD Report".Status)
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

