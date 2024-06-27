pageextension 50186 FixedAssetCard extends "Fixed Asset Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("FA Location Code")
        {
            field("Asset Tag no."; Rec."Asset Tag no.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Fixed &Asset")
        {
            group("Approval")
            {


                action(SendApprovalRequestJournalLine)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send Approval Request';
                    //    Enabled = not OpenApprovalEntriesOnBatchOrCurrJnlLineExist and CanRequestFlowApprovalForBatchAndCurrentLine and EnabledGenJnlLineWorkflowsExist;
                    Image = SendApprovalRequest;
                    ToolTip = 'Send Fixed Asset for approval.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var

                        ApprovalsMgmt: Codeunit "Approval Management hook";
                    begin


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
                        //   GetCurrentlySelectedLines(TDSJournalLine);
                        //  ApprovalsMgmt.TryCancelTaxJournalLineApprovalRequests(TDSJournalLine);
                    end;
                }

            }

        }
    }

    var
        myInt: Integer;
}