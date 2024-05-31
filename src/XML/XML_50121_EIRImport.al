XmlPort 50121 "EIR Import"
{
    DefaultFieldsValidation = false;
    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = UTF16;

    schema
    {
        textelement(Root)
        {
            tableelement("EIR Header"; "EIR Header")
            {
                AutoSave = false;
                XmlName = 'EIRHeader';
                textelement(No)
                {
                }
                textelement(SchDate)
                {
                }
                textelement(CalculatedRate)
                {
                }
                textelement(RepayAmount)
                {
                }
                textelement(BalanceforPftCAL)
                {
                }
                textelement(DisbAmount)
                {
                }
                textelement(PrincipalSchd)
                {
                }
                textelement(ProfitCalc)
                {
                }
                textelement(CPZAMOUNT)
                {
                }
                textelement(ClosingBalance)
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    cnt += 1;
                    if cnt = 1 then
                        currXMLport.Skip;

                    Evaluate(NewNo, No);
                    if NewNo <> PrevNo then begin
                        EIRHeader.Init();
                        EIRHeader."No." := No;
                        EIRHeader.Insert();
                        EIRCnt := EIRCnt + 1;
                    end;
                    EirLine2.Reset();
                    EirLine2.SetRange("Document No.", No);
                    if EirLine2.FindLast then
                        "LineNo." := EirLine2."Line No." + 10000
                    else
                        "LineNo." := 10000;

                    EIRLine.Init();
                    EIRLine."Document No." := No;
                    EIRLine."Line No." := "LineNo.";
                    Evaluate(EIRLine."SCH Date", SchDate);
                    Evaluate(EIRLine."Calculated Rate", CalculatedRate);
                    Evaluate(EIRLine."Repay Amount", RepayAmount);
                    Evaluate(EIRLine."Balance for PFTCAL", BalanceforPftCAL);
                    Evaluate(EIRLine."Disb Amount", DisbAmount);
                    Evaluate(EIRLine."Principal SCHD", PrincipalSchd);
                    Evaluate(EIRLine."Profit Calculation", ProfitCalc);
                    Evaluate(EIRLine."CPZ Amount", CPZAMOUNT);
                    Evaluate(EIRLine."Closing Balance", ClosingBalance);
                    EIRLine.Insert(true);

                    PrevNo := '';
                    PrevNo := NewNo;
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
        Message('Total %1 lines uploaded successfully..', EIRCnt);
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

