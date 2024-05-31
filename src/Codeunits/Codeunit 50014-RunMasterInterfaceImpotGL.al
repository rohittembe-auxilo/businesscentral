// codeunit 50014 "Run Master Interface Impot GL"
// {
//     // version CCIT AN


//     trigger OnRun()
//     begin
//         //New Added CCIT AN 090123
//         CLEAR(BatchnameSelect);
//         //BatchnameSelect.RUNMODAL;
//         IF BatchnameSelect.RUNMODAL = ACTION::Cancel THEN
//             EXIT;

//         ErrorExist := FALSE;
//         InterfacePath.RESET;
//         InterfacePath.SETFILTER(InterfacePath."File Type", 'GL');
//         InterfacePath.FINDFIRST;
//         IF InterfacePath."Instore File Path" <> '' THEN BEGIN
//             WITH recFile DO BEGIN
//                 RESET;
//                 SETRANGE(Path, InterfacePath."Instore File Path");
//                 SETRANGE("Is a file", TRUE);
//                 IF FIND('-') THEN
//                     REPEAT
//                         //ERROR('Onrun');
//                         PLCLogLastRec.RESET;
//                         IF PLCLogLastRec.FINDLAST THEN
//                             RecordLastPoint := PLCLogLastRec."Entry No.";
//                         // IF IsFileTrue(InterfacePath."Instore File Path",Name,'INF0001') THEN BEGIN
//                         //  RemoveNamespaceDotnet(InterfacePath."Instore File Path"+'\'+Name);    //Remove namespaces from xml
//                         GLInterface(InterfacePath."Instore File Path" + '\' + Name);
//                         //END;
//                         MoveFiles(RecordLastPoint, InterfacePath."Instore File Path", 'GL');

//                     UNTIL NEXT = 0;
//             END;
//         END;
//         COMMIT;


//         /*InterfacePath.RESET;
//         InterfacePath.SETFILTER(InterfacePath."File Type",'Vendor');
//         InterfacePath.FINDFIRST;
//           IF InterfacePath."Instore File Path" <> '' THEN BEGIN
//           WITH recFile DO BEGIN
//             RESET;
//             SETRANGE(Path,InterfacePath."Instore File Path");
//             SETRANGE("Is a file",TRUE);
//             IF FIND('-') THEN
//               REPEAT
//                 //MESSAGE('Onrun');
//                 PLCLogLastRec.RESET;
//                 IF PLCLogLastRec.FINDLAST THEN
//                   RecordLastPoint := PLCLogLastRec."Entry No.";
//                // IF IsFileTrue(InterfacePath."Instore File Path",Name,'INF0001') THEN BEGIN
//                 //  RemoveNamespaceDotnet(InterfacePath."Instore File Path"+'\'+Name);    //Remove namespaces from xml
//                   VendorInterface(InterfacePath."Instore File Path"+'\'+Name);
//                 //END;
//                 MoveFiles(RecordLastPoint,InterfacePath."Instore File Path",'Vendor');

//               UNTIL NEXT = 0;
//           END;
//         END;
//         COMMIT;

//         InterfacePath.RESET;
//         InterfacePath.SETFILTER(InterfacePath."File Type",'Purchase');
//         InterfacePath.FINDFIRST;
//           IF InterfacePath."Instore File Path" <> '' THEN BEGIN
//           WITH recFile DO BEGIN
//             RESET;
//             SETRANGE(Path,InterfacePath."Instore File Path");
//             SETRANGE("Is a file",TRUE);
//             IF FIND('-') THEN
//               REPEAT
//                 //MESSAGE('Onrun');
//                 PLCLogLastRec.RESET;
//                 IF PLCLogLastRec.FINDLAST THEN
//                   RecordLastPoint := PLCLogLastRec."Entry No.";
//                // IF IsFileTrue(InterfacePath."Instore File Path",Name,'INF0001') THEN BEGIN
//                 //  RemoveNamespaceDotnet(InterfacePath."Instore File Path"+'\'+Name);    //Remove namespaces from xml
//                   PurchaseInterface(InterfacePath."Instore File Path"+'\'+Name);
//                 //END;
//                 MoveFiles(RecordLastPoint,InterfacePath."Instore File Path",'Purchase');

//               UNTIL NEXT = 0;
//           END;
//         END;
//         COMMIT;

