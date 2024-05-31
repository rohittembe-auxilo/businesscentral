pageextension 50160 RequestToApprove extends "Requests to Approve"

{
    layout
    {
        // Add changes to page layout here
        addafter(Amount)
        {
            field("Debit Amount"; DebitAmt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Debit Amount';


            }
            field("Credit Amount"; CreditAmt)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Credit Amount';
            }
        }

    }


    actions
    {
        // Add changes to page actions here

    }
    trigger OnAfterGetRecord()
    begin
        if Rec.Amount > 0 then
            DebitAmt := Abs(rec.Amount)
        else
            CreditAmt := Abs(rec.Amount)

    end;

    var
        myInt: Integer;
        DebitAmt: Decimal;
        CreditAmt: Decimal;

}