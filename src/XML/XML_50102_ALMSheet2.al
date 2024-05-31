XmlPort 50102 "ALM Sheet2"
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
            tableelement("ALM Sheet2"; "ALM Sheet2")
            {
                XmlName = 'ALMSheet';
                fieldelement(DocNo; "ALM Sheet2"."Document No.")
                {
                }
                fieldelement(LineNo; "ALM Sheet2"."Line No.")
                {
                }
                fieldelement(FileName; "ALM Sheet2"."File Name")
                {
                }
                fieldelement(Category; "ALM Sheet2".Category)
                {
                }
                fieldelement(Month; "ALM Sheet2".Date)
                {
                }
                fieldelement(Unamort; "ALM Sheet2".Unamort)
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    /*cnt+=1;
                    IF cnt=1 THEN
                      currXMLport.SKIP;
                      */
                    /*ALMSheet.INIT;
                    ALMSheet."Document No.":= DocNo;
                    EVALUATE("LineNo.",LineNo);
                    ALMSheet."Line No.":=   "LineNo.";
                    ALMSheet."File Name":=FileName;
                    ALMSheet.Category:= Category;
                    ALMSheet."Sr No.":= SrNo;
                    ALMSheet.Month:= Month;
                    EVALUATE(DDate,DueDate);
                    ALMSheet."Due Date":= DDate;
                    
                    ALMSheet.ROI:= Roi;
                    ALMSheet."Opening Balance":= OpeningBalance;
                    ALMSheet.Disbursement:=Disbursement;
                    ALMSheet.Principal:=Principal;
                    ALMSheet."Interest Due":= InterestDue;
                    //ALMSheet.in
                    ALMSheet.Installment := Installment;
                    ALMSheet."Closing Balance":= ClosingBalance;
                    ALMSheet.INSERT;
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
        EIRHeader: Record "EIR Header";
        EIRLine: Record "EIR Line";
        EirLine2: Record "EIR Line";
        ALMSheet: Record "ALM Sheet2";
        "LineNo.": Integer;
        DDate: Date;
}

