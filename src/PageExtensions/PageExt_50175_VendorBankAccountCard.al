pageextension 50175 VendBankAccount extends "Vendor Bank Account Card"
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

            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
            }
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = All;
            }
            field("Receiver A/c type"; Rec."Receiver A/c type")
            {
                ApplicationArea = All;
            }

            field(Status; Rec.Status)
            {
                ApplicationArea = All;
            }
            field("Approver ID"; Rec."Approver ID")
            {
                ApplicationArea = All;
            }
            field("Approval DateTime"; Rec."Approval DateTime")
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