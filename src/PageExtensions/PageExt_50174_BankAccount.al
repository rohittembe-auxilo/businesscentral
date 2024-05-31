pageextension 50174 BankAccount extends "Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bank Account No.2")
        {
            field(IFSC; Rec.IFSC)
            {
                ApplicationArea = All;
            }
            field("RTGS File Path"; Rec."RTGS File Path")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}