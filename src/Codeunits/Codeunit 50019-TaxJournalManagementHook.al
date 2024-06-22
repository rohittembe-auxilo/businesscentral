codeunit 50019 TaxJournalManagementHook
{
    trigger OnRun()
    begin

    end;

    var

        Text16517: Label 'ENU=Do you want to preview the journal lines?;ENN=Do you want to post the journal lines?';
        RecordRestrictionMgt: Codeunit "Record Restriction Mgt.";
        WorkflowRec: Record Workflow;
        TaxJnlLine: Record "TDS Journal Line";
        DocNo: Code[20];
        CheckLineLbl: Label 'Checking lines        #1######\', Comment = '#1=Line check';
        PostLineLbl: Label 'Posting lines         #2###### @3@@@@@@@@@@@@@\', Comment = '#2=Post Line';
        JnlLinePostMsg: Label 'Journal lines posted successfully.';
        JnlBatchNameLbl: Label 'Journal Batch Name    #4##########\\', Comment = '#4=Journal Batch Name';
        PostTDSAdjQst: Label 'Do you want to post the journal lines?';



    procedure checkw()
    begin
        //CCIT AN 15032023
        WorkflowRec.RESET;
        WorkflowRec.SETRANGE(Code, 'TDS ADJ');
        WorkflowRec.SETRANGE(Enabled, TRUE);
        IF WorkflowRec.FINDFIRST THEN  //CCIT AN 15032023
            RecordRestrictionMgt.CheckRecordHasUsageRestrictions(TaxJnlLine.RECORDID);//Vikas
    end;

    procedure PreviewTaxJournal(var TDSJournalLine: Record "TDS Journal Line")
    var
        TDSJnlLine: Record "TDS Journal Line";
        LineCount: Integer;
        Dialog: Dialog;
    begin
        if not Confirm(PostTDSAdjQst) then
            Error('');

        ClearAll();
        TDSJnlLine.Copy(TDSJournalLine);
        if TDSJnlLine.FindFirst() then begin
            Dialog.Open(JnlBatchNameLbl + CheckLineLbl + PostLineLbl);
            LineCount := 0;
        end;

        repeat
            CheckLine(TDSJnlLine);
            LineCount := LineCount + 1;
            Dialog.Update(4, TDSJnlLine."Journal Batch Name");
            Dialog.Update(1, LineCount);
        until TDSJnlLine.Next() = 0;

        LineCount := 0;
        if TDSJnlLine.FindFirst() then
            repeat
                PreviewGenJnlLine(TDSJnlLine);
                LineCount := LineCount + 1;
                Dialog.Update(4, TDSJnlLine."Journal Batch Name");
                Dialog.Update(2, LineCount);
                Dialog.Update(3, Round(LineCount / TDSJnlLine.Count() * 10000, 1));
            until TDSJnlLine.Next() = 0;

        TDSJnlLine.DeleteAll(true);
        Dialog.Close();
        Message(JnlLinePostMsg);
        TDSJournalLine := TDSJnlLine;
    end;

    procedure CheckLine(var TDSJournalLine: Record "TDS Journal Line")
    begin
        TDSJournalLine.TestField("Document No.");
        TDSJournalLine.TestField("Posting Date");
        TDSJournalLine.TestField("Account No.");
        TDSJournalLine.TestField("Bal. Account No.");
        TDSJournalLine.TestField(Amount);
    end;

    procedure PreviewGenJnlLine(var TDSJournalLine: Record "TDS Journal Line")
    begin
        if (TDSJournalLine."Journal Batch Name" = '') and (TDSJournalLine."Journal Template Name" = '') then
            DocNo := TDSJournalLine."Document No."
        else
            DocNo := CheckDocumentNo(TDSJournalLine);
        InitGenJnlLine(TDSJournalLine);
    end;

    procedure InitGenJnlLine(var TDSJournalLine: Record "TDS Journal Line")
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Init();
        GenJournalLine."Journal Batch Name" := TDSJournalLine."Journal Batch Name";
        GenJournalLine."Journal Template Name" := TDSJournalLine."Journal Template Name";
        GenJournalLine."Line No." := TDSJournalLine."Line No.";
        GenJournalLine."Account Type" := TDSJournalLine."Account Type";
        GenJournalLine."Account No." := TDSJournalLine."Account No.";
        GenJournalLine."Posting Date" := TDSJournalLine."Posting Date";
        GenJournalLine."Document Type" := TDSJournalLine."Document Type";
        GenJournalLine."TDS Section Code" := TDSJournalLine."TDS Section Code";
        GenJournalLine."T.A.N. No." := TDSJournalLine."T.A.N. No.";
        GenJournalLine."Document No." := DocNo;
        GenJournalLine."Posting No. Series" := TDSJournalLine."Posting No. Series";
        GenJournalLine.Description := TDSJournalLine.Description;
        GenJournalLine."TDS Adjustment" := true;
        GenJournalLine."System-Created Entry" := true;
        GenJournalLine.Validate(Amount, TDSJournalLine.Amount);
        GenJournalLine."Bal. Account Type" := TDSJournalLine."Bal. Account Type";
        GenJournalLine."Bal. Account No." := TDSJournalLine."Bal. Account No.";
        GenJournalLine."Shortcut Dimension 1 Code" := TDSJournalLine."Shortcut Dimension 1 Code";
        GenJournalLine."Shortcut Dimension 2 Code" := TDSJournalLine."Shortcut Dimension 2 Code";
        GenJournalLine."Dimension Set ID" := TDSJournalLine."Dimension Set ID";
        GenJournalLine."Source Code" := TDSJournalLine."Source Code";
        GenJournalLine."Reason Code" := TDSJournalLine."Reason Code";
        GenJournalLine."Document Date" := TDSJournalLine."Document Date";
        GenJournalLine."External Document No." := TDSJournalLine."External Document No.";
        GenJournalLine."Location Code" := TDSJournalLine."Location Code";
        if TDSJournalLine."TDS Base Amount" = 0 then
            GenJournalLine."Allow Zero-Amount Posting" := true;
        GenJournalLine.Insert();

        PreviewGenJnlPostLine(GenJournalLine);
    end;

    procedure CheckDocumentNo(TDSJournalLine: Record "TDS Journal Line"): Code[20]
    var
        TDSJournalBatch: Record "TDS Journal Batch";
        NoSeries: Codeunit "No. Series";
    begin
        if (TDSJournalLine."Journal Template Name" = '') and (TDSJournalLine."Journal Batch Name" = '') and (TDSJournalLine."Document No." <> '') then
            exit(TDSJournalLine."Document No.");

        TDSJournalBatch.Get(TDSJournalLine."Journal Template Name", TDSJournalLine."Journal Batch Name");
        if TDSJournalLine."Posting No. Series" = '' then
            TDSJournalLine."Posting No. Series" := TDSJournalBatch."No. Series";
        TDSJournalLine."Document No." := NoSeries.GetNextNo(TDSJournalLine."Posting No. Series", TDSJournalLine."Posting Date");

        exit(TDSJournalLine."Document No.");
    end;

    local procedure PreviewGenJnlPostLine(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        hbhbj: Page 39;
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        GenJournalLine2: Record "Gen. Journal Line";
    begin
        //   GenJnlPostLine.SetPreviewMode(true);
        Clear(GenJnlPost);
        GenJournalLine2 := GenJournalLine;
        //       GenJournalLine2."Journal Batch Name" := 'OPNGL';
        ///      GenJournalLine2."Journal Template Name" := 'GENERAL';
        Commit();
        // GenJnlPost.
        GenJnlPost.Preview(GenJournalLine2);
        // GenJnlPostLine.SetPreviewMode(true);
        // GenJnlPostLine.RunWithCheck(GenJournalLine2);
        // GenJnlPostLine.

    end;


}