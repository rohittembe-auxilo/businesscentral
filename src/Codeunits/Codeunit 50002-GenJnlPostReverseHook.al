codeunit 50002 "Gen. Jnl.-Post Reverse Hook"
{
    trigger OnRun()
    begin

    end;


    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Tax Base Library", OnAfterReverseTDSEntry, '', false, false)]
    // local procedure OnAfterReverseTDSEntry(EntryNo: Integer; TransactionNo: Integer)
    // var
    //     TDSEntry: Record "TDS Entry";
    //     TDSEntryInvRev: Record "TDS Entry";
    //     NewTDSEntry2: Record "TDS Entry";
    // begin
    //     TDSEntry.Get(EntryNo);

    //     //CCIT AN 13022023
    //     TDSEntryInvRev.RESET();
    //     TDSEntryInvRev.SETRANGE("Transaction No.", TDSEntry."Transaction No.");
    //     IF TDSEntryInvRev.FINDFIRST THEN//REPEAT
    //     BEGIN
    //         //ERROR('',NewTDSEntry."Rev. TDS Transaction No.");
    //         NewTDSEntry2.RESET();
    //         NewTDSEntry2.SETRANGE("Entry No.", TDSEntryInvRev."Reversed by Entry No.");
    //         IF NewTDSEntry2.FINDFIRST THEN BEGIN
    //             NewTDSEntry2.Adjusted := FALSE;
    //             NewTDSEntry2."Adjusted TDS %" := 0;
    //             NewTDSEntry2."TDS Amount" := NewTDSEntry2."TDS Amount" - TDSEntry."TDS Line Amount";
    //             NewTDSEntry2."TDS Amount Including Surcharge" := NewTDSEntry2."TDS Amount Including Surcharge" - TDSEntry."TDS Line Amount";
    //             NewTDSEntry2."Bal. TDS Including SHE CESS" := NewTDSEntry2."Bal. TDS Including SHE CESS" - TDSEntry."TDS Line Amount";
    //             //NewTDSEntry2."Rem. Total TDS Incl. SHE CESS" := NewTDSEntry2."Rem. Total TDS Incl. SHE CESS" - TDSEntry."TDS Line Amount";
    //             NewTDSEntry2."Remaining TDS Amount" := NewTDSEntry2."Remaining TDS Amount" - TDSEntry."TDS Line Amount";
    //             NewTDSEntry2."Total TDS Including SHE CESS" := NewTDSEntry2."Total TDS Including SHE CESS" - TDSEntry."TDS Line Amount";
    //             NewTDSEntry2.MODIFY;
    //         END;
    //     END;     //UNTIL NewTDSEntry.NEXT = 0;
    //     //CCIT AN 13022023
    // end;


    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Reverse", OnReverseOnBeforeFinishPosting, '', false, false)]
    // local procedure OnReverseOnBeforeFinishPosting(var ReversalEntry: Record "Reversal Entry"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    // var
    //     TDSEntry: Record "TDS Entry";
    //     NewTDSEntry: Record "TDS Entry";
    //     ReversedTDSEntry: Record "TDS Entry";
    //     NewTDSEntry2: Record "TDS Entry";
    //     TDSEntryInvRev: Record "TDS Entry";
    // begin
    //     TDSEntry.SetRange("Transaction No.", ReversalEntry."Transaction No.");
    //     if TDSEntry.FindSet() then
    //         repeat
    //             //CCIT AN 13022023
    //             TDSEntryInvRev.RESET();
    //             TDSEntryInvRev.SETRANGE("Transaction No.", TDSEntry."Transaction No.");
    //             IF TDSEntryInvRev.FINDFIRST THEN//REPEAT
    //             BEGIN
    //                 //ERROR('',NewTDSEntry."Rev. TDS Transaction No.");
    //                 NewTDSEntry2.RESET();
    //                 NewTDSEntry2.SETRANGE("Entry No.", TDSEntryInvRev."Rev. TDS Transaction No.");
    //                 IF NewTDSEntry2.FINDFIRST THEN BEGIN
    //                     NewTDSEntry2.Adjusted := FALSE;
    //                     NewTDSEntry2."Adjusted TDS %" := 0;
    //                     NewTDSEntry2."TDS Amount" := NewTDSEntry2."TDS Amount" - TDSEntry."TDS Line Amount";
    //                     NewTDSEntry2."TDS Amount Including Surcharge" := NewTDSEntry2."TDS Amount Including Surcharge" - TDSEntry."TDS Line Amount";
    //                     NewTDSEntry2."Bal. TDS Including SHE CESS" := NewTDSEntry2."Bal. TDS Including SHE CESS" - TDSEntry."TDS Line Amount";
    //                     //NewTDSEntry2."Rem. Total TDS Incl. SHE CESS" := NewTDSEntry2."Rem. Total TDS Incl. SHE CESS" - TDSEntry."TDS Line Amount";
    //                     NewTDSEntry2."Remaining TDS Amount" := NewTDSEntry2."Remaining TDS Amount" - TDSEntry."TDS Line Amount";
    //                     NewTDSEntry2."Total TDS Including SHE CESS" := NewTDSEntry2."Total TDS Including SHE CESS" - TDSEntry."TDS Line Amount";
    //                     NewTDSEntry2.MODIFY;
    //                 END;
    //             END;     //UNTIL NewTDSEntry.NEXT = 0;
    //                      //CCIT AN 13022023
    //         until TDSEntry.Next() = 0;
    // end;

    var
        myInt: Integer;
        cu: Codeunit "Gen. Jnl.-Post Line";
}