//         //CCIT AN 05012023++ PO Import
//         InterfacePath.RESET;
//         InterfacePath.SETFILTER(InterfacePath."File Type",'PO');
//         InterfacePath.FINDFIRST;
//           IF InterfacePath."Instore File Path" <> '' THEN BEGIN
//           WITH recFile DO BEGIN
//             RESET;
//             SETRANGE(Path,InterfacePath."Instore File Path");
//             SETRANGE("Is a file",TRUE);
//             IF FIND('-') THEN
//               REPEAT
//                 //MESSAGE('Onrun');
//                 PLCLogLastRec.RESET;
//                 IF PLCLogLastRec.FINDLAST THEN
//                   RecordLastPoint := PLCLogLastRec."Entry No.";
//                // IF IsFileTrue(InterfacePath."Instore File Path",Name,'INF0001') THEN BEGIN
//                 //  RemoveNamespaceDotnet(InterfacePath."Instore File Path"+'\'+Name);    //Remove namespaces from xml
//                   POInterface(InterfacePath."Instore File Path"+'\'+Name);
//                 //END;
//                 MoveFiles(RecordLastPoint,InterfacePath."Instore File Path",'PO');

//               UNTIL NEXT = 0;
//           END;
//         END;
//         COMMIT;
//         //CCIT AN 05012023--
//         */
//         //Vikas 22072020
//         IF ErrorExist = TRUE THEN
//             ERROR('File not uploaded')
//         ELSE
//             MESSAGE('Uploaded sucessfully..');

//     end;

//     var
//         //recFile: Record "2000000022";
//         RecordLastPoint: Integer;
//         PLCLogLastRec: Record "PLC Logs";
//         InterfacePath: Record 50128;
//         "---CIT": Integer;
//         RecItemCategoryCode: Record "Item Category";
//         RecProductGrp: Record "Item Category";
//         dd: Integer;
//         mm: Integer;
//         yy: Integer;
//         date1: Date;
//         txtdate1: Text;
//         ErrorExist: Boolean;
//         BatchnameSelect: Page "Batch name Select";

//     procedure GLInterface(FileName: Text[1000])
//     var
//         OutStrVar: OutStream;
//         TestFile: File;
//         InStrVar: InStream;
//         PLCLog: Record "PLC Logs";
//         LogNo: Integer;
//         RestorePoint: Integer;
//         PLCLogDetail: Record "PLC Logs Details";
//         GLInterface: Record "LMS GL Data Stagings";
//         //Check: Codeunit 279;
//         Url: Text;
//         Json: Text;
//         Httpclint: HttpClient;
//         HttpContnt: HttpContent;
//         HttpResponseMsg: HttpResponseMessage;
//         HttpHdr: HttpHeaders;
//         TempBlob: Codeunit "Temp Blob";

//     begin
//         //Creating LOG HEADER
//         //MESSAGE('Hi');
//         PLCLog.RESET;
//         IF PLCLog.FINDLAST THEN
//             LogNo := PLCLog."Entry No.";

//         PLCLog.INIT;
//         PLCLog."Entry No." := LogNo + 1;
//         PLCLog."Interface Type" := PLCLog."Interface Type"::GL;
//         PLCLog."Start Date Time" := CURRENTDATETIME;
//         PLCLog."File Name" := recFile.Name;
//         //PLCLog."Document No." :=COPYSTR(recFile.Name,12,16) ;
//         PLCLog.INSERT;
//         //COMMIT;

//         GLInterface.RESET;
//         IF GLInterface.FINDLAST THEN
//             RestorePoint := GLInterface."Entry No";

//         //IMPORTING DATA
//         TestFile.OPEN(FileName);
//         TestFile.CREATEINSTREAM(InStrVar);
//         CLEARLASTERROR;
//         XMLPORT.IMPORT(50016, InStrVar);

//         TestFile.CLOSE;
//         //ERASE(FileName);

//         //CREATING Detail LOG each record wise
//         GLInterface.RESET;
//         GLInterface.SETFILTER("Entry No", '>%1', RestorePoint);
//         IF GLInterface.FINDFIRST THEN
//             REPEAT
//                 PLCLogDetail.INIT;
//                 PLCLogDetail."PLC Log No." := PLCLog."Entry No.";
//                 PLCLogDetail."Record No." := GLInterface."Entry No";
//                 PLCLogDetail."Identifier 1" := GLInterface."Document No.";
//                 //PLCLogDetail."Identifier 2" := ItemInterface."Store Code";
//                 //PLCLogDetail."Identifier 3" := ItemInterface.Barcode;
//                 //PLCLogDetail."Identifier 4" := '';
//                 PLCLogDetail."Date & Time" := CURRENTDATETIME;//vikas
//                 PLCLogDetail.Date := WORKDATE;//CCIT Vikas
//                 PLCLogDetail.INSERT;
//             UNTIL GLInterface.NEXT = 0;

