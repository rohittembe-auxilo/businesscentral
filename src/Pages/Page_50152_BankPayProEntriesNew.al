Page 50152 "Bank PayPro Entries-New"
{
    InsertAllowed = false;
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Bank Pay Pro Entries-New";
    SourceTableView = sorting("Bank No", "Line No")
                      where("Exported to File" = filter(false));


    layout
    {
        area(content)
        {
            group("Bank Entries")
            {
                field(GlbBankAccountNo; GlbBankAccountNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Account No';
                    TableRelation = "Bank Account"."No.";

                    trigger OnValidate()
                    begin
                        Rec.SetRange("Bank No", GlbBankAccountNo);
                        if Rec.FindSet then;
                        CurrPage.Update(false);
                    end;
                }
            }
            repeater(Group)
            {
                field("Payment Method identifier"; Rec."Payment Method identifier")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Value Date"; Rec."Value Date")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Name"; Rec."Beneficiary Name")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Address 1"; Rec."Beneficiary Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Address 2"; Rec."Beneficiary Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Address 3"; Rec."Beneficiary Address 3")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary City"; Rec."Beneficiary City")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary State"; Rec."Beneficiary State")
                {
                    ApplicationArea = Basic;
                }
                field("PIN Code"; Rec."PIN Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bene Account Number"; Rec."Bene Account Number")
                {
                    ApplicationArea = Basic;
                }
                field("Email ID of beneficiary"; Rec."Email ID of beneficiary")
                {
                    ApplicationArea = Basic;
                }
                field("Email Body"; Rec."Email Body")
                {
                    ApplicationArea = Basic;
                }
                field("Debit Account Number"; Rec."Debit Account Number")
                {
                    ApplicationArea = Basic;
                }
                field("CRN (Narration  / Remarks)"; Rec."CRN (Narration  / Remarks)")
                {
                    ApplicationArea = Basic;
                }
                field("Receiver IFSC"; Rec."Receiver IFSC")
                {
                    ApplicationArea = Basic;
                }
                field("Receiver A/c type"; Rec."Receiver A/c type")
                {
                    ApplicationArea = Basic;
                }
                field("Print Branch"; Rec."Print Branch")
                {
                    ApplicationArea = Basic;
                }
                field("Payable Location"; Rec."Payable Location")
                {
                    ApplicationArea = Basic;
                }
                field("Instrument Date"; Rec."Instrument Date")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 1"; Rec."Payment Details 1")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 2"; Rec."Payment Details 2")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 3"; Rec."Payment Details 3")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 4"; Rec."Payment Details 4")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 5"; Rec."Payment Details 5")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 6"; Rec."Payment Details 6")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 7"; Rec."Payment Details 7")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 8"; Rec."Payment Details 8")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 9"; Rec."Payment Details 9")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 10"; Rec."Payment Details 10")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 11"; Rec."Payment Details 11")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 12"; Rec."Payment Details 12")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 13"; Rec."Payment Details 13")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 14"; Rec."Payment Details 14")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 15"; Rec."Payment Details 15")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 16"; Rec."Payment Details 16")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 17"; Rec."Payment Details 17")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 18"; Rec."Payment Details 18")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 19"; Rec."Payment Details 19")
                {
                    ApplicationArea = Basic;
                }
                field("Additional Info 99"; Rec."Additional Info 99")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("Phone No"; Rec."Phone No")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Get Bank Ledger Entries")
            {
                ApplicationArea = Basic;
                Caption = '&Get Bank Ledger Entries';
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    LCPgBankLedgerEntriesCopy: Page "Bank Ledger Entries Copy-New";
                    LCRecBankLedgerEntries: Record "Bank Account Ledger Entry";
                begin
                    LCRecBankLedgerEntries.SetRange("Bank Account No.", GlbBankAccountNo);
                    LCRecBankLedgerEntries.SetRange("Document Type", LCRecBankLedgerEntries."document type"::Payment);
                    LCRecBankLedgerEntries.SetFilter(Amount, '<%1', 0);
                    LCRecBankLedgerEntries.SetRange("PayPro Entry Exit", false);
                    LCPgBankLedgerEntriesCopy.SetTableview(LCRecBankLedgerEntries);
                    LCPgBankLedgerEntriesCopy.FnSetBankAccountNo(GlbBankAccountNo);
                    LCPgBankLedgerEntriesCopy.FunSetPayProFlag(true);
                    //LCPgBankLedgerEntriesCopy.LOOKUPMODE:=TRUE;
                    LCPgBankLedgerEntriesCopy.RunModal;
                end;
            }
            action("&Export to Excel")
            {
                ApplicationArea = Basic;
                Caption = '&Export to Excel';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    LCRecPayProEntries: Record "Bank Pay Pro Entries-New";
                begin
                    if not Confirm('Do you want to export to excel?') then
                        Error('');
                    GlbRecExcelBufferTemp.DeleteAll;
                    CurrPage.SetSelectionFilter(LCRecPayProEntries);

                    if LCRecPayProEntries.FindSet then begin
                        //FnCreateExcelHeader;
                        repeat
                            FnCreateExcelBody(LCRecPayProEntries);
                            LCRecPayProEntries."Exported to File" := true;
                            LCRecPayProEntries.Modify;
                        until LCRecPayProEntries.Next = 0;
                        GlbRecExcelBufferTemp.Reset();
                        //  GlbRecExcelBufferTemp.CreateBookAndOpenExcel('', 'sheet1', '', '', UserId);
                        GlbRecExcelBufferTemp.CreateNewBook('sheet1');
                        GlbRecExcelBufferTemp.WriteSheet('sheet1', CompanyName, UserId);
                        GlbRecExcelBufferTemp.CloseBook();
                        GlbRecExcelBufferTemp.OpenExcel();
                        Message('%1', 'Process complete');
                    end
                    else
                        Error('Nothing to export');
                end;
            }
            action("&Export Payment Instruction File")
            {
                ApplicationArea = Basic;
                Caption = '&Export Payment Instruction File';
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    LCRecVendorLedgerEntryTemp: Record "Vendor Ledger Entry" temporary;
                    LCRecVendorLedgerEntry: Record "Vendor Ledger Entry";
                    LCTaxAmt: Decimal;
                    LCPayType: Text[4];
                    LCLineAmount: Decimal;
                    LCRecBankAccount: Record "Bank Account";
                    RawText: BigText;
                    Instrm: InStream;
                    outstrm: OutStream;
                    JObject: JsonObject;
                    Body: Text;
                    base64Txt: Text;
                    Base64: Codeunit "Base64 Convert";
                    FileName: Text;
                    httpclint: HttpClient;
                    HttpContnt: HttpContent;
                    Url: Text;
                    Json: Text;
                    HttpResponseMsg: HttpResponseMessage;
                    HttpHdr: HttpHeaders;
                    ApiResult: Text;
                    purchSetup: Record "Purchases & Payables Setup";
                    tempblob: Codeunit "Temp Blob";
                begin
                    if not Confirm('Do you want export PayProEntries?') then
                        Error('');
                    Clear(GlbFile);
                    purchSetup.Get();
                    GeneralLedgerSetup.Get;
                    Nos := NoSeriesManagement.GetNextNo(GeneralLedgerSetup."Bank Pay Pro File Nos.", Today, true);


                    FileAddin1 := Format(Time);
                    FileAddin1 := DelChr(FileAddin1, '=', ' ');
                    FileAddin1 := DelChr(FileAddin1, '=', ':');
                    FileAddin1 := DelChr(FileAddin1, '=', 'A');
                    FileAddin1 := DelChr(FileAddin1, '=', 'P');
                    FileAddin1 := DelChr(FileAddin1, '=', 'M');


                    FileAddin := Format(Date2dmy(Today, 1)) + Format(Date2dmy(Today, 2)) + Format(Date2dmy(Today, 3)) + FileAddin1;


                    //GlbFilePath := 'D:\CCIT\PayProEntries\AUXIFIN_AUXIFINVENDUPLDAUTO_' + FileAddin + '_' + Nos + '.txt';
                    FileName := 'AUXIFIN_AUXIFINVENDUPLDAUTO_' + FileAddin + '_' + Nos + '.txt';
                    // if FILE.Exists(GlbFilePath) then
                    //     FILE.Erase(GlbFilePath);

                    // GlbFile.TextMode(true);
                    // GlbFile.WriteMode(true);
                    // GlbFile.Create(GlbFilePath);
                    // GlbFile.Close;
                    // GlbFile.Open(GlbFilePath);
                    if rec.FindSet then begin
                        repeat
                            ValueDate := GetDate(Rec."Value Date", 1) + '-' + GetDate(Rec."Value Date", 2) + '-' + GetDate(Rec."Value Date", 3);//CCIT-Vikas 27012022

                            RawText.AddText(rec."Payment Method identifier" + '^' + DelChr(Format(rec.Amount), '=', ',') + '^' + ValueDate + '^' + rec."Beneficiary Name" + '^' + rec."External Document No." + '^' + rec."Beneficiary Address 1" +
                            '^' + rec."Beneficiary Address 2" + '^' + rec."Beneficiary Address 3" + '^' + rec."Beneficiary State" + '^' + rec."PIN Code" + '^' + rec."Bene Account Number" + '^' + rec."Email ID of beneficiary" +
                            '^' + rec."Email Body" + '^' + rec."Debit Account Number" + '^' + rec."CRN (Narration  / Remarks)" + '^' + rec."Receiver IFSC" + '^' + Format(rec."Receiver A/c type") + '^' + rec."Print Branch" +
                            '^' + rec."Payable Location" + '^' + Format(rec."Instrument Date") + '^' + rec."Payment Details 1" + '^' + rec."Payment Details 2" + '^' + rec."Payment Details 3" + '^' + rec."Payment Details 4" +
                            '^' + rec."Payment Details 5" + '^' + rec."Payment Details 6" + '^' + rec."Payment Details 7" + '^' + rec."Payment Details 8" + '^' + rec."Payment Details 9" + '^' + rec."Payment Details 10" +
                            '^' + rec."Payment Details 11" + '^' + rec."Payment Details 12" + '^' + rec."Payment Details 13" + '^' + rec."Payment Details 14" + '^' + rec."Payment Details 15" + '^' + rec."Payment Details 16" +
                            '^' + rec."Payment Details 17" + '^' + rec."Payment Details 18" + '^' + rec."Payment Details 19" + '^' + rec."Additional Info 99" + '^' + rec.Remarks + '^' + rec."Phone No");

                            rec."Exported to File" := true;
                            rec.Modify;
                        //"Export File Name":=GlbFilePath;
                        until rec.Next = 0;
                        //GlbFile.Close;
                    end;

                    tempblob.CreateOutStream(outstrm);
                    //RawText.Read(Instrm);
                    RawText.Write(outstrm);
                    tempblob.CreateInStream(Instrm);
                    DownloadFromStream(Instrm, '', '', '', FileName);
                    base64Txt := Base64.ToBase64(Instrm);
                    //remotePath := '/home/snorkel/ICICI/PayUpload/';
                    //localPath := GlbFilePath;
                    //ICICI1018210122PM
                    fileMask := '*.txt';
                    //logFile := 'D:\SFTPLOGFILE';
                    //MoveFileNavToSFTP.SFTP_GetFilesList(9746, '10.21.10.232', 'snorkel', '', remotePath, localPath, fileMask, logFile);
                    JObject.Add('base64', base64Txt);
                    JObject.Add('fileName', FileName);
                    JObject.Add('fileType', 'text/plain');
                    JObject.Add('fileExt', 'txt');
                    JObject.Add('hostname', purchSetup."SFTP Hostname");
                    JObject.Add('port', purchSetup."SFTP Port");
                    JObject.Add('username', purchSetup."SFTP UserName");
                    JObject.Add('password', purchSetup."SFTP Password");
                    JObject.Add('path', purchSetup."SFTP Path");

                    JObject.WriteTo(Body);
                    Url := 'https://bc2sftp3.azurewebsites.net/api/ftp';
                    HttpContnt.WriteFrom(body);
                    HttpContnt.GetHeaders(HttpHdr);
                    //HttpHdr.Add('app-name', 'Navision');
                    //HttpHdr.Add('x-token', integsetup.MiddlewareKey);
                    HttpHdr.Remove('Content-Type');
                    HttpHdr.Add('Content-Type', 'application/json');


                    if Httpclint.Post(Url, HttpContnt, HttpResponseMsg) then begin
                        HttpResponseMsg.Content.ReadAs(ApiResult);


                        Message('Process complete');

                    end;
                end;
            }
            action("&Get Bank Contra  Entries")
            {
                ApplicationArea = Basic;
                Caption = '&Get Bank Contra  Entries';
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    LCPgBankLedgerEntriesCopy: Page "Bank Ledger Entries Copy-New";
                    LCRecBankLedgerEntries: Record "Bank Account Ledger Entry";
                begin
                    LCRecBankLedgerEntries.SetRange("Bank Account No.", GlbBankAccountNo);
                    LCRecBankLedgerEntries.SetRange("Document Type", LCRecBankLedgerEntries."document type"::Payment);
                    LCRecBankLedgerEntries.SetFilter("Source Code", '=%1', 'CONTRAV');
                    LCRecBankLedgerEntries.SetFilter("Journal Batch Name", '<>%1', 'P2C');
                    LCRecBankLedgerEntries.SetFilter(Amount, '<%1', 0);
                    LCRecBankLedgerEntries.SetRange("PayPro Entry Exit", false);
                    LCPgBankLedgerEntriesCopy.SetTableview(LCRecBankLedgerEntries);
                    LCPgBankLedgerEntriesCopy.FnSetBankAccountNo(GlbBankAccountNo);
                    LCPgBankLedgerEntriesCopy.FunSetPayProFlag(true);
                    //LCPgBankLedgerEntriesCopy.LOOKUPMODE:=TRUE;
                    LCPgBankLedgerEntriesCopy.RunModal;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        LCRecBankAccount: Record "Bank Account";
    begin
        LCRecBankAccount.FindFirst;
        Rec.SetRange("Bank No", LCRecBankAccount."No.");
        GlbBankAccountNo := LCRecBankAccount."No.";
        //IF FINDFIRST THEN;
        CurrPage.Update(false);
    end;

    var
        GlbBankAccountNo: Code[20];
        GlbRecExcelBufferTemp: Record "Excel Buffer" temporary;
        GlbFilePath: Text;
        GlbFile: File;
        //v MoveFileNavToSFTP: Codeunit UnknownCodeunit1610;
        remotePath: Text;
        localPath: Text;
        fileMask: Text;
        logFile: Text;
        FileAddin: Text;
        GeneralLedgerSetup: Record "General Ledger Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Nos: Code[10];
        FileAddin1: Text;
        ValueDate: Text;
        ABSBlobClient: codeunit "ABS Blob Client";

    local procedure FnCreateExcelHeader()
    begin
        GlbRecExcelBufferTemp.AddColumn('Payment identifier', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Amount', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Value Date', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Beneficiary Name', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('External Document No.', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Beneficiary Address 1', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Beneficiary Address 2', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Beneficiary Address 3', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        //GlbRecExcelBufferTemp.AddColumn('Beneficiary City',FALSE,'',TRUE,FALSE,FALSE,'',GlbRecExcelBufferTemp."Cell Type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Beneficiary State', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('PIN Code', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Beneficiary Account Number', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Email ID of beneficiary', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Email Body', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Debit Account Number', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('CRN (Narration  / Remarks)', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Receiver IFSC', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Receiver A/c type', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Print Branch', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payable Location', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Instrument Date', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 1', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 2', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 3', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 4', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 5', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 6', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 7', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 8', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 9', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 10', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 11', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 12', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 13', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 14', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 15', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 16', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 17', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 18', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Payment Details 19', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Additional Info 99', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Remarks', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn('Phone No', false, '', true, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
    end;

    local procedure FnCreateExcelBody(var LCRecPayProEntries: Record "Bank Pay Pro Entries-New")
    begin
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Method identifier", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries.Amount, false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Number);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Value Date", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Date);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Beneficiary Name", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."External Document No.", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Beneficiary Address 1", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Beneficiary Address 2", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Beneficiary Address 3", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        //GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Beneficiary City",FALSE,'',FALSE,FALSE,FALSE,'',GlbRecExcelBufferTemp."Cell Type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Beneficiary State", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."PIN Code", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Bene Account Number", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Email ID of beneficiary", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Email Body", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Debit Account Number", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."CRN (Narration  / Remarks)", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Receiver IFSC", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Receiver A/c type", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Print Branch", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payable Location", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Instrument Date", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Date);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 1", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 2", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 3", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 4", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 5", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 6", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 7", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 8", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 9", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 10", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 11", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 12", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 13", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 14", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 15", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 16", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 17", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 18", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Payment Details 19", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Additional Info 99", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries.Remarks, false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Text);
        GlbRecExcelBufferTemp.AddColumn(LCRecPayProEntries."Phone No", false, '', false, false, false, '', GlbRecExcelBufferTemp."cell type"::Number);
        GlbRecExcelBufferTemp.NewRow;
    end;

    local procedure GetDate(ValueDate: Date; Pos: Integer): Text
    begin

        if (StrLen(Format(Date2dmy(ValueDate, Pos))) = 2) or (StrLen(Format(Date2dmy(ValueDate, Pos))) = 4) then
            exit(Format(Date2dmy(ValueDate, Pos)))
        else
            exit('0' + Format(Date2dmy(ValueDate, Pos)))


    end;
}

