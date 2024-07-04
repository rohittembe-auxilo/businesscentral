pageextension 50181 TDSAdjustJournal extends "TDS Adjustment Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("External Document No.")
        {
            Editable = true;
            Visible = true;
        }
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
            group("Approval")
            {


                action(SendApprovalRequestJournalLine)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send Approval Request';
                    //    Enabled = not OpenApprovalEntriesOnBatchOrCurrJnlLineExist and CanRequestFlowApprovalForBatchAndCurrentLine and EnabledGenJnlLineWorkflowsExist;
                    Image = SendApprovalRequest;
                    ToolTip = 'Send selected TDS journal lines for approval.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        TDSJournalLine: Record "TDS Journal Line";
                        ApprovalsMgmt: Codeunit "Approval Management hook";
                    begin
                        GetCurrentlySelectedLines(TDSJournalLine);
                        ApprovalsMgmt.TrySendTaxJournalLineApprovalRequests(TDSJournalLine);
                        //     SetControlAppearanceFromBatch();
                    end;


                }
                action(CancelApprovalRequestJournalLine)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Request';
                    // Enabled = CanCancelApprovalForJnlLine or CanCancelFlowApprovalForLine;
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel sending selected TDS journal lines for approval.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        [SecurityFiltering(SecurityFilter::Filtered)]
                        TDSJournalLine: Record "TDS Journal Line";
                        ApprovalsMgmt: Codeunit "Approval Management hook";
                    begin
                        GetCurrentlySelectedLines(TDSJournalLine);
                        ApprovalsMgmt.TryCancelTaxJournalLineApprovalRequests(TDSJournalLine);
                    end;
                }

            }

        }
    }

    var
        myInt: Integer;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        fdgfd: page "General Journal";

    local procedure GetCurrentlySelectedLines(var TDSJournalLine: Record "TDS Journal Line"): Boolean
    begin
        CurrPage.SetSelectionFilter(TDSJournalLine);
        exit(TDSJournalLine.FindSet());
    end;
}