Report 50119 "Purchase Invoice"
{
    RDLCLayout = './Layouts/PurchaseInvoice.rdl';
    DefaultLayout = RDLC;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = sorting("Vendor Invoice No.", "Posting Date") order(ascending);
            trigger OnPreDataItem();
            begin
                "Purch. Inv. Header".SetRange("Purch. Inv. Header"."Posting Date", FromDate, ToDate);
                MakeExcelDataHeader;
            end;

            trigger OnAfterGetRecord();
            begin
                MakeExcelDataBody("Purch. Inv. Header"."Buy-from Vendor No.", "Purch. Inv. Header"."No.");
            end;

            trigger OnPostDataItem();
            begin
                CreateExcelBook;
            end;

        }
    }
    requestpage
    {
        SaveValues = false;
        layout
        {
            area(Content)
            {
                field("From Date"; FromDate)
                {
                    ApplicationArea = Basic;
                }
                field("To Date"; ToDate)
                {
                    ApplicationArea = Basic;
                }
            }
        }

    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;


    end;

    trigger OnPreReport()
    begin
        ExcelBuff.DeleteAll;


    end;

    var
        ExcelBuff: Record "Excel Buffer";
        CompanyInfo: Record "Company Information";
        FromDate: Date;
        ToDate: Date;
        RecVend: Record Vendor;
        VendName: Text[100];
        RecPurchInvLine: Record "Purch. Inv. Line";
        TaxableValue: Decimal;
        CGST: Decimal;
        IGST: Decimal;
        TotalAmount: Decimal;
        TDSSections: Text[30];
        TDSPercent: Decimal;
        TDSAMt: Decimal;
        PayableAmt: Decimal;
        HSNCode: Code[20];
        GSTNo: Code[20];
        PANNo: Code[20];
        UserName: Text[20];
        ApprovalDate: Date;
        RecPurchInvCGST: Record "Purch. Inv. Line";
        RecPurchInvIGST: Record "Purch. Inv. Line";
        TDSEntry: Record "TDS Entry";
        VendGSTNo: Code[20];
        RecUserSetup: Record User;
        RecVendLedEntry: Record "Vendor Ledger Entry";
        PaymentDate: Text[1024];
        PayDocNo: Text[1024];
        VendLedgEntry: Record "Vendor Ledger Entry";
        PostedNarration: Record "Posted Narration";
        Narration: Text[1024];
        PIL: Record "Purch. Inv. Line";
        ItemDescript: Text[50];

    procedure MakeExcelDataHeader()
    var
        GSTPercentText: Text[30];
        GSTPercentDecimal: Decimal;
        CGSTPercent: Decimal;
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn('PURCHASE REGISTER', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn(CompanyInfo.Name, false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn(CompanyInfo.Address + ',' + CompanyInfo."Address 2", false, '', true, false, false, '', ExcelBuff."cell type"::Text);
        ExcelBuff.NewRow;
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn('From Date : ' + Format(FromDate) + '  To Date : ' + Format(ToDate), false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        //ExcelBuff.AddColumn('',FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuff."Cell Type"::Text);
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn('Party Code', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('Party Name', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('Invoice No.', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('Invoice Date', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('Entry Date', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('Payment Date', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('Expenses Head', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('Narration', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('Taxable Value', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('CGST', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('SGST', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('IGST', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('Total Amount', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('TDS Sections', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('TDS %', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('TDS Amount', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('Payable Amount', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('Journal Document No.', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('Payment Document No.', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('HSN/SAC Code', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('GST Number', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('PAN No.', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('User Name', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn('Approval Date', false, '', true, false, true, '', ExcelBuff."cell type"::Text);
    end;

    procedure MakeExcelDataBody(VendNo: Code[20]; DocNo: Code[20])
    var
        RecVendorLedger: Record "Vendor Ledger Entry";
        RecVend: Record Vendor;
        VendName: Text[50];
        DeleteChr: Code[20];
        GSTPercent: Decimal;
        VendPanNo: Text[50];
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        ExcelBuff.NewRow;
        ExcelBuff.AddColumn(VendNo, false, '', false, false, false, '', ExcelBuff."cell type"::Text);
        Clear(VendName);
        Clear(VendPanNo);
        Clear(VendGSTNo);
        RecVend.Reset;
        RecVend.SetRange(RecVend."No.", "Purch. Inv. Header"."Buy-from Vendor No.");
        if RecVend.FindFirst then begin
            VendName := RecVend.Name;
            VendPanNo := RecVend."P.A.N. No.";
            VendGSTNo := RecVend."GST Registration No.";
        end;
        ExcelBuff.AddColumn(VendName, false, '', false, false, false, '', ExcelBuff."cell type"::Text);
        RecVendLedEntry.Reset;
        RecVendLedEntry.SetRange(RecVendLedEntry."Document No.", DocNo);
        if RecVendLedEntry.FindFirst then begin
            Clear(PaymentDate);
            Clear(PayDocNo);
            VendLedgEntry.Reset;
            VendLedgEntry.SetRange(VendLedgEntry."Applies-to Ext. Doc. No.", RecVendLedEntry."External Document No.");
            if VendLedgEntry.FindFirst then
                repeat
                    PaymentDate := CopyStr(PaymentDate + ';' + Format(VendLedgEntry."Posting Date"), 1, 1000);

                    PayDocNo := CopyStr(PayDocNo + ';' + VendLedgEntry."Document No.", 1, 1000);
                until VendLedgEntry.Next = 0;
        end;
        Clear(ItemDescript);
        PIL.Reset;
        PIL.SetRange(PIL."Document No.", DocNo);
        if PIL.FindFirst then
            ItemDescript := PIL.Description;
        ExcelBuff.AddColumn("Purch. Inv. Header"."No.", false, '', false, false, false, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn("Purch. Inv. Header"."Document Date", false, '', false, false, false, '', ExcelBuff."cell type"::Date);
        ExcelBuff.AddColumn("Purch. Inv. Header"."Posting Date", false, '', false, false, false, '', ExcelBuff."cell type"::Date);
        PaymentDate := DelChr(PaymentDate, '<', ';');
        ExcelBuff.AddColumn(CopyStr(PaymentDate, 1, 250), false, '', false, false, false, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn(ItemDescript, false, '', false, false, false, '', ExcelBuff."cell type"::Text);
        Clear(Narration);
        PostedNarration.Reset;
        PostedNarration.SetRange(PostedNarration."Document No.", DocNo);
        if PostedNarration.FindFirst then
            repeat
                Narration := Narration + ' ' + PostedNarration.Narration
            until PostedNarration.Next = 0;
        ExcelBuff.AddColumn(Narration, false, '', false, false, false, '', ExcelBuff."cell type"::Text);
        Clear(TaxableValue);
        Clear(HSNCode);
        RecPurchInvLine.Reset;
        RecPurchInvLine.SetRange(RecPurchInvLine."Document No.", DocNo);
        if RecPurchInvLine.FindFirst then
            repeat
                TaxableValue := TaxableValue + RecPurchInvLine.Amount;
                HSNCode := RecPurchInvLine."HSN/SAC Code";
            until RecPurchInvLine.Next = 0;
        ExcelBuff.AddColumn(TaxableValue, false, '', false, false, false, '', ExcelBuff."cell type"::Number);
        Clear(CGST);
        RecPurchInvCGST.Reset;
        RecPurchInvCGST.SetRange(RecPurchInvCGST."Document No.", DocNo);
        RecPurchInvCGST.SetRange(RecPurchInvCGST."GST Jurisdiction Type", RecPurchInvCGST."gst jurisdiction type"::Intrastate);
        if RecPurchInvCGST.FindFirst then
            repeat
                //  CGST := CGST//v(RecPurchInvCGST."Total GST Amount" / 2);
                DetailedGSTLedgerEntry.RESET;
                DetailedGSTLedgerEntry.SETRANGE("Document No.", RecPurchInvCGST."Document No.");
                DetailedGSTLedgerEntry.SETRANGE("Document Line No.", RecPurchInvCGST."Line No.");
                DetailedGSTLedgerEntry.SETRANGE("GST Group Code", RecPurchInvCGST."GST Group Code");
                DetailedGSTLedgerEntry.SETFILTER("Transaction Type", '%1', DetailedGSTLedgerEntry."Transaction Type"::Purchase);
                DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'CGST');
                IF DetailedGSTLedgerEntry.FIND('-') THEN
                    REPEAT
                        CGST := CGST + Abs(DetailedGSTLedgerEntry."GST Amount");
                    //  CGSTRate := DetailedGSTLedgerEntry."GST %";
                    UNTIL DetailedGSTLedgerEntry.NEXT() = 0;
            //Totals

            until RecPurchInvCGST.Next = 0;
        ExcelBuff.AddColumn(CGST, false, '', false, false, false, '', ExcelBuff."cell type"::Number);
        ExcelBuff.AddColumn(CGST, false, '', false, false, false, '', ExcelBuff."cell type"::Number);
        Clear(IGST);
        RecPurchInvIGST.Reset;
        RecPurchInvIGST.SetRange(RecPurchInvIGST."Document No.", DocNo);
        RecPurchInvIGST.SetRange(RecPurchInvIGST."GST Jurisdiction Type", RecPurchInvIGST."gst jurisdiction type"::Interstate);
        if RecPurchInvIGST.FindFirst then
            repeat
                //  IGST := IGST//v + RecPurchInvIGST."Total GST Amount";

                DetailedGSTLedgerEntry.RESET;
                DetailedGSTLedgerEntry.SETRANGE("Document No.", RecPurchInvIGST."Document No.");
                DetailedGSTLedgerEntry.SETRANGE("Document Line No.", RecPurchInvIGST."Line No.");
                DetailedGSTLedgerEntry.SETRANGE("GST Group Code", RecPurchInvIGST."GST Group Code");
                DetailedGSTLedgerEntry.SETFILTER("Transaction Type", '%1', DetailedGSTLedgerEntry."Transaction Type"::Purchase);
                DetailedGSTLedgerEntry.SETRANGE("GST Component Code", 'IGST');
                IF DetailedGSTLedgerEntry.FIND('-') THEN
                    REPEAT
                        IGST := IGST + Abs(DetailedGSTLedgerEntry."GST Amount");
                    //  CGSTRate := DetailedGSTLedgerEntry."GST %";
                    UNTIL DetailedGSTLedgerEntry.NEXT() = 0;

            until RecPurchInvIGST.Next = 0;
        ExcelBuff.AddColumn(IGST, false, '', false, false, false, '', ExcelBuff."cell type"::Number);
        ExcelBuff.AddColumn(Abs(TaxableValue + CGST + IGST), false, '', false, false, false, '', ExcelBuff."cell type"::Number);
        Clear(TDSSections);
        Clear(TDSPercent);
        Clear(TDSAMt);
        TDSEntry.Reset;
        TDSEntry.SetRange(TDSEntry."Document No.", DocNo);
        if TDSEntry.FindFirst then begin
            //v    TDSSections := Format(TDSEntry."TDS Section");
            TDSPercent := TDSEntry."TDS %";
            TDSAMt := TDSEntry."TDS Amount";
        end;
        ExcelBuff.AddColumn(TDSSections, false, '', false, false, false, '', ExcelBuff."cell type"::Text);
        ExcelBuff.AddColumn(TDSPercent, false, '', false, false, false, '', ExcelBuff."cell type"::Number);
        ExcelBuff.AddColumn(Abs(TDSAMt), false, '', false, false, false, '', ExcelBuff."cell type"::Number);
        ExcelBuff.AddColumn(Abs((TaxableValue + CGST + IGST) - TDSAMt), false, '', false, false, false, '', ExcelBuff."cell type"::Number);
        ExcelBuff.AddColumn('', false, '', false, false, false, '', ExcelBuff."cell type"::Number);
        PayDocNo := DelChr(PayDocNo, '<', ';');
        PayDocNo := CopyStr(PayDocNo, 1, 250);
        ExcelBuff.AddColumn(DelChr(PayDocNo, '<', ';'), false, '', false, false, false, '', ExcelBuff."cell type"::Number);
        ExcelBuff.AddColumn(HSNCode, false, '', false, false, false, '', ExcelBuff."cell type"::Number);
        ExcelBuff.AddColumn(VendGSTNo, false, '', false, false, false, '', ExcelBuff."cell type"::Number);
        ExcelBuff.AddColumn(VendPanNo, false, '', false, false, false, '', ExcelBuff."cell type"::Number);
        Clear(UserName);
        RecUserSetup.Reset;
        RecUserSetup.SetRange(RecUserSetup."User Name", "Purch. Inv. Header"."Created By");
        if RecUserSetup.FindFirst then
            UserName := RecUserSetup."Full Name";
        ExcelBuff.AddColumn(UserName, false, '', false, false, false, '', ExcelBuff."cell type"::Number);
        ExcelBuff.AddColumn("Purch. Inv. Header"."Approver Date", false, '', false, false, false, '', ExcelBuff."cell type"::Date);
    end;

    procedure CreateExcelBook()
    begin
        //	ExcelBuff.CreateBookAndOpenExcel('E:\Report by Mail\PurchaseRegister.xlsx','Purchase Register Report','Purchase Register',COMPANYNAME,UserId);
        ExcelBuff.CreateNewBook('Purchase Registers');
        ExcelBuff.WriteSheet('Purchase Register', CompanyName, UserId);
        ExcelBuff.CloseBook();
        ExcelBuff.OpenExcel();

        //   Error('');
    end;

}
