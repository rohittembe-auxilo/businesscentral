XmlPort 50123 "EIR Cost"
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
                textelement(Cost)
                {
                }

                trigger OnAfterInsertRecord()
                var
                    ImportedCost: Decimal;
                begin
                    cnt += 1;
                    if cnt = 1 then
                        currXMLport.Skip;

                    EIRLine.Reset();
                    EIRLine.SetRange("Document No.", No);
                    if EIRLine.FindFirst then begin
                        Evaluate(EIRLine.Cost, Cost);
                        EIRLine.Modify(true);
                    end;
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
        Message('Cost updated successfully..');
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

