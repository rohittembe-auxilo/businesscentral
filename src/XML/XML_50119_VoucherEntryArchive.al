XmlPort 50119 "Voucher Entry Archive"
{
    Format = VariableText;

    schema
    {
        textelement(LMSDATA)
        {
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                XmlName = 'LMSGLTRANS';
                fieldattribute(JournalTempate; "Gen. Journal Line"."Journal Template Name")
                {
                }
                fieldattribute(JournalBatch; "Gen. Journal Line"."Journal Batch Name")
                {
                }
                fieldattribute(LineNo; "Gen. Journal Line"."Line No.")
                {
                }
                fieldattribute(PostingDate; "Gen. Journal Line"."Posting Date")
                {
                }
                fieldattribute(DocumentType; "Gen. Journal Line"."Document Type")
                {
                }
                fieldattribute(DocNo; "Gen. Journal Line"."Document No.")
                {
                }
                fieldattribute(ExternalDocNo; "Gen. Journal Line"."External Document No.")
                {
                }
                fieldattribute(AccountType; "Gen. Journal Line"."Account Type")
                {
                }
                fieldattribute(AccountNo; "Gen. Journal Line"."Account No.")
                {
                }
                fieldattribute(Disc; "Gen. Journal Line"."Payment Discount %")
                {
                }
                fieldattribute(LocCode; "Gen. Journal Line"."Location Code")
                {
                }
                fieldattribute(DebitAmt; "Gen. Journal Line"."Debit Amount")
                {
                }
                fieldattribute(CreditAmt; "Gen. Journal Line"."Credit Amount")
                {
                }
                fieldattribute(BalAccType; "Gen. Journal Line"."Bal. Account Type")
                {
                }
                fieldattribute(BalAccNo; "Gen. Journal Line"."Bal. Account No.")
                {
                }
                fieldattribute(GlobalDim1; "Gen. Journal Line"."Shortcut Dimension 1 Code")
                {
                }
                fieldattribute(GlobalDim2; "Gen. Journal Line"."Shortcut Dimension 2 Code")
                {
                }
                fieldattribute(ShortcutDimCode3; "Gen. Journal Line"."Shortcut Dimension 3")
                {
                }
                fieldattribute(ShortcutDimCode4; "Gen. Journal Line"."Shortcut Dimension 4")
                {
                }
                fieldattribute(ShortcutDimCode5; "Gen. Journal Line"."Shortcut Dimension 5")
                {
                }
                fieldattribute(ShortcutDimCode6; "Gen. Journal Line"."Shortcut Dimension 6")
                {
                }
                fieldattribute(ShortcutDimCode7; "Gen. Journal Line"."Shortcut Dimension 7")
                {
                }
                fieldattribute(ShortcutDimCode8; "Gen. Journal Line"."Shortcut Dimension 8")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    EntryNo += 1;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        EntryNo: Integer;
}

