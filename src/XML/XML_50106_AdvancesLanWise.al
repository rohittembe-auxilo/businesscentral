XmlPort 50106 "Advances LanWise"
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
            tableelement("Advances LanWise"; "Advances LanWise")
            {
                XmlName = 'AdvancesLanWise';
                fieldelement(DocNo; "Advances LanWise"."Document No.")
                {
                }
                fieldelement(LineNo; "Advances LanWise"."Line No.")
                {
                }
                fieldelement(RBICode; "Advances LanWise"."RBI Code")
                {
                }
                fieldelement(FINReference; "Advances LanWise"."FIN Reference")
                {
                }
                fieldelement(SchDate; "Advances LanWise"."SCH Date")
                {
                }
                fieldelement(CalculatedRate; "Advances LanWise"."Calculated Rate")
                {
                }
                fieldelement(RepayAmount; "Advances LanWise"."Repay Amount")
                {
                }
                fieldelement(BalanceForPFTCAL; "Advances LanWise"."Balance For PFTCAL")
                {
                }
                fieldelement(DisbAmount; "Advances LanWise".DisbAmount)
                {
                }
                fieldelement(PrincipalSchd; "Advances LanWise".PrincipalSchd)
                {
                }
                fieldelement(Profitschd; "Advances LanWise".ProfitSchd)
                {
                }
                fieldelement(CPZAAmount; "Advances LanWise"."CPZA Amount")
                {
                }
                fieldelement(ClosingBalance; "Advances LanWise"."Closing Balance")
                {
                }
                fieldelement(Status; "Advances LanWise".Status)
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