//         //CHECKING ERROR
//         GLInterface.RESET;
//         GLInterface.SETFILTER("Entry No", '>%1', RestorePoint);
//         IF GLInterface.FINDFIRST THEN
//             REPEAT
//                 PLCLogDetail.GET(PLCLog."Entry No.", GLInterface."Entry No");
//                 Check.SETITEMRECORD(GLInterface, RecordLastPoint, PLCLog."Entry No.");
//                 COMMIT;
//                 CLEARLASTERROR;
//                 //  Check.RUN;
//                 IF Check.RUN = FALSE THEN BEGIN
//                     PLCLogDetail.Error := GETLASTERRORTEXT;
//                     PLCLogDetail.MODIFY;
//                     ErrorExist := TRUE;//Vikas
//                 END;
//             UNTIL GLInterface.NEXT = 0;

//         PLCLogDetail.RESET;
//         PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
//         IF PLCLogDetail.FINDFIRST THEN
//             REPEAT
//                 PLCLog."Total Records" := PLCLogDetail.COUNT;
//                 IF PLCLogDetail.Error = '' THEN BEGIN
//                     PLCLogDetail.Sucess := TRUE;
//                     PLCLogDetail.MODIFY;
//                 END;
//             UNTIL PLCLogDetail.NEXT = 0;

//         PLCLogDetail.RESET;
//         PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
//         PLCLogDetail.SETRANGE(Sucess, FALSE);
//         IF PLCLogDetail.FINDFIRST THEN
//             PLCLog.Success := FALSE
//         ELSE
//             PLCLog.Success := TRUE;

//         PLCLog."End Date Time" := CURRENTDATETIME;
//         PLCLog.MODIFY;
//     end;

//     local procedure VendorInterface(FileName: Text[100])
//     var
//         OutStrVar: OutStream;
//         TestFile: File;
//         InStrVar: InStream;
//         PLCLog: Record 50126;
//         LogNo: Integer;
//         RestorePoint: Integer;
//         PLCLogDetail: Record "PLC Logs Details";
//         VendorInterface: Record "5213";
//         Check: Codeunit "273";
//     begin
//         PLCLog.RESET;
//         IF PLCLog.FINDLAST THEN
//             LogNo := PLCLog."Entry No.";

//         PLCLog.INIT;
//         PLCLog."Entry No." := LogNo + 1;
//         PLCLog."Interface Type" := PLCLog."Interface Type"::Vendor;
//         PLCLog."Start Date Time" := CURRENTDATETIME;
//         PLCLog."File Name" := recFile.Name;
//         //PLCLog."Document No." :=COPYSTR(recFile.Name,12,16) ;
//         PLCLog.INSERT;
//         //COMMIT;

//         VendorInterface.RESET;
//         IF VendorInterface.FINDLAST THEN
//             RestorePoint := VendorInterface."Entry No";

//         //IMPORTING DATA
//         TestFile.OPEN(FileName);
//         TestFile.CREATEINSTREAM(InStrVar);
//         CLEARLASTERROR;
//         XMLPORT.IMPORT(5050, InStrVar);

//         TestFile.CLOSE;

//         //CREATING Detail LOG each record wise
//         VendorInterface.RESET;
//         VendorInterface.SETFILTER("Entry No", '>%1', RestorePoint);
//         IF VendorInterface.FINDFIRST THEN
//             REPEAT
//                 PLCLogDetail.INIT;
//                 PLCLogDetail."PLC Log No." := PLCLog."Entry No.";
//                 PLCLogDetail."Record No." := VendorInterface."Entry No";
//                 PLCLogDetail."Identifier 1" := VendorInterface."No.";
//                 //PLCLogDetail."Identifier 2" := ItemInterface."Store Code";
//                 //PLCLogDetail."Identifier 3" := ItemInterface.Barcode;
//                 //PLCLogDetail."Identifier 4" := '';
//                 PLCLogDetail."Date & Time" := CURRENTDATETIME;//vikas
//                 PLCLogDetail.Date := WORKDATE;//CCIT Vikas
//                 PLCLogDetail.INSERT;
//             UNTIL VendorInterface.NEXT = 0;

