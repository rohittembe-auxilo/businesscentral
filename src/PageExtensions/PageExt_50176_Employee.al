pageextension 50176 Employee extends "Employee Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bank Account No.")
        {
            field("ESI No."; Rec."ESI No.")
            {
                ApplicationArea = All;
            }
            field("PF No."; Rec."PF No.")
            {
                ApplicationArea = All;
            }
            field("UAN No."; Rec."UAN No.")
            {
                ApplicationArea = All;
            }
            field("Aadhar No."; Rec."Aadhar No.")
            {
                ApplicationArea = All;
            }
            field("Bank A/C No."; Rec."Bank A/C No.")
            {
                ApplicationArea = All;
            }
            field("Bank Name"; Rec."Bank Name")
            {
                ApplicationArea = All;
            }
            field("IFSC Code"; Rec."IFSC Code")
            {
                ApplicationArea = All;
            }
            field(Branch; Rec.Branch)
            {
                ApplicationArea = All;
            }
            field("Reporting Manager"; Rec."Reporting Manager")
            {
                ApplicationArea = All;
            }
            field("Emergency Contact Person"; Rec."Emergency Contact Person")
            {
                ApplicationArea = All;
            }
            field("Emergency Contact No."; Rec."Emergency Contact No.")
            {
                ApplicationArea = All;
            }
            field("Permanent Address"; Rec."Permanent Address")
            {
                ApplicationArea = All;
            }
            field("Permanent Address 2"; Rec."Permanent Address 2")
            {
                ApplicationArea = All;
            }
            field("Permanent Post Code"; Rec."Permanent Post Code")
            {
                ApplicationArea = All;
            }
            field("Permanent City"; Rec."Permanent City")
            {
                ApplicationArea = All;
            }
            field("Permanent Country/Region Code"; Rec."Permanent Country/Region Code")
            {
                ApplicationArea = All;
            }
            field("Recruitment Type"; Rec."Recruitment Type")
            {
                ApplicationArea = All;
            }
            field("Reffered By"; Rec."Reffered By")
            {
                ApplicationArea = All;
            }
            field("SIM Card"; Rec."SIM Card")
            {
                ApplicationArea = All;
            }
            field("Eligible Tele. Expense Amt."; Rec."Eligible Tele. Expense Amt.")
            {
                ApplicationArea = All;
            }
            field("Petty Cash User"; Rec."Petty Cash User")
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