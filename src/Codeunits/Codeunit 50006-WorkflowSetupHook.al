codeunit 50006 "Workflow Setup Hook"
{
    Permissions = tabledata "Approval Entry" = rimd;
    trigger OnRun()
    begin

    end;

    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling Hook";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        BlankDateFormula: DateFormula;
        FinCategoryTxt: Label '@@@={Locked};ENU=FIN;ENN=FIN';
        GLAccountTypeCondnTxt: Label '@@@={Locked};ENU="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""G/L Account"">%1</DataItem></DataItems></ReportParameters>";ENN="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""G/L Account"">%1</DataItem></DataItems></ReportParameters>"';
        GLAccountApprWorkflowCodeTxt: Label '@@@={Locked};ENU=GLAPW;ENN=GLAPW';
        GLAccountApprWorkflowDescTxt: Label 'ENU=GL Account Approval Workflow;ENN=GL Account Approval Workflow';
        GLAccountCategoryTxt: Label 'ENU=GL';
        GLAccountCategoryDescTxt: Label 'ENU=GL Account Documents';
        BankAccountTypeCondnTxt: Label '@@@={Locked};ENU="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Bank Account"">%1</DataItem></DataItems></ReportParameters>";ENN="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Bank Account"">%1</DataItem></DataItems></ReportParameters>"';
        BankAccountApprWorkflowCodeTxt: Label '@@@={Locked};ENU=BankAPW;ENN=GLAPW';
        BankAccountApprWorkflowDescTxt: Label 'ENU=Bank Account Approval Workflow;ENN=GL Account Approval Workflow';
        BankAccountCategoryTxt: Label 'ENU=Bank';
        BankAccountCategoryDescTxt: Label 'ENU=Bank Account Documents';
        ReversalEntryTypeCondnTxt: Label '@@@={Locked};ENU="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=G/L Entry>%1</DataItem></DataItems></ReportParameters>";ENN="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=G/L Entry>%1</DataItem></DataItems></ReportParameters>"';
        ReversalEntryApprWorkflowCodeTxt: Label '@@@={Locked};ENU=REVentryAPW;ENN=REVentryAPW';
        ReversalEntryApprWorkflowDescTxt: Label 'ENU=Reversal Entry Approval Workflow;ENN=Reversal Entry Approval Workflow';
        ReversalEntryCategoryTxt: Label 'ENU=GLREV';
        ReversalEntryCategoryDescTxt: Label 'ENU=Reversal Entry Documents';
        UserSetupTypeCondnTxt: Label '@@@={Locked};ENU="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""User Setup"">%1</DataItem></DataItems></ReportParameters>";ENN="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""User Setup"">%1</DataItem></DataItems></ReportParameters>"';
        UserSetupApprWorkflowCodeTxt: Label '@@@={Locked};ENU=USAPW;ENN=USAPW';
        UserSetupApprWorkflowDescTxt: Label 'ENU=User Setup Approval Workflow;ENN=User Setup Approval Workflow';
        UserSetupCategoryTxt: Label 'ENU=UserSetup';
        UserSetupCategoryDescTxt: Label 'ENU=User Setup Documents';
        POLineTypeCondnTxt: Label '@@@={Locked};ENU="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Purchase Header"">%1</DataItem></DataItems></ReportParameters>";ENN="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Purchase Header"">%1</DataItem></DataItems></ReportParameters>"';
        POLineApprWorkflowCodeTxt: Label '@@@={Locked};ENU=POLSAPW;ENN=POLSAPW';
        POLineApprWorkflowDescTxt: Label 'ENU=PO Lines Approval Workflow;ENN=POl Lines Approval Workflow';
        POLineCategoryTxt: Label 'ENU=POLines';
        POLineCategoryDescTxt: Label 'ENU=PO Lines Documents';
        ALMTypeCondnTxt: Label '@@@={Locked};ENU="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""ALM Header"">%1</DataItem></DataItems></ReportParameters>";ENN="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Purchase Header"">%1</DataItem></DataItems></ReportParameters>"';
        ALMApprWorkflowCodeTxt: Label '@@@={Locked};ENU=ALMAPWF;ENN=POLSAPW';
        ALMApprWorkflowDescTxt: Label 'ENU=ALM Approval Workflow;ENN=POl Lines Approval Workflow';
        ALMCategoryTxt: Label 'ENU=ALMS';
        ALMCategoryDescTxt: Label 'ENU=ALM Documents';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", OnInsertWorkflowTemplates, '', false, false)]
    local procedure OnInsertWorkflowTemplates(var Sender: Codeunit "Workflow Setup")
    begin
        InsertPOLinesApprovalWorkflowTemplate; //CCIT AN 24072023
        InsertALMApprovalWorkflowTemplate; //CCIT AN 27022024
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", OnAddWorkflowCategoriesToLibrary, '', false, false)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WorkflowSetup.InsertWorkflowCategory(POLineCategoryTxt, POLineCategoryDescTxt);//CCIT AN 24072023
        WorkflowSetup.InsertWorkflowCategory(ALMCategoryTxt, ALMCategoryDescTxt); //CCIT AN 27022024
    end;

    local procedure "---GLAccount----"()
    begin
    end;

    local procedure InsertGLAccountApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
        BlankDateFormula: DateFormula;
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, GLAccountApprWorkflowCodeTxt, GLAccountApprWorkflowDescTxt, FinCategoryTxt);
        InsertGLAccountApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    procedure InsertGLAccountApprovalWorkflow()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        Workflow: Record Workflow;
    begin
        InsertWorkflow(Workflow, GetWorkflowCode(GLAccountApprWorkflowCodeTxt), GLAccountApprWorkflowDescTxt, FinCategoryTxt);
        InsertGLAccountApprovalWorkflowDetails(Workflow);
    end;

    local procedure InsertGLAccountApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
          0, '', BlankDateFormula, TRUE);

        WorkflowSetup.InsertRecApprovalWorkflowSteps(Workflow, BuildGLAccountTypeConditions,
          WorkflowEventHandling.RunWorkflowOnSendGLAccountForApprovalCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowEventHandling.RunWorkflowOnCancelGLAccountApprovalRequestCode,
          WorkflowStepArgument,
          TRUE, TRUE);
    end;

    procedure GLAccountWorkflowCode(): Code[17]
    begin
        EXIT(GLAccountApprWorkflowCodeTxt);
    end;

    local procedure BuildGLAccountTypeConditions(): Text
    var
        GLAccount: Record "G/L Account";
    begin
        EXIT(STRSUBSTNO(GLAccountTypeCondnTxt, Encode(GLAccount.GETVIEW(FALSE))));
    end;

    local procedure "---Bank Account----"()
    begin
    end;

    local procedure InsertBankAccountApprovalWorkflowTemplate()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        Workflow: Record Workflow;
        BlankDateFormula: DateFormula;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, BankAccountApprWorkflowCodeTxt, BankAccountApprWorkflowDescTxt, FinCategoryTxt);
        InsertBankAccountApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    procedure InsertBankAccountApprovalWorkflow()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflow(Workflow, GetWorkflowCode(BankAccountApprWorkflowCodeTxt), BankAccountApprWorkflowDescTxt, FinCategoryTxt);
        InsertBankAccountApprovalWorkflowDetails(Workflow);
    end;

    local procedure InsertBankAccountApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
          0, '', BlankDateFormula, TRUE);

        WorkflowSetup.InsertRecApprovalWorkflowSteps(Workflow, BuildBankAccountTypeConditions,
          WorkflowEventHandling.RunWorkflowOnSendBankAccountForApprovalCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowEventHandling.RunWorkflowOnCancelBankAccountApprovalRequestCode,
          WorkflowStepArgument,
          TRUE, TRUE);
    end;

    procedure BankAccountWorkflowCode(): Code[17]
    begin
        EXIT(BankAccountApprWorkflowCodeTxt);
    end;

    local procedure BuildBankAccountTypeConditions(): Text
    var
        BankAccount: Record "Bank Account";
    begin
        EXIT(STRSUBSTNO(BankAccountTypeCondnTxt, Encode(BankAccount.GETVIEW(FALSE))));
    end;

    local procedure "---Reversal Entry---"()
    begin
        //CCIT AN 06022022
    end;

    local procedure InsertReversalEntryApprovalWorkflowTemplate()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        Workflow: Record Workflow;
        BlankDateFormula: DateFormula;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, ReversalEntryApprWorkflowCodeTxt, ReversalEntryApprWorkflowDescTxt, ReversalEntryCategoryTxt);
        InsertReversalEntryApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    procedure InsertReversalEntryApprovalWorkflow()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflow(Workflow, GetWorkflowCode(ReversalEntryApprWorkflowCodeTxt), ReversalEntryApprWorkflowDescTxt, ReversalEntryCategoryTxt);
        InsertReversalEntryApprovalWorkflowDetails(Workflow);
    end;

    local procedure InsertReversalEntryApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
          0, '', BlankDateFormula, TRUE);

        WorkflowSetup.InsertRecApprovalWorkflowSteps(Workflow, BuildReversalEntryTypeConditions,
          WorkflowEventHandling.RunWorkflowOnSendReversalEntryForApprovalCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowEventHandling.RunWorkflowOnCancelReversalEntryApprovalRequestCode,
          WorkflowStepArgument,
          TRUE, TRUE);
    end;

    procedure ReversalEntryWorkflowCode(): Code[17]
    begin
        EXIT(ReversalEntryApprWorkflowCodeTxt);
    end;

    local procedure BuildReversalEntryTypeConditions(): Text
    var
        GLEntry: Record "G/L Account";
    begin
        EXIT(STRSUBSTNO(ReversalEntryTypeCondnTxt, Encode(GLEntry.GETVIEW(FALSE))));
    end;

    local procedure "---User Setup----"()
    begin
    end;

    local procedure InsertUserSetupApprovalWorkflowTemplate()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        Workflow: Record Workflow;
        BlankDateFormula: DateFormula;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, UserSetupApprWorkflowCodeTxt, UserSetupApprWorkflowDescTxt, UserSetupCategoryTxt);
        InsertUserSetupApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    procedure InsertUserSetupApprovalWorkflow()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflow(Workflow, GetWorkflowCode(UserSetupApprWorkflowCodeTxt), UserSetupApprWorkflowDescTxt, UserSetupCategoryTxt);
        InsertBankAccountApprovalWorkflowDetails(Workflow);
    end;

    local procedure InsertUserSetupApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
          0, '', BlankDateFormula, TRUE);

        WorkflowSetup.InsertRecApprovalWorkflowSteps(Workflow, BuildBankAccountTypeConditions,
          WorkflowEventHandling.RunWorkflowOnSendBankAccountForApprovalCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowEventHandling.RunWorkflowOnCancelBankAccountApprovalRequestCode,
          WorkflowStepArgument,
          TRUE, TRUE);

        //InsertRecApprovalWorkflowSteps(Workflow,BuildUserSetupTypeConditions,
        // WorkflowEventHandling.runworkflowonafterus
    end;

    procedure UserSetupWorkflowCode(): Code[17]
    begin
        EXIT(UserSetupApprWorkflowCodeTxt);
    end;

    local procedure BuildUserSetupTypeConditions(): Text
    var
        UserSetup: Record "User Setup";
    begin
        EXIT(STRSUBSTNO(UserSetupCategoryDescTxt, Encode(UserSetup.GETVIEW(FALSE))));
        //CCIT AN 06022022
    end;

    local procedure "---Bulk PO Orders-----"()
    begin
        //CCIT 24072023
    end;

    local procedure InsertPOLinesApprovalWorkflowTemplate()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        Workflow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, POLineApprWorkflowCodeTxt,
          POLineApprWorkflowDescTxt, POLineCategoryTxt);
        InsertPOLinesApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertPOLinesApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        WorkflowStepArgument: Record "Workflow Step Argument";
        PurchaseHeader: Record "Purchase Header";
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
          0, '', BlankDateFormula, FALSE);

        PurchaseHeader.INIT;
        WorkflowSetup.InsertRecApprovalWorkflowSteps(Workflow, BuildPOLinesTypeConditions(PurchaseHeader),
          WorkflowEventHandling.RunWorkflowOnSendPOrderslLineForApprovalCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowEventHandling.RunWorkflowOnCancelPordersLineApprovalRequestCode,
          WorkflowStepArgument,
          FALSE, FALSE);
    end;

    procedure InsertPOLinesApprovalWorkflow()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflow(Workflow, GetWorkflowCode(POLineApprWorkflowCodeTxt), POLineApprWorkflowDescTxt, POLineCategoryTxt);
        InsertPOLinesApprovalWorkflowDetails(Workflow);
    end;

    procedure POLinesApprovalWorkflowCode(): Code[17]
    begin
        EXIT(POLineApprWorkflowCodeTxt);
    end;

    local procedure BuildPOLinesTypeConditions(var PurchaseHeader: Record "Purchase Header"): Text
    begin
        EXIT(STRSUBSTNO(POLineTypeCondnTxt, Encode(PurchaseHeader.GETVIEW(FALSE))));

        //CCIT 24072023
    end;

    local procedure "----ALM Workflow----"()
    begin
        //CCIT AN 27022024++
    end;

    local procedure InsertALMApprovalWorkflowTemplate()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        Workflow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, ALMApprWorkflowCodeTxt,
          ALMApprWorkflowDescTxt, ALMCategoryTxt);
        InsertALMApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertALMApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        WorkflowStepArgument: Record "Workflow Step Argument";
        ALMHeader: Record "ALM Header";
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
          0, '', BlankDateFormula, FALSE);

        ALMHeader.INIT;
        WorkflowSetup.InsertRecApprovalWorkflowSteps(Workflow, BuildALMTypeConditions(ALMHeader),
          WorkflowEventHandling.RunWorkflowOnSendALMForApprovalCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowEventHandling.RunWorkflowOnCancelALMApprovalRequestCode,
          WorkflowStepArgument,
          FALSE, FALSE);
    end;

    procedure InsertALMApprovalWorkflow()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflow(Workflow, GetWorkflowCode(ALMApprWorkflowCodeTxt), ALMApprWorkflowDescTxt, ALMCategoryTxt);
        InsertALMApprovalWorkflowDetails(Workflow);
    end;

    procedure ALMApprovalWorkflowCode(): Code[17]
    begin
        EXIT(ALMApprWorkflowCodeTxt);
    end;

    local procedure BuildALMTypeConditions(var ALMHeader: Record "ALM Header"): Text
    begin
        EXIT(STRSUBSTNO(ALMTypeCondnTxt, Encode(ALMHeader.GETVIEW(FALSE))));

        //CCIT 27022024--
    end;

    local procedure InsertWorkflow(var Workflow: Record Workflow; WorkflowCode: Code[20]; WorkflowDescription: Text[100]; CategoryCode: Code[20])
    begin
        Workflow.Init();
        Workflow.Code := WorkflowCode;
        Workflow.Description := WorkflowDescription;
        Workflow.Category := CategoryCode;
        Workflow.Enabled := false;
        Workflow.Insert();
    end;


    local procedure GetWorkflowCode(WorkflowCode: Text): Code[20]
    var
        Workflow: Record Workflow;
    begin
        exit(CopyStr(Format(Workflow.Count + 1) + '-' + WorkflowCode, 1, MaxStrLen(Workflow.Code)));
    end;

    local procedure Encode(Text: Text): Text
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
    begin
        EXIT(XMLDOMManagement.XMLEscape(Text));
    end;

}