//         //CHECKING ERROR
//         VendorInterface.RESET;
//         VendorInterface.SETFILTER("Entry No", '>%1', RestorePoint);
//         IF VendorInterface.FINDFIRST THEN
//             REPEAT
//                 PLCLogDetail.GET(PLCLog."Entry No.", VendorInterface."Entry No");
//                 Check.SETITEMRECORD(VendorInterface, RecordLastPoint, PLCLog."Entry No.");
//                 COMMIT;
//                 CLEARLASTERROR;
//                 //  Check.RUN;
//                 IF Check.RUN = FALSE THEN BEGIN
//                     PLCLogDetail.Error := GETLASTERRORTEXT;
//                     PLCLogDetail.MODIFY;
//                     ErrorExist := TRUE;//Vikas
//                 END;
//             UNTIL VendorInterface.NEXT = 0;

//         PLCLogDetail.RESET;
//         PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
//         IF PLCLogDetail.FINDFIRST THEN
//             REPEAT
//                 PLCLog."Total Records" := PLCLogDetail.COUNT;
//                 IF PLCLogDetail.Error = '' THEN BEGIN
//                     PLCLogDetail.Sucess := TRUE;
//                     PLCLogDetail.MODIFY;
//                 END;
//             UNTIL PLCLogDetail.NEXT = 0;

//         PLCLogDetail.RESET;
//         PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
//         PLCLogDetail.SETRANGE(Sucess, FALSE);
//         IF PLCLogDetail.FINDFIRST THEN
//             PLCLog.Success := FALSE
//         ELSE
//             PLCLog.Success := TRUE;

//         PLCLog."End Date Time" := CURRENTDATETIME;
//         PLCLog.MODIFY;
//     end;

//     procedure MoveFiles(RestorePoint: Integer; PathFile: Text[200]; Type: Text[30])
//     var
//         PLCLog: Record 50126;
//         ReadFile: Record "2000000022";
//         FileName: Text[1024];
//         AckFileName: Text[60];
//         ErrorFileName: Text[60];
//     begin
//         //Interface.GET;
//         InterfacePath.RESET;
//         InterfacePath.SETFILTER(InterfacePath."File Type", Type);
//         InterfacePath.FINDFIRST;
//         //IF Interface."Item Instore File Path" <> '' THEN
//         IF PathFile <> '' THEN BEGIN
//             ReadFile.RESET;
//             ReadFile.SETRANGE(Path, PathFile);
//             ReadFile.SETRANGE("Is a file", TRUE);
//             IF ReadFile.FINDSET THEN
//                 REPEAT
//                     PLCLog.RESET;
//                     PLCLog.SETFILTER("Entry No.", '>%1', RestorePoint);
//                     // PLCLog.SETRANGE("Interface Type",PLCLog."Interface Type"::"Item Master");
//                     PLCLog.SETFILTER("Interface Type", Type);
//                     PLCLog.SETRANGE(PLCLog."File Name", ReadFile.Name);
//                     IF PLCLog.FINDFIRST THEN BEGIN
//                         CLEAR(FileName);
//                         FileName := PathFile + '\' + ReadFile.Name;
//                         IF PLCLog.Success THEN BEGIN
//                             IF EXISTS(FileName) THEN BEGIN
//                                 COPY(FileName, InterfacePath."Processed File Path" + '\' + ReadFile.Name);
//                                 CLEAR(AckFileName);
//                                 AckFileName := COPYSTR(ReadFile.Name, 1, STRLEN(ReadFile.Name) - 4) + '.ack';
//                                 COPY(FileName, InterfacePath."Acknowledged File Path" + '\' + AckFileName);
//                                 ERASE(FileName);
//                             END;
//                         END ELSE BEGIN
//                             IF EXISTS(FileName) THEN BEGIN
//                                 // COPY(FileName,InterfacePath."Processed File Path"+'\'+ReadFile.Name); //Vikas----------------
//                                 CLEAR(ErrorFileName);
//                                 ErrorFileName := COPYSTR(ReadFile.Name, 1, STRLEN(ReadFile.Name) - 4) + '.err';
//                                 COPY(FileName, InterfacePath."Error File Path" + '\' + ErrorFileName);
//                                 ERASE(FileName);
//                             END;
//                         END;
//                     END;
//                 UNTIL ReadFile.NEXT = 0;
//         END;
//     end;

