codeunit 70000 ReadAllBlobFiles
{
    trigger OnRun()
    var
        containerType: Enum ABSEnum;
        Container: Text;
        SharedKey: SecretText;
        ABSDialog: Page ABSDialog;
        ContainerName: text;
        // ABSBlobClient: codeunit "ABS Blob Client";
        Authorization: Interface "Storage Service Authorization";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        Response: Codeunit "ABS Operation Response";
        ABSContainerContent: Record "ABS Container Content";
        ABSContainersetup: Record "ABS Container setup";
        TempABSContainerContent: Record "ABS Container Content";
    begin
        CLEAR(BatchnameSelect);
        //BatchnameSelect.RUNMODAL;
        IF GUIALLOWED THEN
            ABSContainersetup.Get('GL')
        ELSE
            ABSContainersetup.Get(UpperCase('GL Direct'));

        SharedKey := ABSContainersetup."Shared Access Key";
        Authorization := StorageServiceAuthorization.CreateSharedKey(SharedKey);
        ABSBlobClient.Initialize(ABSContainersetup."Account Name", ABSContainersetup."In Container Name", Authorization);

        Response := ABSBlobClient.ListBlobs(TempABSContainerContent);

        If Response.GetError() <> '' then
            message(format(Response.GetError()));

        if TempABSContainerContent.FindFirst() then
            repeat
                //ABSBlobClient.GetBlobAsFile(TempABSContainerContent."Full Name");

                PLCLogLastRec.RESET;
                IF PLCLogLastRec.FINDLAST THEN
                    RecordLastPoint := PLCLogLastRec."Entry No.";
                IF NOT GuiAllowed then
                    //GLInterfaceJobQueue(TempABSContainerContent."Full Name", TempABSContainerContent)
                    GLInterfaceBG(TempABSContainerContent."Full Name", TempABSContainerContent)
                else
                    GLInterface(TempABSContainerContent."Full Name", TempABSContainerContent);

                IF not GUIALLOWED THEN
                    MoveFiles(RecordLastPoint, TempABSContainerContent."Full Name", 'GL Direct')
                else
                    MoveFiles(RecordLastPoint, TempABSContainerContent."Full Name", 'GL');


            until TempABSContainerContent.Next() = 0;
        COMMIT;

        Clear(ABSContainersetup);
        Clear(ABSBlobClient);
        Clear(Response);
        Clear(Authorization);

        ABSContainersetup.Get(UpperCase('Vendor'));

        SharedKey := ABSContainersetup."Shared Access Key";
        Authorization := StorageServiceAuthorization.CreateSharedKey(SharedKey);
        ABSBlobClient.Initialize(ABSContainersetup."Account Name", ABSContainersetup."In Container Name", Authorization);

        Response := ABSBlobClient.ListBlobs(TempABSContainerContent);

        If Response.GetError() <> '' then
            message(format(Response.GetError()));

        if TempABSContainerContent.FindFirst() then
            repeat
                VendorInterface(TempABSContainerContent."Full Name", TempABSContainerContent);
                MoveFiles(RecordLastPoint, TempABSContainerContent."Full Name", UpperCase('Vendor'));
            until TempABSContainerContent.Next() = 0;

        COMMIT;


        Clear(ABSContainersetup);
        Clear(ABSBlobClient);
        Clear(Response);
        Clear(Authorization);

        ABSContainersetup.Get(UpperCase('Purchase'));

        SharedKey := ABSContainersetup."Shared Access Key";
        Authorization := StorageServiceAuthorization.CreateSharedKey(SharedKey);
        ABSBlobClient.Initialize(ABSContainersetup."Account Name", ABSContainersetup."In Container Name", Authorization);

        Response := ABSBlobClient.ListBlobs(TempABSContainerContent);

        If Response.GetError() <> '' then
            message(format(Response.GetError()));

        if TempABSContainerContent.FindFirst() then
            repeat
                PurchaseInterface(TempABSContainerContent."Full Name", TempABSContainerContent);
                MoveFiles(RecordLastPoint, TempABSContainerContent."Full Name", UpperCase('Purchase'));
            until TempABSContainerContent.Next() = 0;


        COMMIT;

        Clear(ABSContainersetup);
        Clear(ABSBlobClient);
        Clear(Response);
        Clear(Authorization);

        ABSContainersetup.Get('PO');

        SharedKey := ABSContainersetup."Shared Access Key";
        Authorization := StorageServiceAuthorization.CreateSharedKey(SharedKey);
        ABSBlobClient.Initialize(ABSContainersetup."Account Name", ABSContainersetup."In Container Name", Authorization);

        Response := ABSBlobClient.ListBlobs(TempABSContainerContent);

        If Response.GetError() <> '' then
            message(format(Response.GetError()));

        if TempABSContainerContent.FindFirst() then
            repeat
                POInterface(TempABSContainerContent."Full Name", TempABSContainerContent);
                MoveFiles(RecordLastPoint, TempABSContainerContent."Full Name", 'PO');
            until TempABSContainerContent.Next() = 0;

    end;


    procedure GLInterfaceJobQueue(FileName: Text[100]; var TempABSContainerContent: Record "ABS Container Content")
    var

        OutStrVar: OutStream;
        InStrVar: InStream;
        PLCLog: Record "PLC Logs";
        LogNo: Integer;
        RestorePoint: Integer;
        PLCLogDetail: Record "PLC Logs Details";
        GLInterface: Record "LMS GL Data Stagings";
        Check: Codeunit "Check GL Interface Lines";
        TestFile: File;
        ABSContainerSetup: Record "ABS Container setup";
        MoveABSBlobClient: codeunit "ABS Blob Client";
        SharedKey: SecretText;
        RecABSContainerContent: Record "ABS Container Content";
        Authorization: Interface "Storage Service Authorization";
        MoveStorageServiceAuthorization: Codeunit "Storage Service Authorization";
        OperationResponse: Codeunit "ABS Operation Response";
        SourceStream: InStream;
        OptionalParameters: Codeunit "ABS Optional Parameters";
    begin
        PLCLog.RESET;
        IF PLCLog.FINDLAST THEN
            LogNo := PLCLog."Entry No.";

        PLCLog.INIT;
        PLCLog."Entry No." := LogNo + 1;
        PLCLog."Interface Type" := PLCLog."Interface Type"::GL;
        PLCLog."Start Date Time" := CURRENTDATETIME;
        PLCLog."File Name" := FileName;
        //PLCLog."Document No." :=COPYSTR(recFile.Name,12,16) ;
        PLCLog.INSERT;
        //COMMIT;

        GLInterface.RESET;
        IF GLInterface.FINDLAST THEN
            RestorePoint := GLInterface."Entry No";

        //IMPORTING DATA
        ABSBlobClient.GetBlobAsStream(TempABSContainerContent."Full Name", InStrVar);
        XMLPORT.IMPORT(50126, InStrVar);
        //TestFile.CLOSE;

        //CREATING Detail LOG each record wise
        GLInterface.RESET;
        GLInterface.SETFILTER("Entry No", '>%1', RestorePoint);
        IF GLInterface.FINDFIRST THEN
            REPEAT
                PLCLogDetail.INIT;
                PLCLogDetail."PLC Log No." := PLCLog."Entry No.";
                PLCLogDetail."Record No." := GLInterface."Entry No";
                PLCLogDetail."Identifier 1" := GLInterface."Document No.";
                //PLCLogDetail."Identifier 2" := ItemInterface."Store Code";
                //PLCLogDetail."Identifier 3" := ItemInterface.Barcode;
                //PLCLogDetail."Identifier 4" := '';
                PLCLogDetail."Date & Time" := CURRENTDATETIME;//vikas
                PLCLogDetail.Date := WORKDATE;//CCIT Vikas
                PLCLogDetail.Filename := PLCLog."File Name";//CCIT Kritika

                PLCLogDetail.INSERT;
            UNTIL GLInterface.NEXT = 0;

        //CHECKING ERROR
        GLInterface.RESET;
        GLInterface.SETFILTER("Entry No", '>%1', RestorePoint);
        IF GLInterface.FINDFIRST THEN
            REPEAT
                PLCLogDetail.GET(PLCLog."Entry No.", GLInterface."Entry No");
                Check.SETITEMRECORD(GLInterface, RecordLastPoint, PLCLog."Entry No.");
                COMMIT;
                CLEARLASTERROR;
                //  Check.RUN;
                IF Check.RUN = FALSE THEN BEGIN
                    PLCLogDetail.Error := GETLASTERRORTEXT;
                    PLCLogDetail.MODIFY;
                    ErrorExist := TRUE;//Vikas
                END;
            UNTIL GLInterface.NEXT = 0;

        PLCLogDetail.RESET;
        PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
        IF PLCLogDetail.FINDFIRST THEN
            REPEAT
                PLCLog."Total Records" := PLCLogDetail.COUNT;
                IF PLCLogDetail.Error = '' THEN BEGIN
                    PLCLogDetail.Sucess := TRUE;
                    PLCLogDetail.MODIFY;
                END;
            UNTIL PLCLogDetail.NEXT = 0;
        ABSContainerSetup.RESET;
        ABSContainerSetup.SetRange("Primary Key", UpperCase('GL Direct'));
        IF ABSContainerSetup.FINDFIRST then BEGIN
            SharedKey := ABSContainersetup."Shared Access Key";
            Authorization := MoveStorageServiceAuthorization.CreateSharedKey(SharedKey);

            PLCLogDetail.RESET;
            PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
            PLCLogDetail.SETRANGE(Sucess, FALSE);
            IF PLCLogDetail.FINDFIRST THEN
                PLCLog.Success := FALSE
            ELSE
                PLCLog.Success := TRUE;

            PLCLog."End Date Time" := CURRENTDATETIME;
            PLCLog.MODIFY;


            IF PLCLog.Success THEN BEGIN
                ABSBlobClient.GetBlobAsStream(FileName, SourceStream);
                MoveABSBlobClient.Initialize(ABSContainersetup."Account Name", ABSContainersetup."Out Container Name", Authorization);
                OperationResponse := MoveABSBlobClient.PutBlobBlockBlobStream(FileName, SourceStream, OptionalParameters);
                if OperationResponse.IsSuccessful() then
                    ABSBlobClient.DeleteBlob(FileName);
                //ABSBlobClient.ListBlobs(rec);
            END ELSE BEGIN
                ABSBlobClient.GetBlobAsStream(FileName, SourceStream);
                MoveABSBlobClient.Initialize(ABSContainersetup."Account Name", ABSContainersetup."Error Container Name", Authorization);
                OperationResponse := MoveABSBlobClient.PutBlobBlockBlobStream(FileName, SourceStream, OptionalParameters);
                if OperationResponse.IsSuccessful() then
                    ABSBlobClient.DeleteBlob(FileName);
            END;
        end;
    end;

    procedure MoveFiles(RestorePoint: Integer; VarFileName: Text[200]; Type: Text[30])
    var
        PLCLog: Record 50126;//NP
        //ReadFile: Record "2000000022";
        //FileName: Text[1024];
        AckFileName: Text[60];
        ErrorFileName: Text[60];
        ABSContainerSetup: Record "ABS Container setup";
        MoveABSBlobClient: codeunit "ABS Blob Client";
        SharedKey: SecretText;
        ABSDialog: Page ABSDialog;
        ContainerName: text;
        RecABSContainerContent: Record "ABS Container Content";
        Authorization: Interface "Storage Service Authorization";
        MoveStorageServiceAuthorization: Codeunit "Storage Service Authorization";
        OperationResponse: Codeunit "ABS Operation Response";
        SourceStream: InStream;
        OptionalParameters: Codeunit "ABS Optional Parameters";
    begin
        //Interface.GET;

        //Response := MoveABSBlobClient.ListBlobs(TempABSContainerContent);

        ABSContainerSetup.RESET;
        ABSContainerSetup.SetRange("Primary Key", Type);
        IF ABSContainerSetup.FINDFIRST then BEGIN
            SharedKey := ABSContainersetup."Shared Access Key";
            Authorization := MoveStorageServiceAuthorization.CreateSharedKey(SharedKey);

            PLCLog.RESET;
            PLCLog.SETFILTER("Entry No.", '>%1', RestorePoint);
            // PLCLog.SETRANGE("Interface Type",PLCLog."Interface Type"::"Item Master");
            PLCLog.SETFILTER("Interface Type", Type);
            PLCLog.SETRANGE(PLCLog."File Name", varFileName);
            IF PLCLog.FINDFIRST THEN BEGIN
                IF PLCLog.Success THEN BEGIN
                    ABSBlobClient.GetBlobAsStream(VarFileName, SourceStream);
                    MoveABSBlobClient.Initialize(ABSContainersetup."Account Name", ABSContainersetup."Out Container Name", Authorization);
                    OperationResponse := MoveABSBlobClient.PutBlobBlockBlobStream(VarFileName, SourceStream, OptionalParameters);
                    if OperationResponse.IsSuccessful() then
                        ABSBlobClient.DeleteBlob(VarFileName);
                    //ABSBlobClient.ListBlobs(rec);
                END ELSE BEGIN
                    ABSBlobClient.GetBlobAsStream(VarFileName, SourceStream);
                    MoveABSBlobClient.Initialize(ABSContainersetup."Account Name", ABSContainersetup."Error Container Name", Authorization);
                    OperationResponse := MoveABSBlobClient.PutBlobBlockBlobStream(VarFileName, SourceStream, OptionalParameters);
                    if OperationResponse.IsSuccessful() then
                        ABSBlobClient.DeleteBlob(VarFileName);
                END;
            END;
        END;

    END;



    procedure GLInterface(FileName: Text[1000]; var TempABSContainerContent: Record "ABS Container Content")
    var
        OutStrVar: OutStream;
        TestFile: File;
        InStrVar: InStream;
        PLCLog: Record "PLC Logs";
        LogNo: Integer;
        RestorePoint: Integer;
        PLCLogDetail: Record "PLC Logs Details";
        GLInterface: Record "LMS GL Data Stagings";
        Check: Codeunit "Check GL Interface Lines";
        Url: Text;
        Json: Text;
        Httpclint: HttpClient;
        HttpContnt: HttpContent;
        HttpResponseMsg: HttpResponseMessage;
        HttpHdr: HttpHeaders;
        TempBlob: Codeunit "Temp Blob";

    begin
        PLCLog.RESET;
        IF PLCLog.FINDLAST THEN
            LogNo := PLCLog."Entry No.";

        PLCLog.INIT;
        PLCLog."Entry No." := LogNo + 1;
        PLCLog."Interface Type" := PLCLog."Interface Type"::GL;
        PLCLog."Start Date Time" := CURRENTDATETIME;
        PLCLog."File Name" := FileName;
        //PLCLog."Document No." :=COPYSTR(recFile.Name,12,16) ;
        PLCLog.INSERT;
        //COMMIT;

        GLInterface.RESET;
        IF GLInterface.FINDLAST THEN
            RestorePoint := GLInterface."Entry No";

        //IMPORTING DATA
        // TestFile.OPEN(FileName);
        // TestFile.CREATEINSTREAM(InStrVar);
        // CLEARLASTERROR;
        // XMLPORT.IMPORT(50016, InStrVar);
        ABSBlobClient.GetBlobAsStream(TempABSContainerContent."Full Name", InStrVar);
        XMLPORT.IMPORT(50126, InStrVar);
        //TestFile.CLOSE;
        //ERASE(FileName);

        //CREATING Detail LOG each record wise
        GLInterface.RESET;
        GLInterface.SETFILTER("Entry No", '>%1', RestorePoint);
        IF GLInterface.FINDFIRST THEN
            REPEAT
                PLCLogDetail.INIT;
                PLCLogDetail."PLC Log No." := PLCLog."Entry No.";
                PLCLogDetail."Record No." := GLInterface."Entry No";
                PLCLogDetail."Identifier 1" := GLInterface."Document No.";
                //PLCLogDetail."Identifier 2" := ItemInterface."Store Code";
                //PLCLogDetail."Identifier 3" := ItemInterface.Barcode;
                //PLCLogDetail."Identifier 4" := '';
                PLCLogDetail."Date & Time" := CURRENTDATETIME;//vikas
                PLCLogDetail.Date := WORKDATE;//CCIT Vikas
                PLCLogDetail.INSERT;
            UNTIL GLInterface.NEXT = 0;

        //CHECKING ERROR
        GLInterface.RESET;
        GLInterface.SETFILTER("Entry No", '>%1', RestorePoint);
        IF GLInterface.FINDFIRST THEN
            REPEAT
                PLCLogDetail.GET(PLCLog."Entry No.", GLInterface."Entry No");
                Check.SETITEMRECORD(GLInterface, RecordLastPoint, PLCLog."Entry No."); //NP
                COMMIT;
                CLEARLASTERROR;
                //  Check.RUN;
                IF Check.RUN = FALSE THEN BEGIN
                    PLCLogDetail.Error := GETLASTERRORTEXT;
                    PLCLogDetail.MODIFY;
                    ErrorExist := TRUE;//Vikas
                END;
            UNTIL GLInterface.NEXT = 0;

        PLCLogDetail.RESET;
        PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
        IF PLCLogDetail.FINDFIRST THEN
            REPEAT
                PLCLog."Total Records" := PLCLogDetail.COUNT;
                IF PLCLogDetail.Error = '' THEN BEGIN
                    PLCLogDetail.Sucess := TRUE;
                    PLCLogDetail.MODIFY;
                END;
            UNTIL PLCLogDetail.NEXT = 0;

        PLCLogDetail.RESET;
        PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
        PLCLogDetail.SETRANGE(Sucess, FALSE);
        IF PLCLogDetail.FINDFIRST THEN
            PLCLog.Success := FALSE
        ELSE
            PLCLog.Success := TRUE;

        PLCLog."End Date Time" := CURRENTDATETIME;
        PLCLog.MODIFY;
    end;


    procedure GLInterfaceBG(FileName: Text[1000]; var TempABSContainerContent: Record "ABS Container Content")
    var
        OutStrVar: OutStream;
        TestFile: File;
        InStrVar: InStream;
        PLCLog: Record "PLC Logs";
        LogNo: Integer;
        RestorePoint: Integer;
        PLCLogDetail: Record "PLC Logs Details";
        GLInterface: Record "LMS GL Data Stagings";
        Check: Codeunit "Check GL Interface Lines";
        Url: Text;
        Json: Text;
        Httpclint: HttpClient;
        HttpContnt: HttpContent;
        HttpResponseMsg: HttpResponseMessage;
        HttpHdr: HttpHeaders;
        TempBlob: Codeunit "Temp Blob";

    begin
        PLCLog.RESET;
        IF PLCLog.FINDLAST THEN
            LogNo := PLCLog."Entry No.";

        PLCLog.INIT;
        PLCLog."Entry No." := LogNo + 1;
        PLCLog."Interface Type" := PLCLog."Interface Type"::GL;
        PLCLog."Start Date Time" := CURRENTDATETIME;
        PLCLog."File Name" := FileName;
        //PLCLog."Document No." :=COPYSTR(recFile.Name,12,16) ;
        PLCLog.INSERT;
        //COMMIT;

        GLInterface.RESET;
        IF GLInterface.FINDLAST THEN
            RestorePoint := GLInterface."Entry No";

        //IMPORTING DATA
        // TestFile.OPEN(FileName);
        // TestFile.CREATEINSTREAM(InStrVar);
        // CLEARLASTERROR;
        // XMLPORT.IMPORT(50016, InStrVar);
        ABSBlobClient.GetBlobAsStream(TempABSContainerContent."Full Name", InStrVar);
        XMLPORT.IMPORT(50126, InStrVar);
        //TestFile.CLOSE;
        //ERASE(FileName);

        //CREATING Detail LOG each record wise
        GLInterface.RESET;
        GLInterface.SETFILTER("Entry No", '>%1', RestorePoint);
        IF GLInterface.FINDFIRST THEN
            REPEAT
                PLCLogDetail.INIT;
                PLCLogDetail."PLC Log No." := PLCLog."Entry No.";
                PLCLogDetail."Record No." := GLInterface."Entry No";
                PLCLogDetail."Identifier 1" := GLInterface."Document No.";
                //PLCLogDetail."Identifier 2" := ItemInterface."Store Code";
                //PLCLogDetail."Identifier 3" := ItemInterface.Barcode;
                //PLCLogDetail."Identifier 4" := '';
                PLCLogDetail."Date & Time" := CURRENTDATETIME;//vikas
                PLCLogDetail.Date := WORKDATE;//CCIT Vikas
                PLCLogDetail.INSERT;
            UNTIL GLInterface.NEXT = 0;

        //CHECKING ERROR
        GLInterface.RESET;
        GLInterface.SETFILTER("Entry No", '>%1', RestorePoint);
        IF GLInterface.FINDFIRST THEN
            REPEAT
                PLCLogDetail.GET(PLCLog."Entry No.", GLInterface."Entry No");
                Check.SETITEMRECORD(GLInterface, RecordLastPoint, PLCLog."Entry No."); //NP
                COMMIT;
                CLEARLASTERROR;
                //  Check.RUN;
                IF Check.RUN = FALSE THEN BEGIN
                    PLCLogDetail.Error := GETLASTERRORTEXT;
                    PLCLogDetail.MODIFY;
                    ErrorExist := TRUE;//Vikas
                END;
            UNTIL GLInterface.NEXT = 0;

        PLCLogDetail.RESET;
        PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
        IF PLCLogDetail.FINDFIRST THEN
            REPEAT
                PLCLog."Total Records" := PLCLogDetail.COUNT;
                IF PLCLogDetail.Error = '' THEN BEGIN
                    PLCLogDetail.Sucess := TRUE;
                    PLCLogDetail.MODIFY;
                END;
            UNTIL PLCLogDetail.NEXT = 0;

        PLCLogDetail.RESET;
        PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
        PLCLogDetail.SETRANGE(Sucess, FALSE);
        IF PLCLogDetail.FINDFIRST THEN
            PLCLog.Success := FALSE
        ELSE
            PLCLog.Success := TRUE;

        PLCLog."End Date Time" := CURRENTDATETIME;
        PLCLog.MODIFY;
    end;


    // procedure GLinterface()
    // var
    //     containerType: Enum ABSEnum;
    //     Container: Text;
    //     SharedKey: SecretText;
    //     ABSDialog: Page ABSDialog;
    //     ContainerName: text;
    //     ABSBlobClient: codeunit "ABS Blob Client";
    //     Authorization: Interface "Storage Service Authorization";
    //     StorageServiceAuthorization: Codeunit "Storage Service Authorization";
    //     Response: Codeunit "ABS Operation Response";
    //     ABSContainerContent: Record "ABS Container Content";
    //     ABSContainersetup: Record "ABS Container setup";
    //     TempABSContainerContent: Record "ABS Container Content";
    // begin
    //     ABSContainersetup.Get('GL');

    //     SharedKey := ABSContainersetup."Shared Access Key";
    //     Authorization := StorageServiceAuthorization.CreateSharedKey(SharedKey);
    //     ABSBlobClient.Initialize(ABSContainersetup."Account Name", ABSContainersetup."In Container Name", Authorization);

    //     Response := ABSBlobClient.ListBlobs(TempABSContainerContent);

    //     If Response.GetError() <> '' then
    //         message(format(Response.GetError()));

    //     if TempABSContainerContent.FindFirst() then
    //         repeat
    //             ABSBlobClient.GetBlobAsFile(TempABSContainerContent."Full Name");
    //         until TempABSContainerContent.Next() = 0;


    // end;

    local procedure VendorInterface(FileName: Text[1000]; var TempABSContainerContent: Record "ABS Container Content")
    var
        OutStrVar: OutStream;
        TestFile: File;
        InStrVar: InStream;
        PLCLog: Record 50126;
        LogNo: Integer;
        RestorePoint: Integer;
        PLCLogDetail: Record "PLC Logs Details";
        VendorInterface: Record "LMS Vendor Data Stagings";
        Check: Codeunit "Check Vend Interface Lines";
    begin
        PLCLog.RESET;
        IF PLCLog.FINDLAST THEN
            LogNo := PLCLog."Entry No.";

        PLCLog.INIT;
        PLCLog."Entry No." := LogNo + 1;
        PLCLog."Interface Type" := PLCLog."Interface Type"::Vendor;
        PLCLog."Start Date Time" := CURRENTDATETIME;
        PLCLog."File Name" := FileName;
        //PLCLog."Document No." :=COPYSTR(recFile.Name,12,16) ;
        PLCLog.INSERT;
        //COMMIT;

        VendorInterface.RESET;
        IF VendorInterface.FINDLAST THEN
            RestorePoint := VendorInterface."Entry No";

        //IMPORTING DATA
        //TestFile.OPEN(FileName);
        //TestFile.CREATEINSTREAM(InStrVar);
        CLEARLASTERROR;
        XMLPORT.IMPORT(Xmlport::"LMS Vendor Date Import", InStrVar);

        //TestFile.CLOSE;

        //CREATING Detail LOG each record wise
        VendorInterface.RESET;
        VendorInterface.SETFILTER("Entry No", '>%1', RestorePoint);
        IF VendorInterface.FINDFIRST THEN
            REPEAT
                PLCLogDetail.INIT;
                PLCLogDetail."PLC Log No." := PLCLog."Entry No.";
                PLCLogDetail."Record No." := VendorInterface."Entry No";
                PLCLogDetail."Identifier 1" := VendorInterface."No.";
                //PLCLogDetail."Identifier 2" := ItemInterface."Store Code";
                //PLCLogDetail."Identifier 3" := ItemInterface.Barcode;
                //PLCLogDetail."Identifier 4" := '';
                PLCLogDetail."Date & Time" := CURRENTDATETIME;//vikas
                PLCLogDetail.Date := WORKDATE;//CCIT Vikas
                PLCLogDetail.INSERT;
            UNTIL VendorInterface.NEXT = 0;

        //CHECKING ERROR
        VendorInterface.RESET;
        VendorInterface.SETFILTER("Entry No", '>%1', RestorePoint);
        IF VendorInterface.FINDFIRST THEN
            REPEAT
                PLCLogDetail.GET(PLCLog."Entry No.", VendorInterface."Entry No");
                Check.SETITEMRECORD(VendorInterface, RecordLastPoint, PLCLog."Entry No.");
                COMMIT;
                CLEARLASTERROR;
                //  Check.RUN;
                IF Check.RUN = FALSE THEN BEGIN
                    PLCLogDetail.Error := GETLASTERRORTEXT;
                    PLCLogDetail.MODIFY;
                    ErrorExist := TRUE;//Vikas
                END;
            UNTIL VendorInterface.NEXT = 0;

        PLCLogDetail.RESET;
        PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
        IF PLCLogDetail.FINDFIRST THEN
            REPEAT
                PLCLog."Total Records" := PLCLogDetail.COUNT;
                IF PLCLogDetail.Error = '' THEN BEGIN
                    PLCLogDetail.Sucess := TRUE;
                    PLCLogDetail.MODIFY;
                END;
            UNTIL PLCLogDetail.NEXT = 0;

        PLCLogDetail.RESET;
        PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
        PLCLogDetail.SETRANGE(Sucess, FALSE);
        IF PLCLogDetail.FINDFIRST THEN
            PLCLog.Success := FALSE
        ELSE
            PLCLog.Success := TRUE;

        PLCLog."End Date Time" := CURRENTDATETIME;
        PLCLog.MODIFY;
    end;

    local procedure PurchaseInterface(FileName: Text[1000]; var TempABSContainerContent: Record "ABS Container Content")
    var
        OutStrVar: OutStream;
        TestFile: File;
        InStrVar: InStream;
        PLCLog: Record 50126;
        LogNo: Integer;
        RestorePoint: Integer;
        PLCLogDetail: Record "PLC Logs Details";
        PurchInterface: Record "LMS Purchase Trans. Stagings";
        Check: Codeunit "Check Purc Interface Lines";
    begin
        PLCLog.RESET;
        IF PLCLog.FINDLAST THEN
            LogNo := PLCLog."Entry No.";

        PLCLog.INIT;
        PLCLog."Entry No." := LogNo + 1;
        PLCLog."Interface Type" := PLCLog."Interface Type"::Purchase;
        PLCLog."Start Date Time" := CURRENTDATETIME;
        PLCLog."File Name" := FileName;
        //PLCLog."Document No." :=COPYSTR(recFile.Name,12,16) ;
        PLCLog.INSERT;
        //COMMIT;

        PurchInterface.RESET;
        IF PurchInterface.FINDLAST THEN
            RestorePoint := PurchInterface."Entry No";

        //IMPORTING DATA
        //TestFile.OPEN(FileName);
        //TestFile.CREATEINSTREAM(InStrVar);
        CLEARLASTERROR;
        XMLPORT.IMPORT(Xmlport::"LMS Purch.Trans. Import", InStrVar);

        //TestFile.CLOSE;

        //CREATING Detail LOG each record wise
        PurchInterface.RESET;
        PurchInterface.SETFILTER("Entry No", '>%1', RestorePoint);
        IF PurchInterface.FINDFIRST THEN
            REPEAT
                PLCLogDetail.INIT;
                PLCLogDetail."PLC Log No." := PLCLog."Entry No.";
                PLCLogDetail."Record No." := PurchInterface."Entry No";
                PLCLogDetail."Identifier 1" := PurchInterface."No.";
                //PLCLogDetail."Identifier 2" := ItemInterface."Store Code";
                //PLCLogDetail."Identifier 3" := ItemInterface.Barcode;
                //PLCLogDetail."Identifier 4" := '';
                PLCLogDetail."Date & Time" := CURRENTDATETIME;//vikas
                PLCLogDetail.Date := WORKDATE;//CCIT Vikas
                PLCLogDetail.INSERT;
            UNTIL PurchInterface.NEXT = 0;

        //CHECKING ERROR
        PurchInterface.RESET;
        PurchInterface.SETFILTER("Entry No", '>%1', RestorePoint);
        IF PurchInterface.FINDFIRST THEN
            REPEAT
                PLCLogDetail.GET(PLCLog."Entry No.", PurchInterface."Entry No");
                Check.SETITEMRECORD(PurchInterface, RecordLastPoint, PLCLog."Entry No.");
                COMMIT;
                CLEARLASTERROR;
                //  Check.RUN;
                IF Check.RUN = FALSE THEN BEGIN
                    PLCLogDetail.Error := GETLASTERRORTEXT;
                    PLCLogDetail.MODIFY;
                    ErrorExist := TRUE;//Vikas
                END;
            UNTIL PurchInterface.NEXT = 0;

        PLCLogDetail.RESET;
        PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
        IF PLCLogDetail.FINDFIRST THEN
            REPEAT
                PLCLog."Total Records" := PLCLogDetail.COUNT;
                IF PLCLogDetail.Error = '' THEN BEGIN
                    PLCLogDetail.Sucess := TRUE;
                    PLCLogDetail.MODIFY;
                END;
            UNTIL PLCLogDetail.NEXT = 0;

        PLCLogDetail.RESET;
        PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
        PLCLogDetail.SETRANGE(Sucess, FALSE);
        IF PLCLogDetail.FINDFIRST THEN
            PLCLog.Success := FALSE
        ELSE
            PLCLog.Success := TRUE;

        PLCLog."End Date Time" := CURRENTDATETIME;
        PLCLog.MODIFY;
    end;

    local procedure POInterface(FileName: Text[1000]; var TempABSContainerContent: Record "ABS Container Content")
    var
        OutStrVar: OutStream;
        TestFile: File;
        InStrVar: InStream;
        PLCLog: Record 50126;
        LogNo: Integer;
        RestorePoint: Integer;
        PLCLogDetail: Record "PLC Logs Details";
        PurchInterface: Record "LMS Purchase Trans. Stagings";
        Check: Codeunit "Check PO Interface Lines";
    begin
        PLCLog.RESET;
        IF PLCLog.FINDLAST THEN
            LogNo := PLCLog."Entry No.";

        PLCLog.INIT;
        PLCLog."Entry No." := LogNo + 1;
        PLCLog."Interface Type" := PLCLog."Interface Type"::PO;
        PLCLog."Start Date Time" := CURRENTDATETIME;
        PLCLog."File Name" := FileName;
        //PLCLog."Document No." :=COPYSTR(recFile.Name,12,16) ;
        PLCLog.INSERT;
        //COMMIT;

        PurchInterface.RESET;
        IF PurchInterface.FINDLAST THEN
            RestorePoint := PurchInterface."Entry No";

        //IMPORTING DATA
        // TestFile.OPEN(FileName);
        // TestFile.CREATEINSTREAM(InStrVar);
        CLEARLASTERROR;
        XMLPORT.IMPORT(Xmlport::"LMS Purch.Order. Import", InStrVar);

        // TestFile.CLOSE;

        //CREATING Detail LOG each record wise
        PurchInterface.RESET;
        PurchInterface.SETFILTER("Entry No", '>%1', RestorePoint);
        IF PurchInterface.FINDFIRST THEN
            REPEAT
                PLCLogDetail.INIT;
                PLCLogDetail."PLC Log No." := PLCLog."Entry No.";
                PLCLogDetail."Record No." := PurchInterface."Entry No";
                PLCLogDetail."Identifier 1" := PurchInterface."No.";
                //PLCLogDetail."Identifier 2" := ItemInterface."Store Code";
                //PLCLogDetail."Identifier 3" := ItemInterface.Barcode;
                //PLCLogDetail."Identifier 4" := '';
                PLCLogDetail."Date & Time" := CURRENTDATETIME;//vikas
                PLCLogDetail.Date := WORKDATE;//CCIT Vikas
                PLCLogDetail.INSERT;
            UNTIL PurchInterface.NEXT = 0;

        //CHECKING ERROR
        PurchInterface.RESET;
        PurchInterface.SETFILTER("Entry No", '>%1', RestorePoint);
        IF PurchInterface.FINDFIRST THEN
            REPEAT
                PLCLogDetail.GET(PLCLog."Entry No.", PurchInterface."Entry No");
                Check.SETITEMRECORD(PurchInterface, RecordLastPoint, PLCLog."Entry No.");
                COMMIT;
                CLEARLASTERROR;
                //  Check.RUN;
                IF Check.RUN = FALSE THEN BEGIN
                    PLCLogDetail.Error := GETLASTERRORTEXT;
                    PLCLogDetail.MODIFY;
                    ErrorExist := TRUE;//Vikas
                END;
            UNTIL PurchInterface.NEXT = 0;

        PLCLogDetail.RESET;
        PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
        IF PLCLogDetail.FINDFIRST THEN
            REPEAT
                PLCLog."Total Records" := PLCLogDetail.COUNT;
                IF PLCLogDetail.Error = '' THEN BEGIN
                    PLCLogDetail.Sucess := TRUE;
                    PLCLogDetail.MODIFY;
                END;
            UNTIL PLCLogDetail.NEXT = 0;

        PLCLogDetail.RESET;
        PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
        PLCLogDetail.SETRANGE(Sucess, FALSE);
        IF PLCLogDetail.FINDFIRST THEN
            PLCLog.Success := FALSE
        ELSE
            PLCLog.Success := TRUE;

        PLCLog."End Date Time" := CURRENTDATETIME;
        PLCLog.MODIFY;
    end;

    var
        //recFile: Record "2000000022";
        ABSBlobClient: codeunit "ABS Blob Client";
        RecordLastPoint: Integer;
        PLCLogLastRec: Record "PLC Logs";
        InterfacePath: Record 50128;
        "---CIT": Integer;
        RecItemCategoryCode: Record "Item Category";
        RecProductGrp: Record "Item Category";
        dd: Integer;
        mm: Integer;
        yy: Integer;
        date1: Date;
        txtdate1: Text;
        ErrorExist: Boolean;
        BatchnameSelect: Page "Batch name Select";
}
