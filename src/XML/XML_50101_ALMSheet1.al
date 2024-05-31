XmlPort 50101 "ALM Sheet1"
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
            tableelement("ALM Sheet1"; "ALM Sheet1")
            {
                XmlName = 'ALMSheet';
                fieldelement(DocNo; "ALM Sheet1"."Document No.")
                {
                }
                fieldelement(LineNo; "ALM Sheet1"."Line No.")
                {
                }
                fieldelement(FileName; "ALM Sheet1"."File Name")
                {
                }
                fieldelement(Category; "ALM Sheet1".Category)
                {
                }
                fieldelement(RbiCode; "ALM Sheet1"."RBI Code")
                {
                }
                fieldelement(SrNo; "ALM Sheet1"."Sr No.")
                {
                }
                fieldelement(Month; "ALM Sheet1".Month)
                {
                }
                fieldelement(DueDate; "ALM Sheet1"."Due Date")
                {
                }
                fieldelement(Roi; "ALM Sheet1".ROI)
                {
                }
                fieldelement(OpeningBalance; "ALM Sheet1"."Opening Balance")
                {
                }
                fieldelement(Disbursement; "ALM Sheet1".Disbursement)
                {
                }
                fieldelement(Principal; "ALM Sheet1".Principal)
                {
                }
                fieldelement(Interest; "ALM Sheet1"."Interest Due")
                {
                }
                fieldelement(Installment; "ALM Sheet1".Installment)
                {
                }
                fieldelement(ClosingBalance; "ALM Sheet1"."Closing Balance")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    //cnt+=1;
                    //IF cnt=1 THEN
                    //  currXMLport.SKIP;

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
        ALMSheet: Record "ALM Sheet1";
        "LineNo.": Integer;
        DDate: Date;
}

