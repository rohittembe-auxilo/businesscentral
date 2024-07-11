codeunit 50010 "Approval Management hook"
{
    Permissions = tabledata "Approval Entry" = rimd;

    var
        BudgetAmountExceededCnf: Label 'Budgeted amount is less than the amount on line %1 for G/L Account %2, Budget Name %3. Do you want to continue?';
        NoWorkflowEnabledErr: Label 'This record is not supported by related approval workflow.';
        DocStatusChangedMsg: Label '%1 %2 has been automatically approved. The status has been changed to %3.', Comment = 'Order 1001 has been automatically approved. The status has been changed to Released.';
        PurchaserUserNotFoundErr: Label 'The salesperson/purchaser user ID %1 does not exist in the Approval User Setup window for %2 %3.', Comment = 'Example: The salesperson/purchaser user ID NAVUser does not exist in the Approval User Setup window for Salesperson/Purchaser code AB.';
        NoApprovalsSentMsg: Label 'No approval requests have been sent, either because they are already sent or because related workflows do not support the journal line.';
        ApproverUserIdNotInSetupErr: Label 'You must set up an approver for user ID %1 in the Approval User Setup window.', Comment = 'You must set up an approver for user ID NAVUser in the Approval User Setup window.';
        WFUserGroupNotInSetupErr: Label 'The workflow user group member with user ID %1 does not exist in the Approval User Setup window.', Comment = 'The workflow user group member with user ID NAVUser does not exist in the Approval User Setup window.';
        NoWFUserGroupMembersErr: Label 'A workflow user group with at least one member must be set up.';
        UserIdNotInSetupErr: Label 'User ID %1 does not exist in the Approval User Setup window.', Comment = 'User ID NAVUser does not exist in the Approval User Setup window.';
        PendingApprovalForSelectedLinesMsg: Label 'Approval requests have been sent.';
        ApprovalReqCanceledForSelectedLinesMsg: Label 'The approval request for the selected record has been canceled.';
        PendingApprovalForSomeSelectedLinesMsg: Label 'Approval requests have been sent.\\Requests for some journal lines were not sent, either because they are already sent or because related workflows do not support the journal line.';
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandlingHook: Codeunit "Workflow Event Handling Hook";
        NoApprovalRequestsFoundErr: Label 'No approval requests exist.';
        RecHasBeenApprovedMsg: Label '%1 has been approved.', Comment = '%1 = Record Id';
        PendingApprovalMsg: Label 'An approval request has been sent.';
        RecPurchHdr: Record "Purchase Header";
        RecSalesHeader: Record "Sales Header";
        RecVend: Record Vendor;
        RecCust: Record Customer;
        RecGLAccount: Record "G/L Account";
        FixedAsset: Record "Fixed Asset";
        BankAccount: Record "Bank Account";
        UserSetup: Record "User Setup";
        UserSetup2: Record "User Setup";
        ApprEntry: Record "Approval Entry";
        ApprovalEntry2: Record "Approval Entry";
        PendingApprovalForPOSelectedLinesMsg: Label 'ENU=Approval requests have been sent.\\Requests for somePO lines were not sent, either because they are already sent or because related workflows do not support the POl line.;ENN=Approval requests have been sent.\\Requests for some journal lines were not sent, either because they are already sent or because related workflows do not support the journal line.';

    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnApproveApprovalRequest, '', false, false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    VAR
        GenJnlLine: Record "Gen. Journal Line";
        RecordIDGL: Text;
        "Template&Batch": Text;
        JournalTemplateName: Text[50];
        JournalBatchName: Text[50];
        RecordId: RecordId;
        RecordRef: RecordRef;
    begin
        //CCIT AN 18Jan2023
        RecordIDGL := FORMAT(ApprovalEntry."Record ID to Approve");
        //>> ST
        // IF ApprovalEntry."Table ID" <> 91 THEN //CCIT AN 16022023
        //     "Template&Batch" := COPYSTR(RecordIDGL, 21, STRLEN(RecordIDGL));
        // IF STRLEN("Template&Batch") > 1 THEN BEGIN
        //     IF "Template&Batch" <> '' THEN
        //         //JournalTemplateName := COPYSTR("Template&Batch",STRPOS("Template&Batch",',')+1,STRLEN("Template&Batch"));
        //         JournalTemplateName := COPYSTR("Template&Batch", 1, STRPOS("Template&Batch", ',') - 1);
        //     JournalBatchName := COPYSTR("Template&Batch", STRPOS("Template&Batch", ',') + 1, STRLEN("Template&Batch"));
        //     // MESSAGE('recordIDGL%1, Template&Batch%2',RecordIDGL,"Template&Batch");
        // END;
        //<< ST

        IF (ApprovalEntry."Table ID" = 232) OR (ApprovalEntry."Table ID" = 81) THEN BEGIN
            GenJnlLine.RESET();
            GenJnlLine.SETRANGE("Journal Template Name", JournalTemplateName);
            GenJnlLine.SETRANGE("Journal Batch Name", JournalBatchName);
            IF GenJnlLine.FIND('-') THEN
                REPEAT
                    GenJnlLine."Approver ID" := ApprovalEntry."Approver ID";
                    GenJnlLine.MODIFY;
                UNTIL GenJnlLine.NEXT = 0;
        END;
        //CCIT AN 18Jan2023
        //CCIT-PRI-050218
        RecPurchHdr.RESET;
        RecPurchHdr.SETRANGE(RecPurchHdr."No.", ApprovalEntry."Document No.");
        // RecPurchHdr.SETRANGE(RecPurchHdr."Document Type", RecPurchHdr."Document Type"::Order);
        IF RecPurchHdr.FINDFIRST THEN BEGIN
            RecPurchHdr."Approver ID" := ApprovalEntry."Approver ID";
            RecPurchHdr."Approver Date" := TODAY;
            RecPurchHdr.MODIFY;
        END;

        RecSalesHeader.RESET;
        RecSalesHeader.SETRANGE(RecSalesHeader."No.", ApprovalEntry."Document No.");
        IF RecSalesHeader.FINDFIRST THEN BEGIN
            RecSalesHeader."Approver ID" := ApprovalEntry."Approver ID";
            RecSalesHeader."Approver Date" := TODAY;
            RecSalesHeader.MODIFY;
        END;

        if ApprovalEntry."Record ID to Approve".TableNo = Database::Customer then begin
            RecordRef := ApprovalEntry."Record ID to Approve".GetRecord();
            RecordRef.SetTable(RecCust);
            RecCust.GET(RecCust."No.");
            RecCust.Blocked := RecCust.Blocked::" ";
            RecCust.MODIFY;
        end;

        if ApprovalEntry."Record ID to Approve".TableNo = Database::Vendor then begin
            RecordRef := ApprovalEntry."Record ID to Approve".GetRecord();
            RecordRef.SetTable(RecVend);
            RecVend.GET(RecVend."No.");
            RecVend.Blocked := RecVend.Blocked::" ";
            RecVend."Blocked Reason" := '';
            RecVend.MODIFY;
        end;

        //vikas
        RecGLAccount.RESET;
        RecGLAccount.SETRANGE("No.", ApprovalEntry."Document No.");
        IF RecGLAccount.FINDFIRST THEN BEGIN
            RecGLAccount.Blocked := FALSE;
            RecGLAccount.MODIFY;
        END;

        //>> ST
        // FixedAsset.RESET;
        // if FixedAsset.Get(ApprovalEntry."Document No.") then begin
        //     FixedAsset.Blocked := FALSE;
        //     FixedAsset.MODIFY;
        // end;
        //<< ST

        BankAccount.RESET;
        BankAccount.SETRANGE("No.", ApprovalEntry."Document No.");
        IF BankAccount.FINDFIRST THEN BEGIN
            BankAccount.Blocked := FALSE;
            BankAccount.MODIFY;
        END;

        //CCIT AN 16022023
        ApprEntry.RESET();
        ApprEntry.SETRANGE("Document No.", ApprovalEntry."Document No.");
        ApprEntry.SETRANGE(Status, ApprEntry.Status::Approved);
        ApprEntry.SETFILTER("Table ID", '=%1', 91);
        IF ApprEntry.FINDFIRST THEN BEGIN
            UserSetup2.RESET();
            UserSetup2.SETRANGE("User ID", ApprEntry."Document No.");
            IF UserSetup2.FINDFIRST THEN BEGIN
                UserSetup2.Blocked := FALSE;
                UserSetup2.MODIFY;
            END;
        END;
        //CCIT AN 16022023--


        //CCIT-PRI-050218
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnAfterRejectSelectedApprovalRequest, '', false, false)]
    local procedure OnAfterRejectSelectedApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    begin
        //CCIT AN  17022023
        UserSetup.RESET();
        UserSetup.SETRANGE("User ID", ApprovalEntry."Document No.");
        //UserSetup.SETRANGE(,ApprovalEntry.Status::Rejected);
        IF UserSetup.FINDFIRST THEN BEGIN
            UserSetup.Blocked := TRUE;
            UserSetup.MODIFY;
        END;
        //CCIT AN 17022023
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnBeforeShowCommonApprovalStatus, '', false, false)]
    local procedure OnBeforeShowCommonApprovalStatus(var RecRef: RecordRef; var IsHandle: Boolean)
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        //>> ST
        //ShowApprovalStatus(RecRef.RecordId, WorkflowInstanceId);
        //<< ST
    end;

    local procedure HasPendingApprovalEntriesForWorkflow(RecId: RecordID; WorkflowInstanceId: Guid): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetRange("Record ID to Approve", RecId);
        ApprovalEntry.SetFilter(Status, '%1|%2', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created);
        ApprovalEntry.SetFilter("Workflow Step Instance ID", WorkflowInstanceId);
        exit(not ApprovalEntry.IsEmpty);
    end;

    local procedure ShowApprovalStatus(RecId: RecordID; WorkflowInstanceId: Guid)
    var
        RecordRef: RecordRef;
    begin
        if HasPendingApprovalEntriesForWorkflow(RecId, WorkflowInstanceId) then begin
            //CCIT AN 17022023 ++
            ApprovalEntry2.RESET();
            ApprovalEntry2.SETRANGE("Record ID to Approve", RecId);
            ApprovalEntry2.SETRANGE("Workflow Step Instance ID", WorkflowInstanceId);
            IF ApprovalEntry2.FINDFIRST THEN
                REPEAT
                    UserSetup.RESET();
                    UserSetup.SETRANGE("User ID", ApprovalEntry2."Document No.");
                    IF UserSetup.FINDFIRST THEN BEGIN
                        UserSetup.Blocked := TRUE;
                        UserSetup.MODIFY;
                    END;

                    if RecId.TableNo = Database::Customer then begin
                        RecordRef := RecId.GetRecord();
                        RecordRef.SetTable(RecCust);
                        RecCust.GET(RecCust."No.");
                        RecCust.Blocked := RecCust.Blocked::All;
                        RecCust.MODIFY;
                    end;

                    if RecId.TableNo = Database::Vendor then begin
                        RecordRef := RecId.GetRecord();
                        RecordRef.SetTable(RecVend);
                        RecVend.GET(RecVend."No.");
                        RecVend.Blocked := RecVend.Blocked::All;
                        RecVend.MODIFY;
                    end;

                    RecGLAccount.RESET();
                    RecGLAccount.SETRANGE("No.", ApprovalEntry2."Document No.");
                    //RecGLAccount.SETFILTER(ApprovalEntry.Status,'<>%1','Approved');
                    IF RecGLAccount.FINDFIRST THEN BEGIN
                        RecGLAccount.Blocked := TRUE;
                        RecGLAccount.MODIFY;
                    END;

                    // FixedAsset.RESET();
                    // if FixedAsset.get(ApprovalEntry2."Document No.") then begin
                    //     FixedAsset.Blocked := TRUE;
                    //     FixedAsset.MODIFY;
                    // end;

                    BankAccount.RESET();
                    BankAccount.SETRANGE("No.", ApprovalEntry2."Document No.");
                    IF BankAccount.FINDFIRST THEN BEGIN
                        BankAccount.Blocked := TRUE;
                        BankAccount.MODIFY;
                    END;
                //CCIT AN 03042024--
                UNTIL ApprovalEntry2.NEXT = 0;
        end else
            Message(RecHasBeenApprovedMsg, Format(RecId, 0, 1));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnApproveApprovalRequestsForRecordOnAfterApprovalEntrySetFilters, '', false, false)]
    local procedure OnApproveApprovalRequestsForRecordOnAfterApprovalEntrySetFilters(var ApprovalEntry: Record "Approval Entry")
    var
        ApprovalEntryToUpdate: Record "Approval Entry";
    begin
        if ApprovalEntry.FindSet() then
            repeat
                //CCIT AN 17022023
                UserSetup.RESET();
                UserSetup.SETRANGE("User ID", ApprovalEntry."Document No.");
                IF UserSetup.FINDFIRST THEN BEGIN
                    UserSetup.Blocked := FALSE;
                    UserSetup.MODIFY;
                END;
            //CCIT AN 17022023
            until ApprovalEntry.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnSendApprovalRequestFromRecordOnAfterSetApprovalEntryFilters, '', false, false)]
    local procedure OnSendApprovalRequestFromRecordOnAfterSetApprovalEntryFilters(var ApprovalEntry: Record "Approval Entry"; RecRef: RecordRef; var IsHandled: Boolean; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalEntry2: Record "Approval Entry";
    begin
        if ApprovalEntry.FindFirst() then begin
            ApprovalEntry2.CopyFilters(ApprovalEntry);
            ApprovalEntry2.SetRange("Sequence No.", ApprovalEntry."Sequence No.");
            if ApprovalEntry2.FindSet(true) then
                repeat
                    ApprovalEntry2.Validate(Status, ApprovalEntry2.Status::Open);
                    ApprovalEntry2.Modify(true);
                    ApprovalsMgmt.CreateApprovalEntryNotification(ApprovalEntry2, WorkflowStepInstance);
                until ApprovalEntry2.Next() = 0;

            IsHandled := false;
            if not IsHandled then
                if FindApprovedApprovalEntryForWorkflowUserGroup(ApprovalEntry, WorkflowStepInstance) then
                    if (ApprovalEntry."Sender ID" <> ApprovalEntry."Approver ID") or
                       FindOpenApprovalEntryForSequenceNo(RecRef, WorkflowStepInstance, ApprovalEntry."Sequence No.")
                    then
                        OnApproveApprovalRequest(ApprovalEntry);
            IsHandled := true;
            exit;
        end;

        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
        if ApprovalEntry.FindLast() then
            OnApproveApprovalRequest(ApprovalEntry);
        // else
        //     Error(NoApprovalRequestsFoundErr);
        IsHandled := true;
    end;

    local procedure FindApprovedApprovalEntryForWorkflowUserGroup(var ApprovalEntry: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance"): Boolean
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowInstance: Query "Workflow Instance";
    begin
        WorkflowStepInstance.SetLoadFields(Argument);
        WorkflowStepInstance.SetRange("Function Name", WorkflowResponseHandling.CreateApprovalRequestsCode());
        WorkflowStepInstance.SetRange("Record ID", WorkflowStepInstance."Record ID");
        WorkflowStepInstance.SetRange("Workflow Code", WorkflowStepInstance."Workflow Code");
        WorkflowStepInstance.SetRange(Type, WorkflowInstance.Type::Response);
        WorkflowStepInstance.SetRange(Status, WorkflowInstance.Status::Completed);
        if WorkflowStepInstance.FindSet() then
            repeat
                if WorkflowStepArgument.Get(WorkflowStepInstance.Argument) then
                    if WorkflowStepArgument."Approver Type" = WorkflowStepArgument."Approver Type"::"Workflow User Group" then begin
                        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                        exit(ApprovalEntry.FindLast());
                    end;
            until WorkflowStepInstance.Next() = 0;
        exit(false);
    end;

    local procedure FindOpenApprovalEntryForSequenceNo(RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; SequenceNo: Integer): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetRange("Table ID", RecRef.Number);
        ApprovalEntry.SetRange("Record ID to Approve", RecRef.RecordId());
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SetRange("Workflow Step Instance ID", WorkflowStepInstance.ID);
        ApprovalEntry.SetRange("Sequence No.", SequenceNo);

        exit(not ApprovalEntry.IsEmpty());
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnPopulateApprovalEntryArgument, '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        GLAccount: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        TaxJournalLine: Record "TDS Journal Line";
        ALMHeader: Record "ALM Header";
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        CASE RecRef.NUMBER OF
            //CCIT Vikas
            DATABASE::"G/L Account":
                BEGIN
                    RecRef.SETTABLE(GLAccount);
                    ApprovalEntryArgument."Document No." := GLAccount."No.";
                END;
            // DATABASE::"Fixed Asset":
            //     BEGIN
            //         RecRef.SETTABLE(FixedAsset);
            //         ApprovalEntryArgument."Document No." := FixedAsset."No.";
            //     END;
            DATABASE::"Bank Account":
                BEGIN
                    RecRef.SETTABLE(BankAccount);
                    ApprovalEntryArgument."Document No." := BankAccount."No.";
                END;
            DATABASE::"Customer":
                BEGIN
                    RecRef.SETTABLE(Customer);
                    ApprovalEntryArgument."Document No." := Customer."No.";
                END;
            DATABASE::"Vendor":
                BEGIN
                    RecRef.SETTABLE(Vendor);
                    ApprovalEntryArgument."Document No." := Vendor."No.";
                END;
            //CCIT Vikas
            //CCIT AN 06022023 for Reversal Approval
            DATABASE::"G/L Entry":
                BEGIN
                    RecRef.SETTABLE(GLEntry);
                    ApprovalEntryArgument."Document No." := GLEntry."Document No.";
                END;
            //CCIT AN 06022023 for Reversal Approval
            //USER SETUP CCIT AN 16022023
            DATABASE::"User Setup":
                BEGIN
                    RecRef.SETTABLE(UserSetup);
                    ApprovalEntryArgument."Document No." := UserSetup."User ID";
                END;
            //ALM CCIT AN 27022024
            DATABASE::"ALM Header":
                BEGIN
                    RecRef.SETTABLE(ALMHeader);
                    ApprovalEntryArgument."Document No." := ALMHeader."Document No.";
                END;
        //USER SETUP CCIT AN 16022023--
        //CCIT AN 16032023
        //>> ST
        // DATABASE::"TDS Journal Line":
        //     BEGIN
        //         RecRef.SETTABLE(TaxJournalLine);
        //         ApprovalEntryArgument."Document Type" := TaxJournalLine."Document Type";
        //         ApprovalEntryArgument."Document No." := TaxJournalLine."Document No.";
        //         ApprovalEntryArgument."Salespers./Purch. Code" := TaxJournalLine."Salespers./Purch. Code";
        //         ApprovalEntryArgument.Amount := TaxJournalLine.Amount;
        //         //  ApprovalEntryArgument."Amount (LCY)" := TaxJournalLine."Amount (LCY)";
        //         //   ApprovalEntryArgument."Currency Code" := TaxJournalLine."Currency Code";
        //     END;
        // << ST
        end;
    end;

    [TryFunction]
    procedure CheckApplovalEntry(RecordID: RecordID)
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        IF ApprovalsMgmt.FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecordID) THEN
            ERROR('Approver does not have permission to edit');
    end;

    local procedure "---GLAccount-----"()
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendGLAccountForApproval(var GLAccount: Record "G/L Account")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelGLAccountApprovalRequest(var GLAccount: Record "G/L Account")
    begin
    end;

    procedure CheckGLAccountApprovalsWorkflowEnabled(var GLAccount: Record "G/L Account"): Boolean
    begin
        IF NOT WorkflowManagement.CanExecuteWorkflow(GLAccount, WorkflowEventHandlingHook.RunWorkflowOnSendGLAccountForApprovalCode) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    [EventSubscriber(ObjectType::Table, 15, 'OnAfterDeleteEvent', '', false, false)]
    procedure DeleteApprovalEntriesAfterDeleteGLAccount(var Rec: Record "G/L Account"; RunTrigger: Boolean)
    begin
        ApprovalsMgmt.DeleteApprovalEntries(Rec.RECORDID);
    end;


    // local procedure "---FixedAsset-----"()
    // begin
    // end;

    // [IntegrationEvent(false, false)]
    // procedure OnSendFixedAssetForApproval(var FixedAsset: Record "Fixed Asset")
    // begin
    // end;

    // [IntegrationEvent(false, false)]
    // procedure OnCancelFixedAssetApprovalRequest(var FixedAsset: Record "Fixed Asset")
    // begin
    // end;

    // procedure CheckFixedAssetApprovalsWorkflowEnabled(var FixedAsset: Record "Fixed Asset"): Boolean
    // begin
    //     IF NOT WorkflowManagement.CanExecuteWorkflow(FixedAsset, WorkflowEventHandlingHook.RunWorkflowOnSendFixedAssetForApprovalCode) THEN
    //         ERROR(NoWorkflowEnabledErr);

    //     EXIT(TRUE);
    // end;

    // [EventSubscriber(ObjectType::Table, 5600, 'OnAfterDeleteEvent', '', false, false)]
    // procedure DeleteApprovalEntriesAfterDeleteFixedAsset(var Rec: Record "Fixed Asset"; RunTrigger: Boolean)
    // begin
    //     ApprovalsMgmt.DeleteApprovalEntries(Rec.RECORDID);
    // end;

    local procedure "---Bank Account-----"()
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendBankAccountForApproval(var BankAccount: Record "Bank Account")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelBankAccountApprovalRequest(var BankAccount: Record "Bank Account")
    begin
    end;

    procedure CheckBankAccountApprovalsWorkflowEnabled(var BankAccount: Record "Bank Account"): Boolean
    begin
        IF NOT WorkflowManagement.CanExecuteWorkflow(BankAccount, WorkflowEventHandlingHook.RunWorkflowOnSendBankAccountForApprovalCode) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Bank Account", 'OnAfterDeleteEvent', '', false, false)]
    procedure DeleteApprovalEntriesAfterDeleteBankAccount(var Rec: Record "Bank Account"; RunTrigger: Boolean)
    begin
        ApprovalsMgmt.DeleteApprovalEntries(Rec.RECORDID);
    end;

    local procedure "---Tax Journal---"()
    begin
    end;

    //>> ST
    // procedure TrySendTaxJournalLineApprovalRequests(var TaxJournalLine: Record "TDS Journal Line")
    // var
    //     LinesSent: Integer;
    // begin
    //     IF TaxJournalLine.COUNT = 1 THEN
    //         CheckTaxJournalLineApprovalsWorkflowEnabled(TaxJournalLine);

    //     REPEAT
    //         /* IF WorkflowManagement.CanExecuteWorkflow(TaxJournalLine,
    //               WorkflowEventHandling.RunWorkflowOnSendTaxJournalLineForApprovalCode) AND
    //             NOT HasOpenApprovalEntries(TaxJournalLine.RECORDID)
    //          THEN BEGIN*/
    //         OnSendTaxJournalLineForApproval(TaxJournalLine);
    //         LinesSent += 1;
    //     //END;
    //     UNTIL TaxJournalLine.NEXT = 0;

    //     CASE LinesSent OF
    //         0:
    //             MESSAGE(NoApprovalsSentMsg);
    //         TaxJournalLine.COUNT:
    //             MESSAGE(PendingApprovalForSelectedLinesMsg);
    //         ELSE
    //             MESSAGE(PendingApprovalForSomeSelectedLinesMsg);
    //     END;
    // end;

    // procedure TryCancelTaxJournalLineApprovalRequests(var TaxJournalLine: Record "TDS Journal Line")
    // begin
    //     REPEAT
    //         IF ApprovalsMgmt.HasOpenApprovalEntries(TaxJournalLine.RECORDID) THEN
    //             OnCancelTaxJournalLineApprovalRequest(TaxJournalLine);
    //     UNTIL TaxJournalLine.NEXT = 0;
    //     MESSAGE(ApprovalReqCanceledForSelectedLinesMsg);
    // end;

    // procedure CheckTaxJournalLineApprovalsWorkflowEnabled(var TaxJournalLine: Record "TDS Journal Line"): Boolean
    // begin
    //     IF NOT
    //        WorkflowManagement.CanExecuteWorkflow(TaxJournalLine,
    //          WorkflowEventHandlingHook.RunWorkflowOnSendTaxJournalLineForApprovalCode)
    //     THEN
    //         ERROR(NoWorkflowEnabledErr);

    //     EXIT(TRUE);
    // end;

    // [IntegrationEvent(false, false)]
    // procedure OnSendTaxJournalLineForApproval(var TaxJournalLine: Record "TDS Journal Line")
    // begin
    // end;

    // [IntegrationEvent(false, false)]
    // procedure OnCancelTaxJournalLineApprovalRequest(var TaxJournalLine: Record "TDS Journal Line")
    // begin
    // end;

    // procedure IsTaxJournalLineApprovalsWorkflowEnabled(var TaxJournalLine: Record "TDS Journal Line"): Boolean
    // begin
    //     EXIT(WorkflowManagement.CanExecuteWorkflow(TaxJournalLine,
    //         WorkflowEventHandlingHook.RunWorkflowOnSendTaxJournalLineForApprovalCode));
    // end;
    // << ST

    local procedure "------ReversealEntries------"()
    begin
        //CCIT AN 06022023 for Reversal Approval
    end;

    procedure CheckReverseEntryApprovalsWorkflowEnabled(var GLEntry: Record "G/L Entry"): Boolean
    begin
        IF NOT WorkflowManagement.CanExecuteWorkflow(GLEntry, WorkflowEventHandlingHook.RunWorkflowOnSendReversalEntryForApprovalCode) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelReverseEntryApprovalRequest(var GLEntry: Record "G/L Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendReverseEntryForApproval(var GLEntry: Record "G/L Entry")
    begin
        //CCIT AN 06022023 for Reversal Approval
    end;

    procedure CheckReversalEntryLineApprovalsWorkflowEnabled(var GLEntry: Record "G/L Entry"): Boolean
    begin
        IF NOT
           WorkflowManagement.CanExecuteWorkflow(GLEntry,
             WorkflowEventHandlingHook.RunWorkflowOnSendReversalEntryForApprovalCode)
        THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure TrySendReverseEntrylLineApprovalRequests(var GLEntry: Record "G/L Entry")
    var
        LinesSent: Integer;
    begin
        IF GLEntry.COUNT = 1 THEN
            CheckReversalEntryLineApprovalsWorkflowEnabled(GLEntry);

        REPEAT
            IF WorkflowManagement.CanExecuteWorkflow(GLEntry,
                 WorkflowEventHandlingHook.RunWorkflowOnSendReversalEntryForApprovalCode) AND
               NOT ApprovalsMgmt.HasOpenApprovalEntries(GLEntry.RECORDID)
            THEN BEGIN
                OnSendReverseEntryForApproval(GLEntry);
                LinesSent += 1;
            END;
        UNTIL GLEntry.NEXT = 0;

        CASE LinesSent OF
            0:
                MESSAGE(NoApprovalsSentMsg);
            GLEntry.COUNT:
                MESSAGE(PendingApprovalForSelectedLinesMsg);
            ELSE
                MESSAGE(PendingApprovalForSomeSelectedLinesMsg);
        END;
    end;

    local procedure "-----User Setup-----"()
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendUserSetupForApproval(var UserSetup: Record "User Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelUserSetupApprovalRequest(var UserSetup: Record "User Setup")
    begin
    end;

    procedure CheckUserSetupApprovalsWorkflowEnabled(var UserSetup: Record "User Setup"): Boolean
    begin
        IF NOT WorkflowManagement.CanExecuteWorkflow(UserSetup, WorkflowEventHandlingHook.RunWorkflowOnSendUserSetupForApprovalCode) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"User Setup", 'OnAfterDeleteEvent', '', false, false)]
    procedure DeleteApprovalEntriesAfterDeleteUserSetup(var Rec: Record "User Setup"; RunTrigger: Boolean)
    begin
        ApprovalsMgmt.DeleteApprovalEntries(Rec.RECORDID);
    end;

    local procedure "----POBulk-----"()
    begin
    end;

    procedure TrySendPOrdersApprovalRequests(var PurchaseHeader: Record "Purchase Header")
    var
        LinesSent: Integer;
    begin
        IF PurchaseHeader.COUNT = 1 THEN
            CheckPOrdersLineApprovalsWorkflowEnabled(PurchaseHeader);

        REPEAT
            IF WorkflowManagement.CanExecuteWorkflow(PurchaseHeader,
                 WorkflowEventHandlingHook.RunWorkflowOnSendPOrderslLineForApprovalCode) AND
               NOT ApprovalsMgmt.HasOpenApprovalEntries(PurchaseHeader.RECORDID)
            THEN BEGIN
                OnSendPOrdersLineForApproval(PurchaseHeader);
                LinesSent += 1;
            END;
        UNTIL PurchaseHeader.NEXT = 0;

        CASE LinesSent OF
            0:
                MESSAGE(NoApprovalsSentMsg);
            PurchaseHeader.COUNT:
                MESSAGE(PendingApprovalForSelectedLinesMsg);
            ELSE
                MESSAGE(PendingApprovalForPOSelectedLinesMsg);
        END;
    end;

    procedure CheckPOrdersLineApprovalsWorkflowEnabled(var PurchaseHeader: Record "Purchase Header"): Boolean
    begin
        IF NOT
           WorkflowManagement.CanExecuteWorkflow(PurchaseHeader,
             WorkflowEventHandlingHook.RunWorkflowOnSendPOrderslLineForApprovalCode)
        THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPOrdersLineForApproval(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPOrdersLineApprovalRequest(var PurchaseHeader: Record "Purchase Header")
    begin
    end;

    local procedure "----ALM-----"()
    begin
        //CCIT AN 27022024
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendALMForApproval(var ALMHeader: Record "ALM Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelALMApprovalRequest(var ALMHeader: Record "ALM Header")
    begin
    end;

    procedure CheckALMApprovalsWorkflowEnabled(var ALMHeader: Record "ALM Header"): Boolean
    begin
        IF NOT WorkflowManagement.CanExecuteWorkflow(ALMHeader, WorkflowEventHandlingHook.RunWorkflowOnSendALMForApprovalCode) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"ALM Header", 'OnAfterDeleteEvent', '', false, false)]
    procedure DeleteApprovalEntriesAfterDeleteALM(var Rec: Record "ALM Header"; RunTrigger: Boolean)
    begin
        ApprovalsMgmt.DeleteApprovalEntries(Rec.RECORDID);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnBeforeCreateApprovalRequests, '', false, false)]
    local procedure OnBeforeCreateApprovalRequests(RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; var IsHandled: Boolean)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        ApprovalEntryArgument: Record "Approval Entry";
    begin
        ApprovalsMgmt.PopulateApprovalEntryArgument(RecRef, WorkflowStepInstance, ApprovalEntryArgument);

        if WorkflowStepArgument.Get(WorkflowStepInstance.Argument) then
            case WorkflowStepArgument."Approver Type" of
                WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser":
                    CreateApprReqForApprTypeSalespersPurchaser(WorkflowStepArgument, ApprovalEntryArgument);
                WorkflowStepArgument."Approver Type"::Approver:
                    CreateApprReqForApprTypeApprover(WorkflowStepArgument, ApprovalEntryArgument);
                WorkflowStepArgument."Approver Type"::"Workflow User Group":
                    CreateApprReqForApprTypeWorkflowUserGroup(WorkflowStepArgument, ApprovalEntryArgument);
                else
                    OnCreateApprovalRequestsOnElseCase(WorkflowStepArgument, ApprovalEntryArgument);
            end;

        OnCreateApprovalRequestsOnAfterCreateRequests(RecRef, WorkflowStepArgument, ApprovalEntryArgument);

        if WorkflowStepArgument."Show Confirmation Message" then
            InformUserOnStatusChange(RecRef, WorkflowStepInstance.ID);

        IsHandled := true;
    end;

    local procedure CreateApprReqForApprTypeSalespersPurchaser(WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry")
    begin
        ApprovalEntryArgument.TestField("Salespers./Purch. Code");

        case WorkflowStepArgument."Approver Limit Type" of
            WorkflowStepArgument."Approver Limit Type"::"Approver Chain":
                begin
                    CreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument, ApprovalEntryArgument);
                    ApprovalsMgmt.CreateApprovalRequestForChainOfApprovers(WorkflowStepArgument, ApprovalEntryArgument);
                end;
            WorkflowStepArgument."Approver Limit Type"::"Direct Approver":
                CreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument, ApprovalEntryArgument);
            WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver":
                begin
                    CreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument, ApprovalEntryArgument);
                    ApprovalsMgmt.CreateApprovalRequestForApproverWithSufficientLimit(WorkflowStepArgument, ApprovalEntryArgument);
                end;
            WorkflowStepArgument."Approver Limit Type"::"Specific Approver":
                begin
                    CreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument, ApprovalEntryArgument);
                    ApprovalsMgmt.CreateApprovalRequestForSpecificUser(WorkflowStepArgument, ApprovalEntryArgument);
                end;
        end;

        OnAfterCreateApprReqForApprTypeSalespersPurchaser(WorkflowStepArgument, ApprovalEntryArgument);
    end;


    local procedure CreateApprReqForApprTypeApprover(WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry")
    begin
        case WorkflowStepArgument."Approver Limit Type" of
            WorkflowStepArgument."Approver Limit Type"::"Approver Chain":
                begin
                    ApprovalsMgmt.CreateApprovalRequestForUser(WorkflowStepArgument, ApprovalEntryArgument);
                    ApprovalsMgmt.CreateApprovalRequestForChainOfApprovers(WorkflowStepArgument, ApprovalEntryArgument);
                end;
            WorkflowStepArgument."Approver Limit Type"::"Direct Approver":
                CreateApprovalRequestForApprover(WorkflowStepArgument, ApprovalEntryArgument);
            WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver":
                begin
                    ApprovalsMgmt.CreateApprovalRequestForUser(WorkflowStepArgument, ApprovalEntryArgument);
                    ApprovalsMgmt.CreateApprovalRequestForApproverWithSufficientLimit(WorkflowStepArgument, ApprovalEntryArgument);
                end;
            WorkflowStepArgument."Approver Limit Type"::"Specific Approver":
                ApprovalsMgmt.CreateApprovalRequestForSpecificUser(WorkflowStepArgument, ApprovalEntryArgument);
        end;

        OnAfterCreateApprReqForApprTypeApprover(WorkflowStepArgument, ApprovalEntryArgument);
    end;

    local procedure CreateApprReqForApprTypeWorkflowUserGroup(WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
        WorkflowUserGroupMember: Record "Workflow User Group Member";
        ApproverId: Code[50];
        SequenceNo: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCreateApprReqForApprTypeWorkflowUserGroup(WorkflowUserGroupMember, WorkflowStepArgument, ApprovalEntryArgument, SequenceNo, IsHandled);
        if not IsHandled then begin
            if not UserSetup.Get(UserId) then
                Error(UserIdNotInSetupErr, UserId);
            SequenceNo := ApprovalsMgmt.GetLastSequenceNo(ApprovalEntryArgument);

            WorkflowUserGroupMember.SetCurrentKey("Workflow User Group Code", "Sequence No.");
            WorkflowUserGroupMember.SetRange(WorkflowUserGroupMember."Workflow User Group Code", WorkflowStepArgument."Workflow User Group Code");

            if not WorkflowUserGroupMember.FindSet() then
                Error(NoWFUserGroupMembersErr);

            repeat
                ApproverId := WorkflowUserGroupMember."User Name";
                if not UserSetup.Get(ApproverId) then
                    Error(WFUserGroupNotInSetupErr, ApproverId);
                IsHandled := false;
                OnCreateApprReqForApprTypeWorkflowUserGroupOnBeforeMakeApprovalEntry(WorkflowUserGroupMember, ApprovalEntryArgument, WorkflowStepArgument, ApproverId, IsHandled);
                if not IsHandled then
                    ApprovalsMgmt.MakeApprovalEntry(ApprovalEntryArgument, SequenceNo + WorkflowUserGroupMember."Sequence No.", ApproverId, WorkflowStepArgument);
            until WorkflowUserGroupMember.Next() = 0;
        end;
        OnAfterCreateApprReqForApprTypeWorkflowUserGroup(WorkflowStepArgument, ApprovalEntryArgument);
    end;

    local procedure CreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
        SequenceNo: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument, ApprovalEntryArgument, IsHandled);
        if IsHandled then
            exit;

        SequenceNo := ApprovalsMgmt.GetLastSequenceNo(ApprovalEntryArgument);

        FindUserSetupBySalesPurchCode(UserSetup, ApprovalEntryArgument);

        SequenceNo += 1;

        if WorkflowStepArgument."Approver Limit Type" = WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver" then begin
            if ApprovalsMgmt.IsSufficientApprover(UserSetup, ApprovalEntryArgument) then
                ApprovalsMgmt.MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, UserSetup."User ID", WorkflowStepArgument);
        end else
            ApprovalsMgmt.MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, UserSetup."User ID", WorkflowStepArgument);
    end;

    local procedure CreateApprovalRequestForApprover(WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
        UsrId: Code[50];
        SequenceNo: Integer;
    begin
        UsrId := UserId;

        SequenceNo := ApprovalsMgmt.GetLastSequenceNo(ApprovalEntryArgument);

        if not UserSetup.Get(UserId) then
            Error(UserIdNotInSetupErr, UsrId);

        OnCreateApprovalRequestForApproverOnAfterCheckUserSetupUserID(UserSetup, WorkflowStepArgument, ApprovalEntryArgument);

        UsrId := UserSetup."Approver ID";
        if not UserSetup.Get(UsrId) then begin
            if not UserSetup."Approval Administrator" then
                Error(ApproverUserIdNotInSetupErr, UserSetup."User ID");
            UsrId := UserId;
        end;

        SequenceNo += 1;
        ApprovalsMgmt.MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, UsrId, WorkflowStepArgument);
    end;

    local procedure FindUserSetupBySalesPurchCode(var UserSetup: Record "User Setup"; ApprovalEntryArgument: Record "Approval Entry")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeFindUserSetupBySalesPurchCode(UserSetup, ApprovalEntryArgument, IsHandled);
        if not IsHandled then
            if ApprovalEntryArgument."Salespers./Purch. Code" <> '' then begin
                UserSetup.SetCurrentKey("Salespers./Purch. Code");
                UserSetup.SetRange("Salespers./Purch. Code", ApprovalEntryArgument."Salespers./Purch. Code");
                if not UserSetup.FindFirst() then
                    Error(
                      PurchaserUserNotFoundErr, UserSetup."User ID", UserSetup.FieldCaption("Salespers./Purch. Code"),
                      UserSetup."Salespers./Purch. Code");
            end;

        OnAfterFindUserSetupBySalesPurchCode(UserSetup, ApprovalEntryArgument);
    end;

    procedure InformUserOnStatusChange(Variant: Variant; WorkflowInstanceId: Guid)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of
            DATABASE::"Purchase Header":
                ShowPurchApprovalStatus(Variant);
            DATABASE::"Sales Header":
                ShowSalesApprovalStatus(Variant);
            else
                ShowCommonApprovalStatus(RecRef, WorkflowInstanceId);
        end;
    end;

    local procedure ShowPurchApprovalStatus(PurchaseHeader: Record "Purchase Header")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeShowPurchApprovalStatus(PurchaseHeader, IsHandled);
        if IsHandled then
            exit;

        PurchaseHeader.Find();

        case PurchaseHeader.Status of
            PurchaseHeader.Status::Released:
                Message(DocStatusChangedMsg, PurchaseHeader."Document Type", PurchaseHeader."No.", PurchaseHeader.Status);
            PurchaseHeader.Status::"Pending Approval":
                if ApprovalsMgmt.HasOpenOrPendingApprovalEntries(PurchaseHeader.RecordId) then
                    Message(PendingApprovalMsg);
            PurchaseHeader.Status::"Pending Prepayment":
                Message(DocStatusChangedMsg, PurchaseHeader."Document Type", PurchaseHeader."No.", PurchaseHeader.Status);
        end;
    end;

    local procedure ShowSalesApprovalStatus(SalesHeader: Record "Sales Header")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeShowSalesApprovalStatus(SalesHeader, IsHandled);
        if IsHandled then
            exit;

        SalesHeader.Find();

        case SalesHeader.Status of
            SalesHeader.Status::Released:
                Message(DocStatusChangedMsg, SalesHeader."Document Type", SalesHeader."No.", SalesHeader.Status);
            SalesHeader.Status::"Pending Approval":
                if ApprovalsMgmt.HasOpenOrPendingApprovalEntries(SalesHeader.RecordId) then
                    Message(PendingApprovalMsg);
            SalesHeader.Status::"Pending Prepayment":
                Message(DocStatusChangedMsg, SalesHeader."Document Type", SalesHeader."No.", SalesHeader.Status);
        end;
    end;

    local procedure ShowCommonApprovalStatus(var RecRef: RecordRef; WorkflowInstanceId: Guid)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeShowCommonApprovalStatus(RecRef, IsHandled);
        if IsHandled then
            exit;

        ShowApprovalStatus(RecRef.RecordId, WorkflowInstanceId);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnBeforeCheckPurchaseApprovalPossible, '', false, false)]
    local procedure OnBeforeCheckPurchaseApprovalPossible(var PurchaseHeader: Record "Purchase Header"; var Result: Boolean; var IsHandled: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
        GLBudgetEntry: Record "G/L Budget Entry";
        GLBudgetName: Record "G/L Budget Name";
        DimensionSetEntry: Record "Dimension Set Entry";
        NewPostingDate: Date;
        DimSetID: Integer;
        PurchInvHeader: Record "Purch. Inv. Header";
        continue: Boolean;
    begin
        NewPostingDate := CalcDate('CM+1d-1M', PurchaseHeader."Posting Date");

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::"G/L Account");
        if PurchaseLine.FindSet() then
            repeat
                GLBudgetName.Reset();
                if GLBudgetName.FindSet() then
                    repeat
                        GLBudgetEntry.Reset();
                        GLBudgetEntry.SetRange("Budget Name", GLBudgetName.Name);
                        GLBudgetEntry.SetRange("G/L Account No.", PurchaseLine."No.");
                        GLBudgetEntry.SetRange(Date, NewPostingDate);
                        //GLBudgetEntry.SetRange("Dimension Set ID", DimSetID);

                        if DimensionSetEntry.Get(PurchaseLine."Dimension Set ID", 'BRANCHES') then
                            GLBudgetEntry.SetRange("Global Dimension 1 Code", DimensionSetEntry."Dimension Value Code");

                        if DimensionSetEntry.Get(PurchaseLine."Dimension Set ID", 'BUSINESS SEGMENTS') then
                            GLBudgetEntry.SetRange("Global Dimension 2 Code", DimensionSetEntry."Dimension Value Code");

                        if DimensionSetEntry.Get(PurchaseLine."Dimension Set ID", GLBudgetName."Budget Dimension 1 Code") then
                            GLBudgetEntry.SetRange("Budget Dimension 1 Code", DimensionSetEntry."Dimension Value Code");

                        if DimensionSetEntry.Get(PurchaseLine."Dimension Set ID", GLBudgetName."Budget Dimension 2 Code") then
                            GLBudgetEntry.SetRange("Budget Dimension 2 Code", DimensionSetEntry."Dimension Value Code");

                        if DimensionSetEntry.Get(PurchaseLine."Dimension Set ID", GLBudgetName."Budget Dimension 3 Code") then
                            GLBudgetEntry.SetRange("Budget Dimension 3 Code", DimensionSetEntry."Dimension Value Code");

                        IF GLBudgetEntry.FindFirst() then begin
                            if GLBudgetEntry."Remaining Amount" < PurchaseLine.Amount then
                                if not Confirm(StrSubstNo(BudgetAmountExceededCnf, PurchaseLine."Line No.", PurchaseLine."No.", GLBudgetName.Name)) then
                                    Error('');
                        end;
                    until GLBudgetName.Next() = 0;
            until PurchaseLine.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateApprovalRequestsOnElseCase(WorkflowStepArgument: Record "Workflow Step Argument"; var ApprovalEntryArgument: Record "Approval Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateApprovalRequestsOnAfterCreateRequests(RecRef: RecordRef; WorkflowStepArgument: Record "Workflow Step Argument"; var ApprovalEntryArgument: Record "Approval Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateApprReqForApprTypeSalespersPurchaser(WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateApprReqForApprTypeApprover(WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeCreateApprReqForApprTypeWorkflowUserGroup(var WorkflowUserGroupMember: Record "Workflow User Group Member"; WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntry: Record "Approval Entry"; SequenceNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateApprReqForApprTypeWorkflowUserGroupOnBeforeMakeApprovalEntry(var WorkflowUserGroupMember: Record "Workflow User Group Member"; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepArgument: Record "Workflow Step Argument"; var ApproverId: Code[50]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateApprReqForApprTypeWorkflowUserGroup(WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateApprovalRequestForApproverOnAfterCheckUserSetupUserID(var UserSetup: Record "User Setup"; WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindUserSetupBySalesPurchCode(var UserSetup: Record "User Setup"; ApprovalEntryArgument: Record "Approval Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFindUserSetupBySalesPurchCode(var UserSetup: Record "User Setup"; ApprovalEntry: Record "Approval Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowPurchApprovalStatus(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowSalesApprovalStatus(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;
}