//     procedure IsFileTrue(PathFile: Text[200]; NameFile: Text[200]; Prefix: Text[50]): Boolean
//     var
//         FilePath: Text[200];
//         FileName: Text[200];
//         recFile: Record "2000000022";
//         outStr: OutStream;
//         "Count": Integer;
//         Root: Text[100];
//         StringPos: Integer;
//         NewString: Text[30];
//         NameStore: Text[30];
//         StringPlace: Integer;
//     begin
//         /*FilePath := PathFile;
//         Root := COPYSTR(FilePath,1,3);

//         CLEAR(recFile);
//         recFile.RESET;
//         recFile.SETRANGE("Is a file",TRUE);
//         recFile.SETFILTER(Path,FilePath);
//         recFile.SETRANGE(recFile.Name,NameFile);
//         IF recFile.FINDFIRST THEN BEGIN
//           NewString := COPYSTR(recFile.Name,7,4);
//           IF NewString = Prefix THEN
//              EXIT(TRUE)
//           ELSE
//              EXIT(FALSE);
//         END;
//          */

//         // For FileName Contain Store Code - Start

//         FilePath := PathFile;
//         Root := COPYSTR(FilePath, 1, 3);
//         //RecRetailSetup.RESET;
//         //RecRetailSetup.SETRANGE("LS Retail in Use",TRUE);
//         //RecRetailSetup.FINDFIRST;

//         CLEAR(recFile);
//         recFile.RESET;
//         recFile.SETRANGE("Is a file", TRUE);
//         recFile.SETFILTER(Path, FilePath);

//         recFile.SETRANGE(recFile.Name, NameFile);
//         IF recFile.FINDFIRST THEN BEGIN
//             //NameStore   := COPYSTR(recFile.Name,2,4);
//             StringPlace := STRPOS(recFile.Name, Prefix);
//             //IF (NameStore = RecRetailSetup."Local Store No.") AND (StringPlace <>0) THEN
//             IF StringPlace <> 0 THEN
//                 EXIT(TRUE)
//             ELSE
//                 EXIT(FALSE);
//         END;



//         // For File Contail Store Code - End

//     end;

//     local procedure RemoveNamespaceDotnet(Path: Text[100])
//     begin
//         /*
//         IF ISNULL(XMLSourceDocument) THEN BEGIN
//          // XMLSourceDocument := XMLSourceDocument.DOMDocumentClass;
//           XMLSourceDocument.load(Path);
//         END;

//         IF ISNULL(XmlStyleSheet) THEN
//           XmlStyleSheet := XmlStyleSheet.DOMDocumentClass;

//         IF ISNULL(XMLDestinationDocument) THEN
//           XMLDestinationDocument := XMLDestinationDocument.DOMDocumentClass;

//         XmlStyleSheet.loadXML('<?xml version="1.0" encoding="UTF-8"?>' +
//                               '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' +
//                               '<xsl:output method="xml" encoding="UTF-8"/>' +
//                               '<xsl:template match="/">' +
//                               '<xsl:copy>' +
//                               '<xsl:apply-templates />' +
//                               '</xsl:copy>' +
//                               '</xsl:template>' +
//                               '<xsl:template match="*">' +
//                               '<xsl:element name="{local-name()}">' +
//                               '<xsl:apply-templates select="@* | node()" />' +
//                               '</xsl:element>' +
//                               '</xsl:template>' +
//                               '<xsl:template match="@*">' +
//                               '<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>' +
//                               '</xsl:template>' +
//                               '<xsl:template match="text() | processing-instruction() | comment()">' +
//                               '<xsl:copy />' +
//                               '</xsl:template>' +
//                               '</xsl:stylesheet>');

//         XMLSourceDocument.transformNodeToObject(XmlStyleSheet,XMLDestinationDocument);
//         XMLDestinationDocument.save(Path);*/

//     end;

//     local procedure PurchaseInterface(FileName: Text[100])
//     var
//         OutStrVar: OutStream;
//         TestFile: File;
//         InStrVar: InStream;
//         PLCLog: Record 50126;
//         LogNo: Integer;
//         RestorePoint: Integer;
//         PLCLogDetail: Record "PLC Logs Details";
//         PurchInterface: Record "5214";
//         Check: Codeunit "274";
//     begin
//         PLCLog.RESET;
//         IF PLCLog.FINDLAST THEN
//             LogNo := PLCLog."Entry No.";

