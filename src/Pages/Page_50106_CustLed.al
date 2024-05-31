Page 50106 "Cust Led"
{
    PageType = List;
    Permissions = TableData "Cust. Ledger Entry" = rimd;
    SourceTable = "Cust. Ledger Entry";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Customer No."; rec."Customer No.")
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
                field(Description; rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code"; rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Remaining Amount"; rec."Remaining Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Original Amt. (LCY)"; rec."Original Amt. (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Remaining Amt. (LCY)"; rec."Remaining Amt. (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Amount (LCY)"; rec."Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Sales (LCY)"; rec."Sales (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Profit (LCY)"; rec."Profit (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Inv. Discount (LCY)"; rec."Inv. Discount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer No."; rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Posting Group"; rec."Customer Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Salesperson Code"; rec."Salesperson Code")
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
                field("On Hold"; rec."On Hold")
                {
                    ApplicationArea = Basic;
                }
                field("Applies-to Doc. Type"; rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                }
                field("Applies-to Doc. No."; rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic;
                }
                field(Open; rec.Open)
                {
                    ApplicationArea = Basic;
                }
                field("Due Date"; rec."Due Date")
                {
                    ApplicationArea = Basic;
                }
                field("Pmt. Discount Date"; rec."Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                }
                field("Original Pmt. Disc. Possible"; rec."Original Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic;
                }
                field("Pmt. Disc. Given (LCY)"; rec."Pmt. Disc. Given (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(Positive; rec.Positive)
                {
                    ApplicationArea = Basic;
                }
                field("Closed by Entry No."; rec."Closed by Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Closed at Date"; rec."Closed at Date")
                {
                    ApplicationArea = Basic;
                }
                field("Closed by Amount"; rec."Closed by Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Applies-to ID"; rec."Applies-to ID")
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
                field("Bal. Account Type"; rec."Bal. Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Bal. Account No."; rec."Bal. Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction No."; rec."Transaction No.")
                {
                    ApplicationArea = Basic;
                }
                field("Closed by Amount (LCY)"; rec."Closed by Amount (LCY)")
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
                field("Document Date"; rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("External Document No."; rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Calculate Interest"; rec."Calculate Interest")
                {
                    ApplicationArea = Basic;
                }
                field("Closing Interest Calculated"; rec."Closing Interest Calculated")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series"; rec."No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Closed by Currency Code"; rec."Closed by Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Closed by Currency Amount"; rec."Closed by Currency Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Adjusted Currency Factor"; rec."Adjusted Currency Factor")
                {
                    ApplicationArea = Basic;
                }
                field("Original Currency Factor"; rec."Original Currency Factor")
                {
                    ApplicationArea = Basic;
                }
                field("Original Amount"; rec."Original Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Date Filter"; rec."Date Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Remaining Pmt. Disc. Possible"; rec."Remaining Pmt. Disc. Possible")
                {
                    ApplicationArea = Basic;
                }
                field("Pmt. Disc. Tolerance Date"; rec."Pmt. Disc. Tolerance Date")
                {
                    ApplicationArea = Basic;
                }
                field("Max. Payment Tolerance"; rec."Max. Payment Tolerance")
                {
                    ApplicationArea = Basic;
                }
                field("Last Issued Reminder Level"; rec."Last Issued Reminder Level")
                {
                    ApplicationArea = Basic;
                }
                field("Accepted Payment Tolerance"; rec."Accepted Payment Tolerance")
                {
                    ApplicationArea = Basic;
                }
                field("Accepted Pmt. Disc. Tolerance"; rec."Accepted Pmt. Disc. Tolerance")
                {
                    ApplicationArea = Basic;
                }
                field("Pmt. Tolerance (LCY)"; rec."Pmt. Tolerance (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Amount to Apply"; rec."Amount to Apply")
                {
                    ApplicationArea = Basic;
                }
                field("IC Partner Code"; rec."IC Partner Code")
                {
                    ApplicationArea = Basic;
                }
                field("Applying Entry"; rec."Applying Entry")
                {
                    ApplicationArea = Basic;
                }
                field(Reversed; rec.Reversed)
                {
                    ApplicationArea = Basic;
                }
                field("Reversed by Entry No."; rec."Reversed by Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Reversed Entry No."; rec."Reversed Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(Prepayment; rec.Prepayment)
                {
                    ApplicationArea = Basic;
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field("Applies-to Ext. Doc. No."; rec."Applies-to Ext. Doc. No.")
                {
                    ApplicationArea = Basic;
                }
                field("Recipient Bank Account"; rec."Recipient Bank Account")
                {
                    ApplicationArea = Basic;
                }
                field("Message to Recipient"; rec."Message to Recipient")
                {
                    ApplicationArea = Basic;
                }
                field("Exported to Payment File"; rec."Exported to Payment File")
                {
                    ApplicationArea = Basic;
                }
                field("Dimension Set ID"; rec."Dimension Set ID")
                {
                    ApplicationArea = Basic;
                }
                field("Direct Debit Mandate ID"; rec."Direct Debit Mandate ID")
                {
                    ApplicationArea = Basic;
                }
                /*        field("TDS Nature of Deduction"; rec."TDS Nature of Deduction")
                        {
                            ApplicationArea = Basic;
                        }
                        field("TDS Group"; rec."TDS Group")
                        {
                            ApplicationArea = Basic;
                        }
                        field("Total TDS/TCS Incl SHE CESS"; rec."Total TDS/TCS Incl SHE CESS")
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

                        field("Serv. Tax on Advance Payment"; rec."Serv. Tax on Advance Payment")
                        {
                            ApplicationArea = Basic;
                        }
                        */
                field("TDS Certificate Receivable"; rec."TDS Certificate Receivable")
                {
                    ApplicationArea = Basic;
                }
                field("Certificate Received"; rec."Certificate Received")
                {
                    ApplicationArea = Basic;
                }
                field("Certificate No."; rec."Certificate No.")
                {
                    ApplicationArea = Basic;
                }
                field("TDS Certificate Rcpt Date"; rec."TDS Certificate Rcpt Date")
                {
                    ApplicationArea = Basic;
                }
                field("TDS Certificate Amount"; rec."TDS Certificate Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Financial Year"; rec."Financial Year")
                {
                    ApplicationArea = Basic;
                }
                /*   field("TDS Receivable Group"; rec."TDS Receivable Group")
                   {
                       ApplicationArea = Basic;
                   }
                   */
                field("TDS Certificate Received"; rec."TDS Certificate Received")
                {
                    ApplicationArea = Basic;
                }
                /*  field(PoT; rec.PoT)
                  {
                      ApplicationArea = Basic;
                  }
                  */
                field("Location Code"; rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("HSN/SAC Code"; rec."HSN/SAC Code")
                {
                    ApplicationArea = Basic;
                }
                field("GST on Advance Payment"; rec."GST on Advance Payment")
                {
                    ApplicationArea = Basic;
                }
                field("Adv. Pmt. Adjustment"; rec."Adv. Pmt. Adjustment")
                {
                    ApplicationArea = Basic;
                }
                field("GST Jurisdiction Type"; rec."GST Jurisdiction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Location State Code"; rec."Location State Code")
                {
                    ApplicationArea = Basic;
                }
                field("Seller State Code"; rec."Seller State Code")
                {
                    ApplicationArea = Basic;
                }
                field("Seller GST Reg. No."; rec."Seller GST Reg. No.")
                {
                    ApplicationArea = Basic;
                }
                field("GST Customer Type"; rec."GST Customer Type")
                {
                    ApplicationArea = Basic;
                }
                field("Location GST Reg. No."; rec."Location GST Reg. No.")
                {
                    ApplicationArea = Basic;
                }
                field("GST Group Code"; rec."GST Group Code")
                {
                    ApplicationArea = Basic;
                }
                field("Creation DateTime"; rec."Creation DateTime")
                {
                    ApplicationArea = Basic;
                }
                field("Creation Date"; rec."Creation Date")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
        }
    }
}

