codeunit 50016 GSTManagementhook
{
    trigger OnRun()
    begin

    end;

    var
        AccountingPeriodErr: Label 'GST Accounting Period does not exist for the given Date %1.', Comment = '%1  = Posting Date';
        CheckCalculationOrderErr: Label 'You must not enter duplicate calculation order in GST Setup.';
        GSTChargeDocAmtErr: Label 'GST Base Amount must have some value for the selected Document Type = %1 ,Document No. = %2 , Line No. = %3.', Comment = '%1 = Applied Document Type, %2=Applied Document No, %3 = Applied Document Line No.';
        GeneralLedgerSetup: Record "General Ledger Setup";
        InvoiceTypeErr: Label 'You can not select the Invoice Type %1 for GST Customer Type %2.', Comment = '%1 = Invoice Type, %2 = GST Customer Type';
        LineInvTypeErr: Label 'Line Invoice Type should be same as Header.';
        PlaceOfSupplyErr: Label 'You cannot select blank Place of Supply for Document Type %1 and Document No %2 for Sales Line %3.', Comment = '%1 = Document Type, %2 = Document No., %3 = Line No.';
        CompanyInformation: Record "Company Information";
        GLSetupRead: Boolean;
        GSTRegistrationValidationErr: Label 'You must select the same GST Registration No. for all lines in Document No. = %1, Line No. = %2 Registration No. is  %3  should be %4.', Comment = '%1 = Document No, %2 = Line, %3 = Registration No, %4 = PresentGSTRegNo';
        ADVPlaceOfSupplyErr: Label 'You cannot select blank Place of Supply for Template %1 and Batch %2 for Line %3.', Comment = '%1 = Template, %2 = Batch, %3 = Line No.';
        PeriodClosedErr: Label 'Accounting Period has been closed till %1, Document Posting Date must be greater than or equal to %2.', Comment = '%1 = Date, %2 = Posting Date';
        SimilarGSTGroupTypeErr: Label 'You must specify the same %1 in Reverse charge %2 %3, %4 %5.', Comment = '%1 = GST Group Type, %2 = Field Reference %3 = Document Type, %4 = Field Reference %5 = Document No.';
        ExemptedLinesErr: Label 'All lines in the document are GST Exempted, the preferred Invoice type should be Bill of Supply.';
        NonExemptedLinesErr: Label 'All lines in the document are not GST Exempted, the preferred Invoice type should be according to GST Customer Type.';
        DiffJurisdictionTypeErr: Label 'All lines in the document must have same GST Jurisdiction Type.';
        InputServiceLocationErr: Label 'You cannot select Location Code: %1 with GST Input Service Distributor enabled.', Comment = '%1 = Location Code';
        TypeISDErr: Label 'You must select %1 whose %2 is %3 when GST Input Service Distribution is checked.', Comment = '%1 = Type, %2 = Field Name, %3 = GST Group Type';
        UsedForSettlement: Boolean;
        SimilarReverseChargeLineErr: Label 'You must specify the same GST Reverse Charge Group Type in Reverse charge %1 %2, %3 %4.', Comment = '%1 = Document Type, %2 = Field Reference %3 = Field Reference, %4 = Document No.';
        GSTReverseChargeVendorErr: Label 'You cannot select GST Group Code with Reverse Charge when GST Input Service Distribution is set.';
        VendorISDErr: Label 'GST Input Service Distribution Location %1 is applicable only for Registered Vendor.', Comment = '%1 = Location Code';
        NonGSTLineErr: Label 'You cannot do GST and Non-GST Transcation in same document.';
        NonGSTSubconErr: Label 'Please specify the GST Group Code and HSN Code for the selected Document No. = %1.', Comment = '%1 = Code';
        ChargeItemErr: Label 'You cannot select Charge (Item) when GST Input Service Distribution is checked.';
        UOMNotExistErr: Label 'Cess UOM %1 is not defined for the Item %2.', Comment = '%1 = UOM;%2 = Item No.';


    // PROCEDURE FillAppBufferInvoice(TransactionType: Option; InvoiceDocNo@1500004 : Code[20];AccountNo@1500011 : Code[20];PaymentDocNo : Code[20];TDSTCSAmount : Decimal):
    // begin

    // end;

    procedure InsertGSTLedgerEntryPurchaseCredit(GSTPostingBuffer: Record "GST Posting Buffer"; PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header"; NextTransactionNo: Integer; DocumentType: Option; DocumentNo: Code[20]; CurrencyCode: Code[10]; CurrencyFactor: Decimal; SourceCode: Code[10])
    var
        GSTLedgerEntry: Record "GST Ledger Entry";
        Sign: Integer;
    begin
        IF PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::Invoice,
                                              PurchaseHeader."Document Type"::Quote,
                                              PurchaseHeader."Document Type"::"Blanket Order"]
        THEN
            Sign := 1
        ELSE
            Sign := -1;
        GSTLedgerEntry.INIT;
        GSTLedgerEntry."Entry No." := GetNextGSTLedgerEntryNo;
        GSTLedgerEntry."Gen. Bus. Posting Group" := GSTPostingBuffer."Gen. Bus. Posting Group";
        GSTLedgerEntry."Gen. Prod. Posting Group" := GSTPostingBuffer."Gen. Prod. Posting Group";
        GSTLedgerEntry."Posting Date" := PurchaseHeader."Posting Date";
        GSTLedgerEntry."Document No." := DocumentNo;
        GSTLedgerEntry."Document Type" := DocumentType;
        GSTLedgerEntry."GST Amount" := (-1 * ABS(GSTPostingBuffer."GST Amount") * Sign);
        GSTLedgerEntry."Currency Code" := CurrencyCode;
        GSTLedgerEntry."Currency Factor" := CurrencyFactor;
        GSTLedgerEntry."Transaction Type" := GSTLedgerEntry."Transaction Type"::Purchase;
        GSTLedgerEntry."GST Base Amount" := ABS(GSTPostingBuffer."GST Base Amount") * Sign;
        GSTLedgerEntry."Source Type" := GSTLedgerEntry."Source Type"::Vendor;
        GSTLedgerEntry."Source No." := PurchaseLine."Buy-from Vendor No.";
        GSTLedgerEntry."Source Code" := SourceCode;
        GSTLedgerEntry."Transaction No." := NextTransactionNo;
        GSTLedgerEntry."Input Service Distribution" := PurchaseHeader."GST Input Service Distribution";
        IF PurchaseHeader."Vendor Invoice No." <> '' THEN
            GSTLedgerEntry."External Document No." := PurchaseHeader."Vendor Invoice No.";
        IF PurchaseHeader."Vendor Cr. Memo No." <> '' THEN
            GSTLedgerEntry."External Document No." := PurchaseHeader."Vendor Cr. Memo No.";
        IF PurchaseLine.Type = PurchaseLine.Type::"G/L Account" THEN
            GSTLedgerEntry."Purchase Group Type" := "Purchase Group Type"::Service
        ELSE
            GSTLedgerEntry."Purchase Group Type" := "Purchase Group Type"::Goods;
        GSTLedgerEntry."GST Component Code" := GSTPostingBuffer."GST Component Code";
        GSTLedgerEntry."Reverse Charge" := GSTPostingBuffer."GST Reverse Charge";
        GSTLedgerEntry."User ID" := USERID;
        //>> ST
        //GSTLedgerEntry."GST Credit 50%" := TRUE;//vikas
        // GSTLedgerEntry."Reason Code" := PurchaseLine."Reason Code";
        //<< ST
        GSTLedgerEntry.INSERT(TRUE);
    end;

    procedure InsertDetailedGSTLedgEntryPurchaseCredit(PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header"; DocumentNo: Code[20]; DocumentType: Option; QtyFactor: Decimal; TransactionNo: Integer)
    var
        DetailedGSTEntryBuffer: Record "Detailed GST Entry Buffer";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        ValueEntry: Record "Value Entry";
        Vendor: Record "Vendor";
        PurchInvLine: Record "Purch. Inv. Line";
        reccomment: Record "Purch. Comment Line";
        Dimentionsetentry: Record "Dimension Set Entry";
    begin
        DetailedGSTEntryBuffer.SETCURRENTKEY("Transaction Type", "Document Type", "Document No.", "Line No.");
        DetailedGSTEntryBuffer.SETRANGE("Transaction Type", DetailedGSTEntryBuffer."Transaction Type"::Purchase);
        //>> ST
        //DetailedGSTEntryBuffer.SetRange("Document Type", PurchaseLine."Document Type");
        //<< ST
        DetailedGSTEntryBuffer.SETRANGE("Document No.", PurchaseLine."Document No.");
        DetailedGSTEntryBuffer.SETRANGE("Line No.", PurchaseLine."Line No.");
        IF DetailedGSTEntryBuffer.FINDSET THEN
            REPEAT
                DetailedGSTLedgerEntry.INIT;
                DetailedGSTLedgerEntry."Entry No." := GetNextGSTDetailEntryNo;
                DetailedGSTLedgerEntry."Entry Type" := DetailedGSTLedgerEntry."Entry Type"::"Initial Entry";
                DetailedGSTLedgerEntry."Transaction Type" := DetailedGSTLedgerEntry."Transaction Type"::Purchase;
                DetailedGSTLedgerEntry."Document Type" := DocumentType;
                DetailedGSTLedgerEntry."Document No." := DocumentNo;
                IF PurchaseHeader."Vendor Invoice No." <> '' THEN
                    DetailedGSTLedgerEntry."External Document No." := PurchaseHeader."Vendor Invoice No.";
                IF PurchaseHeader."Vendor Cr. Memo No." <> '' THEN
                    DetailedGSTLedgerEntry."External Document No." := PurchaseHeader."Vendor Cr. Memo No.";
                DetailedGSTLedgerEntry."Posting Date" := PurchaseHeader."Posting Date";
                DetailedGSTLedgerEntry."Source Type" := "Source Type"::Vendor;
                IF DetailedGSTEntryBuffer."Item Charge Assgn. Line No." = 0 THEN
                    DetailedGSTLedgerEntry."No." := PurchaseLine."No."
                ELSE
                    DetailedGSTLedgerEntry."No." := DetailedGSTEntryBuffer."No.";
                DetailedGSTEntryBuffer.TESTFIELD("Location Code");
                DetailedGSTEntryBuffer.TESTFIELD("Location State Code");
                DetailedGSTEntryBuffer.TESTFIELD("Location  Reg. No.");
                DetailedGSTLedgerEntry."Location Code" := DetailedGSTEntryBuffer."Location Code";
                DetailedGSTLedgerEntry."Location  Reg. No." := DetailedGSTEntryBuffer."Location  Reg. No.";
                Vendor.GET(PurchaseHeader."Buy-from Vendor No.");
                DetailedGSTLedgerEntry."GST Jurisdiction Type" := PurchaseLine."GST Jurisdiction Type";
                DetailedGSTLedgerEntry."GST Group Type" := PurchaseLine."GST Group Type";
                //>> ST
                // DetailedGSTLedgerEntry.Type := PurchaseLine.Type;
                // DetailedGSTLedgerEntry."Location State Code" := DetailedGSTEntryBuffer."Location State Code";
                // IF NOT PurchaseLine."Item Charge Entry" THEN
                //     DetailedGSTLedgerEntry."Item Charge Entry" := PurchaseLine.Type = PurchaseLine.Type::"Charge (Item)"
                // ELSE
                //     DetailedGSTLedgerEntry."Item Charge Entry" := PurchaseLine."Item Charge Entry";
                // DetailedGSTLedgerEntry."Gen. Bus. Posting Group" := PurchaseLine."Gen. Bus. Posting Group";
                // DetailedGSTLedgerEntry."Gen. Prod. Posting Group" := PurchaseLine."Gen. Prod. Posting Group";
                // DetailedGSTLedgerEntry."Reason Code" := PurchaseHeader."Reason Code";
                // DetailedGSTLedgerEntry."Item Charge Assgn. Line No." := DetailedGSTEntryBuffer."Item Charge Assgn. Line No.";
                // DetailedGSTLedgerEntry."Nature of Supply" := PurchaseHeader."Nature of Supply";
                // DetailedGSTLedgerEntry."Buyer/Seller State Code" := DetailedGSTEntryBuffer."Buyer/Seller State Code";
                // DetailedGSTLedgerEntry."Buyer/Seller Reg. No." := DetailedGSTEntryBuffer."Buyer/Seller Reg. No.";
                // DetailedGSTLedgerEntry."Shipping Address State Code" := DetailedGSTEntryBuffer."Shipping Address State Code";
                // DetailedGSTLedgerEntry."Original Invoice Date" := DetailedGSTEntryBuffer."Original Invoice Date";
                // DetailedGSTLedgerEntry."Component Calc. Type" := DetailedGSTEntryBuffer."Component Calc. Type";
                //<< ST
                DetailedGSTLedgerEntry."GST Component Code" := DetailedGSTEntryBuffer."GST Component Code";
                DetailedGSTLedgerEntry."GST Exempted Goods" := PurchaseLine.Exempted;
                DetailedGSTLedgerEntry."Reverse Charge" := DetailedGSTEntryBuffer."Reverse Charge";
                DetailedGSTLedgerEntry."GST Vendor Type" := PurchaseHeader."GST Vendor Type";
                DetailedGSTLedgerEntry."Associated Enterprises" := PurchaseHeader."Associated Enterprises";
                DetailedGSTLedgerEntry."Original Invoice No." := DetailedGSTEntryBuffer."Original Invoice No.";
                DetailedGSTLedgerEntry."GST Credit 50%" := TRUE;//vikas
                IF DetailedGSTEntryBuffer."Amount Loaded on Item" <> 0 THEN
                    DetailedGSTLedgerEntry."GST Credit" := "GST Credit"::"Non-Availment"
                ELSE
                    DetailedGSTLedgerEntry."GST Credit" := "GST Credit"::Availment;
                //>> ST
                // DetailedGSTLedgerEntry."G/L Account No." :=
                //   GetGSTAccountNo(
                //     DetailedGSTLedgerEntry."Location State Code", DetailedGSTEntryBuffer."GST Component Code", "Transaction Type"::Purchase,
                //     PurchaseLine.Type::" ", PurchaseLine."GST Credit", PurchaseHeader."GST Input Service Distribution",
                //     GetReceivableApplicable(DetailedGSTLedgerEntry."GST Vendor Type", DetailedGSTLedgerEntry."GST Group Type", DetailedGSTLedgerEntry."GST Credit", DetailedGSTLedgerEntry."Associated Enterprises", DetailedGSTLedgerEntry."Reverse Charge"));
                // DetailedGSTLedgerEntry."Credit Availed" :=
                //   GetReceivableApplicable(DetailedGSTLedgerEntry."GST Vendor Type", DetailedGSTLedgerEntry."GST Group Type", DetailedGSTLedgerEntry."GST Credit", DetailedGSTLedgerEntry."Associated Enterprises", DetailedGSTLedgerEntry."Reverse Charge");
                // DetailedGSTLedgerEntry."Liable to Pay" := GetPurchaseLiable(DetailedGSTLedgerEntry."GST Vendor Type", DetailedGSTLedgerEntry."GST Group Type", DetailedGSTLedgerEntry."Associated Enterprises");
                // UpdateDetailGSTLedgerEntryCredit(
                //   DetailedGSTLedgerEntry, DetailedGSTEntryBuffer, PurchaseHeader."Currency Code",
                //   PurchaseHeader."Currency Factor", QtyFactor, TransactionNo);
                // // Get Posted Purch Invoice
                // IF PurchInvLine.GET(DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Document Line No.") THEN
                //     DetailedGSTLedgerEntry."Amount to Customer/Vendor" := -1 * PurchInvLine."Amount To Vendor";
                //<< ST
                DetailedGSTLedgerEntry.TESTFIELD("HSN/SAC Code");
                IF (Vendor."GST Vendor Type" = Vendor."GST Vendor Type"::Import) OR
                   (Vendor."GST Vendor Type" = Vendor."GST Vendor Type"::SEZ)
                THEN
                    IF PurchaseLine.Type IN [PurchaseLine.Type::"Fixed Asset", PurchaseLine.Type::Item] THEN
                        PurchaseLine.TESTFIELD("GST Assessable Value");

                IF (DetailedGSTEntryBuffer."Amount Loaded on Item" = 0) AND
                   (DetailedGSTEntryBuffer."GST Input/Output Credit Amount" = 0)
                THEN
                    EVALUATE(DetailedGSTLedgerEntry."GST Credit", FORMAT(PurchaseLine."GST Credit"));

                //CCIT Aux-0002 Vikas 25/07/2019 Start
                DetailedGSTLedgerEntry."Vendor Name" := Vendor.Name;
                DetailedGSTLedgerEntry."Vendor Invoice No." := PurchaseHeader."Vendor Invoice No.";
                DetailedGSTLedgerEntry."Document Date" := PurchaseHeader."Document Date";

                reccomment.RESET();
                reccomment.SETRANGE("No.", PurchaseHeader."No.");
                IF reccomment.FIND('-') THEN
                    DetailedGSTLedgerEntry."Purchase Invoice Comment" := reccomment.Comment;

                Dimentionsetentry.RESET();
                Dimentionsetentry.SETRANGE("Dimension Set ID", PurchaseLine."Dimension Set ID");
                Dimentionsetentry.SETRANGE("Dimension Code", 'LAN');
                IF Dimentionsetentry.FIND('-') THEN BEGIN
                    DetailedGSTLedgerEntry."Shortcut Dimention 8 Code" := Dimentionsetentry."Dimension Value Code";
                END;
                //CCIT Aux-0002 Vikas 25/07/2019 Start

                IF QtyFactor <> 0 THEN
                    DetailedGSTLedgerEntry.INSERT(TRUE);
                IF DetailedGSTLedgerEntry."GST Credit" = DetailedGSTLedgerEntry."GST Credit"::"Non-Availment" THEN BEGIN
                    ValueEntry.SETCURRENTKEY("Document No.", "Document Line No.", "Item No.");
                    ValueEntry.SETRANGE("Document No.", DocumentNo);
                    ValueEntry.SETRANGE("Document Line No.", DetailedGSTLedgerEntry."Document Line No.");
                    ValueEntry.SETRANGE("Item No.", DetailedGSTLedgerEntry."No.");
                    IF ValueEntry.FINDFIRST THEN BEGIN
                        //>> ST
                        //DetailedGSTLedgerEntry."Item Ledger Entry No." := ValueEntry."Item Ledger Entry No.";
                        //<< ST
                        DetailedGSTLedgerEntry.MODIFY(TRUE);
                    END;
                END;
            UNTIL DetailedGSTEntryBuffer.NEXT = 0;
    end;

    procedure UpdateDetailGSTLedgerEntryCredit(var DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry"; DetailedGSTEntryBuffer: Record "Detailed GST Entry Buffer"; CurrencyCode: Code[10]; CurrencyFactor: Decimal; QtyFactor: Decimal; TransactionNo: Integer)
    begin
        GeneralLedgerSetup.GET;
        DetailedGSTLedgerEntry.Type := DetailedGSTEntryBuffer.Type;
        DetailedGSTLedgerEntry."Product Type" := DetailedGSTEntryBuffer."Product Type";
        DetailedGSTLedgerEntry."Source No." := DetailedGSTEntryBuffer."Source No.";
        DetailedGSTLedgerEntry."HSN/SAC Code" := DetailedGSTEntryBuffer."HSN/SAC Code";
        DetailedGSTLedgerEntry."GST Component Code" := DetailedGSTEntryBuffer."GST Component Code";
        DetailedGSTLedgerEntry."GST Group Code" := DetailedGSTEntryBuffer."GST Group Code";
        DetailedGSTLedgerEntry."Document Line No." := DetailedGSTEntryBuffer."Line No.";
        DetailedGSTLedgerEntry."Currency Code" := CurrencyCode;
        DetailedGSTLedgerEntry."Currency Factor" := CurrencyFactor;
        IF DetailedGSTEntryBuffer."GST Assessable Value" <> 0 THEN
            DetailedGSTLedgerEntry."GST Base Amount" :=
              ROUND(
                DetailedGSTEntryBuffer."GST Assessable Value (LCY)" + DetailedGSTEntryBuffer."Custom Duty Amount (LCY)",
                GeneralLedgerSetup."Amount Rounding Precision")
        ELSE
            DetailedGSTLedgerEntry."GST Base Amount" :=
              ROUND(
                DetailedGSTEntryBuffer."GST Base Amount (LCY)" * QtyFactor,
                GeneralLedgerSetup."Amount Rounding Precision");
        ///>> ST
        // IF DetailedGSTEntryBuffer."GST Assessable Value" <> 0 THEN
        //     DetailedGSTLedgerEntry."GST Amount" :=
        //       RoundGSTPrecision(-1 * (DetailedGSTEntryBuffer."GST Amount (LCY)" / DetailedGSTEntryBuffer."GST Base Amount (LCY)") *
        //         DetailedGSTLedgerEntry."GST Base Amount")
        // ELSE
        //     DetailedGSTLedgerEntry."GST Amount" := RoundGSTPrecision(-1 * DetailedGSTEntryBuffer."GST Amount (LCY)" * QtyFactor);

        // IF DetailedGSTEntryBuffer."GST Assessable Value" <> 0 THEN
        //     DetailedGSTLedgerEntry."Amount Loaded on Item" :=
        //       ConvertGSTAmountToLCY(
        //         CurrencyCode, DetailedGSTEntryBuffer."Amount Loaded on Item",
        //         CurrencyFactor, DetailedGSTLedgerEntry."Posting Date")
        // ELSE
        //     DetailedGSTLedgerEntry."Amount Loaded on Item" :=
        //       ConvertGSTAmountToLCY(
        //         CurrencyCode, DetailedGSTEntryBuffer."Amount Loaded on Item" * QtyFactor,
        //         CurrencyFactor, DetailedGSTLedgerEntry."Posting Date");
        //<< ST
        IF DetailedGSTEntryBuffer."Item Charge Assgn. Line No." <> 0 THEN
            QtyFactor := 1;
        DetailedGSTLedgerEntry."Remaining Base Amount" := DetailedGSTLedgerEntry."GST Base Amount";
        DetailedGSTLedgerEntry."Remaining GST Amount" := DetailedGSTLedgerEntry."GST Amount";
        DetailedGSTLedgerEntry."GST %" := DetailedGSTEntryBuffer."GST %";//vikas
        DetailedGSTLedgerEntry.Quantity := DetailedGSTEntryBuffer.Quantity * QtyFactor;
        DetailedGSTLedgerEntry."GST Rounding Type" := DetailedGSTEntryBuffer."GST Rounding Type";
        DetailedGSTLedgerEntry."GST Rounding Precision" := DetailedGSTEntryBuffer."GST Rounding Precision";
        DetailedGSTLedgerEntry."Input Service Distribution" := DetailedGSTEntryBuffer."Input Service Distribution";
        //>> ST
        // IF DetailedGSTLedgerEntry."GST Amount" > 0 THEN
        //     DetailedGSTLedgerEntry.Positive := TRUE;
        // DetailedGSTLedgerEntry."Original Doc. Type" := DetailedGSTLedgerEntry."Document Type";
        // DetailedGSTLedgerEntry."Original Doc. No." := DetailedGSTLedgerEntry."Document No.";
        // DetailedGSTLedgerEntry."User ID" := USERID;
        // DetailedGSTLedgerEntry."Transaction No." := TransactionNo;
        // DetailedGSTLedgerEntry.Cess := DetailedGSTEntryBuffer.Cess;
        // DetailedGSTLedgerEntry."Component Calc. Type" := DetailedGSTEntryBuffer."Component Calc. Type";
        // DetailedGSTLedgerEntry."Cess Amount Per Unit Factor" := DetailedGSTEntryBuffer."Cess Amt Per Unit Factor (LCY)";
        // DetailedGSTLedgerEntry."Cess UOM" := DetailedGSTEntryBuffer."Cess UOM";
        // DetailedGSTLedgerEntry."Cess Factor Quantity" := DetailedGSTEntryBuffer."Cess Factor Quantity";
        // DetailedGSTLedgerEntry.UOM := DetailedGSTEntryBuffer.UOM;
        //<< ST
    end;

    procedure InsertGSTLedgerEntryPurchaseCredit1(GSTPostingBuffer: Record "GST Posting Buffer"; PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header"; NextTransactionNo: Integer; DocumentType: Option; DocumentNo: Code[20]; CurrencyCode: Code[10]; CurrencyFactor: Decimal; SourceCode: Code[10])
    var
        GSTLedgerEntry: Record "GST Ledger Entry";
        Sign: Integer;
    begin
        IF PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::Invoice,
                                              PurchaseHeader."Document Type"::Quote,
                                              PurchaseHeader."Document Type"::"Blanket Order"]
        THEN
            Sign := 1
        ELSE
            Sign := -1;
        GSTLedgerEntry.INIT;
        GSTLedgerEntry."Entry No." := GetNextGSTLedgerEntryNo;
        GSTLedgerEntry."Gen. Bus. Posting Group" := GSTPostingBuffer."Gen. Bus. Posting Group";
        GSTLedgerEntry."Gen. Prod. Posting Group" := GSTPostingBuffer."Gen. Prod. Posting Group";
        GSTLedgerEntry."Posting Date" := PurchaseHeader."Posting Date";
        GSTLedgerEntry."Document No." := DocumentNo;
        GSTLedgerEntry."Document Type" := DocumentType;
        GSTLedgerEntry."GST Amount" := (ABS(GSTPostingBuffer."GST Amount") * Sign) / 2;
        GSTLedgerEntry."Currency Code" := CurrencyCode;
        GSTLedgerEntry."Currency Factor" := CurrencyFactor;
        GSTLedgerEntry."Transaction Type" := GSTLedgerEntry."Transaction Type"::Purchase;
        GSTLedgerEntry."GST Base Amount" := ABS(GSTPostingBuffer."GST Base Amount") * Sign;
        GSTLedgerEntry."Source Type" := GSTLedgerEntry."Source Type"::Vendor;
        GSTLedgerEntry."Source No." := PurchaseLine."Buy-from Vendor No.";
        GSTLedgerEntry."Source Code" := SourceCode;
        GSTLedgerEntry."Transaction No." := NextTransactionNo;
        GSTLedgerEntry."Input Service Distribution" := PurchaseHeader."GST Input Service Distribution";
        IF PurchaseHeader."Vendor Invoice No." <> '' THEN
            GSTLedgerEntry."External Document No." := PurchaseHeader."Vendor Invoice No.";
        IF PurchaseHeader."Vendor Cr. Memo No." <> '' THEN
            GSTLedgerEntry."External Document No." := PurchaseHeader."Vendor Cr. Memo No.";
        IF PurchaseLine.Type = PurchaseLine.Type::"G/L Account" THEN
            GSTLedgerEntry."Purchase Group Type" := "Purchase Group Type"::Service
        ELSE
            GSTLedgerEntry."Purchase Group Type" := "Purchase Group Type"::Goods;
        GSTLedgerEntry."GST Component Code" := GSTPostingBuffer."GST Component Code";
        GSTLedgerEntry."Reverse Charge" := GSTPostingBuffer."GST Reverse Charge";
        GSTLedgerEntry."User ID" := USERID;
        //>> ST
        // GSTLedgerEntry."Reason Code" := PurchaseLine."Reason Code";
        // GSTLedgerEntry."GST Credit 50%" := TRUE;//CCIT AN Gst 50%
        //<< ST
        GSTLedgerEntry.INSERT(TRUE);
    end;

    procedure InsertDetailedGSTLedgEntryPurchaseCredit1(PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header"; DocumentNo: Code[20]; DocumentType: Option; QtyFactor: Decimal; TransactionNo: Integer)
    var
        DetailedGSTEntryBuffer: Record "Detailed GST Entry Buffer";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        ValueEntry: Record "Value Entry";
        Vendor: Record "Vendor";
        PurchInvLine: Record "Purch. Inv. Line";
        reccomment: Record "Purch. Comment Line";
        Dimentionsetentry: Record "Dimension Set Entry";
    begin
        DetailedGSTEntryBuffer.SETCURRENTKEY("Transaction Type", "Document Type", "Document No.", "Line No.");
        DetailedGSTEntryBuffer.SETRANGE("Transaction Type", DetailedGSTEntryBuffer."Transaction Type"::Purchase);
        //>> ST
        //DetailedGSTEntryBuffer.SETRANGE("Document Type", PurchaseLine."Document Type");
        //<< ST
        DetailedGSTEntryBuffer.SETRANGE("Document No.", PurchaseLine."Document No.");
        DetailedGSTEntryBuffer.SETRANGE("Line No.", PurchaseLine."Line No.");
        IF DetailedGSTEntryBuffer.FINDSET THEN
            REPEAT
                DetailedGSTLedgerEntry.INIT;
                DetailedGSTLedgerEntry."Entry No." := GetNextGSTDetailEntryNo;
                DetailedGSTLedgerEntry."Entry Type" := DetailedGSTLedgerEntry."Entry Type"::"Initial Entry";
                DetailedGSTLedgerEntry."Transaction Type" := DetailedGSTLedgerEntry."Transaction Type"::Purchase;
                DetailedGSTLedgerEntry."Document Type" := DocumentType;
                DetailedGSTLedgerEntry."Document No." := DocumentNo;
                IF PurchaseHeader."Vendor Invoice No." <> '' THEN
                    DetailedGSTLedgerEntry."External Document No." := PurchaseHeader."Vendor Invoice No.";
                IF PurchaseHeader."Vendor Cr. Memo No." <> '' THEN
                    DetailedGSTLedgerEntry."External Document No." := PurchaseHeader."Vendor Cr. Memo No.";
                DetailedGSTLedgerEntry."Posting Date" := PurchaseHeader."Posting Date";
                DetailedGSTLedgerEntry."Source Type" := "Source Type"::Vendor;
                IF DetailedGSTEntryBuffer."Item Charge Assgn. Line No." = 0 THEN
                    DetailedGSTLedgerEntry."No." := PurchaseLine."No."
                ELSE
                    DetailedGSTLedgerEntry."No." := DetailedGSTEntryBuffer."No.";
                DetailedGSTEntryBuffer.TESTFIELD("Location Code");
                DetailedGSTEntryBuffer.TESTFIELD("Location State Code");
                DetailedGSTEntryBuffer.TESTFIELD("Location  Reg. No.");
                DetailedGSTLedgerEntry."Location Code" := DetailedGSTEntryBuffer."Location Code";
                DetailedGSTLedgerEntry."Location  Reg. No." := DetailedGSTEntryBuffer."Location  Reg. No.";
                Vendor.GET(PurchaseHeader."Buy-from Vendor No.");
                DetailedGSTLedgerEntry."GST Jurisdiction Type" := PurchaseLine."GST Jurisdiction Type";
                DetailedGSTLedgerEntry."GST Group Type" := PurchaseLine."GST Group Type";
                //>> ST
                // DetailedGSTLedgerEntry.Type := PurchaseLine.Type;
                // DetailedGSTLedgerEntry."Location State Code" := DetailedGSTEntryBuffer."Location State Code";
                // IF NOT PurchaseLine."Item Charge Entry" THEN
                //     DetailedGSTLedgerEntry."Item Charge Entry" := PurchaseLine.Type = PurchaseLine.Type::"Charge (Item)"
                // ELSE
                //     DetailedGSTLedgerEntry."Item Charge Entry" := PurchaseLine."Item Charge Entry";
                // DetailedGSTLedgerEntry."Gen. Bus. Posting Group" := PurchaseLine."Gen. Bus. Posting Group";
                // DetailedGSTLedgerEntry."Gen. Prod. Posting Group" := PurchaseLine."Gen. Prod. Posting Group";
                // DetailedGSTLedgerEntry."Reason Code" := PurchaseHeader."Reason Code";
                // DetailedGSTLedgerEntry."Item Charge Assgn. Line No." := DetailedGSTEntryBuffer."Item Charge Assgn. Line No.";
                // DetailedGSTLedgerEntry."Nature of Supply" := PurchaseHeader."Nature of Supply";
                // DetailedGSTLedgerEntry."Buyer/Seller State Code" := DetailedGSTEntryBuffer."Buyer/Seller State Code";
                // DetailedGSTLedgerEntry."Shipping Address State Code" := DetailedGSTEntryBuffer."Shipping Address State Code";
                // DetailedGSTLedgerEntry."Original Invoice Date" := DetailedGSTEntryBuffer."Original Invoice Date";
                // DetailedGSTLedgerEntry."Component Calc. Type" := DetailedGSTEntryBuffer."Component Calc. Type";
                //<< ST
                DetailedGSTLedgerEntry."Buyer/Seller Reg. No." := DetailedGSTEntryBuffer."Buyer/Seller Reg. No.";
                DetailedGSTLedgerEntry."GST Component Code" := DetailedGSTEntryBuffer."GST Component Code";
                DetailedGSTLedgerEntry."GST Exempted Goods" := PurchaseLine.Exempted;
                DetailedGSTLedgerEntry."Reverse Charge" := DetailedGSTEntryBuffer."Reverse Charge";
                DetailedGSTLedgerEntry."GST Vendor Type" := PurchaseHeader."GST Vendor Type";
                DetailedGSTLedgerEntry."Associated Enterprises" := PurchaseHeader."Associated Enterprises";
                DetailedGSTLedgerEntry."Original Invoice No." := DetailedGSTEntryBuffer."Original Invoice No.";
                DetailedGSTLedgerEntry."GST Credit 50%" := TRUE;//vikas
                IF DetailedGSTEntryBuffer."Amount Loaded on Item" <> 0 THEN
                    DetailedGSTLedgerEntry."GST Credit" := "GST Credit"::"Non-Availment"
                ELSE
                    DetailedGSTLedgerEntry."GST Credit" := "GST Credit"::Availment;
                //>> ST
                // DetailedGSTLedgerEntry."G/L Account No." :=
                //   GetGSTAccountNo(
                //     DetailedGSTLedgerEntry."Location State Code", DetailedGSTEntryBuffer."GST Component Code", "Transaction Type"::Purchase,
                //     PurchaseLine.Type::" ", PurchaseLine."GST Credit", PurchaseHeader."GST Input Service Distribution",
                //     GetReceivableApplicable(DetailedGSTLedgerEntry."GST Vendor Type", DetailedGSTLedgerEntry."GST Group Type", DetailedGSTLedgerEntry."GST Credit", DetailedGSTLedgerEntry."Associated Enterprises", DetailedGSTLedgerEntry."Reverse Charge"));
                // DetailedGSTLedgerEntry."Credit Availed" :=
                //   GetReceivableApplicable(DetailedGSTLedgerEntry."GST Vendor Type", DetailedGSTLedgerEntry."GST Group Type", DetailedGSTLedgerEntry."GST Credit", DetailedGSTLedgerEntry."Associated Enterprises", DetailedGSTLedgerEntry."Reverse Charge");
                // DetailedGSTLedgerEntry."Liable to Pay" := GetPurchaseLiable(DetailedGSTLedgerEntry."GST Vendor Type", DetailedGSTLedgerEntry."GST Group Type", DetailedGSTLedgerEntry."Associated Enterprises");
                //<< ST
                UpdateDetailGSTLedgerEntryCredit1(
                  DetailedGSTLedgerEntry, DetailedGSTEntryBuffer, PurchaseHeader."Currency Code",
                  PurchaseHeader."Currency Factor", QtyFactor, TransactionNo);
                // Get Posted Purch Invoice
                //>> ST
                // IF PurchInvLine.GET(DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Document Line No.") THEN
                //     DetailedGSTLedgerEntry."Amount to Customer/Vendor" := PurchInvLine."Amount To Vendor" / 2;
                //<< ST
                DetailedGSTLedgerEntry.TESTFIELD("HSN/SAC Code");
                IF (Vendor."GST Vendor Type" = Vendor."GST Vendor Type"::Import) OR
                   (Vendor."GST Vendor Type" = Vendor."GST Vendor Type"::SEZ)
                THEN
                    IF PurchaseLine.Type IN [PurchaseLine.Type::"Fixed Asset", PurchaseLine.Type::Item] THEN
                        PurchaseLine.TESTFIELD("GST Assessable Value");

                IF (DetailedGSTEntryBuffer."Amount Loaded on Item" = 0) AND
                   (DetailedGSTEntryBuffer."GST Input/Output Credit Amount" = 0)
                THEN
                    EVALUATE(DetailedGSTLedgerEntry."GST Credit", FORMAT(PurchaseLine."GST Credit"));

                //CCIT Aux-0002 Vikas 25/07/2019 Start
                DetailedGSTLedgerEntry."Vendor Name" := Vendor.Name;
                DetailedGSTLedgerEntry."Vendor Invoice No." := PurchaseHeader."Vendor Invoice No.";
                DetailedGSTLedgerEntry."Document Date" := PurchaseHeader."Document Date";

                reccomment.RESET();
                reccomment.SETRANGE("No.", PurchaseHeader."No.");
                IF reccomment.FIND('-') THEN
                    DetailedGSTLedgerEntry."Purchase Invoice Comment" := reccomment.Comment;

                Dimentionsetentry.RESET();
                Dimentionsetentry.SETRANGE("Dimension Set ID", PurchaseLine."Dimension Set ID");
                Dimentionsetentry.SETRANGE("Dimension Code", 'LAN');
                IF Dimentionsetentry.FIND('-') THEN BEGIN
                    DetailedGSTLedgerEntry."Shortcut Dimention 8 Code" := Dimentionsetentry."Dimension Value Code";
                END;
                //CCIT Aux-0002 Vikas 25/07/2019 Start

                IF QtyFactor <> 0 THEN
                    DetailedGSTLedgerEntry.INSERT(TRUE);
                IF DetailedGSTLedgerEntry."GST Credit" = DetailedGSTLedgerEntry."GST Credit"::"Non-Availment" THEN BEGIN
                    ValueEntry.SETCURRENTKEY("Document No.", "Document Line No.", "Item No.");
                    ValueEntry.SETRANGE("Document No.", DocumentNo);
                    ValueEntry.SETRANGE("Document Line No.", DetailedGSTLedgerEntry."Document Line No.");
                    ValueEntry.SETRANGE("Item No.", DetailedGSTLedgerEntry."No.");
                    IF ValueEntry.FINDFIRST THEN BEGIN
                        //>> ST
                        //DetailedGSTLedgerEntry."Item Ledger Entry No." := ValueEntry."Item Ledger Entry No.";
                        //<< ST
                        DetailedGSTLedgerEntry.MODIFY(TRUE);
                    END;
                END;
            UNTIL DetailedGSTEntryBuffer.NEXT = 0;
    end;

    procedure UpdateDetailGSTLedgerEntryCredit1(var DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry"; DetailedGSTEntryBuffer: Record "Detailed GST Entry Buffer"; CurrencyCode: Code[10]; CurrencyFactor: Decimal; QtyFactor: Decimal; TransactionNo: Integer)
    begin
        GeneralLedgerSetup.GET;
        DetailedGSTLedgerEntry.Type := DetailedGSTEntryBuffer.Type;
        DetailedGSTLedgerEntry."Product Type" := DetailedGSTEntryBuffer."Product Type";
        DetailedGSTLedgerEntry."Source No." := DetailedGSTEntryBuffer."Source No.";
        DetailedGSTLedgerEntry."HSN/SAC Code" := DetailedGSTEntryBuffer."HSN/SAC Code";
        DetailedGSTLedgerEntry."GST Component Code" := DetailedGSTEntryBuffer."GST Component Code";
        DetailedGSTLedgerEntry."GST Group Code" := DetailedGSTEntryBuffer."GST Group Code";
        DetailedGSTLedgerEntry."Document Line No." := DetailedGSTEntryBuffer."Line No.";
        DetailedGSTLedgerEntry."Currency Code" := CurrencyCode;
        DetailedGSTLedgerEntry."Currency Factor" := CurrencyFactor;
        IF DetailedGSTEntryBuffer."GST Assessable Value" <> 0 THEN
            DetailedGSTLedgerEntry."GST Base Amount" :=
              ROUND(
                DetailedGSTEntryBuffer."GST Assessable Value (LCY)" + DetailedGSTEntryBuffer."Custom Duty Amount (LCY)",
                GeneralLedgerSetup."Amount Rounding Precision")
        ELSE
            DetailedGSTLedgerEntry."GST Base Amount" :=
              ROUND(
                DetailedGSTEntryBuffer."GST Base Amount (LCY)" * QtyFactor,
                GeneralLedgerSetup."Amount Rounding Precision");
        //>> ST
        // IF DetailedGSTEntryBuffer."GST Assessable Value" <> 0 THEN
        //     DetailedGSTLedgerEntry."GST Amount" :=
        //       RoundGSTPrecision((DetailedGSTEntryBuffer."GST Amount (LCY)" / DetailedGSTEntryBuffer."GST Base Amount (LCY)") *
        //         DetailedGSTLedgerEntry."GST Base Amount" / 2)
        // ELSE
        //     DetailedGSTLedgerEntry."GST Amount" := RoundGSTPrecision(-1 * DetailedGSTEntryBuffer."GST Amount (LCY)" * QtyFactor / 2);

        // IF DetailedGSTEntryBuffer."GST Assessable Value" <> 0 THEN
        //     DetailedGSTLedgerEntry."Amount Loaded on Item" :=
        //       ConvertGSTAmountToLCY(
        //         CurrencyCode, DetailedGSTEntryBuffer."Amount Loaded on Item",
        //         CurrencyFactor, DetailedGSTLedgerEntry."Posting Date")
        // ELSE
        //     DetailedGSTLedgerEntry."Amount Loaded on Item" :=
        //       ConvertGSTAmountToLCY(
        //         CurrencyCode, DetailedGSTEntryBuffer."Amount Loaded on Item" * QtyFactor,
        //         CurrencyFactor, DetailedGSTLedgerEntry."Posting Date");
        //<< ST
        IF DetailedGSTEntryBuffer."Item Charge Assgn. Line No." <> 0 THEN
            QtyFactor := 1;
        DetailedGSTLedgerEntry."Remaining Base Amount" := DetailedGSTLedgerEntry."GST Base Amount";
        DetailedGSTLedgerEntry."Remaining GST Amount" := DetailedGSTLedgerEntry."GST Amount";
        DetailedGSTLedgerEntry."GST %" := DetailedGSTEntryBuffer."GST %" / 2;//vikas
        DetailedGSTLedgerEntry.Quantity := DetailedGSTEntryBuffer.Quantity * QtyFactor;
        DetailedGSTLedgerEntry."GST Rounding Type" := DetailedGSTEntryBuffer."GST Rounding Type";
        DetailedGSTLedgerEntry."GST Rounding Precision" := DetailedGSTEntryBuffer."GST Rounding Precision";
        DetailedGSTLedgerEntry."Input Service Distribution" := DetailedGSTEntryBuffer."Input Service Distribution";
        //>> ST
        // IF DetailedGSTLedgerEntry."GST Amount" > 0 THEN
        //     DetailedGSTLedgerEntry.Positive := TRUE;
        // DetailedGSTLedgerEntry."Original Doc. Type" := DetailedGSTLedgerEntry."Document Type";
        // DetailedGSTLedgerEntry."Original Doc. No." := DetailedGSTLedgerEntry."Document No.";
        // DetailedGSTLedgerEntry."User ID" := USERID;
        // DetailedGSTLedgerEntry."Transaction No." := TransactionNo;
        // DetailedGSTLedgerEntry.Cess := DetailedGSTEntryBuffer.Cess;
        // DetailedGSTLedgerEntry."Component Calc. Type" := DetailedGSTEntryBuffer."Component Calc. Type";
        // DetailedGSTLedgerEntry."Cess Amount Per Unit Factor" := DetailedGSTEntryBuffer."Cess Amt Per Unit Factor (LCY)";
        // DetailedGSTLedgerEntry."Cess UOM" := DetailedGSTEntryBuffer."Cess UOM";
        // DetailedGSTLedgerEntry."Cess Factor Quantity" := DetailedGSTEntryBuffer."Cess Factor Quantity";
        // DetailedGSTLedgerEntry.UOM := DetailedGSTEntryBuffer.UOM;
        //<< ST
    end;

    procedure GetNextGSTLedgerEntryNo(): Integer
    var
        GSTLedgerEntry: Record "GST Ledger Entry";
    begin
        GSTLedgerEntry.LOCKTABLE;
        IF GSTLedgerEntry.FINDLAST THEN
            EXIT(GSTLedgerEntry."Entry No." + 1);
        EXIT(1);
    end;

    procedure GetNextGSTDetailEntryNo(): Integer
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        DetailedGSTLedgerEntry.LOCKTABLE;
        IF DetailedGSTLedgerEntry.FINDLAST THEN
            EXIT(DetailedGSTLedgerEntry."Entry No." + 1);
        EXIT(1);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Detailed GST Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure UpdateDetailedGstLedgerEntryOnafterInsertEvent(var Rec: Record "Detailed GST Ledger Entry"; RunTrigger: Boolean)
    var
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnRunOnAfterPostInvoice, '', false, false)]
    local procedure OnRunOnAfterPostInvoice(var PurchaseHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var ReturnShipmentHeader: Record "Return Shipment Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PreviewMode: Boolean; var Window: Dialog; SrcCode: Code[10]; GenJnlLineDocType: Enum "Gen. Journal Document Type"; GenJnlLineDocNo: Code[20]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        GSTLedgerEntry: Record "GST Ledger Entry";
        TempGSTLedgerEntry: Record "GST Ledger Entry" temporary;
        GSTLedgerEntryInsert: Record "GST Ledger Entry";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        TempDetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry" temporary;
        DetailedGSTLedgerEntryInsert: Record "Detailed GST Ledger Entry";
        GenJournalLine: Record "Gen. Journal Line";
        NextEntryNo: Integer;
        BalacingAmount: Decimal;
        GeneralPostingSetup: record "General Posting Setup";
        GLAccount: Record "G/L Account";
        TempGSTPostingBuffer: Record "GST Posting Buffer" temporary;
        PurchInvLine: Record "Purch. Inv. Line";
    begin
        PurchInvLine.Reset();
        PurchInvLine.SetRange("Document No.", PurchInvHeader."No.");
        PurchInvLine.SetFilter("No.", '<>%1', '');
        PurchInvLine.SetRange("GST Credit", PurchInvLine."GST Credit"::Availment);
        if not PurchInvLine.FindFirst() then
            exit;

        //Fill TempGSTPostingBuffer
        GSTLedgerEntry.Reset();
        GSTLedgerEntry.SetRange("Document No.", PurchInvHeader."No.");
        if GSTLedgerEntry.FindSet() then
            repeat
                TempGSTLedgerEntry.TransferFields(GSTLedgerEntry);
                TempGSTLedgerEntry.Insert();
            until GSTLedgerEntry.Next() = 0;

        DetailedGSTLedgerEntry.Reset();
        DetailedGSTLedgerEntry.SetRange("Document No.", PurchInvHeader."No.");
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                PurchInvLine.GET(DetailedGSTLedgerEntry."Document No.", DetailedGSTLedgerEntry."Document Line No.");
                if PurchInvLine."GST Credit" = PurchInvLine."GST Credit"::Availment then begin
                    TempDetailedGSTLedgerEntry.init;
                    TempDetailedGSTLedgerEntry.TransferFields(DetailedGSTLedgerEntry);
                    TempDetailedGSTLedgerEntry.Insert();
                end;
            until DetailedGSTLedgerEntry.Next() = 0;

        TempDetailedGSTLedgerEntry.Reset();
        if TempDetailedGSTLedgerEntry.FindSet() then
            repeat
                PurchInvLine.Reset();
                PurchInvLine.SetRange("Document No.", TempGSTLedgerEntry."Document No.");
                PurchInvLine.SetFilter("No.", '<>%1', '');
                PurchInvLine.SetRange("GST Credit", PurchInvLine."GST Credit"::Availment);
                if not PurchInvLine.FindFirst() then
                    exit;

                PurchInvLine.GET(TempGSTLedgerEntry."Document No.", TempDetailedGSTLedgerEntry."Document Line No.");
                TempGSTPostingBuffer.Init();
                TempGSTPostingBuffer."Gen. Bus. Posting Group" := PurchInvLine."Gen. Bus. Posting Group";
                TempGSTPostingBuffer."Gen. Prod. Posting Group" := PurchInvLine."Gen. Prod. Posting Group";
                TempGSTPostingBuffer."Global Dimension 1 Code" := PurchInvLine."Shortcut Dimension 1 Code";
                TempGSTPostingBuffer."Global Dimension 2 Code" := PurchInvLine."Shortcut Dimension 2 Code";
                TempGSTPostingBuffer."Gen. Bus. Posting Group" := PurchInvLine."Gen. Bus. Posting Group";
                TempGSTPostingBuffer."Gen. Prod. Posting Group" := PurchInvLine."Gen. Prod. Posting Group";
                TempGSTPostingBuffer."GST Group Type" := PurchInvLine."GST Group Type";
                TempGSTPostingBuffer."GST Component Code" := TempDetailedGSTLedgerEntry."GST Component Code";
                TempGSTPostingBuffer.Type := TempDetailedGSTLedgerEntry.Type;
                TempGSTPostingBuffer."Account No." := TempDetailedGSTLedgerEntry."No.";
                TempGSTPostingBuffer."Dimension Set ID" := PurchInvLine."Dimension Set ID";
                if not TempGSTPostingBuffer.insert then;
            until TempDetailedGSTLedgerEntry.Next() = 0;

        TempDetailedGSTLedgerEntry.Reset();
        if TempDetailedGSTLedgerEntry.FindSet() then
            repeat
                PurchInvLine.GET(TempGSTLedgerEntry."Document No.", TempDetailedGSTLedgerEntry."Document Line No.");
                TempGSTPostingBuffer.Reset();
                TempGSTPostingBuffer."Gen. Bus. Posting Group" := PurchInvLine."Gen. Bus. Posting Group";
                TempGSTPostingBuffer."Gen. Prod. Posting Group" := PurchInvLine."Gen. Prod. Posting Group";
                TempGSTPostingBuffer."Global Dimension 1 Code" := PurchInvLine."Shortcut Dimension 1 Code";
                TempGSTPostingBuffer."Global Dimension 2 Code" := PurchInvLine."Shortcut Dimension 2 Code";
                TempGSTPostingBuffer."Gen. Bus. Posting Group" := PurchInvLine."Gen. Bus. Posting Group";
                TempGSTPostingBuffer."Gen. Prod. Posting Group" := PurchInvLine."Gen. Prod. Posting Group";
                TempGSTPostingBuffer."GST Group Type" := PurchInvLine."GST Group Type";
                TempGSTPostingBuffer."GST Component Code" := TempDetailedGSTLedgerEntry."GST Component Code";
                TempGSTPostingBuffer."Account No." := TempDetailedGSTLedgerEntry."No.";
                TempGSTPostingBuffer."Dimension Set ID" := PurchInvLine."Dimension Set ID";
                TempGSTPostingBuffer.Type := TempDetailedGSTLedgerEntry.Type;
                TempGSTPostingBuffer.find('=');
                TempGSTPostingBuffer."GST Amount" := TempGSTPostingBuffer."GST Amount" + TempDetailedGSTLedgerEntry."GST Amount" / 2;
                TempGSTPostingBuffer.Modify();
            until TempDetailedGSTLedgerEntry.Next() = 0;

        //Post GST Ledger Entry
        NextEntryNo := GetNextGSTLedgerEntryNo();

        // TempGSTPostingBuffer.Reset();
        // if TempGSTPostingBuffer.FindSet() then
        //     repeat
        //         TempDetailedGSTLedgerEntry.Reset();
        //         TempDetailedGSTLedgerEntry.SetRange("No.", TempGSTPostingBuffer."Account No.");
        //         TempDetailedGSTLedgerEntry.FindFirst();

        //         TempGSTLedgerEntry.RESET;
        //         //TempGSTLedgerEntry.SetRange(TempGSTLedgerEntry."Gen. Bus. Posting Group", TempGSTPostingBuffer."Gen. Bus. Posting Group");
        //         //TempGSTLedgerEntry.SetRange(TempGSTLedgerEntry."Gen. Prod. Posting Group", TempGSTPostingBuffer."Gen. Prod. Posting Group");
        //         //TempGSTLedgerEntry.SetRange("GST Component Code", TempGSTPostingBuffer."GST Component Code");
        //         TempGSTLedgerEntry.SetRange("Account No.", TempGSTPostingBuffer."Account No.");
        //         TempGSTLedgerEntry.FindFirst();

        //         GSTLedgerEntryInsert.init;
        //         GSTLedgerEntryInsert.TransferFields(TempGSTLedgerEntry);
        //         GSTLedgerEntryInsert."Entry No." := NextEntryNo;
        //         GSTLedgerEntryInsert."GST Amount" := -TempGSTLedgerEntry."GST Amount" / 2;
        //         GSTLedgerEntryInsert."GST Credit 50%" := true;
        //         GSTLedgerEntryInsert.Insert();
        //         NextEntryNo := NextEntryNo + 1;
        //     until TempGSTPostingBuffer.Next() = 0;

        TempGSTLedgerEntry.Reset();
        if TempGSTLedgerEntry.FindSet() then
            repeat
                GSTLedgerEntryInsert.init;
                GSTLedgerEntryInsert.TransferFields(TempGSTLedgerEntry);
                GSTLedgerEntryInsert."Entry No." := NextEntryNo;
                GSTLedgerEntryInsert."GST Amount" := -TempGSTLedgerEntry."GST Amount" / 2;
                GSTLedgerEntryInsert."GST Credit 50%" := true;
                GSTLedgerEntryInsert.Insert();
                NextEntryNo := NextEntryNo + 1;
            until TempGSTLedgerEntry.Next() = 0;

        // Insert DetailedGSTLedgerEntry
        NextEntryNo := GetNextGSTDetailEntryNo() - 1;
        TempDetailedGSTLedgerEntry.Reset();
        if TempDetailedGSTLedgerEntry.FindSet() then
            repeat
                DetailedGSTLedgerEntryInsert.init;
                DetailedGSTLedgerEntryInsert.TransferFields(TempDetailedGSTLedgerEntry);
                NextEntryNo := NextEntryNo + 1;
                DetailedGSTLedgerEntryInsert."Entry No." := NextEntryNo;
                DetailedGSTLedgerEntryInsert."GST Amount" := -TempDetailedGSTLedgerEntry."GST Amount" / 2;
                DetailedGSTLedgerEntryInsert."GST Credit 50%" := true;
                DetailedGSTLedgerEntryInsert.Insert();

                GLAccount.Get(TempDetailedGSTLedgerEntry."G/L Account No.");
                PurchInvLine.GET(TempDetailedGSTLedgerEntry."Document No.", TempDetailedGSTLedgerEntry."Document Line No.");
                //GeneralPostingSetup.Get(PurchInvHeader."Gen. Bus. Posting Group", GLAccount."Gen. Prod. Posting Group");

                GenJournalLine.init;
                GenJournalLine.validate("Posting Date", TempDetailedGSTLedgerEntry."Posting Date");
                GenJournalLine.validate("Document Type", TempDetailedGSTLedgerEntry."Document Type");
                GenJournalLine.validate("Document No.", TempDetailedGSTLedgerEntry."Document No.");
                // if TempDetailedGSTLedgerEntry.Type = TempDetailedGSTLedgerEntry.Type::"G/L Account" then
                //     GenJournalLine.validate("Account Type", GenJournalLine."Account Type"::"G/L Account")
                // else if TempDetailedGSTLedgerEntry.Type = TempDetailedGSTLedgerEntry.Type::"Fixed Asset" then
                //     GenJournalLine.validate("Account Type", GenJournalLine."Account Type"::"Fixed Asset");

                GenJournalLine.validate("Account Type", GenJournalLine."Account Type"::"G/L Account");
                GenJournalLine.validate("Account No.", TempDetailedGSTLedgerEntry."G/L Account No.");//vikas
                GenJournalLine.validate(Amount, -TempDetailedGSTLedgerEntry."GST Amount" / 2);
                GenJournalLine.validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
                //GenJournalLine.validate("Bal. Account No.", GeneralPostingSetup."Purch. Account");
                //GenJournalLine.validate("Bal. Account No.", '10102002');
                GenJournalLine.validate("Shortcut Dimension 1 Code", PurchInvHeader."Shortcut Dimension 1 Code");
                GenJournalLine.validate("Shortcut Dimension 2 Code", PurchInvHeader."Shortcut Dimension 2 Code");
                GenJournalLine.validate("Dimension Set ID", PurchInvHeader."Dimension Set ID");
                GenJournalLine.validate("GSTCredit 50%", true);
                if TempGSTPostingBuffer.Type = TempGSTPostingBuffer.Type::"Fixed Asset" then
                    GenJournalLine.validate("FA Posting Type", GenJournalLine."FA Posting Type"::"Acquisition Cost");
                GenJnlPostLine.RunWithCheck(GenJournalLine);
            until TempDetailedGSTLedgerEntry.Next() = 0;

        TempGSTPostingBuffer.Reset();
        if TempGSTPostingBuffer.FindSet() then
            repeat
                GenJournalLine.init;
                GenJournalLine.validate("Posting Date", TempDetailedGSTLedgerEntry."Posting Date");
                GenJournalLine.validate("Document Type", TempDetailedGSTLedgerEntry."Document Type");
                GenJournalLine.validate("Document No.", TempDetailedGSTLedgerEntry."Document No.");
                if TempGSTPostingBuffer.Type = TempGSTPostingBuffer.Type::"G/L Account" then
                    GenJournalLine.validate("Account Type", GenJournalLine."Account Type"::"G/L Account")
                else if TempGSTPostingBuffer.Type = TempGSTPostingBuffer.Type::"Fixed Asset" then
                    GenJournalLine.validate("Account Type", GenJournalLine."Account Type"::"Fixed Asset");
                GenJournalLine.validate("Account No.", TempGSTPostingBuffer."Account No.");
                GenJournalLine.validate(Amount, TempGSTPostingBuffer."GST Amount");
                GenJournalLine.validate("Shortcut Dimension 1 Code", PurchInvHeader."Shortcut Dimension 1 Code");
                GenJournalLine.validate("Shortcut Dimension 2 Code", PurchInvHeader."Shortcut Dimension 2 Code");
                GenJournalLine.validate("Dimension Set ID", PurchInvHeader."Dimension Set ID");
                GenJournalLine.validate("GSTCredit 50%", true);
                GenJournalLine.validate("Gen. Bus. Posting Group", TempGSTPostingBuffer."Gen. Bus. Posting Group");
                GenJournalLine.validate("Gen. Prod. Posting Group", TempGSTPostingBuffer."Gen. Prod. Posting Group");
                if (GenJournalLine."Gen. Prod. Posting Group" <> '') or (GenJournalLine."Gen. Bus. Posting Group" <> '') then
                    GenJournalLine.validate("Gen. Posting Type", GenJournalLine."Gen. Posting Type"::Purchase);
                GenJournalLine.validate("System-Created Entry", true);
                if TempGSTPostingBuffer.Type = TempGSTPostingBuffer.Type::"Fixed Asset" then
                    GenJournalLine.validate("FA Posting Type", GenJournalLine."FA Posting Type"::"Acquisition Cost");
                GenJnlPostLine.RunWithCheck(GenJournalLine);
            until TempGSTPostingBuffer.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterCreateFAAcquisitionLines, '', false, false)]
    local procedure OnAfterCreateFAAcquisitionLines(var FAGenJournalLine: Record "Gen. Journal Line"; GenJournalLine: Record "Gen. Journal Line"; var BalancingGenJournalLine: Record "Gen. Journal Line")
    begin
        FAGenJournalLine."GSTCredit 50%" := GenJournalLine."GSTCredit 50%";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Jnl.-Post Line", OnBeforePostFixedAssetFromGenJnlLine, '', false, false)]
    local procedure OnBeforePostFixedAssetFromGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; var FALedgerEntry: Record "FA Ledger Entry"; FAAmount: Decimal; VATAmount: Decimal; GLRegisterNo: Integer)
    begin
        FALedgerEntry."GSTCredit 50%" := GenJournalLine."GSTCredit 50%";
    end;
}