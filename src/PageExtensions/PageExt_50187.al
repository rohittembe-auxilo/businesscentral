pageextension 50187 FixedAssetJournal extends "Fixed Asset G/L Journal"
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        // Add changes to page actions here
        addafter("Insert FA &Bal. Account")
        {
            group("Approval")
            {


                action(SendApprovalRequestJournalLine)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send Approval Request';
                    //    Enabled = not OpenApprovalEntriesOnBatchOrCurrJnlLineExist and CanRequestFlowApprovalForBatchAndCurrentLine and EnabledGenJnlLineWorkflowsExist;
                    Image = SendApprovalRequest;
                    ToolTip = 'Send selected journal lines for approval.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        GenJournalLine: Record "Gen. Journal Line";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        GetCurrentlySelectedLines(GenJournalLine);
                        ApprovalsMgmt.OnSendGeneralJournalLineForApproval(GenJournalLine);

                        //     SetControlAppearanceFromBatch();
                    end;


                }
                action(CancelApprovalRequestJournalLine)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Request';
                    // Enabled = CanCancelApprovalForJnlLine or CanCancelFlowApprovalForLine;
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel selected journal lines for approval.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        [SecurityFiltering(SecurityFilter::Filtered)]
                        GenJournalLine: Record "Gen. Journal Line";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        GetCurrentlySelectedLines(GenJournalLine);
                        ApprovalsMgmt.OnCancelGeneralJournalLineApprovalRequest(GenJournalLine);
                    end;
                }

            }

        }
    }

    local procedure GetCurrentlySelectedLines(var GenJournalLine: Record "Gen. Journal Line"): Boolean
    begin
        CurrPage.SetSelectionFilter(GenJournalLine);
        exit(GenJournalLine.FindSet());
    end;

    var
        myInt: Integer;
        bub: Page 39;
}