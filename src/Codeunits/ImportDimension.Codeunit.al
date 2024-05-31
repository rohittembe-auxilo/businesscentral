// codeunit 50033 "Import Dimension"
// {

//     trigger OnRun()
//     var
//         TestFile: File;
//         InStrVar: InStream;
//         InterfacePath: Record "5217";
//         Filename: Text[250];
//     begin
//         //ErrorExist:= FALSE;
//         InterfacePath.RESET;
//         InterfacePath.SETFILTER(InterfacePath."File Type", 'Dimension');
//         InterfacePath.FINDFIRST;
//         IF InterfacePath."Instore File Path" <> '' THEN BEGIN
//             recFile.RESET;
//             recFile.SETRANGE(Path, InterfacePath."Instore File Path");
//             recFile.SETRANGE("Is a file", TRUE);
//             //recFile.SETFILTER(Name,'AUX_LANDIM*');
//             IF recFile.FINDFIRST THEN BEGIN
//                 //IMPORTING DATA
//                 Filename := InterfacePath."Instore File Path" + '\' + recFile.Name;
//                 checkDuplicateFile(recFile.Name);
//                 TestFile.OPEN(Filename);
//                 TestFile.CREATEINSTREAM(InStrVar);
//                 //CLEARLASTERROR;

//                 //XMLPORT.IMPORT(50012, InStrVar);

//                 IF XMLPORT.IMPORT(50012, InStrVar) THEN BEGIN
//                     TestFile.CLOSE;
//                     createPLClog(TRUE);
//                     COPY(Filename, InterfacePath."Processed File Path" + '\' + recFile.Name);
//                     ERASE(Filename);
//                 END ELSE BEGIN
//                     TestFile.CLOSE;
//                     createPLClog(FALSE);
//                     COPY(Filename, InterfacePath."Error File Path" + '\' + recFile.Name);
//                     ERASE(Filename);
//                 END;

//             END;
//         END;
//     end;

//     var
//         recFile: Record "2000000022";

//     local procedure createPLClog(success: Boolean)
//     var
//         PLCLog: Record "PLC Logs";
//         LogNo: Integer;
//         PLCLogDetail: Record "PLC Logs Details";
//     begin
//         PLCLog.RESET;
//         IF PLCLog.FINDLAST THEN
//             LogNo := PLCLog."Entry No.";

//         PLCLog.INIT;
//         PLCLog."Entry No." := LogNo + 1;
//         PLCLog."Interface Type" := PLCLog."Interface Type"::Dimension;
//         PLCLog."Start Date Time" := CURRENTDATETIME;
//         PLCLog."File Name" := recFile.Name;
//         //PLCLog."Document No." :=COPYSTR(recFile.Name,12,16) ;
//         PLCLog.INSERT;

//         PLCLogDetail.INIT;
//         PLCLogDetail."PLC Log No." := PLCLog."Entry No.";
//         PLCLogDetail."Record No." := PLCLog."Entry No.";
//         PLCLogDetail."Identifier 1" := '';
//         //PLCLogDetail."Identifier 2" := ItemInterface."Store Code";
//         //PLCLogDetail."Identifier 3" := ItemInterface.Barcode;
//         //PLCLogDetail."Identifier 4" := '';
//         PLCLogDetail."Date & Time" := CURRENTDATETIME;//vikas
//         PLCLogDetail.Date := WORKDATE;//CCIT Vikas
//         PLCLogDetail.Filename := PLCLog."File Name";//CCIT Kritika
//         PLCLogDetail.Sucess := success;//ccit
//         PLCLogDetail.INSERT;

//     end;

//     local procedure checkDuplicateFile(filenameDuplicate: Text[1000])
//     var
//         PLCLogs: Record "PLC Logs";
//         PLCLogsDetails: Record "PLC Logs Details";
//     begin
//         PLCLogs.RESET;
//         PLCLogs.SETRANGE("File Name", filenameDuplicate);
//         IF PLCLogs.FINDFIRST THEN BEGIN
//             PLCLogsDetails.RESET;
//             PLCLogsDetails.SETRANGE(Sucess, FALSE);
//             PLCLogsDetails.SETRANGE("PLC Log No.", PLCLogs."Entry No.");
//             IF NOT PLCLogsDetails.FINDFIRST THEN
//                 ERROR('DUPLICATE!!File with same name is already uploaded into the system.');
//         END;
//     end;
// }

