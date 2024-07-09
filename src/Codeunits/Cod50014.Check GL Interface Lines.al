codeunit 50014 "Check GL Interface Lines"
{

    trigger OnRun()
    begin
        WITH RecGLInterface DO BEGIN
            PLCDetail.RESET;
            PLCDetail.SETRANGE(PLCDetail."PLC Log No.", TransactionNo);
            IF PLCDetail.FINDFIRST THEN BEGIN
                IF PLCDetail."Record No." = RecGLInterface."Entry No" THEN
                    RunCheck(RecordLastPoint);
            END;
        END;
    end;

    var
        PointoStart: Integer;
        RecGLInterface: Record "LMS GL Data Stagings";
        PLCLOG: Integer;
        TransactionNo: Integer;
        PLCDetail: Record "PLC Logs Details";
        RecordLastPoint: Integer;
        "--CITS-MM-----": Integer;
        RecGJL: Record "Gen. Journal Line";
        LINENO: Integer;
        GenJournalLine: Record "Gen. Journal Line";


    procedure SETITEMRECORD(GLInterfaceRec: Record "LMS GL Data Stagings"; LocalRecordLastPoint: Integer; LocalTransactionNo: Integer)
    begin
        RecGLInterface := GLInterfaceRec;
        RecordLastPoint := LocalRecordLastPoint;
        TransactionNo := LocalTransactionNo;
    end;

    procedure RunCheck("RecordNo.": Integer)
    var
        PLCLogRec: Record "PLC Logs";
        PLCLogDetailRec: Record "PLC Logs Details";
        LineNo: Integer;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        ItemNo: Code[20];
    begin
        //MESSAGE('RunCheck');
        PLCLogRec.RESET;
        PLCLogRec.SETFILTER("Entry No.", '>%1', RecordLastPoint);
        PLCLogRec.SETRANGE("Interface Type", PLCLogRec."Interface Type"::GL);
        IF PLCLogRec.FINDFIRST THEN
            REPEAT
                PLCLogDetailRec.RESET;
                PLCLogDetailRec.SETRANGE("PLC Log No.", PLCLogRec."Entry No.");
                IF PLCLogDetailRec.FINDFIRST THEN
                    REPEAT
                        //  MESSAGE('%1..%2',PLCLogRec."Entry No.",PLCLogDetailRec."Record No.");
                        //CREATE General Journal Line
                        CreateGJL(PLCLogRec."Entry No.", PLCLogDetailRec."Record No.");
                    UNTIL PLCLogDetailRec.NEXT = 0;
                // CCIT AN 27feb2023
                RecGJL.SetHideValidation(FALSE);
                RecGJL.SETRANGE(RecGJL."Journal Template Name", 'GENERAL');
                RecGJL.SETRANGE(RecGJL."Journal Batch Name", 'LMS DIRECT');  //RecGJL."Journal Batch Name");
                IF RecGJL.FINDSET() THEN
                    REPEAT
                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Auto Jobque", RecGJL);
                    UNTIL RecGJL.NEXT = 0;
            // CCIT AN 27feb2023}
            UNTIL PLCLogRec.NEXT = 0;
    end;

    local procedure CreateGJL("PLCLOGNo.": Integer; ItemInterfaceEntryNumber: Integer)
    var
        PLCLogDetail: Record "PLC Logs Details";
        NOSeries: Codeunit NoSeriesManagement;
        AccType: Integer;
        DocType: Integer;
        GSTCustType: Integer;
        Dim_Set_Entry: Record "Dimension Set Entry";
        Gen_Ledger_Set: Record 98;
    begin
        LINENO := 10000;
        PLCLogDetail.RESET;
        PLCLogDetail.SETRANGE("PLC Log No.", "PLCLOGNo.");
        PLCLogDetail.SETRANGE("Record No.", ItemInterfaceEntryNumber);
        IF PLCLogDetail.FINDFIRST THEN BEGIN
            RecGLInterface.GET(PLCLogDetail."Record No.");

            RecGJL.RESET;
            RecGJL.SETRANGE("Journal Template Name", 'General');
            IF GUIALLOWED THEN
                RecGJL.SETRANGE("Journal Batch Name", 'LMS')
            ELSE
                RecGJL.SETRANGE("Journal Batch Name", 'LMS DIRECT');
            IF RecGJL.FINDLAST THEN
                LINENO := RecGJL."Line No." + 10000;

            //MESSAGE(FORMAT(LINENO));
            RecGJL.INIT;
            RecGJL."Journal Template Name" := 'General';
            IF GUIALLOWED THEN
                RecGJL."Journal Batch Name" := 'LMS'
            ELSE
                RecGJL."Journal Batch Name" := 'LMS DIRECT';
            RecGJL."Line No." := LINENO;
            IF RecGLInterface."Account Type" = 'G/L Account' THEN
                AccType := 0 ELSE
                IF RecGLInterface."Account Type" = 'Customer' THEN
                    AccType := 1 ELSE
                    IF RecGLInterface."Account Type" = 'Vendor' THEN
                        AccType := 2 ELSE
                        IF RecGLInterface."Account Type" = 'Bank Account' THEN
                            AccType := 3;


            //RecGJL."Document Type" := RecGLInterface."Document Type";
            RecGJL."Account Type" := AccType;
            //RecGJL."External Document No." := RecGLInterface."Document No.";
            RecGJL."Document No." := RecGLInterface."External Document No.";//ccit san
            RecGJL."External Document No." := RecGLInterface."External Document No.";//ccit san
            RecGJL."Posting Date" := RecGLInterface."Posting Date";

            IF RecGLInterface."Document Type" = 'Payment' THEN
                DocType := 1 ELSE
                IF RecGLInterface."Document Type" = 'INVOICE' THEN
                    DocType := 2 ELSE
                    IF RecGLInterface."Document Type" = 'Credit Memo' THEN
                        DocType := 3 ELSE
                        IF RecGLInterface."Document Type" = 'Finance Charge Memo' THEN
                            DocType := 4 ELSE
                            IF RecGLInterface."Document Type" = 'Reminder' THEN
                                DocType := 5 ELSE
                                IF RecGLInterface."Document Type" = 'Refund' THEN
                                    DocType := 6 ELSE
                                    DocType := 0;
            RecGJL."Document Type" := DocType;

            RecGJL.VALIDATE("Account No.", RecGLInterface."Account No.");
            RecGJL.Description := RecGLInterface.Description;
            RecGJL.VALIDATE("Location Code", RecGLInterface."Location Code");

            //RecGJL.VALIDATE("Debit Amount",RecGLInterface."Debit Amount");
            //RecGJL.VALIDATE("Credit Amount",RecGLInterface."Credit Amount");
            IF RecGLInterface."Debit Amount" <> 0 THEN
                RecGJL.VALIDATE("Debit Amount", RecGLInterface."Debit Amount");
            IF RecGLInterface."Credit Amount" <> 0 THEN
                RecGJL.VALIDATE("Credit Amount", RecGLInterface."Credit Amount");

            RecGJL.VALIDATE("GST Group Code", RecGLInterface."GST Group Code");
            //RecGJL.VALIDATE("GST TDS/TCS Base Amount", RecGLInterface."GST Base Amount");
            //RecGJL.VALIDATE("GST TDS/TCS %", RecGLInterface."GST %");
            RecGJL."GST TDS/TCS Base Amount" := RecGLInterface."GST Base Amount";
            RecGJL."GST TDS/TCS %" := RecGLInterface."GST %";

            // RecGJL.VALIDATE("Total GST Amount", RecGLInterface."Total GST Amount");
            RecGJL.VALIDATE("GST Bill-to/BuyFrom State Code", RecGLInterface."GST Bill-to/BuyFrom State Code");
            RecGJL.VALIDATE("GST Ship-to State Code", RecGLInterface."GST Ship-to State Code");
            RecGJL."HSN/SAC Code" := RecGLInterface."HSN/SAC Code";
            IF RecGLInterface."GST Customer Type" = 'Registered' THEN
                GSTCustType := 1 ELSE
                IF RecGLInterface."GST Customer Type" = 'Unregistered' THEN
                    GSTCustType := 2 ELSE
                    IF RecGLInterface."GST Customer Type" = 'Export' THEN
                        GSTCustType := 3 ELSE
                        IF RecGLInterface."GST Customer Type" = 'Deemed Export' THEN
                            GSTCustType := 4 ELSE
                            IF RecGLInterface."GST Customer Type" = 'Exempted' THEN
                                GSTCustType := 5 ELSE
                                IF RecGLInterface."GST Customer Type" = 'SEZ Development' THEN
                                    GSTCustType := 6 ELSE
                                    IF RecGLInterface."GST Customer Type" = 'SEZ Unit' THEN
                                        GSTCustType := 7 ELSE
                                        GSTCustType := 0;
            RecGJL."GST Customer Type" := GSTCustType;
            //CCIT-Vikas14042020

            IF RecGLInterface."Recurring Method" = 'B Balance' THEN
                RecGJL."Recurring Method" := RecGJL."Recurring Method"::"B  Balance"
            ELSE
                IF RecGLInterface."Recurring Method" = 'F Fixed' THEN
                    RecGJL."Recurring Method" := RecGJL."Recurring Method"::"F  Fixed"
                ELSE
                    IF RecGLInterface."Recurring Method" = 'RB Reversing Balance' THEN
                        RecGJL."Recurring Method" := RecGJL."Recurring Method"::"RB Reversing Balance"
                    ELSE
                        IF RecGLInterface."Recurring Method" = 'RF Reversing Fixed' THEN
                            RecGJL."Recurring Method" := RecGJL."Recurring Method"::"RF Reversing Fixed"
                        ELSE
                            IF RecGLInterface."Recurring Method" = 'RV Reversing Variable' THEN
                                RecGJL."Recurring Method" := RecGJL."Recurring Method"::"RV Reversing Variable"
                            ELSE
                                IF RecGLInterface."Recurring Method" = 'V Variable' THEN
                                    RecGJL."Recurring Method" := RecGJL."Recurring Method"::"V  Variable";


            RecGJL.Comment := RecGLInterface.Comment;
            RecGJL."Recurring Frequency" := RecGLInterface."Recurring Frequency";
            RecGJL."Expiration Date" := RecGLInterface."Expiration Date";
            RecGJL."Approver ID" := 'GLADMIN';

            //Vikas-Vikas14042020
            RecGJL.VALIDATE("Shortcut Dimension 1 Code", RecGLInterface."Global Dimension 1 Code");
            RecGJL.VALIDATE("Shortcut Dimension 2 Code", RecGLInterface."Global Dimension 2 Code");
            RecGJL.VALIDATE("Shortcut Dimension 8", RecGLInterface."Shortcut Dimension 8 Code");
            RecGJL.VALIDATE("Shortcut Dimension 7", RecGLInterface."Shortcut Dimension 7 Code");
            RecGJL.VALIDATE("Shortcut Dimension 6", RecGLInterface."Shortcut Dimension 6 Code");
            RecGJL.VALIDATE("Shortcut Dimension 5", RecGLInterface."Shortcut Dimension 5 Code");
            RecGJL.VALIDATE("Shortcut Dimension 4", RecGLInterface."Shortcut Dimension 4 Code");
            RecGJL.VALIDATE("Shortcut Dimension 3", RecGLInterface."Shortcut Dimension 3 Code");

            RecGJL.INSERT;

        END;
    end;
}

