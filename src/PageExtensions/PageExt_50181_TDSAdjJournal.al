pageextension 50181 TDSAdjustJournal extends "TDS Adjustment Journal"
{
    layout
    {
        // Add changes to page layout here
        addlast(Line)
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
            }
        }

        modify("External Document No.")
        {
            Editable = true;
            Visible = true;
        }
    }

    actions
    {
        //>> ST
        modify("P&ost")
        {
            trigger OnBeforeAction()
            var
                TDSJournalLine: Record "TDS Journal Line";
            begin
                TDSJournalLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                TDSJournalLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                if TDSJournalLine.FindSet() then
                    repeat
                        TDSJournalLine.TestField(Status, TDSJournalLine.Status::Approved);
                    until TDSJournalLine.Next() = 0;
            end;
        }
        //<< ST

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

            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = not OpenApprovalEntriesExist and CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    ToolTip = 'Request approval to change the record.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        TDSJournalLine: Record "TDS Journal Line";
                    begin
                        CurrPage.SetSelectionFilter(TDSJournalLine);
                        if TDSJournalLine.FindSet() then
                            repeat
                                Clear(Recref);
                                Recref.GetTable(TDSJournalLine);
                                if CustomWorkflowManagement.CheckCustomWorkflowApprovalsWorkflowEnabled(RecRef) then begin
                                    CustomWorkflowManagement.OnSendWorkflowForApproval(RecRef);
                                end;
                            until TDSJournalLine.Next() = 0;

                        CurrPage.Update();
                        Message('Approval request sent successfully');
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord or CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel the approval request.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        TDSJournalLine: Record "TDS Journal Line";
                    begin
                        CurrPage.SetSelectionFilter(TDSJournalLine);
                        if TDSJournalLine.FindSet() then
                            repeat
                                Clear(Recref);
                                Recref.GetTable(TDSJournalLine);
                                CustomWorkflowManagement.OnCancelWorkflowApprovalRequest(RecRef);
                            until TDSJournalLine.Next() = 0;

                        CurrPage.Update();
                        Message('Approval request cancelled if any.');
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Enabled = Rec.Status <> Rec.Status::Open;
                    Image = ReOpen;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        TDSJournalLine: Record "TDS Journal Line";
                        Recref: RecordRef;
                    begin
                        CurrPage.SetSelectionFilter(TDSJournalLine);
                        if TDSJournalLine.FindSet() then
                            repeat
                                Clear(Recref);
                                TDSJournalLine.Get(TDSJournalLine."Journal Template Name", TDSJournalLine."Journal Batch Name", TDSJournalLine."Line No.");
                                Recref.GetTable(TDSJournalLine);
                                CustomWorkflowManagement.OnCancelWorkflowApprovalRequest(RecRef);
                                TDSJournalLine.FIND('=');
                                TDSJournalLine.Status := TDSJournalLine.Status::Open;
                                TDSJournalLine.Modify();
                            until TDSJournalLine.Next() = 0;

                        CurrPage.Update();
                        Message('All selected lines are now open');
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approvals';
                    //Enabled = OpenApprovalEntriesExistForCurrUser;
                    Image = Approvals;
                    ToolTip = 'Approvals.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
                // action(SendApprovalRequest2)
                // {
                //     ApplicationArea = Basic, Suite;
                //     Caption = 'Send A&pproval Request 2';
                //     Enabled = not OpenApprovalEntriesExist and CanRequestApprovalForFlow;
                //     Image = SendApprovalRequest;
                //     ToolTip = 'Request approval to change the record.';
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;

                //     trigger OnAction()
                //     var
                //         RecRef: RecordRef;
                //         TDSJournalLine: Record "TDS Journal Line";
                //     begin
                //         Recref.GetTable(Rec);
                //         if CustomWorkflowManagement.CheckCustomWorkflowApprovalsWorkflowEnabled(RecRef) then
                //             CustomWorkflowManagement.OnSendWorkflowForApproval(RecRef);

                //         Message('Approval request sent successfully');
                //     end;
                // }
                // action(Reopen2)
                // {
                //     ApplicationArea = Basic, Suite;
                //     Caption = 'Re&open2';
                //     Enabled = Rec.Status <> Rec.Status::Open;
                //     Image = ReOpen;
                //     ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;

                //     trigger OnAction()
                //     var
                //         Recref: RecordRef;
                //         TDSJournalLine: Record "TDS Journal Line";
                //     begin
                //         Clear(Recref);
                //         Recref.GetTable(Rec);
                //         CustomWorkflowManagement.OnCancelWorkflowApprovalRequest(RecRef);
                //         TDSJournalLine.Get(Rec."Journal Template Name", Rec."Journal Batch Name", Rec."Line No.");
                //         TDSJournalLine.Status := TDSJournalLine.Status::Open;
                //         TDSJournalLine.Modify();
                //         Message('All selected lines are now open');
                //     end;
                // }
            }
        }
    }

    // trigger OnModifyRecord()
    // begin
    //     if Rec.Status = Rec.Status::Approved then
    //         error('You can not change the record if status is approved.');
    // end;

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance();
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        DocumentErrorsMgt: Codeunit "Document Errors Mgt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;

    local procedure GetCurrentlySelectedLines(var TDSJournalLine: Record "TDS Journal Line"): Boolean
    begin
        CurrPage.SetSelectionFilter(TDSJournalLine);
        exit(TDSJournalLine.FindSet());
    end;

    var
        CustomWorkflowManagement: Codeunit CustomWorkflowManagement;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        CanCancelApprovalForRecord: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
}