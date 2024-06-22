codeunit 50007 "Workflow Event Handling Hook"
{
    Permissions = tabledata "Approval Entry" = rimd, tabledata "Bank Account" = rimd;

    trigger OnRun()
    begin

    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        GLAccountSendForApprovalEventDescTxt: Label 'ENU=Approval of a gl account is requested.;ENN=Approval of a gl account is requested.';
        GLAccountApprovalRequestCancelEventDescTxt: Label 'ENU=An approval request for a gl account is canceled.;ENN=An approval request for a gl account is canceled.';
        GLAccountChangedTxt: Label 'ENU=A gl account record is changed.;ENN=A gl account record is changed.';
        BankAccountSendForApprovalEventDescTxt: Label 'ENU=Approval of a bank account is requested.';
        BankAccountApprovalRequestCancelEventDescTxt: Label 'ENU=An approval request for a bank account is canceled.';
        BankAccountChangedTxt: Label 'ENU=A bank account record is changed.';
        ReversalEntrySendForApprovalEventDescTxt: Label 'ENU=Approval of a Reversal Entry is requested.;ENN=Approval of a Reversal Entry is requested.';
        ReversalEntryApprovalRequestCancelEventDescTxt: Label 'ENU=An approval request for a Reversal Entry is canceled.;ENN=An approval request for a  Reversal Entry is canceled.';
        ReversalEntryChangedTxt: Label 'ENU=A Reversal Entry record is changed.;ENN=A gl account record is changed.';
        UserSetupSendForApprovalEventDescTxt: Label 'ENU=Approval of a User Setup is requested.';
        UserSetupApprovalRequestCancelEventDescTxt: Label 'ENU=An approval request for a User Setup is canceled.';
        UserSetupChangedTxt: Label 'ENU=A User Setup record is changed.';
        TaxJournalLineSendForApprovalEventDescTxt: Label 'ENU=Approval of a tax journal line is requested.;ENN=Approval of a general journal line is requested.';
        TaxJournalLineApprovalRequestCancelEventDescTxt: Label 'ENU=An approval request for a tax journal line is canceled.;ENN=An approval request for a general journal line is canceled.';
        POLinesSendForApprovalEventDescTxt: Label 'ENU=Approval of a PO Orders lines is requested.;ENN=Approval of a PO Orders lines is requested.';
        POLinesApprovalRequestCancelEventDescTxt: Label 'ENU=An approval request for a PO Orders line is canceled.;ENN=An approval request for a PO Ordersl line is canceled.';
        ALMSendForApprovalEventDescTxt: Label 'ENU=Approval of a ALM Sheet  is requested.;ENN=Approval of a PO Orders lines is requested.';
        ALMApprovalRequestCancelEventDescTxt: Label 'ENU=An approval request for a ALM Sheet is canceled.;ENN=An approval request for a PO Ordersl line is canceled.';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", OnAddWorkflowEventsToLibrary, '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        //CCIT Vikas
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendGLAccountForApprovalCode, DATABASE::"G/L Account",
          GLAccountSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelGLAccountApprovalRequestCode, DATABASE::"G/L Account",
          GLAccountApprovalRequestCancelEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendBankAccountForApprovalCode, DATABASE::"Bank Account",
          BankAccountSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelBankAccountApprovalRequestCode, DATABASE::"Bank Account",
          BankAccountApprovalRequestCancelEventDescTxt, 0, FALSE);
        //CCIT AN 16032023
        //>> ST
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendTaxJournalLineForApprovalCode, DATABASE::"TDS Journal Line",
        TaxJournalLineSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelTaxJournalLineApprovalRequestCode, DATABASE::"TDS Journal Line",
          TaxJournalLineApprovalRequestCancelEventDescTxt, 0, FALSE);
        //<< ST
        //CCIT Vikas

        //CCIT AN 06022023 for Reversal Approval
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendReversalEntryForApprovalCode, DATABASE::"G/L Entry",
          ReversalEntrySendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelReversalEntryApprovalRequestCode, DATABASE::"G/L Entry",
          ReversalEntryApprovalRequestCancelEventDescTxt, 0, FALSE);
        //CCIT AN 06022023 for Reversal Approval

        //CCIT AN 16022023 For User Setup Approval
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendUserSetupForApprovalCode, DATABASE::"User Setup",
          UserSetupSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelUserSetupApprovalRequestCode, DATABASE::"User Setup",
          UserSetupApprovalRequestCancelEventDescTxt, 0, FALSE);
        //CCIT AN 16022023 For User Setup Approval--

        //CCIT AN 24072023 Bulk PO Orders
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendPOrderslLineForApprovalCode, DATABASE::"Purchase Header",
        POLinesSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelPordersLineApprovalRequestCode, DATABASE::"Purchase Header",
        POLinesApprovalRequestCancelEventDescTxt, 0, FALSE);

        //CCIT AN 27022024 ALM Approval
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendALMForApprovalCode, DATABASE::"ALM Header",
          ALMSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelALMApprovalRequestCode, DATABASE::"ALM Header",
          ALMApprovalRequestCancelEventDescTxt, 0, FALSE);
        //CCIT AN 27092024 ALM Approval--

        //CCIT-Vikas
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnGLAccountChangedCode, DATABASE::"G/L Account", GLAccountChangedTxt, 0, TRUE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnBankAccountChangedCode, DATABASE::"Bank Account", BankAccountChangedTxt, 0, TRUE);
        //CCIT AN 06022023 for Reversal Approval
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReversalEntryChangedCode, DATABASE::"G/L Entry", ReversalEntryChangedTxt, 0, TRUE);
        //CCIT AN 06022023 for Reversal Approval--
        //CCIT AN 16022023 For User Setup Approval
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnUserSetupChangedCode, DATABASE::"User Setup", UserSetupChangedTxt, 0, TRUE);
        //CCIT AN 16022023 For User Setup Approval--
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", OnAddWorkflowEventPredecessorsToLibrary, '', false, false)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        CASE EventFunctionName OF
            //CCIT Vikas
            RunWorkflowOnCancelGLAccountApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelGLAccountApprovalRequestCode, RunWorkflowOnSendGLAccountForApprovalCode);

            RunWorkflowOnCancelBankAccountApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelBankAccountApprovalRequestCode, RunWorkflowOnSendBankAccountForApprovalCode);

            RunWorkflowOnCancelTaxJournalLineApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelTaxJournalLineApprovalRequestCode,
                  RunWorkflowOnSendTaxJournalLineForApprovalCode);//16032023

            //CCIT AN 06022023 for Reversal Approval
            RunWorkflowOnCancelReversalEntryApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelReversalEntryApprovalRequestCode, RunWorkflowOnSendReversalEntryForApprovalCode);

            //CCIT AN 16022023 for user setup Approval
            RunWorkflowOnCancelUserSetupApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelUserSetupApprovalRequestCode, RunWorkflowOnSendUserSetupForApprovalCode);

            //CCIT AN 24072023 Bulk PO Orders
            RunWorkflowOnCancelPordersLineApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelPordersLineApprovalRequestCode, RunWorkflowOnSendPOrderslLineForApprovalCode);

            //CCIT AN 27022024 ALM Sheet
            RunWorkflowOnCancelALMApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelALMApprovalRequestCode, RunWorkflowOnSendALMForApprovalCode);

            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                begin
                    //CCIT Vikas
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendGLAccountForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendBankAccountForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendTaxJournalLineForApprovalCode);//16032023
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendReversalEntryForApprovalCode);//CCIT AN 06022023 for Reversal Approval
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendUserSetupForApprovalCode);//CCIT AN 16022023 UserSetup
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendPOrderslLineForApprovalCode);//CCIT AN 24072023 Bulk PO Orders
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendALMForApprovalCode);//CCIT AN 27022024 ALM
                                                                                                                                                                  //CCIT Vikas
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnGLAccountChangedCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnBankAccountChangedCode);
                    //CCIT AN 06022023 for Reversal Approval
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnReversalEntryChangedCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnUserSetupChangedCode); //CCIT AN 16022023 UserSetup
                end;
            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                begin
                    //CCIT-Vikas
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendGLAccountForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendBankAccountForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendTaxJournalLineForApprovalCode);//16032023
                                                                                                                                                                            //CCIT AN 06022023 for Reversal Approval
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendReversalEntryForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendUserSetupForApprovalCode); //CCIT AN 16022023 UserSetup
                                                                                                                                                                        //CCIT AN 24072023 Bulk PO Orders
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendPOrderslLineForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendALMForApprovalCode); //CCIT AN 27022024 ALM
                end;
            WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode:
                begin
                    //CCIT Vikas
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendGLAccountForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendBankAccountForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendTaxJournalLineForApprovalCode);
                    //CCIT AN 06022023 for Reversal Approval
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendReversalEntryForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendUserSetupForApprovalCode);//CCIT AN  16022023 UserSetup
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendPOrderslLineForApprovalCode);//CCIT AN 24072023 Bulk PO Orders
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendALMForApprovalCode);//CCIT AN 27022024 ALM
                end;
        end;
    end;

    local procedure "----GLAccount---------"()
    begin
    end;

    procedure RunWorkflowOnSendGLAccountForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendGLAccountForApproval'));
    end;

    procedure RunWorkflowOnCancelGLAccountApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelGLAccountApprovalRequest'));
    end;

    procedure RunWorkflowOnGLAccountChangedCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnGLAccountChangedCode'));
    end;

    procedure RunWorkflowOnSendGLAccountForApproval(var GLAccount: Record "G/L Account")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendGLAccountForApprovalCode, GLAccount);
    end;

    procedure RunWorkflowOnCancelGLAccountApprovalRequest(var GLAccount: Record "G/L Account")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelGLAccountApprovalRequestCode, GLAccount);
    end;

    [EventSubscriber(ObjectType::Table, 15, OnAfterModifyEvent, '', false, false)]
    procedure RunWorkflowOnGLAccountChanged(var Rec: Record "G/L Account"; var xRec: Record "G/L Account"; RunTrigger: Boolean)
    begin
        IF FORMAT(xRec) <> FORMAT(Rec) THEN
            WorkflowManagement.HandleEventWithxRec(RunWorkflowOnGLAccountChangedCode, Rec, xRec);
    end;

    local procedure "----Bank Account---------"()
    begin
    end;

    procedure RunWorkflowOnSendBankAccountForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendBankAccountForApproval'));
    end;

    procedure RunWorkflowOnCancelBankAccountApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelBankAccountApprovalRequest'));
    end;

    procedure RunWorkflowOnBankAccountChangedCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnBankAccountChangedCode'));
    end;


    procedure RunWorkflowOnSendBankAccountForApproval(var BankAccount: Record "Bank Account")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendBankAccountForApprovalCode, BankAccount);
    end;

    procedure RunWorkflowOnCancelBankAccountApprovalRequest(var BankAccount: Record "Bank Account")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelBankAccountApprovalRequestCode, BankAccount);
    end;

    [EventSubscriber(ObjectType::Table, 270, OnAfterModifyEvent, '', false, false)]
    procedure RunWorkflowOnBankAccountChanged(var Rec: Record "Bank Account"; var xRec: Record "Bank Account"; RunTrigger: Boolean)
    begin
        IF FORMAT(xRec) <> FORMAT(Rec) THEN
            WorkflowManagement.HandleEventWithxRec(RunWorkflowOnBankAccountChangedCode, Rec, xRec);
    end;

    local procedure "----TaxJournal-------"()
    begin
    end;

    //>> ST
    procedure RunWorkflowOnSendTaxJournalLineForApproval(var TaxJournalLine: Record "TDS Journal Line")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendTaxJournalLineForApprovalCode, TaxJournalLine);
    end;

    procedure RunWorkflowOnCancelTaxJournalLineApprovalRequest(var TaxJournalLine: Record "TDS Journal Line")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelTaxJournalLineApprovalRequestCode, TaxJournalLine);
    end;
    //<< ST

    procedure RunWorkflowOnAfterInsertTaxJournalLineCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterInsertTaxJournalLine'));
    end;

    procedure RunWorkflowOnSendTaxJournalLineForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendTaxJournalLineForApproval'));
    end;

    procedure RunWorkflowOnCancelTaxJournalLineApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelTaxJournalLineApprovalRequest'));
    end;

    local procedure "-------ReversalEntry---------"()
    begin
        //CCIT AN 06022023 for Reversal Approval
    end;

    procedure RunWorkflowOnSendReversalEntryForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendReversalEntryForApproval'));
    end;

    procedure RunWorkflowOnCancelReversalEntryApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelReversalEntryApprovalRequest'));
    end;

    procedure RunWorkflowOnReversalEntryChangedCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReversalEntryChanged'));
    end;

    procedure RunWorkflowOnSendReversalEntryForApproval(var GLEntry: Record "G/L Entry")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendReversalEntryForApprovalCode, GLEntry);
    end;

    procedure RunWorkflowOnCancelReversalEntryApprovalRequest(var GLEntry: Record "G/L Entry")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelReversalEntryApprovalRequestCode, GLEntry);
    end;

    [EventSubscriber(ObjectType::Table, 17, 'OnAfterModifyEvent', '', false, false)]
    procedure RunWorkflowOnReversalEntryChanged(var Rec: Record "G/L Entry"; var xRec: Record "G/L Entry"; RunTrigger: Boolean)
    begin
        IF FORMAT(xRec) <> FORMAT(Rec) THEN
            WorkflowManagement.HandleEventWithxRec(RunWorkflowOnReversalEntryChangedCode, Rec, xRec);
        //CCIT AN 06022023
    end;

    local procedure "-----User Setup---------"()
    begin
    end;

    procedure RunWorkflowOnSendUserSetupForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendUserSetupForApproval'));
    end;

    procedure RunWorkflowOnCancelUserSetupApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelUserSetupApprovalRequest'));
    end;

    procedure RunWorkflowOnSendUserSetupForApproval(var UserSetup: Record "User Setup")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendUserSetupForApprovalCode, UserSetup);
    end;

    procedure RunWorkflowOnCancelUserSetupApprovalRequest(var UserSetup: Record "User Setup")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelUserSetupApprovalRequestCode, UserSetup);
    end;

    [EventSubscriber(ObjectType::Table, 91, 'OnAfterModifyEvent', '', false, false)]
    procedure RunWorkflowOnUserSetupChanged(var Rec: Record "User Setup"; var xRec: Record "User Setup"; RunTrigger: Boolean)
    begin
        IF FORMAT(xRec) <> FORMAT(Rec) THEN
            WorkflowManagement.HandleEventWithxRec(RunWorkflowOnUserSetupChangedCode, Rec, xRec);
    end;

    procedure RunWorkflowOnUserSetupChangedCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnUserSetupChangedCode'));
    end;

    local procedure "-----PO Lines-----"()
    begin
        //CCIT AN Bulk PO Lines 24072023
    end;

    procedure RunWorkflowOnSendPOrderslLineForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendPOrdersLineForApproval'));
    end;

    procedure RunWorkflowOnCancelPordersLineApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelPOrdersLineApprovalRequest'));
    end;

    procedure RunWorkflowOnSendPOLinesForApproval(var PurchaseHeader: Record "Purchase Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPOrderslLineForApprovalCode, PurchaseHeader);
    end;

    procedure RunWorkflowOnCancelPOLinesApprovalRequest(var PurchaseHeader: Record "Purchase Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelPordersLineApprovalRequestCode, PurchaseHeader);
    end;

    local procedure "-----ALMs-----"()
    begin
        //CCIT AN ALM 27022024
    end;

    procedure RunWorkflowOnSendALMForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendALMSheetForApproval'));
    end;

    procedure RunWorkflowOnCancelALMApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelALMSheetApprovalRequest'));
    end;

    procedure RunWorkflowOnSendALMForApproval(var ALMHeader: Record "ALM Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendALMForApprovalCode, ALMHeader);
    end;

    procedure RunWorkflowOnCancelALMApprovalRequest(var ALMHeader: Record "ALM Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelALMApprovalRequestCode, ALMHeader);
    end;

}