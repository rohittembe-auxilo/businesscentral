#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50134 "gen.vaoucherXmlport"
{

    Format = VariableText;
    schema
    {
        textelement(root)
        {
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                XmlName = 'Gen_Voucher';
                MinOccurs = Once;
                fieldelement(JournalTemplateName; "Gen. Journal Line"."Journal Template Name")
                {
                }
                fieldelement(JournalBatchName; "Gen. Journal Line"."Journal Batch Name")
                {

                }
                fieldelement(lineno; "Gen. Journal Line"."Line No.")
                {

                }
                fieldelement(Posting_Date; "Gen. Journal Line"."Posting Date")
                {
                }
                fieldelement(Doc_NO; "Gen. Journal Line"."Document No.")
                {
                }
                fieldelement(Doc_Type; "Gen. Journal Line"."Document Type")
                {
                }
                fieldelement(Account_Type; "Gen. Journal Line"."Account Type")
                {
                }
                fieldelement(Account_No; "Gen. Journal Line"."Account No.")
                {
                }
                fieldelement(Debit_Amount; "Gen. Journal Line"."Debit Amount")
                {
                }
                fieldelement(Credit_Amount; "Gen. Journal Line"."Credit Amount")
                {
                }
                fieldelement(Balence_Acoount_Type; "Gen. Journal Line"."Bal. Account Type")
                {
                }
                fieldelement(Bal_Account_No; "Gen. Journal Line"."Bal. Account No.")
                {
                }
                fieldelement(Shortcut_Dimension_1; "Gen. Journal Line"."Shortcut Dimension 1 Code")
                {
                }
                fieldelement(Shortcut_Dimension_2; "Gen. Journal Line"."Shortcut Dimension 2 Code")
                {
                }

                fieldelement(Shortcut_Dimension_3; "Gen. Journal Line"."Shortcut Dimension 3")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Shortcut_Dimension_4; "Gen. Journal Line"."Shortcut Dimension 4")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Shortcut_Dimension_5; "Gen. Journal Line"."Shortcut Dimension 5")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Shortcut_Dimension_6; "Gen. Journal Line"."Shortcut Dimension 6")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Shortcut_Dimension_7; "Gen. Journal Line"."Shortcut Dimension 7")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Shortcut_Dimension_8; "Gen. Journal Line"."Shortcut Dimension 8")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Comment; "Gen. Journal Line".Comment)
                {

                }
                fieldelement(ExtDocNo; "Gen. Journal Line"."External Document No.")
                {

                }
                trigger OnAfterInsertRecord()
                var
                    postingDate: date;
                begin

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
    trigger OnPostXmlPort()
    begin
        Message(' uploaded successfully');
    end;

    var
        Debit_Amount1: Decimal;
        Credit_Amount1: Decimal;
}

