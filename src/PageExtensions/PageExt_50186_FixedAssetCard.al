pageextension 50186 FixedAssetCard extends "Fixed Asset Card"
{
    layout
    {
        addafter(Blocked)
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    if (xRec.Blocked = true) and (rec.Blocked = false) then
                        Error('To unblock the fixed asset, please send the approval request.ss');
                end;
            }
        }
        // Add changes to page layout here
        addafter("FA Location Code")
        {
            field("Asset Tag no."; Rec."Asset Tag no.")
            {
                ApplicationArea = All;
            }
            field("Created DateTime"; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Caption = 'Created DateTime';
                Editable = false;
            }
            field("Created By"; CreatedBy)
            {
                ApplicationArea = All;
                Caption = 'Created By';
                Editable = false;
            }
            field("Modified DateTime"; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Caption = 'Modified DateTime';
                Editable = false;
            }
            field("Modified By"; ModifiedBy)
            {
                ApplicationArea = All;
                Caption = 'Modified By';
                Editable = false;
            }
        }
    }

    actions
    {
        addafter(Attachments)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested changes.';
                    //Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    ToolTip = 'Reject the approval request.';
                    //Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    //Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    ToolTip = 'View or add comments for the record.';
                    //Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    //Enabled = not OpenApprovalEntriesExist and CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    ToolTip = 'Request approval to change the record.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                    begin
                        Recref.GetTable(Rec);
                        if CustomWorkflowManagement.CheckCustomWorkflowApprovalsWorkflowEnabled(RecRef) then
                            CustomWorkflowManagement.OnSendWorkflowForApproval(RecRef);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    //Enabled = CanCancelApprovalForRecord or CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel the approval request.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                    begin
                        Recref.GetTable(Rec);
                        CustomWorkflowManagement.OnCancelWorkflowApprovalRequest(RecRef);
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approvals';
                    //Enabled = OpenApprovalentriesExistsForCurrUser;
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
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        User: Record User;
    begin
        CreatedBy := '';
        User.Reset();
        User.SetRange("User Security ID", Rec.SystemCreatedBy);
        If User.FindFirst() then
            CreatedBy := User."User Name";

        ModifiedBy := '';
        User.Reset();
        User.SetRange("User Security ID", Rec.SystemModifiedBy);
        If User.FindFirst() then
            ModifiedBy := User."User Name";
    end;

    local procedure OnAfterGetCurrRecordFunc()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CustomWorkflowManagement: Codeunit CustomWorkflowManagement;
        CreatedBy: Text;
        ModifiedBy: Text;
}