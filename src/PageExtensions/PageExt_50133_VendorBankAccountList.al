pageextension 50133 VendorBankAccountList extends "Vendor Bank Account List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bank Account No.")
        {
            field("IFSC Description"; Rec."IFSC Description")
            {
                ApplicationArea = All;
            }
            field("IFSC"; Rec."IFSC")
            {
                ApplicationArea = All;
            }

            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
            }

            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
            }
            field("Vendor No."; Rec."Vendor No.")
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
        xml1: XMLport 5051;
        BankRecoStmt: Report 1408;
}