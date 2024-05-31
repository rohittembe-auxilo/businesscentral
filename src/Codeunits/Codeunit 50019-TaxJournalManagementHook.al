// codeunit 50019 TaxJournalManagementHook
// {
//     trigger OnRun()
//     begin

//     end;

//     var

//         Text16517: Label 'ENU=Do you want to preview the journal lines?;ENN=Do you want to post the journal lines?';
//         RecordRestrictionMgt: Codeunit "Record Restriction Mgt.";
//         WorkflowRec: Record Workflow;


//     procedure checkw()
//     begin
//         //CCIT AN 15032023
//         WorkflowRec.RESET;
//         WorkflowRec.SETRANGE(Code, 'TDS ADJ');
//         WorkflowRec.SETRANGE(Enabled, TRUE);
//         IF WorkflowRec.FINDFIRST THEN  //CCIT AN 15032023
//             RecordRestrictionMgt.CheckRecordHasUsageRestrictions(TaxJnlLine.RECORDID);//Vikas
//     end;

//     procedure PreviewTaxJournal(var TJLine: Record "16587")
//     var
//         TaxJnlLine: Record "16587";
//         LineCount: Integer;
//         Window: Dialog;
//     begin
//         IF NOT TJLine."From Subcon. Order" THEN BEGIN
//             IF NOT CONFIRM(Text16517) THEN
//                 ERROR('');
//         END ELSE
//             TJLine.SETRANGE("From Subcon. Order", TRUE);

//         CLEARALL;
//         TaxJnlLine.COPY(TJLine);
//         IF TaxJnlLine.FIND('-') THEN BEGIN
//             IF NOT TaxJnlLine."From Subcon. Order" THEN BEGIN
//                 Window.OPEN(Text16514 + Text16510 + Text16511);
//                 LineCount := 0;
//             END;

//             REPEAT
//                 CheckLines(TaxJnlLine);
//                 IF NOT TaxJnlLine."From Subcon. Order" THEN BEGIN
//                     LineCount := LineCount + 1;
//                     Window.UPDATE(4, TaxJnlLine."Journal Batch Name");
//                     Window.UPDATE(1, LineCount);

//                 END;
//             UNTIL TaxJnlLine.NEXT = 0;
//             Window.CLOSE;
//             LineCount := 0;
//             IF TaxJnlLine.FIND('-') THEN
//                 REPEAT

//                     PriviewGenJnlLine(TaxJnlLine);
//                     IF NOT TaxJnlLine."From Subcon. Order" THEN BEGIN
//                         LineCount := LineCount + 1;
//                         //  Window.UPDATE(4,TaxJnlLine."Journal Batch Name");
//                         // Window.UPDATE(2,LineCount);
//                         //  Window.UPDATE(3,ROUND(LineCount / TaxJnlLine.COUNT * 10000,1));
//                     END;
//                 UNTIL TaxJnlLine.NEXT = 0;
//             CLEAR(GenJnlPostLine);

//             VATAdjustmentBuffer.RESET;
//             VATAdjustmentBuffer.SETRANGE("Journal Template Name", TJLine."Journal Template Name");
//             VATAdjustmentBuffer.SETRANGE("Journal Batch Name", TJLine."Journal Batch Name");
//             VATAdjustmentBuffer.SETRANGE("Line No.", TJLine."Line No.");
//             VATAdjustmentBuffer.DELETEALL;

//             TaxJnlLine.DELETEALL(TRUE);
//             IF NOT TaxJnlLine."From Subcon. Order" THEN BEGIN
//                 Window.CLOSE;
//                 MESSAGE(Text16512);
//             END;
//         END;
//         TJLine := TaxJnlLine;
//     end;

// }