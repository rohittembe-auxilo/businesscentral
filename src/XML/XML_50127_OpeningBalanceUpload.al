XmlPort 50127
 "Opening Balance Upload"
{
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                XmlName = 'generaljournal';
                fieldelement(journaltemplate; "Gen. Journal Line"."Journal Template Name")
                {
                }
                fieldelement(journalbatch; "Gen. Journal Line"."Journal Batch Name")
                {
                }
                fieldelement("lineno."; "Gen. Journal Line"."Line No.")
                {
                }
                fieldelement(document; "Gen. Journal Line"."Document Type")
                {
                }
                fieldelement(posting; "Gen. Journal Line"."Posting Date")
                {
                }
                fieldelement(ext; "Gen. Journal Line"."External Document No.")
                {
                }
                fieldelement(docdate; "Gen. Journal Line"."Document Date")
                {
                }
                fieldelement(duedate; "Gen. Journal Line"."Due Date")
                {
                }
                fieldelement(docno; "Gen. Journal Line"."Document No.")
                {
                }
                fieldelement(act; "Gen. Journal Line"."Account Type")
                {
                }
                fieldelement("acno."; "Gen. Journal Line"."Account No.")
                {
                }
                fieldelement(desc; "Gen. Journal Line".Description)
                {
                }
                fieldelement(curcode; "Gen. Journal Line"."Currency Code")
                {
                }
                fieldelement(amount; "Gen. Journal Line".Amount)
                {
                }
                fieldelement(amtlcy; "Gen. Journal Line"."Amount (LCY)")
                {
                }
                fieldelement(balac; "Gen. Journal Line"."Bal. Account Type")
                {
                }
                fieldelement(bal; "Gen. Journal Line"."Bal. Account No.")
                {
                }
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
}