//         PLCLog.INIT;
//         PLCLog."Entry No." := LogNo + 1;
//         PLCLog."Interface Type" := PLCLog."Interface Type"::Purchase;
//         PLCLog."Start Date Time" := CURRENTDATETIME;
//         PLCLog."File Name" := recFile.Name;
//         //PLCLog."Document No." :=COPYSTR(recFile.Name,12,16) ;
//         PLCLog.INSERT;
//         //COMMIT;

//         PurchInterface.RESET;
//         IF PurchInterface.FINDLAST THEN
//             RestorePoint := PurchInterface."Entry No";

//         //IMPORTING DATA
//         TestFile.OPEN(FileName);
//         TestFile.CREATEINSTREAM(InStrVar);
//         CLEARLASTERROR;
//         XMLPORT.IMPORT(5150, InStrVar);

//         TestFile.CLOSE;

//         //CREATING Detail LOG each record wise
//         PurchInterface.RESET;
//         PurchInterface.SETFILTER("Entry No", '>%1', RestorePoint);
//         IF PurchInterface.FINDFIRST THEN
//             REPEAT
//                 PLCLogDetail.INIT;
//                 PLCLogDetail."PLC Log No." := PLCLog."Entry No.";
//                 PLCLogDetail."Record No." := PurchInterface."Entry No";
//                 PLCLogDetail."Identifier 1" := PurchInterface."No.";
//                 //PLCLogDetail."Identifier 2" := ItemInterface."Store Code";
//                 //PLCLogDetail."Identifier 3" := ItemInterface.Barcode;
//                 //PLCLogDetail."Identifier 4" := '';
//                 PLCLogDetail."Date & Time" := CURRENTDATETIME;//vikas
//                 PLCLogDetail.Date := WORKDATE;//CCIT Vikas
//                 PLCLogDetail.INSERT;
//             UNTIL PurchInterface.NEXT = 0;

//         //CHECKING ERROR
//         PurchInterface.RESET;
//         PurchInterface.SETFILTER("Entry No", '>%1', RestorePoint);
//         IF PurchInterface.FINDFIRST THEN
//             REPEAT
//                 PLCLogDetail.GET(PLCLog."Entry No.", PurchInterface."Entry No");
//                 Check.SETITEMRECORD(PurchInterface, RecordLastPoint, PLCLog."Entry No.");
//                 COMMIT;
//                 CLEARLASTERROR;
//                 //  Check.RUN;
//                 IF Check.RUN = FALSE THEN BEGIN
//                     PLCLogDetail.Error := GETLASTERRORTEXT;
//                     PLCLogDetail.MODIFY;
//                     ErrorExist := TRUE;//Vikas
//                 END;
//             UNTIL PurchInterface.NEXT = 0;

//         PLCLogDetail.RESET;
//         PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
//         IF PLCLogDetail.FINDFIRST THEN
//             REPEAT
//                 PLCLog."Total Records" := PLCLogDetail.COUNT;
//                 IF PLCLogDetail.Error = '' THEN BEGIN
//                     PLCLogDetail.Sucess := TRUE;
//                     PLCLogDetail.MODIFY;
//                 END;
//             UNTIL PLCLogDetail.NEXT = 0;

//         PLCLogDetail.RESET;
//         PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
//         PLCLogDetail.SETRANGE(Sucess, FALSE);
//         IF PLCLogDetail.FINDFIRST THEN
//             PLCLog.Success := FALSE
//         ELSE
//             PLCLog.Success := TRUE;

//         PLCLog."End Date Time" := CURRENTDATETIME;
//         PLCLog.MODIFY;
//     end;

//     procedure GLInterfaceJobQueue(FileName: Text[100]; name: Text[100]; InterfaceFilePaths: Record 50128)
//     var
//         OutStrVar: OutStream;
//         InStrVar: InStream;
//         PLCLog: Record 50126;
//         LogNo: Integer;
//         RestorePoint: Integer;
//         PLCLogDetail: Record "PLC Logs Details";
//         GLInterface: Record "5218";
//         Check: Codeunit "272";
//         TestFile: File;
//     begin
//         //Creating LOG HEADER
//         //MESSAGE('Hi');
//         PLCLog.RESET;
//         IF PLCLog.FINDLAST THEN
//             LogNo := PLCLog."Entry No.";

//         PLCLog.INIT;
//         PLCLog."Entry No." := LogNo + 1;
//         PLCLog."Interface Type" := PLCLog."Interface Type"::GL;
//         PLCLog."Start Date Time" := CURRENTDATETIME;
//         PLCLog."File Name" := recFile.Name;
//         //PLCLog."Document No." :=COPYSTR(recFile.Name,12,16) ;
//         PLCLog.INSERT;
//         //COMMIT;

