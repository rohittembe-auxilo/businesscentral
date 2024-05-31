Report 50101 "Posted Voucher Auto Payment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PostedVoucherAutoPayment.rdl';
    Caption = 'Posted Voucher';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = sorting("Document No.", "Posting Date", Amount) order(descending) where("Source Code" = filter(<> 'UNAPPPURCH'));
            RequestFilterFields = "Posting Date", "Document No.";
            column(ReportForNavId_7069; 7069)
            {
            }
            column(VoucherSourceDesc; SourceDesc + ' Voucher')
            {
            }
            column(VendInvNo; VendInvNo)
            {
            }
            column(DocumentNo_GLEntry; "Document No.")
            {
            }
            column(PostingDateFormatted; 'Date: ' + Format("Posting Date"))
            {
            }
            column(CmpAddress; CmpAddress + ' ' + CmpAddress2 + ' ' + CmpCity)
            {
            }
            column(CmpName; CmpName)
            {
            }
            column(CreditAmount_GLEntry; "Credit Amount")
            {
            }
            column(DebitAmount_GLEntry; "Debit Amount")
            {
            }
            column(DrText; DrText)
            {
            }
            column(GLAccName; GLAccName)
            {
            }
            column(CrText; CrText)
            {
            }
            column(DebitAmountTotal; DebitAmountTotal)
            {
            }
            column(CreditAmountTotal; CreditAmountTotal)
            {
            }
            column(ChequeDetail; 'Cheque No: ' + ChequeNo + '  Dated: ' + Format(ChequeDate))
            {
            }
            column(ChequeNo; ChequeNo)
            {
            }
            column(ChequeDate; ChequeDate)
            {
            }
            column(RsNumberText1NumberText2; 'Rs. ' + NumberText[1] + ' ' + NumberText[2])
            {
            }
            column(EntryNo_GLEntry; "Entry No.")
            {
            }
            column(PostingDate_GLEntry; "Posting Date")
            {
            }
            column(TransactionNo_GLEntry; "Transaction No.")
            {
            }
            column(VoucherNoCaption; VoucherNoCaptionLbl)
            {
            }
            column(CreditAmountCaption; CreditAmountCaptionLbl)
            {
            }
            column(DebitAmountCaption; DebitAmountCaptionLbl)
            {
            }
            column(ParticularsCaption; ParticularsCaptionLbl)
            {
            }
            column(AmountInWordsCaption; AmountInWordsCaptionLbl)
            {
            }
            column(PreparedByCaption; PreparedByCaptionLbl)
            {
            }
            column(CheckedByCaption; CheckedByCaptionLbl)
            {
            }
            column(ApprovedByCaption; ApprovedByCaptionLbl)
            {
            }
            column(GLaccno; "G/L Account No.")
            {
            }
            column(sourceno; sourceno)
            {
            }
            column(vendAccount; vendAccount)
            {
            }
            column(vendifsc; vendIFSC)
            {
            }
            column(bankname; vendbankname)
            {
            }
            column(vledoctype; vledoctype)
            {
            }
            column(AppliedEntry; AppliedDocNo)
            {
            }
            column(Comments; Comments)
            {
            }
            column(username; users."User Name")
            {
            }
            column(ApproverName; ApproverName)
            {
            }
            column(PC; PrintCreator)
            {
            }
            dataitem("Purch. Comment Line"; "Purch. Comment Line")
            {
                DataItemLink = "No." = field("Document No.");
                column(ReportForNavId_1000000003; 1000000003)
                {
                }
                column(Comment; Comment)
                {
                }
            }
            dataitem(LineNarration; "Posted Narration")
            {
                DataItemLink = "Transaction No." = field("Transaction No."), "Entry No." = field("Entry No.");
                DataItemTableView = sorting("Entry No.", "Transaction No.", "Line No.");
                column(ReportForNavId_3384; 3384)
                {
                }
                column(Narration_LineNarration; Narration)
                {
                }
                column(PrintLineNarration; PrintLineNarration)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if PrintLineNarration then begin
                        PageLoop := PageLoop - 1;
                        LinesPrinted := LinesPrinted + 1;
                    end;
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_5444; 5444)
                {
                }
                column(IntegerOccurcesCaption; IntegerOccurcesCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    PageLoop := PageLoop - 1;
                end;

                trigger OnPreDataItem()
                begin
                    GLEntry.SetCurrentkey("Document No.", "Posting Date", Amount);
                    GLEntry.Ascending(false);
                    GLEntry.SetRange("Posting Date", "G/L Entry"."Posting Date");
                    GLEntry.SetRange("Document No.", "G/L Entry"."Document No.");
                    GLEntry.FindLast;
                    if not (GLEntry."Entry No." = "G/L Entry"."Entry No.") then
                        CurrReport.Break;

                    SetRange(Number, 1, PageLoop)
                end;
            }
            dataitem(PostedNarration1; "Posted Narration")
            {
                DataItemLink = "Transaction No." = field("Transaction No.");
                DataItemTableView = sorting("Entry No.", "Transaction No.", "Line No.") where("Entry No." = filter(0));
                column(ReportForNavId_2156; 2156)
                {
                }
                column(Narration_PostedNarration1; Narration)
                {
                }
                column(NarrationCaption; NarrationCaptionLbl)
                {
                }

                trigger OnPreDataItem()
                begin
                    GLEntry.SetCurrentkey("Document No.", "Posting Date", Amount);
                    GLEntry.Ascending(false);
                    GLEntry.SetRange("Posting Date", "G/L Entry"."Posting Date");
                    GLEntry.SetRange("Document No.", "G/L Entry"."Document No.");
                    GLEntry.FindLast;
                    if not (GLEntry."Entry No." = "G/L Entry"."Entry No.") then
                        CurrReport.Break;
                end;
            }

            trigger OnAfterGetRecord()
            var
                VLE: Record "Vendor Ledger Entry";
                Vend: Record Vendor;
                CLE: Record "Cust. Ledger Entry";
                RecCustomer: Record Customer;
                VLE2: Record "Vendor Ledger Entry";
                LCVenLedEntry: Record "Vendor Ledger Entry";
                AppliedInvNo: Code[20];
                LCRecPurchInv: Record "Purch. Inv. Header";
                VLE3: Record "Vendor Ledger Entry";
            begin

                Comp_info.SetFilter("From Date", '<=%1', "G/L Entry"."Posting Date");
                Comp_info.SetFilter("To Date", '>=%1', "G/L Entry"."Posting Date");
                if Comp_info.FindFirst then begin
                    CmpAddress := Comp_info.Address;
                    CmpAddress2 := Comp_info."Address 2";
                    CmpCity := Comp_info.City;
                    CmpName := Comp_info.Name;
                end;
                Comments := '';
                AppliedDocNo := '';
                /*VLE.RESET();
                VLE.SETRANGE("Document No.","Document No.");
                VLE.SETRANGE("Document Type",VLE."Document Type"::Payment);
                IF VLE.FIND('-') THEN BEGIN
                  Comments := VLE.Comment;
                  IF VLE."Closed by Entry No." =0 THEN BEGIN
                      VLE2.RESET();
                      VLE2.SETRANGE("Closed by Entry No.",VLE."Entry No.");
                      IF VLE2.FIND('-') THEN REPEAT
                         AppliedDocNo :=  AppliedDocNo +VLE2."Document No."+'   ';
                        UNTIL VLE2.NEXT=0;
                    END ELSE BEGIN
                       VLE2.RESET();
                       VLE2.SETRANGE("Entry No.",VLE."Closed by Entry No.");
                       IF VLE2.FIND('-') THEN REPEAT
                          AppliedDocNo :=  AppliedDocNo +VLE2."Document No."+'   ';
                         UNTIL VLE2.NEXT=0;
                
                      END;
                
                  IF Vend.GET(VLE."Vendor No.") THEN BEGIN
                     IF Vend."GST Vendor Type" = Vend."GST Vendor Type"::Unregistered THEN BEGIN
                       IF "G/L Entry"."Bal. Account Type" = "G/L Entry"."Bal. Account Type"::"G/L Account" THEN
                          CurrReport.SKIP;
                       END;
                    END;
                  END;
                
                VLE.RESET();
                VLE.SETRANGE("Document No.","Document No.");
                VLE.SETRANGE("Document Type",VLE."Document Type"::Invoice);
                IF VLE.FIND('-') THEN BEGIN
                  IF VLE."Closed by Entry No." <> 0 THEN BEGIN
                    VLE2.RESET();
                    VLE2.SETRANGE("Entry No.",VLE."Closed by Entry No.");
                    IF VLE2.FIND('-') THEN
                       AppliedDocNo := AppliedDocNo + VLE2."Document No." +'  ';
                
                
                    END ELSE BEGIN
                     VLE2.RESET();
                     VLE2.SETRANGE("Closed by Entry No.",VLE."Entry No.");
                     IF VLE2.FIND('-') THEN BEGIN
                       AppliedDocNo := AppliedDocNo + VLE2."Document No." +'  ';
                
                    END;
                   END;
                 END;
                */
                //CCIT AN 23122022

                VLE.Reset();
                VLE.SetRange("Document No.", "Document No.");
                VLE.SetRange("Vendor No.", "G/L Entry"."Source No."); // ."Vendor No.");
                if VLE.Find('-') then begin
                    RECDetldLedgerEntry.Reset();
                    RECDetldLedgerEntry.SetRange(RECDetldLedgerEntry."Document No.", VLE."Document No."); //"Vendor Ledger Entry"."Document No.");
                    RECDetldLedgerEntry.SetRange("Entry Type", RECDetldLedgerEntry."entry type"::Application);
                    if RECDetldLedgerEntry.Find('-') then begin
                        repeat
                            RECDetldLedgerEntry1.Reset();
                            RECDetldLedgerEntry1.SetRange(RECDetldLedgerEntry1."Vendor Ledger Entry No.", RECDetldLedgerEntry."Vendor Ledger Entry No.");
                            RECDetldLedgerEntry1.SetFilter(RECDetldLedgerEntry1."Document Type", '<>%1', RECDetldLedgerEntry1."document type"::Payment);
                            if RECDetldLedgerEntry1.FindFirst() then begin
                                AppliedDocNo := RECDetldLedgerEntry1."Document No.";//AppDocumentNo:=RECDetldLedgerEntry1."Document No.";
                            end;
                        until RECDetldLedgerEntry.Next = 0;
                    end;
                end;

                //CCIT AN

                /*
                CLE.RESET();
                CLE.SETRANGE("Document No.","Document No.");
                IF CLE.FIND('-') THEN BEGIN
                  IF RecCustomer.GET(CLE."Customer No.") THEN BEGIN
                     IF RecCustomer."GST Customer Type" = RecCustomer."GST Customer Type"::Unregistered THEN BEGIN
                       IF "G/L Entry"."Bal. Account Type" = "G/L Entry"."Bal. Account Type"::"G/L Account" THEN
                          CurrReport.SKIP;
                       END;
                    END;
                  END;
                //CCIT Vikas
                */
                //CCIT-PRI
                Clear(VendInvNo);
                RecPurchInvHdr.Reset;
                RecPurchInvHdr.SetRange(RecPurchInvHdr."No.", "G/L Entry"."Document No.");
                if RecPurchInvHdr.FindFirst then
                    VendInvNo := RecPurchInvHdr."Vendor Invoice No.";
                //CCIT-PRI
                if VendInvNo = '' then
                    VendInvNo := "G/L Entry"."External Document No.";

                GLAccName := FindGLAccName("Source Type", "Entry No.", "Source No.", "G/L Account No.");
                if Amount < 0 then begin
                    CrText := 'To';
                    DrText := '';
                end else begin
                    CrText := '';
                    DrText := 'Dr';
                end;

                SourceDesc := '';
                if "Source Code" <> '' then begin
                    SourceCode.Get("Source Code");
                    SourceDesc := 'Purchase / Payment';  //'Invoice/'+SourceCode.Description;
                end;

                PageLoop := PageLoop - 1;
                LinesPrinted := LinesPrinted + 1;

                ChequeNo := '';
                ChequeDate := 0D;
                if ("Source No." <> '') and ("Source Type" = "source type"::"Bank Account") then begin
                    if BankAccLedgEntry.Get("Entry No.") then begin
                        ChequeNo := BankAccLedgEntry."Cheque No.";
                        ChequeDate := BankAccLedgEntry."Cheque Date";
                    end;
                end;

                if (ChequeNo <> '') and (ChequeDate <> 0D) then begin
                    PageLoop := PageLoop - 1;
                    LinesPrinted := LinesPrinted + 1;
                end;
                if PostingDate <> "Posting Date" then begin
                    PostingDate := "Posting Date";
                    TotalDebitAmt := 0;
                end;
                if DocumentNo <> "Document No." then begin
                    DocumentNo := "Document No.";
                    TotalDebitAmt := 0;
                end;

                if PostingDate = "Posting Date" then begin
                    InitTextVariable;
                    TotalDebitAmt += "Debit Amount";
                    FormatNoText(NumberText, Abs(TotalDebitAmt), '');
                    PageLoop := NUMLines;
                    LinesPrinted := 0;
                end;
                if (PrePostingDate <> "Posting Date") or (PreDocumentNo <> "Document No.") then begin
                    DebitAmountTotal := 0;
                    CreditAmountTotal := 0;
                    PrePostingDate := "Posting Date";
                    PreDocumentNo := "Document No.";
                end;

                DebitAmountTotal := DebitAmountTotal + "Debit Amount";
                CreditAmountTotal := CreditAmountTotal + "Credit Amount";
                //CCIT-Vikas
                /*vledoctype := '';
                recVLE.SETRANGE("Document Type",recVLE."Document Type"::Payment);
                recVLE.SETRANGE("Document No.","Document No.");
                IF recVLE.FIND('-') THEN BEGIN
                   vledoctype := 'Payment';
                 IF  recvend.GET(recVLE."Vendor No.") THEN BEGIN
                  recvendacc.SETRANGE("Vendor No.",recvend."No.");
                //   recvendacc.SETRANGE(Code,recVLE."Recipient Bank Account");
                  IF recvendacc.FIND('-') THEN BEGIN
                    vendAccount:= recvendacc."Bank Account No.";
                    vendIFSC   := recvendacc.IFSC;
                    vendbankname:= recvendacc.Name;
                
                    END;
                   END;
                  END;
                  */
                //CCIT AN 05012023 Address Change from PPI VLE OR VEND BANK ACC++
                vledoctype := '';
                Clear(vendAccount);
                Clear(vendbankname);
                Clear(vendIFSC);

                recVLE.SetRange("Document Type", recVLE."document type"::Payment);
                recVLE.SetRange("Document No.", "Document No.");
                //recVLE.SETFILTER("Closed by Entry No.",'<>%1',0);
                if recVLE.Find('-') then begin
                    vledoctype := 'Payment';
                    VLE2.Reset();
                    VLE2.SetRange("Document No.", recVLE."Document No.");
                    VLE2.SetFilter("Closed by Entry No.", '<>%1', 0);
                    if VLE2.Find('-') then begin
                        LCRecPurchInv.Reset();
                        LCRecPurchInv.SetRange("No.", VLE2."Document No.");    //G/L Entry"."Document No.");
                        if LCRecPurchInv.FindFirst then begin
                            vendAccount := LCRecPurchInv."Bank Account No.";
                            vendIFSC := LCRecPurchInv."Bank Account IFSC";
                            vendbankname := LCRecPurchInv."Bank Account Name";
                            VendBankEmail := LCRecPurchInv."Bank Account Email";
                        end;  // END;
                    end
                    else begin
                        //recVLE.SETRANGE("Document Type",recVLE."Document Type"::Payment);
                        if recvend.Get(recVLE."Vendor No.") then begin
                            recvendacc.SetRange("Vendor No.", recvend."No.");
                            recvendacc.SetRange(Code, recVLE."Recipient Bank Account");
                            if recvendacc.Find('-') then begin
                                vendAccount := recvendacc."Bank Account No.";
                                vendIFSC := recvendacc.IFSC;
                                vendbankname := recvendacc.Name;
                            end;
                        end;
                    end;
                end;
                //ELSE BEGIN
                LCRecPurchInv.Reset();
                LCRecPurchInv.SetRange("No.", "G/L Entry"."Document No.");
                if LCRecPurchInv.FindFirst then begin
                    vendAccount := LCRecPurchInv."Bank Account No.";
                    vendIFSC := LCRecPurchInv."Bank Account IFSC";
                    vendbankname := LCRecPurchInv."Bank Account Name";
                    VendBankEmail := LCRecPurchInv."Bank Account Email";
                    //MESSAGE('%1%2%3%4 Bank Details from PPI',vendAccount,vendIFSC,vendbankname,VendBankEmail);
                end;
                //END;
                //CCIT AN 05012023 Address Change from PPI OR VEND BANK ACC--
                /*
                                users.Reset();
                                users.SetRange("User Name", UserIDFilter);
                                if users.Find('-') then;


                                if users."User Code" = '' then begin
                                    users.Reset();
                                    users.SetRange("Old User ID", UserIDFilter);
                                    if users.Find('-') then;
                                end;




                                ApproverName := '';
                                PostedApprovedEntry.Reset();
                                PostedApprovedEntry.SetRange(Status, PostedApprovedEntry.Status::Approved);
                                PostedApprovedEntry.SetRange("Document No.", "G/L Entry"."Document No.");
                                PostedApprovedEntry.SetFilter("Approver ID", '<>%1', "G/L Entry"."User ID");
                                if PostedApprovedEntry.FindLast then begin
                                    users1.Reset();
                                    users1.SetRange("User Name", PostedApprovedEntry."Approver ID");
                                    if users1.Find('-') then
                                        ApproverName := users1."User Code";

                                    if ApproverName = '' then begin
                                        users1.Reset();
                                        users1.SetRange("Old User ID", PostedApprovedEntry."Approver ID");
                                        if users1.Find('-') then
                                            ApproverName := users1."User Code";

                                    end;

                                end;
                                if ApproverName = '' then begin
                                    // IF Reversed = TRUE THEN BEGIN
                                    if ApproverName = '' then begin
                                        if AppravalSetup.Get("User ID") then begin
                                            users1.Reset();
                                            users1.SetRange("User Name", AppravalSetup."Approver ID");
                                            if users1.Find('-') then
                                                ApproverName := users1."User Code";
                                        end;
                                        if ApproverName = '' then begin
                                            users1.Reset();
                                            users1.SetRange("Old User ID", AppravalSetup."Approver ID");
                                            if users1.Find('-') then
                                                ApproverName := users1."User Code";

                                        end;
                                    end;
                                    if (ApproverName = '') and ("Approver ID" <> '') then begin
                                        users1.Reset();
                                        users1.SetRange("User Name", "Approver ID");
                                        if users1.Find('-') then
                                            ApproverName := users1."User Code";
                                    end;
                                    if ApproverName = '' then begin
                                        users1.Reset();
                                        users1.SetRange("Old User ID", "Approver ID");
                                        if users1.Find('-') then
                                            ApproverName := users1."User Code";

                                    end;
                                end;

                                */

                if ("G/L Entry".Comment <> '') and (Comments = '') then
                    Comments := "G/L Entry".Comment;

            end;

            trigger OnPreDataItem()
            begin
                NUMLines := 13;
                PageLoop := NUMLines;
                LinesPrinted := 0;
                DebitAmountTotal := 0;
                CreditAmountTotal := 0;
                AppliedDocNo := '';

                //Comp_info.GET;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintLineNarration; PrintLineNarration)
                    {
                        ApplicationArea = Basic;
                        Caption = 'PrintLineNarration';
                    }
                    field(PrintCreator; PrintCreator)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Prepaired By & Approved By';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            PrintLineNarration := true;
            PrintCreator := true;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        //CompanyInformation.GET;
    end;

    var
        CompanyInformation: Record "Company Information";
        Comp_info: Record "Company Information2";
        SourceCode: Record "Source Code";
        GLEntry: Record "G/L Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        GLAccName: Text[50];
        SourceDesc: Text[50];
        CrText: Text[2];
        DrText: Text[2];
        NumberText: array[2] of Text[80];
        PageLoop: Integer;
        LinesPrinted: Integer;
        NUMLines: Integer;
        ChequeNo: Code[50];
        ChequeDate: Date;
        Text16526: label 'ZERO';
        Text16527: label 'HUNDRED';
        Text16528: label 'AND';
        Text16529: label '%1 results in a written number that is too long.';
        Text16532: label 'ONE';
        Text16533: label 'TWO';
        Text16534: label 'THREE';
        Text16535: label 'FOUR';
        Text16536: label 'FIVE';
        Text16537: label 'SIX';
        Text16538: label 'SEVEN';
        Text16539: label 'EIGHT';
        Text16540: label 'NINE';
        Text16541: label 'TEN';
        Text16542: label 'ELEVEN';
        Text16543: label 'TWELVE';
        Text16544: label 'THIRTEEN';
        Text16545: label 'FOURTEEN';
        Text16546: label 'FIFTEEN';
        Text16547: label 'SIXTEEN';
        Text16548: label 'SEVENTEEN';
        Text16549: label 'EIGHTEEN';
        Text16550: label 'NINETEEN';
        Text16551: label 'TWENTY';
        Text16552: label 'THIRTY';
        Text16553: label 'FORTY';
        Text16554: label 'FIFTY';
        Text16555: label 'SIXTY';
        Text16556: label 'SEVENTY';
        Text16557: label 'EIGHTY';
        Text16558: label 'NINETY';
        Text16559: label 'THOUSAND';
        Text16560: label 'MILLION';
        Text16561: label 'BILLION';
        Text16562: label 'LAKH';
        Text16563: label 'CRORE';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        PrintLineNarration: Boolean;
        PostingDate: Date;
        TotalDebitAmt: Decimal;
        DocumentNo: Code[20];
        DebitAmountTotal: Decimal;
        CreditAmountTotal: Decimal;
        PrePostingDate: Date;
        PreDocumentNo: Code[50];
        VoucherNoCaptionLbl: label 'Voucher No. :';
        CreditAmountCaptionLbl: label 'Credit Amount';
        DebitAmountCaptionLbl: label 'Debit Amount';
        ParticularsCaptionLbl: label 'Particulars';
        AmountInWordsCaptionLbl: label 'Amount (in words):';
        PreparedByCaptionLbl: label 'Prepared by:';
        CheckedByCaptionLbl: label 'Checked by:';
        ApprovedByCaptionLbl: label 'Approved by:';
        IntegerOccurcesCaptionLbl: label 'IntegerOccurces';
        NarrationCaptionLbl: label 'Narration :';
        RecPurchInvHdr: Record "Purch. Inv. Header";
        VendInvNo: Code[50];
        sourceno: Code[20];
        recVLE: Record "Vendor Ledger Entry";
        recvend: Record Vendor;
        recvendacc: Record "Vendor Bank Account";
        vendAccount: Text;
        vendIFSC: Text;
        vendbankname: Text;
        vledoctype: Text;
        AppliedDocNo: Text;
        Comments: Text[250];
        PrintCreator: Boolean;
        CreatorName: Text;
        ApproverName: Text;
        users: Record User;
        ApprovalEntry: Record "Approval Entry";
        users1: Record User;
        PostedApprovedEntry: Record "Posted Approval Entry";
        UserIDFilter: Text;
        DocNoFilter: Text;
        PostingDatefilter: Date;
        AppravalSetup: Record "User Setup";
        ApproverIdfilter: Text;
        DVLE: Record "Detailed Vendor Ledg. Entry";
        DVLE2: Record "Detailed Vendor Ledg. Entry";
        GLE: Record "G/L Entry";
        RECDetldLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        RECDetldLedgerEntry1: Record "Detailed Vendor Ledg. Entry";
        VendBankEmail: Text;
        CmpAddress: Text;
        CmpAddress2: Text;
        CmpCity: Text;
        CmpName: Text;


    procedure FindGLAccName("Source Type": Option " ",Customer,Vendor,"Bank Account","Fixed Asset"; "Entry No.": Integer; "Source No.": Code[20]; "G/L Account No.": Code[20]): Text[50]
    var
        AccName: Text[50];
        VendLedgerEntry: Record "Vendor Ledger Entry";
        Vend: Record Vendor;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        Bank: Record "Bank Account";
        GLAccount: Record "G/L Account";
    begin
        sourceno := '';
        if "Source Type" = "source type"::Vendor then
            if VendLedgerEntry.Get("Entry No.") then
                if IsGSTDocument(VendLedgerEntry."Document Type", VendLedgerEntry."Document No.") then begin
                    Vend.Get("Source No.");
                    AccName := Vend.Name;
                    if "G/L Account No." in ['1010606', '10106065', '10106063', '10106064', '10106061', '10103004', '1010606', '10106062'] then
                        sourceno := Vend."No."; //CCIT-V

                end else begin
                    Vend.Get("Source No.");
                    AccName := Vend.Name;
                    if "G/L Account No." in ['1010606', '10106065', '10106063', '10106064', '10106061', '10103004', '1010606', '10106062'] then
                        sourceno := Vend."No.";//CCIT-V
                end
            else begin
                GLAccount.Get("G/L Account No.");
                AccName := GLAccount.Name;
            end
        else
            if "Source Type" = "source type"::Customer then
                if CustLedgerEntry.Get("Entry No.") then
                    if IsGSTDocument(CustLedgerEntry."Document Type", CustLedgerEntry."Document No.") then begin
                        GLAccount.Get("G/L Account No.");
                        AccName := GLAccount.Name;
                        // sourceno := GLAccount."No.";//CCIT-V
                        Cust.Get("Source No.");
                        if "G/L Account No." in ['20105202', '20105203', '20105204', '20105201', '20105205'] then
                            sourceno := Cust."No.";
                    end else begin
                        Cust.Get("Source No.");
                        AccName := Cust.Name;

                        if "G/L Account No." in ['20105202', '20105203', '20105204', '20105201', '20105205'] then
                            sourceno := Cust."No.";
                    end
                else begin
                    GLAccount.Get("G/L Account No.");
                    AccName := GLAccount.Name;
                    // Cust.GET("Source No.");
                    //      IF "G/L Account No." IN ['20105202','20105203','20105204','20105201','20105205'] THEN
                    //         sourceno := Cust."No.";
                end
            else if "Source Type" = "source type"::"Bank Account" then
                if BankLedgerEntry.Get("Entry No.") then begin
                    Bank.Get("Source No.");
                    AccName := Bank.Name;
                    //  sourceno := "Source No." //CCIT-V
                end else begin
                    GLAccount.Get("G/L Account No.");
                    AccName := GLAccount.Name;
                    //  sourceno := GLAccount."No.";//CCIT-V
                end
            else begin
                GLAccount.Get("G/L Account No.");
                AccName := GLAccount.Name;
                sourceno := GLAccount."No.";//CCIT-V
            end;

        if "Source Type" = "source type"::" " then begin
            GLAccount.Get("G/L Account No.");
            AccName := GLAccount.Name;
            // sourceno := GLAccount."No.";//CCIT-V
        end;

        exit(AccName);
    end;


    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        Currency: Record Currency;
        TensDec: Integer;
        OnesDec: Integer;
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                if No > 99999 then begin
                    Ones := No DIV (Power(100, Exponent - 1) * 10);
                    Hundreds := 0;
                end else begin
                    Ones := No DIV Power(1000, Exponent - 1);
                    Hundreds := Ones DIV 100;
                end;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text16527);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                if No > 99999 then
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(100, Exponent - 1) * 10
                else
                    No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;
        end;

        if CurrencyCode <> '' then begin
            Currency.Get(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Currency."Amount Decimal Places");
        end else
            AddToNoText(NoText, NoTextIndex, PrintExponent, 'RUPEES');

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text16528);

        TensDec := ((No * 100) MOD 100) DIV 10;
        OnesDec := (No * 100) MOD 10;
        if TensDec >= 2 then begin
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
            if OnesDec > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
        end else
            if (TensDec * 10 + OnesDec) > 0 then
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
            else
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text16526);
        if (CurrencyCode <> '') then
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + Currency."Amount Decimal Places" + ' ONLY')
        else
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' PAISA ONLY');
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text16529, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;


    procedure InitTextVariable()
    begin
        OnesText[1] := Text16532;
        OnesText[2] := Text16533;
        OnesText[3] := Text16534;
        OnesText[4] := Text16535;
        OnesText[5] := Text16536;
        OnesText[6] := Text16537;
        OnesText[7] := Text16538;
        OnesText[8] := Text16539;
        OnesText[9] := Text16540;
        OnesText[10] := Text16541;
        OnesText[11] := Text16542;
        OnesText[12] := Text16543;
        OnesText[13] := Text16544;
        OnesText[14] := Text16545;
        OnesText[15] := Text16546;
        OnesText[16] := Text16547;
        OnesText[17] := Text16548;
        OnesText[18] := Text16549;
        OnesText[19] := Text16550;

        TensText[1] := '';
        TensText[2] := Text16551;
        TensText[3] := Text16552;
        TensText[4] := Text16553;
        TensText[5] := Text16554;
        TensText[6] := Text16555;
        TensText[7] := Text16556;
        TensText[8] := Text16557;
        TensText[9] := Text16558;

        ExponentText[1] := '';
        ExponentText[2] := Text16559;
        ExponentText[3] := Text16562;
        ExponentText[4] := Text16563;
    end;


    procedure IsGSTDocument(DocumentType: Option; DocumentNo: Code[20]): Boolean
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        DetailedGSTLedgerEntry.SetRange("Document No.", DocumentNo);
        if DetailedGSTLedgerEntry.FindFirst then
            exit(true);
        DetailedGSTLedgerEntry.SetRange("Document No.");
        DetailedGSTLedgerEntry.SetRange("Entry Type", DetailedGSTLedgerEntry."entry type"::Application);
        DetailedGSTLedgerEntry.SetRange("Application Doc. Type", DocumentType);
        DetailedGSTLedgerEntry.SetRange("Application Doc. No", DocumentNo);
        if not DetailedGSTLedgerEntry.IsEmpty then
            exit(true);
        exit(false);
    end;


    procedure SetParameter(Useri: Text)
    begin
        UserIDFilter := Useri;
        //ApproverIdfilter := Approveri;
    end;
}

