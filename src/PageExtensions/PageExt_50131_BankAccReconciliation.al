pageextension 50131 BankAccReconciliation extends "Bank Acc. Reconciliation"
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        // Add changes to page actions here
        addafter(ImportBankStatement)
        {
            action(ImportBankStatementFromCSV)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    xml1.getdata(Rec);
                    xml1.RUN;
                end;
            }
            action(BankRecoReport)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    BankRecoStmt: Report 1408;
                begin
                    BankRecoStmt.RUN;

                end;
            }
        }
    }

    var
        myInt: Integer;
        xml1: XMLport "Bank Acc. Reconcillation XML";
}