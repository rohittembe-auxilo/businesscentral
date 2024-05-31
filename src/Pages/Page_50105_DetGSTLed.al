Page 50105 "Det GST Led"
{
    PageType = List;
    Permissions = TableData "Detailed GST Ledger Entry" = rimd;
    SourceTable = "Detailed GST Ledger Entry";
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
                field("Entry Type"; rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type"; rec."Transaction Type")
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
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(Type; rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Product Type"; rec."Product Type")
                {
                    ApplicationArea = Basic;
                }
                field("Source Type"; rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field("Source No."; rec."Source No.")
                {
                    ApplicationArea = Basic;
                }
                field("HSN/SAC Code"; rec."HSN/SAC Code")
                {
                    ApplicationArea = Basic;
                }
                field("GST Component Code"; rec."GST Component Code")
                {
                    ApplicationArea = Basic;
                }
                field("GST Group Code"; rec."GST Group Code")
                {
                    ApplicationArea = Basic;
                }
                field("GST Jurisdiction Type"; rec."GST Jurisdiction Type")
                {
                    ApplicationArea = Basic;
                }
                field("GST Base Amount"; rec."GST Base Amount")
                {
                    ApplicationArea = Basic;
                }
                field("GST %"; rec."GST %")
                {
                    ApplicationArea = Basic;
                }
                field("GST Amount"; rec."GST Amount")
                {
                    ApplicationArea = Basic;
                }
                field("External Document No."; rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Amount Loaded on Item"; rec."Amount Loaded on Item")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("GST Without Payment of Duty"; rec."GST Without Payment of Duty")
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account No."; rec."G/L Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Reversed by Entry No."; rec."Reversed by Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(Reversed; rec.Reversed)
                {
                    ApplicationArea = Basic;
                }
                /*    field("User ID"; rec."User ID")
                    {
                        ApplicationArea = Basic;
                    }
                    field(Positive; rec.Positive)
                    {
                        ApplicationArea = Basic;
                    }
                    */
                field("Document Line No."; rec."Document Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Item Charge Entry"; rec."Item Charge Entry")
                {
                    ApplicationArea = Basic;
                }
                field("Reverse Charge"; rec."Reverse Charge")
                {
                    ApplicationArea = Basic;
                }
                field("GST on Advance Payment"; rec."GST on Advance Payment")
                {
                    ApplicationArea = Basic;
                }
                /* field("Nature of Supply"; rec."Nature of Supply")
                 {
                     ApplicationArea = Basic;
                 }
                 */
                field("Payment Document No."; rec."Payment Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("GST Exempted Goods"; rec."GST Exempted Goods")
                {
                    ApplicationArea = Basic;
                }
                /*   field("Location State Code"; rec."Location State Code")
                   {
                       ApplicationArea = Basic;
                   }

                   field("Buyer/Seller State Code"; rec."Buyer/Seller State Code")
                   {
                       ApplicationArea = Basic;
                   }
                   field("Shipping Address State Code"; rec."Shipping Address State Code")
                   {
                       ApplicationArea = Basic;
                   }
                   */
                field("Location  Reg. No."; rec."Location  Reg. No.")
                {
                    ApplicationArea = Basic;
                }
                field("Buyer/Seller Reg. No."; rec."Buyer/Seller Reg. No.")
                {
                    ApplicationArea = Basic;
                }
                field("GST Group Type"; rec."GST Group Type")
                {
                    ApplicationArea = Basic;
                }
                field("GST Credit"; rec."GST Credit")
                {
                    ApplicationArea = Basic;
                }
                field("Reversal Entry"; rec."Reversal Entry")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction No."; rec."Transaction No.")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code"; rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Factor"; rec."Currency Factor")
                {
                    ApplicationArea = Basic;
                }
                field("Application Doc. Type"; rec."Application Doc. Type")
                {
                    ApplicationArea = Basic;
                }
                field("Application Doc. No"; rec."Application Doc. No")
                {
                    ApplicationArea = Basic;
                }
                /*   field("Original Doc. Type"; rec."Original Doc. Type")
                   {
                       ApplicationArea = Basic;
                   }
                   field("Original Doc. No."; rec."Original Doc. No.")
                   {
                       ApplicationArea = Basic;
                   }
                   */
                field("Applied From Entry No."; rec."Applied From Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Reversed Entry No."; rec."Reversed Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Remaining Closed"; rec."Remaining Closed")
                {
                    ApplicationArea = Basic;
                }
                field("GST Rounding Precision"; rec."GST Rounding Precision")
                {
                    ApplicationArea = Basic;
                }
                field("GST Rounding Type"; rec."GST Rounding Type")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code"; rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("GST Customer Type"; rec."GST Customer Type")
                {
                    ApplicationArea = Basic;
                }
                field("GST Vendor Type"; rec."GST Vendor Type")
                {
                    ApplicationArea = Basic;
                }
                /* field("CLE/VLE Entry No."; rec."CLE/VLE Entry No.")
                 {
                     ApplicationArea = Basic;
                 }
                 field("Bill Of Export No."; rec."Bill Of Export No.")
                 {
                     ApplicationArea = Basic;
                 }

                 field("Bill Of Export Date"; rec."Bill Of Export Date")
                 {
                     ApplicationArea = Basic;
                 }
                 field("e-Comm. Merchant Id"; rec."e-Comm. Merchant Id")
                 {
                     ApplicationArea = Basic;
                 }
                 field("e-Comm. Operator GST Reg. No."; rec."e-Comm. Operator GST Reg. No.")
                 {
                   /  ApplicationArea = Basic;
                 }

                 field("Invoice Type"; rec."Invoice Type")
                 {
                     ApplicationArea = Basic;
                 }
                 */
                field("Original Invoice No."; rec."Original Invoice No.")
                {
                    ApplicationArea = Basic;
                }
                /* field("Original Invoice Date"; rec."Original Invoice Date")
                 {
                     ApplicationArea = Basic;
                 }
                 */
                field("Reconciliation Month"; rec."Reconciliation Month")
                {
                    ApplicationArea = Basic;
                }
                field("Reconciliation Year"; rec."Reconciliation Year")
                {
                    ApplicationArea = Basic;
                }
                field(Reconciled; rec.Reconciled)
                {
                    ApplicationArea = Basic;
                }
                field("Credit Availed"; rec."Credit Availed")
                {
                    ApplicationArea = Basic;
                }
                field(Paid; rec.Paid)
                {
                    ApplicationArea = Basic;
                }
                //   field("Amount to Customer/Vendor"; rec."Amount to Customer/Vendor")
                //   {
                //       ApplicationArea = Basic;
                //   }
                field("Credit Adjustment Type"; rec."Credit Adjustment Type")
                {
                    ApplicationArea = Basic;
                }
                //   field("Adv. Pmt. Adjustment"; rec."Adv. Pmt. Adjustment")
                //   {
                //       ApplicationArea = Basic;
                //   }
                //   field("Original Adv. Pmt Doc. No."; rec."Original Adv. Pmt Doc. No.")
                //   {
                //       ApplicationArea = Basic;
                //   }
                //   field("Original Adv. Pmt Doc. Date"; rec."Original Adv. Pmt Doc. Date")
                //   {
                //       ApplicationArea = Basic;
                //   }
                //   field("Payment Document Date"; rec."Payment Document Date")
                //   {
                //       ApplicationArea = Basic;
                //   }
                //   field(Cess; rec.Cess)
                //   {
                //       ApplicationArea = Basic;
                //   }
                field(UnApplied; rec.UnApplied)
                {
                    ApplicationArea = Basic;
                }
                //   field("Item Ledger Entry No."; rec."Item Ledger Entry No.")
                //   {
                //       ApplicationArea = Basic;
                //   }
                //  field("Credit Reversal"; rec."Credit Reversal")
                //  {
                //      ApplicationArea = Basic;
                //  }
                field("GST Place of Supply"; rec."GST Place of Supply")
                {
                    ApplicationArea = Basic;
                }
                // field("Item Charge Assgn. Line No."; rec."Item Charge Assgn. Line No.")
                // {
                //     ApplicationArea = Basic;
                // }
                field("Payment Type"; rec."Payment Type")
                {
                    ApplicationArea = Basic;
                }
                field(Distributed; rec.Distributed)
                {
                    ApplicationArea = Basic;
                }
                field("Distributed Reversed"; rec."Distributed Reversed")
                {
                    ApplicationArea = Basic;
                }
                field("Input Service Distribution"; rec."Input Service Distribution")
                {
                    ApplicationArea = Basic;
                }
                field(Opening; rec.Opening)
                {
                    ApplicationArea = Basic;
                }
                /*  field("Remaining Amount Closed"; rec."Remaining Amount Closed")
                  {
                      ApplicationArea = Basic;
                  }*/
                field("Remaining Base Amount"; rec."Remaining Base Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Remaining GST Amount"; rec."Remaining GST Amount")
                {
                    ApplicationArea = Basic;
                }
                /*  field("Gen. Bus. Posting Group"; rec."Gen. Bus. Posting Group")
                  {
                      ApplicationArea = Basic;
                  }
                  field("Gen. Prod. Posting Group"; rec."Gen. Prod. Posting Group")
                  {
                      ApplicationArea = Basic;
                  }
                  field("Reason Code"; rec."Reason Code")
                  {
                      ApplicationArea = Basic;
                  }*/
                field("Dist. Document No."; rec."Dist. Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Associated Enterprises"; rec."Associated Enterprises")
                {
                    ApplicationArea = Basic;
                }
                /*  field("Delivery Challan Amount"; rec."Delivery Challan Amount")
                  {
                      ApplicationArea = Basic;
                  }*/
                field("Liable to Pay"; rec."Liable to Pay")
                {
                    ApplicationArea = Basic;
                }
                /*     field("Subcon Document No."; rec."Subcon Document No.")
                     {
                         ApplicationArea = Basic;
                     }
                     */
                /*  field("Last Credit Adjusted Date"; rec."Last Credit Adjusted Date")
                  {
                      ApplicationArea = Basic;
                  }
                  */
                field("Dist. Input GST Credit"; rec."Dist. Input GST Credit")
                {
                    ApplicationArea = Basic;
                }
                /*   field("Component Calc. Type"; rec."Component Calc. Type")
                   {
                       ApplicationArea = Basic;
                   }
                   */
                /*    field("Cess Amount Per Unit Factor"; rec."Cess Amount Per Unit Factor")
                    {
                        ApplicationArea = Basic;
                    }

                    field("Cess UOM"; rec."Cess UOM")
                    {
                        ApplicationArea = Basic;
                    }
                    field("Cess Factor Quantity"; rec."Cess Factor Quantity")
                    {
                        ApplicationArea = Basic;
                    }
                    */
                field("Dist. Reverse Document No."; rec."Dist. Reverse Document No.")
                {
                    ApplicationArea = Basic;
                }
                /*  field(UOM; rec.UOM)
                  {
                      ApplicationArea = Basic;
                  }
                  */
                field("Shortcut Dimention 8 Code"; rec."Shortcut Dimention 8 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date"; rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Invoice No."; rec."Vendor Invoice No.")
                {
                    ApplicationArea = Basic;
                }
                field("Purchase Invoice Comment"; rec."Purchase Invoice Comment")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Date"; rec."Payment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Doc No."; rec."Payment Doc No.")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Name"; rec."Vendor Name")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

