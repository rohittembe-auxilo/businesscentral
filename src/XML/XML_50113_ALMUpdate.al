XmlPort 50113 "ALM Update"
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
            tableelement("ALM Lines"; "ALM Lines")
            {
                AutoSave = false;
                XmlName = 'ALMHeader';
                textelement(No)
                {
                }
                textelement(RBICode)
                {
                }
                textelement(BSFigure)
                {
                }
                textelement(OneTo7days)
                {
                }
                textelement(Eightto14days)
                {
                }
                textelement(Fifteento1month)
                {
                }
                textelement(onemonthto2month)
                {
                }
                textelement(Twomonthto3month)
                {
                }
                textelement(Threemonthto6month)
                {
                }
                textelement(Sixmonthto1year)
                {
                }
                textelement(Oneyearto3year)
                {
                }
                textelement(Threeyearto5year)
                {
                }
                textelement(overfiveyears)
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    cnt += 1;
                    if cnt = 1 then
                        currXMLport.Skip;

                    ALMLine.Reset();
                    ALMLine.SetRange("Document No.", '082021');
                    ALMLine.SetRange("RBI Code", RBICode);
                    if ALMLine.Find('-') then begin
                        Evaluate(ALMLine."1 to 7 days", OneTo7days);
                        Evaluate(ALMLine."8 to 14 days", Eightto14days);
                        Evaluate(ALMLine."15 to 1 Month", Fifteento1month);
                        Evaluate(ALMLine."1 Month to 2 Months", onemonthto2month);
                        Evaluate(ALMLine."2 Month to 3 Months", Twomonthto3month);
                        Evaluate(ALMLine."3 Month To 6 Months", Threemonthto6month);
                        Evaluate(ALMLine."6 Month To 1 Year", Sixmonthto1year);
                        Evaluate(ALMLine."1 Year to 3 Year", Oneyearto3year);
                        Evaluate(ALMLine."3 year to 5 Years", Threeyearto5year);
                        Evaluate(ALMLine."Over 5 Years", overfiveyears);

                        ALMLine.Modify;
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
        if GuiAllowed then
            Message('ALM updated successfully..');
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
        EirLine2: Record "EIR Line";
        "LineNo.": Integer;
        ALMLine: Record "ALM Lines";
}