//         GLInterface.RESET;
//         IF GLInterface.FINDLAST THEN
//             RestorePoint := GLInterface."Entry No";

//         //IMPORTING DATA
//         TestFile.OPEN(FileName);
//         TestFile.CREATEINSTREAM(InStrVar);
//         //CLEARLASTERROR;
//         XMLPORT.IMPORT(5151, InStrVar);
//         //TestFile.CLOSE;
//         /*
//         IF XMLPORT.IMPORT(5151, InStrVar) THEN BEGIN
//         COPY(FileName,InterfaceFilePaths."Processed File Path"+'\'+recFile.Name);
//               TestFile.CLOSE;
//                ERASE(FileName);
//         END ELSE BEGIN
//         COPY(FileName,InterfaceFilePaths."Error File Path"+'\'+recFile.Name);
//               TestFile.CLOSE;
//               ERASE(FileName);
//         END;*/
//         //TestFile.CLOSE;//Manish  06/12/22  code comment
//         //ERASE(FileName); //manish comment 071222

//         //CREATING Detail LOG each record wise
//         GLInterface.RESET;
//         GLInterface.SETFILTER("Entry No", '>%1', RestorePoint);
//         IF GLInterface.FINDFIRST THEN
//             REPEAT
//                 PLCLogDetail.INIT;
//                 PLCLogDetail."PLC Log No." := PLCLog."Entry No.";
//                 PLCLogDetail."Record No." := GLInterface."Entry No";
//                 PLCLogDetail."Identifier 1" := GLInterface."Document No.";
//                 //PLCLogDetail."Identifier 2" := ItemInterface."Store Code";
//                 //PLCLogDetail."Identifier 3" := ItemInterface.Barcode;
//                 //PLCLogDetail."Identifier 4" := '';
//                 PLCLogDetail."Date & Time" := CURRENTDATETIME;//vikas
//                 PLCLogDetail.Date := WORKDATE;//CCIT Vikas
//                 PLCLogDetail.Filename := PLCLog."File Name";//CCIT Kritika

//                 PLCLogDetail.INSERT;
//             UNTIL GLInterface.NEXT = 0;

//         //CHECKING ERROR
//         GLInterface.RESET;
//         GLInterface.SETFILTER("Entry No", '>%1', RestorePoint);
//         IF GLInterface.FINDFIRST THEN
//             REPEAT
//                 PLCLogDetail.GET(PLCLog."Entry No.", GLInterface."Entry No");
//                 Check.SETITEMRECORD(GLInterface, RecordLastPoint, PLCLog."Entry No.");
//                 COMMIT;
//                 CLEARLASTERROR;
//                 //  Check.RUN;
//                 IF Check.RUN = FALSE THEN BEGIN
//                     PLCLogDetail.Error := GETLASTERRORTEXT;
//                     PLCLogDetail.MODIFY;
//                     ErrorExist := TRUE;//Vikas
//                 END;
//             UNTIL GLInterface.NEXT = 0;

//         PLCLogDetail.RESET;
//         PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
//         IF PLCLogDetail.FINDFIRST THEN
//             REPEAT
//                 PLCLog."Total Records" := PLCLogDetail.COUNT;
//                 IF PLCLogDetail.Error = '' THEN BEGIN
//                     PLCLogDetail.Sucess := TRUE;
//                     PLCLogDetail.MODIFY;
//                 END;
//             UNTIL PLCLogDetail.NEXT = 0;

//         PLCLogDetail.RESET;
//         PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
//         PLCLogDetail.SETRANGE(Sucess, FALSE);
//         IF PLCLogDetail.FINDFIRST THEN
//             PLCLog.Success := FALSE
//         ELSE
//             PLCLog.Success := TRUE;

//         PLCLog."End Date Time" := CURRENTDATETIME;
//         PLCLog.MODIFY;


//         IF PLCLog.Success THEN BEGIN
//             COPY(FileName, InterfaceFilePaths."Processed File Path" + '\' + recFile.Name);
//             TestFile.CLOSE;
//             ERASE(FileName);
//         END ELSE BEGIN
//             COPY(FileName, InterfaceFilePaths."Error File Path" + '\' + recFile.Name);
//             TestFile.CLOSE;
//             ERASE(FileName);
//         END;

//     end;

