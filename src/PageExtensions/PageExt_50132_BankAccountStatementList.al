pageextension 50132 BankAccountStatementList extends "Bank Account Statement List"
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        // Add changes to page actions here
        addfirst(processing)

        {
            action("Bank Account Statement")
            {

                ApplicationArea = All;

                trigger OnAction()
                begin
                    BankRecoStmt.GetParameter(rec."Bank Account No.", rec."Statement Date", rec."Statement Ending Balance");
                    BankRecoStmt.RUN;

                end;
            }


        }
    }

    var
        myInt: Integer;
        // xml1: XMLport "Bank Acc. Reconcillation XML";
        BankRecoStmt: Report "Bank Reconcilation Statement";
}