XmlPort 50105 "Advances CL Balance"
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
            tableelement("Advance Cl Balances"; "Advance Cl Balances")
            {
                XmlName = 'AdvancesCLBalance';
                fieldelement(DocNo; "Advance Cl Balances"."Document No.")
                {
                }
                fieldelement(LineNo; "Advance Cl Balances"."Line No.")
                {
                }
                fieldelement(RBICode; "Advance Cl Balances"."RBI Code")
                {
                }
                fieldelement(FINReference; "Advance Cl Balances".FINReference)
                {
                }
                fieldelement(CustomerName; "Advance Cl Balances"."Customer Name")
                {
                }
                fieldelement(SchDate; "Advance Cl Balances"."Sch Date")
                {
                }
                fieldelement(ClosingBal; "Advance Cl Balances"."Closing Balance")
                {
                }
                fieldelement(SchMethod; "Advance Cl Balances"."Sch Method")
                {
                }
                fieldelement(QDate; "Advance Cl Balances"."Q Date")
                {
                }
                fieldelement(Status; "Advance Cl Balances".Status)
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
        AdvanceCLBalance: Record "Advance Cl Balances";
        "LineNo.": Integer;
        DDate: Date;
}

