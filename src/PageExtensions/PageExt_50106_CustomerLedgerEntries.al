pageextension 50106 CustomerLedgerEntries extends "Customer Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("TDS Certificate Receivable")
        {
            field("Creation DateTime"; Rec."Creation DateTime")
            {
                ApplicationArea = All;
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
            }
            field(Attachments; Rec.Attachments)
            {
                ApplicationArea = all;
            }
            field("Cust. Name"; Rec."Cust. Name")
            {
                ApplicationArea = all;
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