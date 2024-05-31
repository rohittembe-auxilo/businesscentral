codeunit 50013 "Duplicate Depr. Book Hook"
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Duplicate Depr. Book", OnBeforeGenJnlLineDuplicate, '', false, false)]
    local procedure OnBeforeGenJnlLineDuplicate(var GenJournalLine: Record "Gen. Journal Line"; var FAAmount: Decimal)
    begin
        if GenJournalLine."Depreciation Book Code" = '' then
            GenJournalLine."Depreciation Book Code" := 'COMPANY';
    end;

}