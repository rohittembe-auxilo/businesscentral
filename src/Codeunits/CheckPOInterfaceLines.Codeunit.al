codeunit 50030 "Check PO Interface Lines"
{

    trigger OnRun()
    begin
        WITH RecPurchInterface DO BEGIN
            PLCDetail.RESET;
            PLCDetail.SETRANGE(PLCDetail."PLC Log No.", TransactionNo);
            IF PLCDetail.FINDFIRST THEN BEGIN
                IF PLCDetail."Record No." = RecPurchInterface."Entry No" THEN
                    RunCheck(RecordLastPoint);
            END;
        END;
    end;

    var
        PointoStart: Integer;
        RecPurchInterface: Record "LMS Purchase Trans. Stagings";
        PLCLOG: Integer;
        TransactionNo: Integer;
        PLCDetail: Record "PLC Logs Details";
        RecordLastPoint: Integer;
        "--CITS-MM-----": Integer;
        RecGJL: Record 81;
        LINENO: Integer;
        GSTCRE: Integer;
        GSTGRTYPE: Integer;
        //RecGLInterface: Record "5214";
        RecPH: Record 38;
        PurchCommentLine: Record 43;

    // [Scope('Internal')]
    procedure SETITEMRECORD(PurchInterfaceRec: Record "LMS Purchase Trans. Stagings"; LocalRecordLastPoint: Integer; LocalTransactionNo: Integer)
    begin
        RecPurchInterface := PurchInterfaceRec;
        RecordLastPoint := LocalRecordLastPoint;
        TransactionNo := LocalTransactionNo;
    end;

    // [Scope('Internal')]
    procedure RunCheck("RecordNo.": Integer)
    var
        PLCLogRec: Record "PLC Logs";
        PLCLogDetailRec: Record "PLC Logs Details";
        LineNo: Integer;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        VendorNo: Code[20];
    begin
        PLCLogRec.RESET;
        PLCLogRec.SETFILTER("Entry No.", '>%1', RecordLastPoint);
        PLCLogRec.SETRANGE("Interface Type", PLCLogRec."Interface Type"::PO);
        IF PLCLogRec.FINDFIRST THEN
            REPEAT
                VendorNo := '';
                PLCLogDetailRec.RESET;
                PLCLogDetailRec.SETRANGE("PLC Log No.", PLCLogRec."Entry No.");
                IF PLCLogDetailRec.FINDFIRST THEN
                    REPEAT
                        CreatePurchHeader(PLCLogRec."Entry No.", PLCLogDetailRec."Record No.");
                    UNTIL PLCLogDetailRec.NEXT = 0;
            UNTIL PLCLogRec.NEXT = 0;
    end;

    local procedure CreatePurchHeader("PLCLOGNo.": Integer; PurchInterfaceEntryNumber: Integer)
    var
        PLCLogDetail: Record "PLC Logs Details";
        NOSeries: Codeunit NoSeriesManagement;
        AccType: Integer;
        Rec_PurchHeader: Record 38;
        Rec_PurchLine: Record 39;
        Rec_PurchHeader1: Record 38;
        Rec_PurchLine1: Record 39;
        Putch_LineNo: Integer;
    begin
        PLCLogDetail.RESET;
        PLCLogDetail.SETRANGE("PLC Log No.", "PLCLOGNo.");
        PLCLogDetail.SETRANGE("Record No.", PurchInterfaceEntryNumber);
        IF PLCLogDetail.FINDFIRST THEN BEGIN
            // MESSAGE(FORMAT("PLCLOGNo."));
            RecPurchInterface.GET(PLCLogDetail."Record No.");
            Rec_PurchHeader1.RESET;
            Rec_PurchHeader1.SETRANGE("Vendor Invoice No.", RecPurchInterface."Vendor Invoice No.");
            Rec_PurchHeader1.SETRANGE("Posting Date", RecPurchInterface."Posting Date");//ccit san
            Rec_PurchHeader1.SETRANGE("Buy-from Vendor No.", RecPurchInterface."Buy-from Vendor No.");//CCIT Vikas 14022020 Added Line For Vendor order  no Can be same for different Vendor
            IF NOT Rec_PurchHeader1.FINDFIRST THEN BEGIN
                Rec_PurchHeader.INIT;
                Rec_PurchHeader."Document Type" := Rec_PurchHeader."Document Type"::Order;
                //Rec_PurchHeader.VALIDATE("Buy-from Vendor No.",RecPurchInterface."Buy-from Vendor No.");
                Rec_PurchHeader.VALIDATE("Buy-from Vendor No.", RecPurchInterface."Buy-from Vendor No.");
                Rec_PurchHeader.PHComment := RecPurchInterface."PH Comment";//CCIT-TK-31219
                //Rec_PurchHeader.VALIDATE(Structure, RecPurchInterface.Structure);
                Rec_PurchHeader.VALIDATE("Posting Date", RecPurchInterface."Posting Date");
                Rec_PurchHeader.VALIDATE("Document Date", RecPurchInterface."Document Date");
                //Rec_PurchHeader.VALIDATE("Payment Terms Code",RecPurchInterface."Payment Terms Code");
                Rec_PurchHeader.VALIDATE("Location Code", RecPurchInterface."Location Code");
                Rec_PurchHeader.VALIDATE("Vendor Invoice No.", RecPurchInterface."Vendor Invoice No.");

                /*  Rec_PurchHeader.VALIDATE("Shortcut Dimension 1 Code", RecGLInterface."Shortcut Dimension 1 Code");
                  Rec_PurchHeader.VALIDATE("Shortcut Dimension 2 Code", RecGLInterface."Shortcut Dimension 2 Code");
                  Rec_PurchHeader.VALIDATE("Shortcut Dimension 8 Code",RecGLInterface."Shortcut Dimension 8 Code");
                  Rec_PurchHeader.VALIDATE("Shortcut Dimension 7 Code",RecGLInterface."Shortcut Dimension 7 Code");
                  Rec_PurchHeader.VALIDATE("Shortcut Dimension 6 Code",RecGLInterface."Shortcut Dimension 6 Code");
                  Rec_PurchHeader.VALIDATE("Shortcut Dimension 5 Code",RecGLInterface."Shortcut Dimension 5 Code");
                  Rec_PurchHeader.VALIDATE("Shortcut Dimension 4 Code",RecGLInterface."Shortcut Dimension 4 Code");
                  Rec_PurchHeader.VALIDATE("Shortcut Dimension 3 Code",RecGLInterface."Shortcut Dimension 3 Code");*/
                IF Rec_PurchHeader.INSERT(TRUE) THEN BEGIN

                    RecPH.RESET;
                    RecPH.SETRANGE(RecPH."No.", Rec_PurchHeader."No.");
                    IF RecPH.FINDFIRST THEN BEGIN
                        RecPH.VALIDATE("Shortcut Dimension 1 Code", RecPurchInterface."Shortcut Dimension 1 Code");
                        RecPH.VALIDATE("Shortcut Dimension 2 Code", RecPurchInterface."Shortcut Dimension 2 Code");
                        RecPH.VALIDATE("Shortcut Dimension 8 Code", RecPurchInterface."Shortcut Dimension 8 Code");
                        RecPH.VALIDATE("Shortcut Dimension 7 Code", RecPurchInterface."Shortcut Dimension 7 Code");
                        RecPH.VALIDATE("Shortcut Dimension 6 Code", RecPurchInterface."Shortcut Dimension 6 Code");
                        RecPH.VALIDATE("Shortcut Dimension 5 Code", RecPurchInterface."Shortcut Dimension 5 Code");
                        RecPH.VALIDATE("Shortcut Dimension 4 Code", RecPurchInterface."Shortcut Dimension 4 Code");
                        RecPH.VALIDATE("Shortcut Dimension 3 Code", RecPurchInterface."Shortcut Dimension 3 Code");
                        //CCIT Vikas
                        PurchCommentLine.INIT();
                        PurchCommentLine."Document Type" := PurchCommentLine."Document Type"::Order;
                        PurchCommentLine."Document Line No." := 0;
                        PurchCommentLine."No." := RecPH."No.";
                        PurchCommentLine.Comment := RecPurchInterface."PH Comment";
                        PurchCommentLine.INSERT;
                        //CCIT Vikas
                        RecPH.MODIFY;
                        RecPH.MODIFY;
                    END;

                    Rec_PurchLine.INIT;
                    Rec_PurchLine."Document Type" := Rec_PurchLine."Document Type"::Order;
                    Rec_PurchLine."Document No." := Rec_PurchHeader."No.";
                    Rec_PurchLine."Line No." := RecPurchInterface."Line No.";
                    Rec_PurchLine."Buy-from Vendor No." := RecPurchInterface."Buy-from Vendor No.";
                    Rec_PurchLine.Type := Rec_PurchLine.Type::"G/L Account";
                    Rec_PurchLine.VALIDATE("No.", RecPurchInterface."No.");
                    Rec_PurchLine.VALIDATE(Quantity, 1);
                    Rec_PurchLine.VALIDATE("Direct Unit Cost", RecPurchInterface."Direct Unit Cost");
                    Rec_PurchLine.VALIDATE(Amount, RecPurchInterface.Amount);
                    IF RecPurchInterface."GST Credit" = 'Availment' THEN
                        GSTCRE := 0
                    ELSE
                        GSTCRE := 1;
                    Rec_PurchLine.VALIDATE("GST Credit", GSTCRE);
                    Rec_PurchLine.VALIDATE("GST Group Code", RecPurchInterface."GST Group Code");
                    IF RecPurchInterface."GST Group Type" = 'Goods' THEN
                        GSTGRTYPE := 0
                    ELSE
                        GSTGRTYPE := 0;
                    Rec_PurchLine.VALIDATE("GST Group Type", GSTGRTYPE);
                    //Rec_PurchLine.VALIDATE("TDS Nature of Deduction",RecPurchInterface."TDS Nature of Deduction") ;
                    Rec_PurchLine.VALIDATE("HSN/SAC Code", RecPurchInterface."HSN/SAC Code");
                    // Rec_PurchLine.VALIDATE("GST Base Amount", RecPurchInterface."GST Base Amount");
                    // Rec_PurchLine.VALIDATE("GST %", RecPurchInterface."GST %");
                    // Rec_PurchLine.VALIDATE("Total GST Amount", RecPurchInterface."Total GST Amount");
                    Rec_PurchLine.VALIDATE(Exempted, RecPurchInterface.Exempted);
                    Rec_PurchLine."Location Code" := RecPurchInterface."Location Code";

                    //  Rec_PurchLine.Comment:=RecPurchInterface.Comment;//CCIT-TK-31219
                    Rec_PurchLine.VALIDATE(Comment, RecPurchInterface.Comment);//CCIT-TK-311219
                    Rec_PurchLine.INSERT(TRUE);
                END;
            END ELSE BEGIN
                Rec_PurchLine1.RESET;
                Rec_PurchLine1.SETRANGE("Document No.", Rec_PurchHeader1."No.");
                IF Rec_PurchLine1.FINDLAST THEN BEGIN
                    Putch_LineNo := Rec_PurchLine1."Line No." + 10000;

                    Rec_PurchLine.INIT;
                    Rec_PurchLine."Document Type" := Rec_PurchLine."Document Type"::Order;
                    Rec_PurchLine."Document No." := Rec_PurchHeader1."No.";
                    Rec_PurchLine."Line No." := Putch_LineNo;
                    Rec_PurchLine."Buy-from Vendor No." := RecPurchInterface."Buy-from Vendor No.";
                    Rec_PurchLine.Type := Rec_PurchLine.Type::"G/L Account";
                    Rec_PurchLine.VALIDATE("No.", RecPurchInterface."No.");
                    Rec_PurchLine.VALIDATE(Quantity, 1);
                    Rec_PurchLine.VALIDATE("Direct Unit Cost", RecPurchInterface."Direct Unit Cost");
                    Rec_PurchLine.VALIDATE(Amount, RecPurchInterface.Amount);
                    IF RecPurchInterface."GST Credit" = 'Availment' THEN
                        GSTCRE := 0
                    ELSE
                        GSTCRE := 1;
                    Rec_PurchLine.VALIDATE("GST Credit", GSTCRE);
                    Rec_PurchLine.VALIDATE("GST Group Code", RecPurchInterface."GST Group Code");
                    IF RecPurchInterface."GST Group Type" = 'Goods' THEN
                        GSTGRTYPE := 0
                    ELSE
                        GSTGRTYPE := 0;
                    Rec_PurchLine.VALIDATE("GST Group Type", GSTGRTYPE);
                    //Rec_PurchLine.VALIDATE("TDS Nature of Deduction",RecPurchInterface."TDS Nature of Deduction") ;
                    Rec_PurchLine.VALIDATE("HSN/SAC Code", RecPurchInterface."HSN/SAC Code");
                    // Rec_PurchLine.VALIDATE("GST Base Amount", RecPurchInterface."GST Base Amount");
                    // Rec_PurchLine.VALIDATE("GST %", RecPurchInterface."GST %");
                    // Rec_PurchLine.VALIDATE("Total GST Amount", RecPurchInterface."Total GST Amount");
                    Rec_PurchLine.VALIDATE(Exempted, RecPurchInterface.Exempted);
                    Rec_PurchLine."Location Code" := RecPurchInterface."Location Code";
                    Rec_PurchLine.VALIDATE(Comment, RecPurchInterface.Comment);//CCIT-TK-311219
                                                                               //Rec_PurchLine.Comment:=RecPurchInterface.Comment;//CCIT-TK-31219
                    Rec_PurchLine.INSERT(TRUE);
                END;
            END;
        END;

    end;
}

