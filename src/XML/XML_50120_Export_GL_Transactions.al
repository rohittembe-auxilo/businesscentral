/*XmlPort 50120 "Export GL Transactions"
{
    Format = VariableText;

    schema
    {
        textelement(LMSDATA)
        {
            tableelement("Gen. Journal Line Archive New"; "Gen. Journal Line Archive New")
            {
                XmlName = 'LMSGLTRANS';
                fieldattribute(JournalTempate; "Gen. Journal Line Archive New"."Journal Template Name")
                {
                }
                fieldattribute(JournalBatch; "Gen. Journal Line Archive New"."Journal Batch Name")
                {
                }
                fieldattribute(LineNo; "Gen. Journal Line Archive New"."Line No.")
                {
                }
                fieldattribute(PostingDate; "Gen. Journal Line Archive New"."Posting Date")
                {
                }
                fieldattribute(DocumentType; "Gen. Journal Line Archive New"."Document Type")
                {
                }
                fieldattribute(DocNo; "Gen. Journal Line Archive New"."Document No.")
                {
                }
                fieldattribute(ExternalDocNo; "Gen. Journal Line Archive New"."External Document No.")
                {
                }
                fieldattribute(AccountType; "Gen. Journal Line Archive New"."Account Type")
                {
                }
                fieldattribute(AccountNo; "Gen. Journal Line Archive New"."Account No.")
                {
                }
                fieldattribute(Disc; "Gen. Journal Line Archive New"."Payment Discount %")
                {
                }
                fieldattribute(LocCode; "Gen. Journal Line Archive New"."Location Code")
                {
                }
                fieldattribute(DebitAmt; "Gen. Journal Line Archive New"."Debit Amount")
                {
                }
                fieldattribute(CreditAmt; "Gen. Journal Line Archive New"."Credit Amount")
                {
                }
                fieldattribute(BalAccType; "Gen. Journal Line Archive New"."Bal. Account Type")
                {
                }
                fieldattribute(BalAccNo; "Gen. Journal Line Archive New"."Bal. Account No.")
                {
                }
                fieldattribute(GlobalDim1; "Gen. Journal Line Archive New"."Shortcut Dimension 1 Code")
                {
                }
                fieldattribute(GlobalDim2; "Gen. Journal Line Archive New"."Shortcut Dimension 2 Code")
                {
                }
                fieldattribute(ShortcutDimCode3; "Gen. Journal Line Archive New"."Shortcut Dimension 3 Code")
                {
                }
                fieldattribute(ShortcutDimCode4; "Gen. Journal Line Archive New"."Shortcut Dimension 4 Code")
                {
                }
                fieldattribute(ShortcutDimCode5; "Gen. Journal Line Archive New"."Shortcut Dimension 5 Code")
                {
                }
                fieldattribute(ShortcutDimCode6; "Gen. Journal Line Archive New"."Shortcut Dimension 6 Code")
                {
                }
                fieldattribute(ShortcutDimCode7; "Gen. Journal Line Archive New"."Shortcut Dimension 7 Code")
                {
                }
                fieldattribute(ShortcutDimCode8; "Gen. Journal Line Archive New"."Shortcut Dimension 8 Code")
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
        // RecLMSGL: Record UnknownRecord5219;
        // PLCLog: Record UnknownRecord50126;
        EntryNo: Integer;
}

*/
