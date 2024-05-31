codeunit 50021 "Gen. Jnl.-Post Auto Jobque"
{
    // version CCIT AN

    TableNo = 81;

    trigger OnRun()
    begin
        GenJnlLine.COPY(Rec);
        Code;
        Rec.COPY(GenJnlLine);
    end;

    var
        Text000: Label 'cannot be filtered when posting recurring journals';
        Text001: Label 'Do you want to post the journal lines?';
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The journal lines were successfully posted.';
        Text004: Label 'The journal lines were successfully posted. You are now in the %1 journal.';
        Text005: Label 'Using %1 for Declining Balance can result in misleading numbers for subsequent years. You should manually check the postings and correct them if necessary. Do you want to continue?';
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        TempJnlBatchName: Code[10];
        Text006: Label '%1 in %2 must not be equal to %3 in %4.', Comment = 'Source Code in Genenral Journal Template must not be equal to Job G/L WIP in Source Code Setup.';
        Text16500: Label 'Document type should be Payment with party type Party in case of TDS. ';
        PreviewMode: Boolean;

    [TryFunction]
    local procedure "Code"()
    var
        FALedgEntry: Record "FA Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        GenJnlTemplate.GET(GenJnlLine."Journal Template Name");
        IF GenJnlTemplate.Type = GenJnlTemplate.Type::Jobs THEN BEGIN
            SourceCodeSetup.GET;
            IF GenJnlTemplate."Source Code" = SourceCodeSetup."Job G/L WIP" THEN
                ERROR(Text006, GenJnlTemplate.FIELDCAPTION("Source Code"), GenJnlTemplate.TABLECAPTION,
                  SourceCodeSetup.FIELDCAPTION("Job G/L WIP"), SourceCodeSetup.TABLECAPTION);
        END;
        GenJnlTemplate.TESTFIELD("Force Posting Report", FALSE);
        IF GenJnlTemplate.Recurring AND (GenJnlLine.GETFILTER("Posting Date") <> '') THEN
            GenJnlLine.FIELDERROR("Posting Date", Text000);

        //IF NOT PreviewMode THEN
        //IF NOT CONFIRM(Text001,FALSE) THEN //Commented for hiding confirm box for auto posting
        //  EXIT;

        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset" THEN BEGIN
            FALedgEntry.SETRANGE("FA No.", GenJnlLine."Account No.");
            FALedgEntry.SETRANGE("FA Posting Type", GenJnlLine."FA Posting Type"::"Acquisition Cost");
            IF FALedgEntry.FINDFIRST AND GenJnlLine."Depr. Acquisition Cost" THEN
                IF NOT CONFIRM(Text005, FALSE, GenJnlLine.FIELDCAPTION("Depr. Acquisition Cost")) THEN
                    EXIT;
        END;


        TempJnlBatchName := GenJnlLine."Journal Batch Name";

        GenJnlPostBatch.RUN(GenJnlLine);

        IF PreviewMode THEN
            EXIT;

        IF GenJnlLine."Line No." = 0 THEN
            MESSAGE(Text002)
        ELSE
            IF TempJnlBatchName = GenJnlLine."Journal Batch Name" THEN
                //MESSAGE(Text003)
                //ELSE
                // MESSAGE(
                // Text004,
                // "Journal Batch Name"); //Commented for auto posting

                IF NOT GenJnlLine.FIND('=><') OR (TempJnlBatchName <> GenJnlLine."Journal Batch Name") THEN BEGIN
                    GenJnlLine.RESET;
                    GenJnlLine.FILTERGROUP(2);
                    GenJnlLine.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                    GenJnlLine.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                    GenJnlLine.FILTERGROUP(0);
                    GenJnlLine."Line No." := 1;
                END;
    end;

    procedure Preview(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
    begin
        PreviewMode := TRUE;
        GenJnlPostBatch.SetPreviewMode(TRUE);
        GenJnlLine.COPY(GenJournalLine);
        //>> ST
        // GenJnlPostPreview.Start;

        // IF NOT Code THEN BEGIN
        //     GenJnlPostPreview.Finish;
        //     IF GETLASTERRORTEXT <> GenJnlPostPreview.GetPreviewModeErrMessage THEN
        //         ERROR(GETLASTERRORTEXT);
        //     GenJnlPostPreview.ShowAllEntries;
        //     ERROR('');
        // END;
        //<< ST
    end;
}

