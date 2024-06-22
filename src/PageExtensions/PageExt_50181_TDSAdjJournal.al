pageextension 50181 TDSAdjustJournal extends "TDS Adjustment Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("P&ost")
        {
            action("Preview")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                Image = PreviewChecks;

                trigger OnAction()

                var
                    TDSAdjPost: Codeunit TaxJournalManagementHook;
                    GenJournalLine: Record "Gen. Journal Line";
                    zsc: Page 39;
                    GenJnlPost: Codeunit "Gen. Jnl.-Post";

                begin
                    GenJournalLine.Reset();
                    GenJournalLine.SetRange("Journal Batch Name", rec."Journal Batch Name");
                    GenJournalLine.SetRange("Journal Template Name", rec."Journal Template Name");
                    if GenJournalLine.FindSet() then
                        GenJournalLine.DeleteAll();

                    TDSAdjPost.PreviewTaxJournal(Rec);
                end;



            }
        }
    }

    var
        myInt: Integer;

}