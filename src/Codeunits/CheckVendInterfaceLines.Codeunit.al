codeunit 50032 "Check Vend Interface Lines"
{

    trigger OnRun()
    begin
        WITH RecVendInterface DO BEGIN
            PLCDetail.RESET;
            PLCDetail.SETRANGE(PLCDetail."PLC Log No.", TransactionNo);
            IF PLCDetail.FINDFIRST THEN BEGIN
                IF PLCDetail."Record No." = RecVendInterface."Entry No" THEN
                    RunCheck(RecordLastPoint);
            END;
        END;
    end;

    var
        PointoStart: Integer;
        RecVendInterface: Record "LMS Vendor Data Stagings";
        PLCLOG: Integer;
        TransactionNo: Integer;
        PLCDetail: Record "PLC Logs Details";
        RecordLastPoint: Integer;
        RecItem: Record 27;
        //RecProductGroup: Record "5723";
        "--CITS-MM-----": Integer;
        RecGJL: Record 81;
        LINENO: Integer;

    //[Scope('Internal')]
    procedure SETITEMRECORD(VendorInterfaceRec: Record "LMS Vendor Data Stagings"; LocalRecordLastPoint: Integer; LocalTransactionNo: Integer)
    begin
        RecVendInterface := VendorInterfaceRec;
        RecordLastPoint := LocalRecordLastPoint;
        TransactionNo := LocalTransactionNo;
    end;

    //[Scope('Internal')]
    procedure RunCheck("RecordNo.": Integer)
    var
        PLCLogRec: Record "PLC Logs";
        PLCLogDetailRec: Record "PLC Logs Details";
        LineNo: Integer;
        NoSeriesManagement: Codeunit "396";
        VendorNo: Code[20];
    begin
        PLCLogRec.RESET;
        PLCLogRec.SETFILTER("Entry No.", '>%1', RecordLastPoint);
        PLCLogRec.SETRANGE("Interface Type", PLCLogRec."Interface Type"::Vendor);
        IF PLCLogRec.FINDFIRST THEN
            REPEAT
                VendorNo := '';
                PLCLogDetailRec.RESET;
                PLCLogDetailRec.SETRANGE("PLC Log No.", PLCLogRec."Entry No.");
                IF PLCLogDetailRec.FINDFIRST THEN
                    REPEAT
                        // MESSAGE('%1..%2',PLCLogRec."Entry No.",PLCLogDetailRec."Record No.");
                        //CREATE General Journal Line
                        CreateVendor(PLCLogRec."Entry No.", PLCLogDetailRec."Record No.");
                    UNTIL PLCLogDetailRec.NEXT = 0;
            UNTIL PLCLogRec.NEXT = 0;
    end;

    local procedure CreateVendor("PLCLOGNo.": Integer; ItemInterfaceEntryNumber: Integer)
    var
        PLCLogDetail: Record "PLC Logs Details";
        NOSeries: Codeunit NoSeriesManagement;
        AccType: Integer;
        Rec_Vend: Record 23;
    begin
        PLCLogDetail.RESET;
        PLCLogDetail.SETRANGE("PLC Log No.", "PLCLOGNo.");
        PLCLogDetail.SETRANGE("Record No.", ItemInterfaceEntryNumber);
        IF PLCLogDetail.FINDFIRST THEN BEGIN
            //MESSAGE(FORMAT(PLCLogDetail."Record No."));
            RecVendInterface.GET(PLCLogDetail."Record No.");
            Rec_Vend.RESET;
            Rec_Vend.SETRANGE("LMS Vendor No", RecVendInterface."No.");
            IF Rec_Vend.FINDFIRST THEN BEGIN
                ModifyVend(Rec_Vend."No.", RecVendInterface);
            END ELSE BEGIN
                InsertVend(RecVendInterface);
            END;
        END;
    end;

    local procedure ModifyVend(VendNo: Code[20]; VendInterface: Record "LMS Vendor Data Stagings")
    var
        Rec_Vend1: Record 23;
        VendorBankAcc: Record "288";
    begin
        MESSAGE('Modify');
        Rec_Vend1.GET(VendNo);
        //Rec_Vend1."No." := VendInterface."No.";
        Rec_Vend1.Name := VendInterface.Name;
        Rec_Vend1.Address := VendInterface.Address;
        Rec_Vend1."Address 2" := VendInterface."Address 2";
        Rec_Vend1.City := VendInterface.City;
        Rec_Vend1.Contact := VendInterface.Contact;
        Rec_Vend1."Phone No." := VendInterface."Phone No.";
        Rec_Vend1."LMS Vendor No" := VendInterface.VendorBankCode;
        Rec_Vend1."Vendor Posting Group" := VendInterface."Vendor Posting Group";
        Rec_Vend1."Payment Terms Code" := VendInterface."Payment Terms Code";
        Rec_Vend1."Country/Region Code" := VendInterface."Country/Region Code";
        Rec_Vend1."Payment Method Code" := VendInterface."Payment Method Code";
        Rec_Vend1."Gen. Bus. Posting Group" := VendInterface."Gen. Bus. Posting Group";
        Rec_Vend1."Post Code" := VendInterface."Post Code";
        Rec_Vend1."E-Mail" := VendInterface."E-Mail";
        Rec_Vend1."P.A.N. No." := VendInterface."P.A.N. No.";
        Rec_Vend1."State Code" := VendInterface."State Code";
        //Rec_Vend1.Structure := VendInterface.Structure;
        Rec_Vend1."GST Registration No." := VendInterface."GST Registration No.";
        IF VendorBankAcc.GET(VendNo, VendInterface.VendorBankCode) THEN
            ModifyBank(VendNo, VendInterface.VendorBankCode)
        ELSE
            InsertBank(VendInterface);
        //Rec_Vend1."GST Vendor Type" := VendInterface."GST Vendor Type";
        IF Rec_Vend1.MODIFY THEN BEGIN
            IF VendorBankAcc.GET(Rec_Vend1."No.", VendInterface.VendorBankCode) THEN
                ModifyBank(Rec_Vend1."No.", VendInterface.VendorBankCode)
            ELSE
                InsertBank(VendInterface);
        END;
    end;

    local procedure InsertVend(VendInterface: Record "LMS Vendor Data Stagings")
    var
        Rec_Vend1: Record 23;
        C_NoSerMng: Codeunit "396";
        VendorBankAcc: Record "288";
    begin
        //MESSAGE('Insert');
        Rec_Vend1.INIT;
        //Rec_Vend1."No." := VendInterface."No.";
        Rec_Vend1."No." := C_NoSerMng.GetNextNo(VendInterface."No. Series", TODAY, TRUE);
        Rec_Vend1.Name := VendInterface.Name;
        Rec_Vend1.Address := VendInterface.Address;
        Rec_Vend1."Address 2" := VendInterface."Address 2";
        Rec_Vend1.City := VendInterface.City;
        Rec_Vend1.Contact := VendInterface.Contact;
        Rec_Vend1."LMS Vendor No" := VendInterface.VendorBankCode;
        Rec_Vend1."Phone No." := VendInterface."Phone No.";
        Rec_Vend1."Vendor Posting Group" := VendInterface."Vendor Posting Group";
        Rec_Vend1."Payment Terms Code" := VendInterface."Payment Terms Code";
        Rec_Vend1."Country/Region Code" := VendInterface."Country/Region Code";
        Rec_Vend1."Payment Method Code" := VendInterface."Payment Method Code";
        Rec_Vend1."Gen. Bus. Posting Group" := VendInterface."Gen. Bus. Posting Group";
        Rec_Vend1."Post Code" := VendInterface."Post Code";
        Rec_Vend1."E-Mail" := VendInterface."E-Mail";
        Rec_Vend1."P.A.N. No." := VendInterface."P.A.N. No.";
        Rec_Vend1."State Code" := VendInterface."State Code";
        //Rec_Vend1.Structure := VendInterface.Structure;
        Rec_Vend1."GST Registration No." := VendInterface."GST Registration No.";

        IF Rec_Vend1.INSERT THEN BEGIN
            IF VendorBankAcc.GET(Rec_Vend1."No.", VendInterface.VendorBankCode) THEN
                ModifyBank(Rec_Vend1."No.", VendInterface.VendorBankCode)
            ELSE
                InsertBank(VendInterface);
        END;
    end;

    local procedure ModifyBank(VendNo: Code[20]; VendorBank: Code[20])
    var
        Rec_Vend_Bank_Acc: Record "Vendor Bank Account";
    begin
        //Rec_Vend_Bank_Acc.RESET;
    end;

    local procedure InsertBank(VendorInterFace: Record "LMS Vendor Data Stagings")
    var
        Rec_Vend_Bank_Acc: Record 288;
    begin
        Rec_Vend_Bank_Acc.INIT;
        Rec_Vend_Bank_Acc."Vendor No." := VendorInterFace.VendorBankCode;
        Rec_Vend_Bank_Acc.Name := VendorInterFace."Bank Name";
        Rec_Vend_Bank_Acc."Bank Account No." := VendorInterFace."Account No";
        Rec_Vend_Bank_Acc.IFSC := VendorInterFace."IFSC Code";
        Rec_Vend_Bank_Acc.INSERT;
    end;
}

