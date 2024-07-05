codeunit 70001 "Import Dimension Blob"
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
        Clear(ABSContainersetup);
        Clear(ABSBlobClient);
        Clear(Response);
        Clear(Authorization);

        ABSContainersetup.Get(UpperCase('Dimension'));

        SharedKey := ABSContainersetup."Shared Access Key";
        Authorization := StorageServiceAuthorization.CreateSharedKey(SharedKey);
        ABSBlobClient.Initialize(ABSContainersetup."Account Name", ABSContainersetup."In Container Name", Authorization);

        Response := ABSBlobClient.ListBlobs(TempABSContainerContent);

        If Response.GetError() <> '' then
            message(format(Response.GetError()));

        if TempABSContainerContent.FindFirst() then
            repeat
                ClearLastError();
                tempblob.CreateInStream(InStrVar);
                ABSBlobClient.GetBlobAsStream(TempABSContainerContent."Full Name", InStrVar);
                checkDuplicateFile(TempABSContainerContent."Full Name");
                IF TryImport() THEN BEGIN
                    createPLClog(TRUE, TempABSContainerContent."Full Name");
                    MoveFiles(RecordLastPoint, TempABSContainerContent."Full Name", UpperCase('Dimension'));
                END ELSE BEGIN
                    Message(GetLastErrorText());
                    createPLClog(FALSE, TempABSContainerContent."Full Name");
                    MoveFiles(RecordLastPoint, TempABSContainerContent."Full Name", UpperCase('Dimension'));
                END;

            until TempABSContainerContent.Next() = 0;


    end;

    [TryFunction]
    procedure TryImport()//NP 050724
    begin
        XMLPORT.IMPORT(Xmlport::"Dimvale update", InStrVar)
    end;

    local procedure createPLClog(success: Boolean; filename: Text[100])
    var
        PLCLog: Record "PLC Logs";
        LogNo: Integer;
        PLCLogDetail: Record "PLC Logs Details";
    begin
        PLCLog.RESET;
        IF PLCLog.FINDLAST THEN
            LogNo := PLCLog."Entry No.";

        PLCLog.INIT;
        PLCLog."Entry No." := LogNo + 1;
        PLCLog."Interface Type" := PLCLog."Interface Type"::Dimension;
        PLCLog."Start Date Time" := CURRENTDATETIME;
        PLCLog."File Name" := filename;
        PLCLog.Success := success;
        //PLCLog."Document No." :=COPYSTR(recFile.Name,12,16) ;
        PLCLog.INSERT;

        PLCLogDetail.INIT;
        PLCLogDetail."PLC Log No." := PLCLog."Entry No.";
        PLCLogDetail."Record No." := PLCLog."Entry No.";
        PLCLogDetail."Identifier 1" := '';
        //PLCLogDetail."Identifier 2" := ItemInterface."Store Code";
        //PLCLogDetail."Identifier 3" := ItemInterface.Barcode;
        //PLCLogDetail."Identifier 4" := '';
        PLCLogDetail.Error := COPYSTR(GetLastErrorText(), 1, 250);
        PLCLogDetail."Date & Time" := CURRENTDATETIME;//vikas
        PLCLogDetail.Date := WORKDATE;//CCIT Vikas
        PLCLogDetail.Filename := PLCLog."File Name";//CCIT Kritika
        PLCLogDetail.Sucess := success;//ccit
        PLCLogDetail.INSERT;

    end;

    local procedure checkDuplicateFile(filenameDuplicate: Text[1000])
    var
        PLCLogs: Record "PLC Logs";
        PLCLogsDetails: Record "PLC Logs Details";
    begin
        PLCLogs.RESET;
        PLCLogs.SETRANGE("File Name", filenameDuplicate);
        IF PLCLogs.FINDFIRST THEN BEGIN
            PLCLogsDetails.RESET;
            PLCLogsDetails.SETRANGE(Sucess, FALSE);
            PLCLogsDetails.SETRANGE("PLC Log No.", PLCLogs."Entry No.");
            IF NOT PLCLogsDetails.FINDFIRST THEN
                ERROR('DUPLICATE!!File with same name is already uploaded into the system.');
        END;
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


    var
        ABSBlobClient: codeunit "ABS Blob Client";
        RecordLastPoint: Integer;
        PLCLogLastRec: Record "PLC Logs";
        InterfacePath: Record 50128;
        tempblob: Codeunit "Temp Blob";
        InStrVar: InStream;
}
