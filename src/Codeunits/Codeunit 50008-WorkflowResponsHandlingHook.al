codeunit 50008 "WorkflowRespons Handling Hook"
{
    Permissions = tabledata "Approval Entry" = rimd;

    trigger OnRun()
    begin

    end;

    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandlingHook: Codeunit "Workflow Event Handling Hook";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", OnAddWorkflowResponsePredecessorsToLibrary, '', false, false)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.CreateApprovalRequestsCode():
                begin//CCIT Vikas
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnSendGLAccountForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnGLAccountChangedCode);
                    //>> ST
                    // WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnSendFixedAssetForApprovalCode);
                    // WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnFixedAssetChangedCode);
                    //<< ST
                    WorkflowResponseHandling.AddResponsePredecessor(
                      WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnSendTaxJournalLineForApprovalCode);

                    //CCIT AN 06022023
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnSendReversalEntryForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnReversalEntryChangedCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnSendUserSetupForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnUserSetupChangedCode);
                    //CCIT AN 16022023 UserSetup--
                    //CCIT AN 24072023 Bulk PO Orders
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnSendPOrderslLineForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnSendALMForApprovalCode);//CCIT AN 27022024 ALM

                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnSendBankAccountForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnBankAccountChangedCode);
                end;
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode():
                begin
                    //CCIT Vikas
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingHook.RunWorkflowOnSendGLAccountForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingHook.RunWorkflowOnGLAccountChangedCode);
                    //>> ST
                    // WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingHook.RunWorkflowOnSendFixedAssetForApprovalCode);
                    // WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingHook.RunWorkflowOnFixedAssetChangedCode);
                    //<< ST
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
                      WorkflowEventHandlingHook.RunWorkflowOnSendTaxJournalLineForApprovalCode);
                    //CCIT AN 06022023
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingHook.RunWorkflowOnSendReversalEntryForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingHook.RunWorkflowOnReversalEntryChangedCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingHook.RunWorkflowOnSendUserSetupForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingHook.RunWorkflowOnUserSetupChangedCode);
                    //CCIT AN 16022023 UserSetup--
                    //CCIT AN 24072023 Bulk PO Orders
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingHook.RunWorkflowOnSendPOrderslLineForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingHook.RunWorkflowOnSendALMForApprovalCode); //CCIT AN 27022024 ALM
                end;

            WorkflowResponseHandling.OpenDocumentCode():
                begin
                    //CCIT Vikas
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingHook.RunWorkflowOnCancelGLAccountApprovalRequestCode);
                    //>> ST
                    //WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingHook.RunWorkflowOnCancelFixedAssetApprovalRequestCode);
                    //<< ST
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingHook.RunWorkflowOnCancelBankAccountApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingHook.RunWorkflowOnCancelTaxJournalLineApprovalRequestCode);
                    //CCIT AN 06022023
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingHook.RunWorkflowOnCancelReversalEntryApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingHook.RunWorkflowOnCancelUserSetupApprovalRequestCode); //CCIT AN 16022023 UserSetup
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingHook.RunWorkflowOnCancelPordersLineApprovalRequestCode); //CCIT AN 24072023 Bulk PO Orders
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingHook.RunWorkflowOnCancelALMApprovalRequestCode); //CCIT AN 27022024 ALM
                end;
            WorkflowResponseHandling.CancelAllApprovalRequestsCode():
                begin
                    //CCIT Vikas
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnCancelGLAccountApprovalRequestCode);
                    //>> ST
                    //WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnCancelFixedAssetApprovalRequestCode);
                    //<< ST
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnCancelBankAccountApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode,
                      WorkflowEventHandlingHook.RunWorkflowOnCancelTaxJournalLineApprovalRequestCode);
                    //CCIT AN 06022023
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnCancelReversalEntryApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnCancelUserSetupApprovalRequestCode);
                    //CCIT AN 16022023 UserSetup--
                    //CCIT AN 24072023 Bulk PO Orders
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnCancelPordersLineApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandlingHook.RunWorkflowOnCancelALMApprovalRequestCode);//CCIT AN 27022024 ALM
                end;
            WorkflowResponseHandling.RevertValueForFieldCode():
                begin
                    //CCIT Vikas
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.RevertValueForFieldCode, WorkflowEventHandlingHook.RunWorkflowOnGLAccountChangedCode);
                    //>> ST
                    //WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.RevertValueForFieldCode, WorkflowEventHandlingHook.RunWorkflowOnFixedAssetChangedCode);
                    //<< ST
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.RevertValueForFieldCode, WorkflowEventHandlingHook.RunWorkflowOnBankAccountChangedCode);
                    //CCIT AN
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.RevertValueForFieldCode, WorkflowEventHandlingHook.RunWorkflowOnReversalEntryChangedCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.RevertValueForFieldCode, WorkflowEventHandlingHook.RunWorkflowOnUserSetupChangedCode); //CCIT AN 16022023 UserSetup
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", OnExecuteWorkflowResponse, '', false, false)]
    local procedure OnExecuteWorkflowResponse(var ResponseExecuted: Boolean; var Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowResponse: Record "Workflow Response";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowManagement: Codeunit "Workflow Management";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin

        if not WorkflowResponse.Get(ResponseWorkflowStepInstance."Function Name") then
            exit;

        case WorkflowResponse."Function Name" of
            WorkflowResponseHandling.CreateAndApproveApprovalRequestAutomaticallyCode():
                begin
                    RecRef.GETTABLE(Variant);

                    CASE RecRef.NUMBER OF
                        DATABASE::"Sales Header":
                            ApprovalsMgmt.CreateAndAutomaticallyApproveRequest(RecRef, ResponseWorkflowStepInstance);
                        DATABASE::Customer:
                            ApprovalsMgmt.CreateAndAutomaticallyApproveRequest(RecRef, ResponseWorkflowStepInstance);
                        //CCIT Vikas
                        DATABASE::"G/L Account":
                            ApprovalsMgmt.CreateAndAutomaticallyApproveRequest(RecRef, ResponseWorkflowStepInstance);
                        //>> ST
                        // DATABASE::"Fixed Asset":
                        //     ApprovalsMgmt.CreateAndAutomaticallyApproveRequest(RecRef, ResponseWorkflowStepInstance);
                        //<< ST
                        //CCIT Vikas
                        DATABASE::"Bank Account":
                            ApprovalsMgmt.CreateAndAutomaticallyApproveRequest(RecRef, ResponseWorkflowStepInstance);
                        //CCIT AN
                        DATABASE::"G/L Entry":
                            ApprovalsMgmt.CreateAndAutomaticallyApproveRequest(RecRef, ResponseWorkflowStepInstance);
                        ////CCIT AN 16022023 UserSetup
                        DATABASE::"User Setup":
                            ApprovalsMgmt.CreateAndAutomaticallyApproveRequest(RecRef, ResponseWorkflowStepInstance);
                        //CCIT AN 24072023 Bulk PO Orders
                        DATABASE::"Purchase Header":
                            ApprovalsMgmt.CreateAndAutomaticallyApproveRequest(RecRef, ResponseWorkflowStepInstance);
                        //CCIT AN 27022024 ALM
                        DATABASE::"ALM Header":
                            ApprovalsMgmt.CreateAndAutomaticallyApproveRequest(RecRef, ResponseWorkflowStepInstance);
                    end;
                end;
        end;
    end;
}