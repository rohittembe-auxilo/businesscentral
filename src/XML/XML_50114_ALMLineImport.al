XmlPort 50114 "ALM Line Import"
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
            tableelement(Integer; Integer)
            {
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'ALMHeader';
                UseTemporary = true;
                textelement(DocNo)
                {
                }
                textelement(SourceCode)
                {
                    MinOccurs = Zero;
                }
                textelement(RBICode)
                {
                    MinOccurs = Zero;
                }
                textelement(OneTo7days)
                {
                    MinOccurs = Zero;
                }
                textelement(Eightto14days)
                {
                    MinOccurs = Zero;
                }
                textelement(Fifteento1month)
                {
                    MinOccurs = Zero;
                }
                textelement(onemonthto2month)
                {
                    MinOccurs = Zero;
                }
                textelement(Twomonthto3month)
                {
                    MinOccurs = Zero;
                }
                textelement(Threemonthto6month)
                {
                    MinOccurs = Zero;
                }
                textelement(Sixmonthto1year)
                {
                    MinOccurs = Zero;
                }
                textelement(Oneyearto3year)
                {
                    MinOccurs = Zero;
                }
                textelement(Threeyearto5year)
                {
                    MinOccurs = Zero;
                }
                textelement(overfiveyears)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                    cnt += 1;
                    if cnt = 1 then
                        currXMLport.Skip;
                    //MESSAGE(SourceCode);
                    ALMLineRec.Reset();
                    ALMLineRec.SetFilter("Document No.", DocNo);  //ALMLineRec.SETFILTER(Source,'%1','*'+SourceCode+'*');
                    ALMLineRec.SetFilter("RBI Code", RBICode);
                    //ALMLineRec.SETFILTER(Source,SourceCode);
                    if ALMLineRec.Find('-') then begin
                        // RecGLAcc.SETFILTER("No.",ALMLineRec.Source);      //  newFilStr := CONVERTSTR(ALMLineRec.Source,'|',',');  //New
                        // IF RecGLAcc.FINDSET THEN
                        // REPEAT
                        // IF RecGLAcc."No." = SourceCode THEN     //IF STRPOS(SourceCode,RecGLAcc."No.") <> 0 THEN
                        //BEGIN
                        Evaluate(Oneto7, OneTo7days);
                        Evaluate(Eightto14, Eightto14days);
                        Evaluate(Fifteento1M, Fifteento1month);
                        Evaluate(OneMto2M, onemonthto2month);
                        Evaluate(TwoMto3M, Twomonthto3month);
                        Evaluate(ThreeMto6M, Threemonthto6month);
                        Evaluate(SixMto1Y, Sixmonthto1year);
                        Evaluate(OneYto3Y, Oneyearto3year);
                        Evaluate(ThreeYto5Y, Threeyearto5year);
                        Evaluate(Over5Y, overfiveyears);

                        ALMLineRec."1 to 7 days" += Oneto7;
                        ALMLineRec."8 to 14 days" += Eightto14;
                        ALMLineRec."15 to 1 Month" += Fifteento1M;
                        ALMLineRec."1 Month to 2 Months" += OneMto2M;
                        ALMLineRec."2 Month to 3 Months" += TwoMto3M;
                        ALMLineRec."3 Month To 6 Months" += ThreeMto6M;
                        ALMLineRec."6 Month To 1 Year" += SixMto1Y;
                        ALMLineRec."1 Year to 3 Year" += OneYto3Y;
                        ALMLineRec."3 year to 5 Years" += ThreeYto5Y;
                        ALMLineRec."Over 5 Years" += Over5Y;

                        ALMLineRec.Modify(true);
                        //END;
                        //UNTIL RecGLAcc.NEXT = 0;
                        // MESSAGE('Record Modifyed');
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
            Message('ALM line updated successfully..');
    end;

    trigger OnPreXmlPort()
    begin
        cnt := 0;
    end;

    var
        ALMLineRec: Record "ALM Lines";
        Oneto7: Decimal;
        Eightto14: Decimal;
        Fifteento1M: Decimal;
        OneMto2M: Decimal;
        TwoMto3M: Decimal;
        ThreeMto6M: Decimal;
        SixMto1Y: Decimal;
        OneYto3Y: Decimal;
        ThreeYto5Y: Decimal;
        Over5Y: Decimal;
        cnt: Integer;
        RecGLAcc: Record "G/L Account";
        newFilStr: Text;
}

