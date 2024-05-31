// codeunit 50018 ServiceTaxManagementHook
// {
//     trigger OnRun()
//     begin

//     end;

//     var
//         myInt: Integer;


//         //CCIT Aux-0003 Vikas 25/07/19 start
//         detailGSTledgentry.RESET();
//       detailGSTledgentry.SETRANGE("Document No.", VendorLedgerEntry."Document No.");
//       //detailGSTledgentry.SETRANGE("Transaction Type",detailGSTledgentry."Transaction Type"::Purchase);
//       IF detailGSTledgentry.FIND('-') THEN
//         REPEAT
//          detailGSTledgentry."Payment Date" := ApplyingGenJnlLine."Posting Date";
//         detailGSTledgentry."Payment Doc No." := ApplyingGenJnlLine."Document No.";
//         detailGSTledgentry.MODIFY;

//         UNTIL detailGSTledgentry.NEXT =0;
//       //CCIT Aux-0003 Vikas 25/07/19 End

// }