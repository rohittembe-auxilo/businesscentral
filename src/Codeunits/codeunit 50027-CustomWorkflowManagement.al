codeunit 50027 CustomWorkflowManagement
{
    trigger OnRun()
    begin
    end;

    procedure CheckCustomWorkflowApprovalsWorkflowEnabled(var RecRef: RecordRef): Boolean
    begin
        if not WorkflowManagement.CanExecuteWorkflow(RecRef, GetWorkflowCode(RUNWORKFLOWSENDFORAPPROVALCODE, RecRef)) then begin
            Error(NoWorkflowEnabledErr);
        end;
        exit(true);
    end;

    local procedure GetWorkflowCode(WorkFlowCode: Code[128]; RecRef: RecordRef): Code[128]
    begin
        exit(DelChr(StrSubstNo(WorkFlowCode, RecRef.Name), '=', ' '));
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelWorkflowApprovalRequest(var RecRef: RecordRef)
    begin
    end;

    // [IntegrationEvent(false, false)]
    // procedure OnReopenWorkflowApprovalRequest(var RecRef: RecordRef)
    // begin
    // end;

    // Add events to the library
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        RecRef.Open(Database::"Fixed Asset");
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWSENDFORAPPROVALCODE, RecRef), DATABASE::"Fixed Asset",
          GetWorkflowEventDesc(WorkflowSendForApprovalEventDescTxt, RecRef), 0, false);
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWCANCELPROVALCODE, RecRef), DATABASE::"Fixed Asset",
          GetWorkflowEventDesc(WorkflowApprovalRequestCancelEventDescTxt, RecRef), 0, false);
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWCHANGERECORDCODE, RecRef), DATABASE::"Fixed Asset",
          GetWorkflowEventDesc(RecordChangedTxt, RecRef), 0, true);
        RecRef.Close();

        RecRef.Open(Database::"TDS Journal Line");
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWSENDFORAPPROVALCODE, RecRef), DATABASE::"TDS Journal Line",
          GetWorkflowEventDesc(WorkflowSendForApprovalEventDescTxt, RecRef), 0, false);
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWCANCELPROVALCODE, RecRef), DATABASE::"TDS Journal Line",
          GetWorkflowEventDesc(WorkflowApprovalRequestCancelEventDescTxt, RecRef), 0, false);
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWCHANGERECORDCODE, RecRef), DATABASE::"TDS Journal Line",
          GetWorkflowEventDesc(RecordChangedTxt, RecRef), 0, true);
        RecRef.Close();
    end;

    // Subscribe
    [EventSubscriber(ObjectType::Codeunit, Codeunit::CustomWorkflowManagement, 'OnSendWorkflowForApproval', '', false, false)]
    local procedure RunWorkflowOnSendWorkflowForApproval(RecRef: RecordRef)
    var
        FixedAsset: Record "Fixed Asset";
        TDSJournalLine: Record "TDS Journal Line";
    begin
        case RecRef.Number of
            DataBASE::"Fixed Asset":
                begin
                    RecRef.SetTable(FixedAsset);
                    if FixedAsset.Blocked and (FixedAsset.Status = FixedAsset.Status::"Pending for Approval") then
                        exit;
                    FixedAsset.Status := FixedAsset.Status::"Pending for Approval";
                    FixedAsset.Blocked := true;
                    FixedAsset.Modify();
                end;
            DataBASE::"TDS Journal Line":
                begin
                    RecRef.SetTable(TDSJournalLine);
                    if TDSJournalLine.Status = TDSJournalLine.Status::"Pending for Approval" then
                        exit;

                    TDSJournalLine.Status := TDSJournalLine.Status::"Pending for Approval";
                    TDSJournalLine.Modify();
                end;
        end;
        WorkflowManagement.HandleEvent(GetWorkflowCode(RUNWORKFLOWSENDFORAPPROVALCODE, RecRef), RecRef);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Fixed Asset", 'OnAfterInsertEvent', '', false, false)]
    procedure RunWorkflowOnAfterInsertIncomingDocument(var Rec: Record "Fixed Asset"; RunTrigger: Boolean)
    var
        xRec: Record "Fixed Asset";
    begin
        if Rec.IsTemporary() then
            exit;

        xRec := Rec;
        Rec.Status := Rec.Status::"Pending for Approval";
        Rec.Blocked := true;

        RecRef.Open(Database::"Fixed Asset");
        WorkflowManagement.HandleEventWithxRec(GetWorkflowCode(RUNWORKFLOWCHANGERECORDCODE, RecRef), Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Fixed Asset", 'OnAfterModifyEvent', '', false, false)]
    procedure RunWorkflowOnFixedAssetChanged(var Rec: Record "Fixed Asset"; var xRec: Record "Fixed Asset"; RunTrigger: Boolean)
    var
        RecRef: RecordRef;
    begin
        if (xRec.Blocked = false) and (rec.Blocked = true) then
            exit;

        if Rec.Status = Rec.Status::"Pending for Approval" then
            exit;

        if Rec.IsTemporary() then
            exit;

        RecRef.GetTable(Rec);
        if Format(xRec) <> Format(Rec) then begin
            WorkflowManagement.HandleEventWithxRec(GetWorkflowCode(RUNWORKFLOWCHANGERECORDCODE, RecRef), Rec, xRec);
            if WorkflowManagement.CanExecuteWorkflow(RecRef, GetWorkflowCode(RUNWORKFLOWCANCELPROVALCODE, RecRef)) then begin
                Rec.Validate(Status, Rec.Status::"Pending for Approval");
                Rec.Validate(Blocked, true);
                Rec.Modify(true);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"TDS Journal Line", 'OnAfterModifyEvent', '', false, false)]
    procedure RunWorkflowOnTDSJournalLineChanged(var Rec: Record "TDS Journal Line"; var xRec: Record "TDS Journal Line"; RunTrigger: Boolean)
    var
        RecRef: RecordRef;
        xRec2: Record "TDS Journal Line";
    begin
        if Rec.Status <> Rec.Status::Open then begin
            xRec2 := XRec;
            xRec2.Status := Rec.Status;
            if Format(xRec2) <> Format(Rec) then
                Error('You can not modify the record if it is not Open. Reopen the record first.');
        end;
    end;

    // Handle the document
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        FixedAsset: Record "Fixed Asset";
        TDSJournalLine: Record "TDS Journal Line";
    begin
        case RecRef.Number of
            DataBASE::"Fixed Asset":
                begin
                    RecRef.SetTable(FixedAsset);
                    FixedAsset.Status := FixedAsset.Status::Open;
                    FixedAsset.Blocked := true;
                    FixedAsset.Modify();
                    Handled := True;
                end;
            Database::"TDS Journal Line":
                begin
                    RecRef.SetTable(TDSJournalLine);
                    TDSJournalLine.Status := TDSJournalLine.Status::Open;
                    TDSJournalLine.Modify();
                    Handled := True;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        FixedAsset: Record "Fixed Asset";
        TDSJournalLine: Record "TDS Journal Line";
    begin
        case RecRef.Number of
            DataBASE::"Fixed Asset":
                begin
                    RecRef.SetTable(FixedAsset);
                    FixedAsset.Validate(Status, FixedAsset.Status::"Pending for Approval");
                    FixedAsset.Validate(Blocked, true);
                    FixedAsset.Modify();
                    Variant := FixedAsset;
                    IsHandled := True;
                end;
            DataBASE::"TDS Journal Line":
                begin
                    RecRef.SetTable(TDSJournalLine);
                    TDSJournalLine.Status := TDSJournalLine.Status::"Pending for Approval";
                    TDSJournalLine.Modify();
                    Variant := TDSJournalLine;
                    IsHandled := True;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        FixedAsset: Record "Fixed Asset";
        TDSJournalLine: Record "TDS Journal Line";
    begin
        case RecRef.Number of
            DataBASE::"Fixed Asset":
                begin
                    RecRef.SetTable(FixedAsset);
                    ApprovalEntryArgument."Document No." := FixedAsset."No.";
                end;
            DataBASE::"TDS Journal Line":
                begin
                    RecRef.SetTable(TDSJournalLine);
                    ApprovalEntryArgument."Document Type" := TDSJournalLine."Document Type";
                    ApprovalEntryArgument."Document No." := TDSJournalLine."Document No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := TDSJournalLine."Salespers./Purch. Code";
                    ApprovalEntryArgument.Amount := TDSJournalLine.Amount;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        FixedAsset: Record "Fixed Asset";
        TDSJournalLine: Record "TDS Journal Line";
    begin
        case RecRef.Number of
            DataBASE::"Fixed Asset":
                begin
                    RecRef.SetTable(FixedAsset);
                    FixedAsset.Status := FixedAsset.Status::Approved;
                    FixedAsset.Blocked := false;
                    FixedAsset.Modify();
                    Handled := true;
                end;
            DataBASE::"TDS Journal Line":
                begin
                    RecRef.SetTable(TDSJournalLine);
                    TDSJournalLine.Status := TDSJournalLine.Status::Approved;
                    TDSJournalLine.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        FixedAsset: Record "Fixed Asset";
        TDSJournalLine: Record "TDS Journal Line";
    begin
        RecRef.get(ApprovalEntry."Record ID to Approve");
        case RecRef.Number of
            DataBASE::"Fixed Asset":
                begin
                    FixedAsset.Get(ApprovalEntry."Document No.");
                    FixedAsset.Status := FixedAsset.Status::Approved;
                    FixedAsset.Blocked := false;
                    FixedAsset.Modify;
                end;
            DataBASE::"TDS Journal Line":
                begin
                    RecRef.SetTable(TDSJournalLine);
                    TDSJournalLine.Status := TDSJournalLine.Status::Approved;
                    TDSJournalLine.Modify;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        RecRef: RecordRef;
        FixedAsset: Record "Fixed Asset";
        TDSJournalLine: Record "TDS Journal Line";
    begin
        RecRef.get(ApprovalEntry."Record ID to Approve");
        case RecRef.Number of
            DataBASE::"Fixed Asset":
                begin
                    FixedAsset.Get(ApprovalEntry."Document No.");
                    FixedAsset.Status := FixedAsset.Status::Rejected;
                    FixedAsset.Modify();
                end;
            DataBASE::"TDS Journal Line":
                begin
                    RecRef.SetTable(TDSJournalLine);
                    TDSJournalLine.Status := TDSJournalLine.Status::Open;
                    TDSJournalLine.Modify();
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::CustomWorkflowManagement, 'OnCancelWorkflowApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnCancelWorkflowApprovalRequest(RecRef: RecordRef)
    var
        FixedAsset: Record "Fixed Asset";
        TDSJournalLine: Record "TDS Journal Line";
    begin
        case RecRef.Number of
            DataBASE::"Fixed Asset":
                begin
                    RecRef.SetTable(FixedAsset);
                    FixedAsset.Status := FixedAsset.Status::Open;
                    FixedAsset.Blocked := true;
                    FixedAsset.Modify();
                end;
            DataBASE::"TDS Journal Line":
                begin
                    RecRef.SetTable(TDSJournalLine);
                    TDSJournalLine.Status := FixedAsset.Status::Open;
                    TDSJournalLine.Modify();
                end;
        end;
        WorkflowManagement.HandleEvent(GetWorkflowCode(RUNWORKFLOWCANCELPROVALCODE, RecRef), RecRef);
    end;

    local procedure GetWorkflowEventDesc(WorkflowEventDesc: Text; RecRef: RecordRef): Text
    begin
        exit(StrSubstNo(WorkflowEventDesc, RecRef.Name));
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        RUNWORKFLOWSENDFORAPPROVALCODE: Label 'RUNWORKFLOWONSEND%1FORAPPROVAL';
        RUNWORKFLOWCANCELPROVALCODE: Label 'RUNWORKFLOWONCANCEL%1APPROVALREQUEST';
        RUNWORKFLOWCHANGERECORDCODE: Label 'RUNWORKFLOWON%1CHANGEDCODE';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        WorkflowSendForApprovalEventDescTxt: Label 'Approval of a %1 is requested.';
        WorkflowApprovalRequestCancelEventDescTxt: Label 'An approval request for a %1 is canceled.';
        RecordChangedTxt: Label 'A %1 record is changed.';
        RecRef: RecordRef;
}