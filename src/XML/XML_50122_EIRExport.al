XmlPort 50122 "EIR Export"
{
    DefaultFieldsValidation = false;
    Direction = Export;
    Format = VariableText;
    FormatEvaluate = Legacy;
    //v mig TextEncoding = MS"-";

    schema
    {
        textelement(Root)
        {
            tableelement("EIR Line"; "EIR Line")
            {
                AutoSave = false;
                XmlName = 'EIRLine';
                fieldelement(No; "EIR Line"."Document No.")
                {
                }
                fieldelement(SchDate; "EIR Line"."SCH Date")
                {
                }
                fieldelement(CalculatedRate; "EIR Line"."Calculated Rate")
                {
                }
                fieldelement(RepayAmount; "EIR Line"."Repay Amount")
                {
                }
                fieldelement(BalanceforPftCAL; "EIR Line"."Balance for PFTCAL")
                {
                }
                fieldelement(DisbAmount; "EIR Line"."Disb Amount")
                {
                }
                fieldelement(PrincipalSchd; "EIR Line"."Principal SCHD")
                {
                }
                fieldelement(ProfitCalc; "EIR Line"."Profit Calculation")
                {
                }
                fieldelement(CPZAMOUNT; "EIR Line"."CPZ Amount")
                {
                }
                fieldelement(ClosingBalance; "EIR Line"."Closing Balance")
                {
                }
                fieldelement(Cost; "EIR Line".Cost)
                {
                }
                fieldelement(EIR; "EIR Line".EIR)
                {
                }
                fieldelement(OpeningBalancr; "EIR Line"."Opening Balance")
                {
                }
                fieldelement(SchDateOut; "EIR Line"."SCH Date Out")
                {
                }
                fieldelement(RevisedDisbAmt; "EIR Line"."Revised Disburshment Amt")
                {
                }
                fieldelement(RepayAmtOut; "EIR Line"."Repay Amount Out")
                {
                }
                fieldelement(Interest; "EIR Line".Interest)
                {
                }
                fieldelement(ClosingBalanceOut; "EIR Line"."Closing Balance Out")
                {
                }
                fieldelement(Amortization; "EIR Line".Amortization)
                {
                }
                fieldelement(CumAmortization; "EIR Line"."Cumulative Amortization")
                {
                }
                fieldelement(Unamortization; "EIR Line".Unamortization)
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    /*cnt+=1;
                    IF cnt=1 THEN
                      currXMLport.SKIP;
                    
                    */

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
        Message('EIR exported successfully..');
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
        "LineNo.": Integer;
}

