XmlPort 50100 "Bank Acc. Reconcillation XML"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Bank Acc. Reconciliation Line"; "Bank Acc. Reconciliation Line")
            {
                XmlName = 'BankAccReconsilationLine';
                fieldelement(ValueDate; "Bank Acc. Reconciliation Line"."Value Date")
                {
                }
                fieldelement(TxnPostedDate; "Bank Acc. Reconciliation Line"."Transaction Date")
                {
                }
                fieldelement(CheckNo; "Bank Acc. Reconciliation Line"."Check No.")
                {
                }
                fieldelement(Description; "Bank Acc. Reconciliation Line".Description)
                {
                }
                fieldelement(CRDR; "Bank Acc. Reconciliation Line".CRDR)
                {
                }
                fieldelement(StatementAmount; "Bank Acc. Reconciliation Line"."Statement Amount")
                {
                }
                fieldelement(Amt; "Bank Acc. Reconciliation Line".Amt)
                {
                }
                fieldelement(DocNo; "Bank Acc. Reconciliation Line"."Document No.")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    "Bank Acc. Reconciliation Line"."Bank Account No." := bankreco1."Bank Account No.";
                    "Bank Acc. Reconciliation Line"."Statement No." := bankreco1."Statement No.";
                    line := line + 1;
                    "Bank Acc. Reconciliation Line"."Statement Line No." := line;
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

    trigger OnPreXmlPort()
    begin


        bankrecoline.Reset;
        bankrecoline.SetRange("Bank Account No.", bankreco1."Bank Account No.");
        bankrecoline.SetRange("Statement No.", bankreco1."Statement No.");
        if bankrecoline.FindLast then
            line := bankrecoline."Statement Line No.";
    end;

    var
        bankreco1: Record "Bank Acc. Reconciliation";
        line: Integer;
        bankrecoline: Record "Bank Acc. Reconciliation Line";


    procedure getdata(bankreco: Record "Bank Acc. Reconciliation")
    begin
        bankreco1 := bankreco;
    end;
}