//     local procedure checkDuplicateFile(filenameDuplicate: Text[1000])
//     var
//         PLCLogs: Record 50126;
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

//     local procedure "---PO interface---CCIT AN"()
//     begin
//     end;

//     local procedure POInterface(FileName: Text[100])
//     var
//         OutStrVar: OutStream;
//         TestFile: File;
//         InStrVar: InStream;
//         PLCLog: Record 50126;
//         LogNo: Integer;
//         RestorePoint: Integer;
//         PLCLogDetail: Record "PLC Logs Details";
//         PurchInterface: Record "5214";
//         Check: Codeunit "277";
//     begin
//         PLCLog.RESET;
//         IF PLCLog.FINDLAST THEN
//             LogNo := PLCLog."Entry No.";

//         PLCLog.INIT;
//         PLCLog."Entry No." := LogNo + 1;
//         PLCLog."Interface Type" := PLCLog."Interface Type"::PO;
//         PLCLog."Start Date Time" := CURRENTDATETIME;
//         PLCLog."File Name" := recFile.Name;
//         //PLCLog."Document No." :=COPYSTR(recFile.Name,12,16) ;
//         PLCLog.INSERT;
//         //COMMIT;

//         PurchInterface.RESET;
//         IF PurchInterface.FINDLAST THEN
//             RestorePoint := PurchInterface."Entry No";

//         //IMPORTING DATA
//         TestFile.OPEN(FileName);
//         TestFile.CREATEINSTREAM(InStrVar);
//         CLEARLASTERROR;
//         XMLPORT.IMPORT(50015, InStrVar);

//         TestFile.CLOSE;

//         //CREATING Detail LOG each record wise
//         PurchInterface.RESET;
//         PurchInterface.SETFILTER("Entry No", '>%1', RestorePoint);
//         IF PurchInterface.FINDFIRST THEN
//             REPEAT
//                 PLCLogDetail.INIT;
//                 PLCLogDetail."PLC Log No." := PLCLog."Entry No.";
//                 PLCLogDetail."Record No." := PurchInterface."Entry No";
//                 PLCLogDetail."Identifier 1" := PurchInterface."No.";
//                 //PLCLogDetail."Identifier 2" := ItemInterface."Store Code";
//                 //PLCLogDetail."Identifier 3" := ItemInterface.Barcode;
//                 //PLCLogDetail."Identifier 4" := '';
//                 PLCLogDetail."Date & Time" := CURRENTDATETIME;//vikas
//                 PLCLogDetail.Date := WORKDATE;//CCIT Vikas
//                 PLCLogDetail.INSERT;
//             UNTIL PurchInterface.NEXT = 0;

//         //CHECKING ERROR
//         PurchInterface.RESET;
//         PurchInterface.SETFILTER("Entry No", '>%1', RestorePoint);
//         IF PurchInterface.FINDFIRST THEN
//             REPEAT
//                 PLCLogDetail.GET(PLCLog."Entry No.", PurchInterface."Entry No");
//                 Check.SETITEMRECORD(PurchInterface, RecordLastPoint, PLCLog."Entry No.");
//                 COMMIT;
//                 CLEARLASTERROR;
//                 //  Check.RUN;
//                 IF Check.RUN = FALSE THEN BEGIN
//                     PLCLogDetail.Error := GETLASTERRORTEXT;
//                     PLCLogDetail.MODIFY;
//                     ErrorExist := TRUE;//Vikas
//                 END;
//             UNTIL PurchInterface.NEXT = 0;

//         PLCLogDetail.RESET;
//         PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
//         IF PLCLogDetail.FINDFIRST THEN
//             REPEAT
//                 PLCLog."Total Records" := PLCLogDetail.COUNT;
//                 IF PLCLogDetail.Error = '' THEN BEGIN
//                     PLCLogDetail.Sucess := TRUE;
//                     PLCLogDetail.MODIFY;
//                 END;
//             UNTIL PLCLogDetail.NEXT = 0;

//         PLCLogDetail.RESET;
//         PLCLogDetail.SETRANGE(PLCLogDetail."PLC Log No.", PLCLog."Entry No.");
//         PLCLogDetail.SETRANGE(Sucess, FALSE);
//         IF PLCLogDetail.FINDFIRST THEN
//             PLCLog.Success := FALSE
//         ELSE
//             PLCLog.Success := TRUE;

//         PLCLog."End Date Time" := CURRENTDATETIME;
//         PLCLog.MODIFY;
//     end;
// }


