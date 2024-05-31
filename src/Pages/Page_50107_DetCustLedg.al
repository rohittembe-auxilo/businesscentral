Page 50107 "Det Cust ledg"
{
    PageType = List;
    Permissions = TableData "Detailed Cust. Ledg. Entry" = rimd;
    SourceTable = "Detailed Cust. Ledg. Entry";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Cust. Ledger Entry No."; rec."Cust. Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Entry Type"; rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Document Type"; rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Document No."; rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Amount (LCY)"; rec."Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Customer No."; rec."Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code"; rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("User ID"; rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Source Code"; rec."Source Code")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction No."; rec."Transaction No.")
                {
                    ApplicationArea = Basic;
                }
                field("Journal Batch Name"; rec."Journal Batch Name")
                {
                    ApplicationArea = Basic;
                }
                field("Reason Code"; rec."Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field("Debit Amount"; rec."Debit Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Credit Amount"; rec."Credit Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Debit Amount (LCY)"; rec."Debit Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Credit Amount (LCY)"; rec."Credit Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Initial Entry Due Date"; rec."Initial Entry Due Date")
                {
                    ApplicationArea = Basic;
                }
                field("Initial Entry Global Dim. 1"; rec."Initial Entry Global Dim. 1")
                {
                    ApplicationArea = Basic;
                }
                field("Initial Entry Global Dim. 2"; rec."Initial Entry Global Dim. 2")
                {
                    ApplicationArea = Basic;
                }
                field("Gen. Bus. Posting Group"; rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Gen. Prod. Posting Group"; rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Use Tax"; rec."Use Tax")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Bus. Posting Group"; rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Prod. Posting Group"; rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Initial Document Type"; rec."Initial Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Applied Cust. Ledger Entry No."; rec."Applied Cust. Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(Unapplied; rec.Unapplied)
                {
                    ApplicationArea = Basic;
                }
                field("Unapplied by Entry No."; rec."Unapplied by Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Remaining Pmt. Disc. Possible"; rec."Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic;
                }
                field("Max. Payment Tolerance"; rec."Max. Payment Tolerance")
                {
                    ApplicationArea = Basic;
                }
                field("Tax Jurisdiction Code"; rec."Tax Jurisdiction Code")
                {
                    ApplicationArea = Basic;
                }
                field("Application No."; rec."Application No.")
                {
                    ApplicationArea = Basic;
                }
                field("Ledger Entry Amount"; rec."Ledger Entry Amount")
                {
                    ApplicationArea = Basic;
                }
                /* field("TDS Nature of Deduction"; rec."TDS Nature of Deduction")
                 {
                     ApplicationArea = Basic;
                 }
                 field("TDS Group"; rec."TDS Group")
                 {
                     ApplicationArea = Basic;
                 }
                 field("Total TDS/TCS Incl. SHECESS"; rec."Total TDS/TCS Incl. SHECESS")
                 {
                     ApplicationArea = Basic;
                 }
                 field("TCS Nature of Collection"; rec."TCS Nature of Collection")
                 {
                     ApplicationArea = Basic;
                 }
                 field("TCS Type"; rec."TCS Type")
                 {
                     ApplicationArea = Basic;
                 }
                 */
            }
        }
    }

    actions
    {
    }
}

