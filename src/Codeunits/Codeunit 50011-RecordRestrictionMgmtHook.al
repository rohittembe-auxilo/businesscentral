codeunit 50011 "Record Restriction Mgt. hook"
{
    Permissions = tabledata "Approval Entry" = rimd;

    trigger OnRun()
    begin
    end;

    var
        RecordRestrictionMgt: Codeunit "Record Restriction Mgt.";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmtHook: Codeunit "Approval Management hook";
        RestrictLineUsageDetailsTxt: Label 'The restriction was imposed because the line requires approval.';

    local procedure "----GLAccount------"()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Account", 'OnBeforeDeleteEvent', '', false, false)]
    procedure RemoveGLAccountRestrictionsBeforeDelete(var Rec: Record "G/L Account"; RunTrigger: Boolean)
    begin
        RecordRestrictionMgt.AllowRecordUsage(Rec.RECORDID);
    end;

    local procedure "--Tax Journal---"()
    begin
    end;

    //>> ST
    // [EventSubscriber(ObjectType::Table, "Tax Journal Line", 'OnAfterInsertEvent', '', false, false)]
    // procedure RestrictTaxJournalLineAfterInsert(var Rec: Record "Tax Journal Line"; RunTrigger: Boolean)
    // begin
    //     RestrictTaxJournalLine(Rec);
    // end;

    // [EventSubscriber(ObjectType::Table, "Tax Journal Line", 'OnAfterModifyEvent', '', false, false)]
    // procedure RestrictTaxJournalLineAfterModify(var Rec: Record "Tax Journal Line"; var xRec: Record "Tax Journal Line"; RunTrigger: Boolean)
    // begin
    //     IF FORMAT(Rec) = FORMAT(xRec) THEN
    //         EXIT;
    //     RestrictTaxJournalLine(Rec);
    // end;

    // local procedure RestrictTaxJournalLine(var TaxJournalLine: Record "Tax Journal Line")
    // var
    //     GenJournalBatch: Record "Gen. Journal Batch";
    // begin
    //     IF TaxJournalLine."System-Created Entry" OR TaxJournalLine.ISTEMPORARY THEN
    //         EXIT;

    //     IF ApprovalsMgmtHook.IsTaxJournalLineApprovalsWorkflowEnabled(TaxJournalLine) THEN
    //         RecordRestrictionMgt.RestrictRecordUsage(TaxJournalLine.RECORDID, RestrictLineUsageDetailsTxt);
    // end;

    // [EventSubscriber(ObjectType::Table, "Tax Journal Line", OnCheckTaxJournalLinePostRestrictions, '', false, false)]
    // procedure TaxJournalLineCheckTaxJournalLinePostRestrictions(var Sender: Record "Tax Journal Line")
    // begin
    //     RecordRestrictionMgt.CheckRecordHasUsageRestrictions(Sender.RECORDID);
    // end;

    // [EventSubscriber(ObjectType::Table, "Tax Journal Line", OnAfterModifyEvent, '', false, false)]
    // procedure RestrictTaxJournalLineAfterCancelApproval(var Rec: Record "Tax Journal Line"; var xRec: Record "Tax Journal Line"; RunTrigger: Boolean)
    // begin
    //     IF FORMAT(Rec) = FORMAT(xRec) THEN
    //         EXIT;
    //     RestrictTaxJournalLine(Rec);
    // end;
    //<< ST
}