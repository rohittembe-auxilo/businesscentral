pageextension 50107 VendorLedgerEntries extends "Vendor Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("GST Reverse Charge")
        {

            field("RCM Invoice No"; Rec."RCM Invoice No")
            {
                ApplicationArea = All;
            }
            field("RCM Payment No"; Rec."RCM Payment No")
            {
                ApplicationArea = All;
            }
            field("MSME Type"; Rec."MSME Type")
            {
                ApplicationArea = All;
            }
            field("Purch. Order No."; Rec."Purch. Order No.")
            {
                ApplicationArea = All;
            }
            field("Bank Account Code"; Rec."Bank Account Code")
            {
                ApplicationArea = All;
            }
            field("Bank Account No."; Rec."Bank Account No.")
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
            field("Related party transaction"; Rec."Related party transaction")
            {
                ApplicationArea = All;
            }
            field("PO Type"; Rec."PO Type")
            {
                ApplicationArea = All;
            }
            field("PO Sub Type"; Rec."PO Sub Type")
            {
                ApplicationArea = All;
            }
            field("Total TDS Including SHE CESS"; Rec."Total TDS Including SHE CESS")
            {
                ApplicationArea = All;
            }
            field("Creation DateTime"; Rec."Creation DateTime")
            {
                ApplicationArea = All;
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
            }
            field("Recipient Bank Account"; Rec."Recipient Bank Account")
            {
                ApplicationArea = All;
            }
            field(Comment; Rec.Comment)
            {
                ApplicationArea = All;
            }
            field(Attachments; Rec.Attachments)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Applying Entry"; Rec."Applying Entry")
            {
                ApplicationArea = All;
            }
            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
            }
            field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
            {
                ApplicationArea = all;
            }
            field("Applies-to Ext. Doc. No."; Rec."Applies-to Ext. Doc. No.")
            {
                ApplicationArea = all;
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
            action("Print Voucher Auto Payment")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                begin
                    GLEntry.Reset();
                    ;
                    GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
                    GLEntry.SETRANGE("Document No.", rec."Document No.");
                    GLEntry.SETRANGE("Posting Date", rec."Posting Date");
                    IF GLEntry.FIND('-') THEN BEGIN
                        CLEAR(PostedVoucherAutoPaymentReport);
                        PostedVoucherAutoPaymentReport.SetParameter(rec."User ID");
                        PostedVoucherAutoPaymentReport.SETTABLEVIEW(GLEntry);
                        PostedVoucherAutoPaymentReport.RUNMODAL;
                    END;

                end;
            }
            action("Auto Payment Mail")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    VLEntry: Record "Vendor Ledger Entry";
                begin
                    VLEntry.RESET;
                    VLEntry.SETRANGE("Document No.", Rec."Document No.");
                    VLEntry.SETRANGE("Document Type", VLEntry."Document Type"::Payment);
                    REPORT.RUNMODAL(50106, TRUE, TRUE, VLEntry);


                end;
            }
            action("Auto Payment Mail From To Date")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    VLEntry: Record "Vendor Ledger Entry";

                begin
                    VLEntry.RESET;
                    VLEntry.SETRANGE("Document No.", Rec."Document No.");
                    VLEntry.SETRANGE("Document Type", VLEntry."Document Type"::Payment);
                    REPORT.RUNMODAL(50113, TRUE, TRUE, VLEntry);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VendorLedgerEntry2: Record "Vendor Ledger Entry";
    begin
        recvendor.GET(Rec."Vendor No.");
        "Vendor Name" := recvendor.Name;

        //>> ST
        AppliedDocNo := '';
        VendorLedgerEntry.RESET();
        VendorLedgerEntry.SETRANGE("Document No.", Rec."Document No.");
        IF VendorLedgerEntry.FindFirst() THEN
            repeat
                VendorLedgerEntry2.RESET();
                VendorLedgerEntry2.SETRANGE("Closed by Entry No.", VendorLedgerEntry."Entry No.");
                IF VendorLedgerEntry2.FindSet() THEN
                    REPEAT
                        AppliedDocNo := AppliedDocNo + VendorLedgerEntry2."Document No." + '   ';
                    UNTIL VendorLedgerEntry2.NEXT = 0;

                if VendorLedgerEntry."Closed by Entry No." <> 0 then begin
                    VendorLedgerEntry2.RESET();
                    VendorLedgerEntry2.SETRANGE("Entry No.", VendorLedgerEntry."Closed by Entry No.");
                    IF VendorLedgerEntry2.FindSet() THEN
                        REPEAT
                            AppliedDocNo := AppliedDocNo + VendorLedgerEntry2."Document No." + '   ';
                        UNTIL VendorLedgerEntry2.NEXT = 0;
                end;
            until VendorLedgerEntry.Next() = 0;
        //<< ST
    END;

    var
        recvendor: Record vendor;
        "Vendor Name": Text;
        PostedVoucherAutoPaymentReport: Report "Posted Voucher Auto Payment";
        AppliedDocNo: Text;

}