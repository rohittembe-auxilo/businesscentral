pageextension 50173 GLSetup extends "General Ledger Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bank Account Nos.")
        {
            field("Bank Pay Pro File Nos."; Rec."Bank Pay Pro File Nos.")
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