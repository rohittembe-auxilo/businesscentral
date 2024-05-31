pageextension 50130 BankAccountLedgerEntries extends "Bank Account Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Global Dimension 1 Code")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
            field("Party Code"; Rec."Party Code")
            {
                ApplicationArea = All;
            }

            field("Recipient Bank Account"; Rec."Recipient Bank Account")
            {
                ApplicationArea = All;
            }
            field("Bank Account Code"; Rec."Bank Account Code")
            {
                ApplicationArea = All;
            }
            field("VenBank Account No."; Rec."VenBank Account No.")
            {
                ApplicationArea = All;
            }
            field("Bank Account Name"; Rec."Bank Account Name")
            {
                ApplicationArea = All;
            }
            field("Bank Account IFSC"; Rec."Bank Account IFSC")
            {
                ApplicationArea = All;
            }
            field("Bank Account E-Mail"; Rec."Bank Account E-Mail")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 8"; Rec."Shortcut Dimension 8")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Print Voucher")
        {
            action("Print Voucher New")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                    PostedVoucherReport: Report "Posted Voucher New";
                begin
                    GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
                    GLEntry.SETRANGE("Document No.", rec."Document No.");
                    GLEntry.SETRANGE("Posting Date", rec."Posting Date");
                    IF GLEntry.FINDFIRST THEN BEGIN
                        CLEAR(PostedVoucherReport);
                        PostedVoucherReport.SetParameter(rec."User ID");
                        PostedVoucherReport.SETTABLEVIEW(GLEntry);
                        PostedVoucherReport.RUNMODAL;
                        // REPORT.RUNMODAL(REPORT::"Posted Voucher",TRUE,TRUE,GLEntry);
                        // PostedVoucherReport.RUN(GLEntry);
                    END;



                end;
            }
        }
    }

    var
        myInt: Integer;
}