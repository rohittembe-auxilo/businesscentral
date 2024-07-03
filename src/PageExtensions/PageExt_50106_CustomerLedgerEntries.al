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
            field("Applying Entry"; Rec."Applying Entry")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Applies-to Ext. Doc. No."; Rec."Applies-to Ext. Doc. No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Applied Document No."; "AppliedDocNo")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Application Exists"; Rec.Amount <> Rec."Remaining Amount")
            {
                ApplicationArea = All;
                Editable = false;
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

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        //>> ST
        AppliedDocNo := '';
        CustLedgerEntry.RESET();
        CustLedgerEntry.SETRANGE("Document No.", Rec."Document No.");
        IF CustLedgerEntry.FindFirst() THEN
            repeat
                CustLedgerEntry2.RESET();
                CustLedgerEntry2.SETRANGE("Closed by Entry No.", CustLedgerEntry."Entry No.");
                IF CustLedgerEntry2.FindSet() THEN
                    REPEAT
                        AppliedDocNo := AppliedDocNo + CustLedgerEntry2."Document No." + '   ';
                    UNTIL CustLedgerEntry2.NEXT = 0;

                if CustLedgerEntry."Closed by Entry No." <> 0 then begin
                    CustLedgerEntry2.RESET();
                    CustLedgerEntry2.SETRANGE("Entry No.", CustLedgerEntry."Closed by Entry No.");
                    IF CustLedgerEntry2.FindSet() THEN
                        REPEAT
                            AppliedDocNo := AppliedDocNo + CustLedgerEntry2."Document No." + '   ';
                        UNTIL CustLedgerEntry2.NEXT = 0;
                end;
            until CustLedgerEntry.Next() = 0;
        //<< ST
    END;

    var
        CustLedgerEntry2: Record "Cust. Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        AppliedDocNo: Text;
}