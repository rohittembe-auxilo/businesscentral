codeunit 50003 "Posting Prev. Event Handlr Hk"
{
    trigger OnRun()
    begin

    end;

    var
        TempDeferralGLEntries: Record "Deferral G/L Entries" temporary;
        ShowDocNo: Boolean;
        CommitPrevented: Boolean;

    procedure PreventCommit()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if CommitPrevented then
            exit;

        // Mark any table as inconsistent as long as it is not made consistent later in the transaction
        SalesInvoiceHeader.Init();
        SalesInvoiceHeader.Consistent(false);
        CommitPrevented := true;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", OnGetEntries, '', false, false)]
    local procedure OnGetEntries(TableNo: Integer; var RecRef: RecordRef)
    begin
        case TableNo of
            Database::"Deferral G/L Entries":
                RecRef.GetTable(TempDeferralGLEntries);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", OnAfterShowEntries, '', false, false)]
    local procedure OnAfterShowEntries(TableNo: Integer)
    begin
        case TableNo of
            Database::"Deferral G/L Entries":
                Page.Run(Page::"Defferal G/L Entries", TempDeferralGLEntries);//vikasdeferralentries

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", OnAfterFillDocumentEntry, '', false, false)]
    local procedure OnAfterFillDocumentEntry(var DocumentEntry: Record "Document Entry" temporary)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(TempDeferralGLEntries);

        if RecRef.IsEmpty() then
            exit;

        DocumentEntry.Init();
        DocumentEntry."Entry No." := RecRef.Number;
        DocumentEntry."Table ID" := RecRef.Number;
        DocumentEntry."Table Name" := RecRef.Caption;
        DocumentEntry."No. of Records" := RecRef.Count();
        DocumentEntry.Insert();
    end;


    [EventSubscriber(ObjectType::Table, Database::"Deferral G/L Entries", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEvent(var Rec: Record "Deferral G/L Entries"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary() then
            exit;

        PreventCommit();
        TempDeferralGLEntries := Rec;
        if not ShowDocNo then
            TempDeferralGLEntries."Document No." := '***';
        TempDeferralGLEntries.Insert();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Deferral G/L Entries", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEvent(var Rec: Record "Deferral G/L Entries"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary() then
            exit;

        TempDeferralGLEntries := Rec;
        if not ShowDocNo then
            TempDeferralGLEntries."Document No." := '***';

        if TempDeferralGLEntries.Modify() then
            PreventCommit();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Deferral G/L Entries", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertFALedgEntry(var Rec: Record "Deferral G/L Entries"; RunTrigger: Boolean)
    begin
        if Rec.IsTemporary() then
            exit;

        PreventCommit();
        TempDeferralGLEntries := Rec;
        if not ShowDocNo then
            TempDeferralGLEntries."Document No." := '***';
        TempDeferralGLEntries.Insert();
    end;
}