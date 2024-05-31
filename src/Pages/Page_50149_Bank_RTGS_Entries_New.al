/*Page 50149 "Bank RTGS Entries-New"
{
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Bank RTGS Entries-New";
    SourceTableView = sorting("Bank No", "Line No")
                      where("Exported to File" = filter(false));

    layout
    {
        area(content)
        {
            group(Control1000000039)
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
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = Basic;
                }
                field("Corporate Code"; Rec."Corporate Code")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Ref No"; Rec."Customer Ref No")
                {
                    ApplicationArea = Basic;
                }
                field("Debit Bank Account No"; Rec."Debit Bank Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Amount"; Rec."Transaction Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Amount(LCY)"; Rec."Transaction Amount(LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Name"; Rec."Beneficiary Name")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Bank Account No"; Rec."Vendor Bank Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Code"; Rec."Beneficiary Code")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Account Type"; Rec."Beneficiary Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Address1"; Rec."Beneficiary Address1")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Address2"; Rec."Beneficiary Address2")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Address3"; Rec."Beneficiary Address3")
                {
                    ApplicationArea = Basic;
                }
                field("Benficiary City"; Rec."Benficiary City")
                {
                    ApplicationArea = Basic;
                }
                field("Benficiary State"; Rec."Benficiary State")
                {
                    ApplicationArea = Basic;
                }
                field("Benficiary Pin Code"; Rec."Benficiary Pin Code")
                {
                    ApplicationArea = Basic;
                }
                field("Benficiary IFSC Code"; Rec."Benficiary IFSC Code")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Bank Name"; Rec."Beneficiary Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field("Base Code"; Rec."Base Code")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque No"; Rec."Cheque No")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    ApplicationArea = Basic;
                }
                field("Payable Location"; Rec."Payable Location")
                {
                    ApplicationArea = Basic;
                }
                field("Print Location"; Rec."Print Location")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Email address 1"; Rec."Beneficiary Email address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Email address 2"; Rec."Beneficiary Email address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Mobile Number"; Rec."Beneficiary Mobile Number")
                {
                    ApplicationArea = Basic;
                }
                field("Corp Batch No"; Rec."Corp Batch No")
                {
                    ApplicationArea = Basic;
                }
                field("Company Code"; Rec."Company Code")
                {
                    ApplicationArea = Basic;
                }
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = Basic;
                }
                field("Extra 1"; Rec."Extra 1")
                {
                    ApplicationArea = Basic;
                }
                field("Extra 2"; Rec."Extra 2")
                {
                    ApplicationArea = Basic;
                }
                field("Extra 3"; Rec."Extra 3")
                {
                    ApplicationArea = Basic;
                }
                field("Extra 4"; Rec."Extra 4")
                {
                    ApplicationArea = Basic;
                }
                field("Extra 5"; Rec."Extra 5")
                {
                    ApplicationArea = Basic;
                }
                field(PayType; Rec.PayType)
                {
                    ApplicationArea = Basic;
                }
                field(CORP_EMAIL_ADDR; Rec.CORP_EMAIL_ADDR)
                {
                    ApplicationArea = Basic;
                }
                field("User Department"; Rec."User Department")
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
                    LCPgBankLedgerEntriesCopy: Page "Bank Account Ledger Entries";
                    LCRecBankLedgerEntries: Record "Bank Account Ledger Entry";
                begin
                    LCRecBankLedgerEntries.SetRange("Bank Account No.", GlbBankAccountNo);
                    LCRecBankLedgerEntries.SetRange("Document Type", LCRecBankLedgerEntries."document type"::Payment);
                    LCRecBankLedgerEntries.SetFilter(Amount, '<%1', 0);
                    LCRecBankLedgerEntries.SetRange("RTGS Entry Exist", false);
                    LCPgBankLedgerEntriesCopy.SetTableview(LCRecBankLedgerEntries);
                    LCPgBankLedgerEntriesCopy.FnSetBankAccountNo(GlbBankAccountNo);
                    //LCPgBankLedgerEntriesCopy.LOOKUPMODE:=TRUE;
                    LCPgBankLedgerEntriesCopy.RunModal;
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
                begin
                    if not Confirm('Do you want export RTGS file?') then
                        Error('');
                    Clear(GlbFile);
                    LCRecBankAccount.Get(GlbBankAccountNo);
                    LCRecBankAccount.TestField("RTGS File Path");
                    GlbFilePath := LCRecBankAccount."RTGS File Path" + 'RTGS File_' + Format(CurrentDatetime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + '.text';
                    if FILE.Exists(GlbFilePath) then
                        FILE.Erase(GlbFilePath);

                    GlbFile.TextMode(true);
                    GlbFile.WriteMode(true);
                    GlbFile.Create(GlbFilePath);
                    GlbFile.Close;

                    if rec.FindSet then begin
                        repeat
                            FnCheckMandatoryFields(Rec);
                            if rec.PayType = rec.Paytype::CUST then
                                LCPayType := 'CUST';
                            if rec.PayType = rec.Paytype::DIST then
                                LCPayType := 'DIST';
                            if rec.PayType = rec.Paytype::INTN then
                                LCPayType := 'INTN';
                            if rec.PayType = rec.Paytype::MERC then
                                LCPayType := 'MERC';
                            if rec.PayType = rec.Paytype::VEND then
                                LCPayType := 'VEND';
                            GlbFile.Open(GlbFilePath);
                            GlbFile.Write('P' + '^' + rec."Payment Mode" + '^' + rec."Corporate Code" + '^' + rec."Customer Ref No" + '^' + rec."Debit Bank Account No" + '^' + Format(Today, 0, '<Year4><Month,2><Day,2>')
                            + '^' + rec."Currency Code" + '^' + Format(rec."Transaction Amount(LCY)") + '^' + rec."Beneficiary Name" + '^' + rec."Beneficiary Code" + '^' + rec."Vendor Bank Account No" + '^' + rec."Beneficiary Account Type" + '^'
                            + rec."Beneficiary Address1" + '^' + rec."Beneficiary Address2" + '^' + rec."Beneficiary Address3" + '^' + rec."Benficiary City" + '^' + rec."Benficiary State" + '^' + rec."Benficiary Pin Code" + '^'
                            + rec."Benficiary IFSC Code" + '^' + rec."Beneficiary Bank Name" + '^' + rec."Base Code" + '^' + rec."Cheque No" + '^' + Format(rec."Cheque Date") + '^' + rec."Payable Location" + '^' + rec."Print Location" + '^'
                            + rec."Beneficiary Email address 1" + '^' + rec."Beneficiary Email address 2" + '^' + rec."Beneficiary Mobile Number" + '^' + rec."Corp Batch No" + '^' + rec."Company Code" + '^' + rec."Product Code" + '^'
                            + rec."Extra 1" + '^' + rec."Extra 2" + '^' + rec."Extra 3" + '^' + rec."Extra 4" + '^' + rec."Extra 5" + '^' + LCPayType + '^' + rec.CORP_EMAIL_ADDR + '^' + Format(Today, 0, '<Year4><Month,2><Day,2>') + '^'
                            + UserId + '^');
                            if LCRecVendorLedgerEntry.Get(rec."Vendor Ledger Entry No") then begin
                                FnGetAppliedVendEntries(LCRecVendorLedgerEntryTemp, LCRecVendorLedgerEntry, true);
                            end;
                            LCRecVendorLedgerEntryTemp.Reset;
                            if LCRecVendorLedgerEntryTemp.FindSet then begin
                                repeat
                                    FnGetTaxAmount(LCTaxAmt, LCRecVendorLedgerEntryTemp."Document No.", LCLineAmount);
                                    GlbFile.Write('I' + '^' + LCRecVendorLedgerEntryTemp."Document No." + '^' + Format(LCRecVendorLedgerEntryTemp."Posting Date") + '^' + Format(LCLineAmount) + '^' +
                                    Format(LCTaxAmt) + '^' + '0' + '^' + Format(LCRecVendorLedgerEntryTemp."Amount (LCY)"));
                                until LCRecVendorLedgerEntryTemp.Next = 0;
                            end;
                            rec."Exported to File" := true;
                            rec."Export File Name" := GlbFilePath;
                        until rec.Next = 0;
                        GlbFile.Close;
                    end;
                    Message('Process complete');
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
        GlbFilePath: Text;
        GlbFile: File;

    local procedure FnCheckMandatoryFields(LCRTGSEntries: Record "Bank RTGS Entries-New")
    begin
        if LCRTGSEntries."Payment Mode" = '' then begin
            if FILE.Exists(GlbFilePath) then
                FILE.Erase(GlbFilePath);
            Error('Payment mode cannot be blank for Line no %1', LCRTGSEntries."Line No");
        end;
        if LCRTGSEntries."Corporate Code" = '' then begin
            if FILE.Exists(GlbFilePath) then
                FILE.Erase(GlbFilePath);
            Error('Corporate code cannot be blank for Line no %1', LCRTGSEntries."Line No");
        end;
        if LCRTGSEntries."Customer Ref No" = '' then begin
            if FILE.Exists(GlbFilePath) then
                FILE.Erase(GlbFilePath);
            Error('Customer reference no cannot be blank for Line no %1', LCRTGSEntries."Line No");
        end;
        if LCRTGSEntries."Debit Bank Account No" = '' then begin
            if FILE.Exists(GlbFilePath) then
                FILE.Erase(GlbFilePath);
            Error('Debit Bank Account No cannot be blank for Line no %1', LCRTGSEntries."Line No");
        end;
        if LCRTGSEntries."Currency Code" = '' then begin
            if FILE.Exists(GlbFilePath) then
                FILE.Erase(GlbFilePath);
            Error('Transaction currency code cannot be blank for Line no %1', LCRTGSEntries."Line No");
        end;
        if LCRTGSEntries."Transaction Amount(LCY)" = 0 then begin
            if FILE.Exists(GlbFilePath) then
                FILE.Erase(GlbFilePath);
            Error('Transaction amount cannot be blank for Line no %1', LCRTGSEntries."Line No");
        end;
        if LCRTGSEntries."Beneficiary Name" = '' then begin
            if FILE.Exists(GlbFilePath) then
                FILE.Erase(GlbFilePath);
            Error('Beneficiary Name cannot be blank for Line no %1', LCRTGSEntries."Line No");
        end;
        if LCRTGSEntries."Beneficiary Code" = '' then begin
            if FILE.Exists(GlbFilePath) then
                FILE.Erase(GlbFilePath);
            Error('Beneficiary code cannot be blank for Line no %1', LCRTGSEntries."Line No");
        end;
        if LCRTGSEntries."Vendor Bank Account No" = '' then begin
            if FILE.Exists(GlbFilePath) then
                FILE.Erase(GlbFilePath);
            Error('Beneficiary bank account no cannot be blank for Line no %1', LCRTGSEntries."Line No");
        end;
        if LCRTGSEntries."Beneficiary Account Type" = '' then begin
            if FILE.Exists(GlbFilePath) then
                FILE.Erase(GlbFilePath);
            Error('Beneficiary Account Type cannot be blank for Line no %1', LCRTGSEntries."Line No");
        end;
        if LCRTGSEntries."Benficiary IFSC Code" = '' then begin
            if FILE.Exists(GlbFilePath) then
                FILE.Erase(GlbFilePath);
            Error('Benficiary IFSC Code cannot be blank for Line no %1', LCRTGSEntries."Line No");
        end;
        if LCRTGSEntries."Base Code" = '' then begin
            if FILE.Exists(GlbFilePath) then
                FILE.Erase(GlbFilePath);
            Error('Base code cannot be blank for Line no %1', LCRTGSEntries."Line No");
        end;
        if LCRTGSEntries."Cheque No" = '' then begin
            if FILE.Exists(GlbFilePath) then
                FILE.Erase(GlbFilePath);
            Error('Cheque no cannot be blank for Line no %1', LCRTGSEntries."Line No");
        end;
        if LCRTGSEntries."Cheque Date" = 0D then begin
            if FILE.Exists(GlbFilePath) then
                FILE.Erase(GlbFilePath);
            Error('Cheque date cannot be blank for Line no %1', LCRTGSEntries."Line No");
        end;
    end;


    procedure FnGetAppliedVendEntries(var AppliedVendLedgEntryTemp: Record "Vendor Ledger Entry" temporary; VendLedgEntry: Record "Vendor Ledger Entry"; UseLCY: Boolean)
    var
        ClosingVendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        AppliedDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        // Temporary Table, AppliedVendLedgEntry, to be filled in with everything that VendLedgEntry applied to.
        // Note that within AppliedVendLedgEntry, the "Amount to Apply" field will be filled in with the Amount Applied.
        // IF UseLCY is TRUE, Amount Applied will be in LCY, else it will be in the application currency


        AppliedVendLedgEntryTemp.Reset;
        AppliedVendLedgEntryTemp.DeleteAll;

        DtldVendLedgEntry.SetCurrentkey("Vendor Ledger Entry No.");
        DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgEntry."Entry No.");
        DtldVendLedgEntry.SetRange(Unapplied, false);
        if DtldVendLedgEntry.Find('-') then
            repeat
                if DtldVendLedgEntry."Vendor Ledger Entry No." =
                   DtldVendLedgEntry."Applied Vend. Ledger Entry No."
                then begin
                    AppliedDtldVendLedgEntry.Init;
                    AppliedDtldVendLedgEntry.SetCurrentkey("Applied Vend. Ledger Entry No.", "Entry Type");
                    AppliedDtldVendLedgEntry.SetRange(
                      "Applied Vend. Ledger Entry No.", DtldVendLedgEntry."Applied Vend. Ledger Entry No.");
                    AppliedDtldVendLedgEntry.SetRange(
                      "Entry Type", AppliedDtldVendLedgEntry."entry type"::Application);
                    AppliedDtldVendLedgEntry.SetRange(Unapplied, false);
                    if AppliedDtldVendLedgEntry.Find('-') then
                        repeat
                            if AppliedDtldVendLedgEntry."Vendor Ledger Entry No." <>
                               AppliedDtldVendLedgEntry."Applied Vend. Ledger Entry No."
                            then begin
                                if ClosingVendLedgEntry.Get(AppliedDtldVendLedgEntry."Vendor Ledger Entry No.") then begin
                                    AppliedVendLedgEntryTemp := ClosingVendLedgEntry;
                                    if UseLCY then
                                        AppliedVendLedgEntryTemp."Amount to Apply" := -AppliedDtldVendLedgEntry."Amount (LCY)"
                                    else
                                        AppliedVendLedgEntryTemp."Amount to Apply" := -AppliedDtldVendLedgEntry.Amount;
                                    if AppliedVendLedgEntryTemp.Insert then;
                                    AppliedVendLedgEntryTemp."Posting Date" := AppliedDtldVendLedgEntry."Posting Date";
                                end;
                            end;
                        until AppliedDtldVendLedgEntry.Next = 0;
                end else begin
                    if ClosingVendLedgEntry.Get(DtldVendLedgEntry."Applied Vend. Ledger Entry No.") then begin
                        AppliedVendLedgEntryTemp := ClosingVendLedgEntry;
                        if UseLCY then
                            AppliedVendLedgEntryTemp."Amount to Apply" := DtldVendLedgEntry."Amount (LCY)"
                        else
                            AppliedVendLedgEntryTemp."Amount to Apply" := DtldVendLedgEntry.Amount;
                        if AppliedVendLedgEntryTemp.Insert then;
                        AppliedVendLedgEntryTemp."Posting Date" := DtldVendLedgEntry."Posting Date";
                    end;
                end;
            until DtldVendLedgEntry.Next = 0;

        if VendLedgEntry."Closed by Entry No." <> 0 then begin
            if ClosingVendLedgEntry.Get(VendLedgEntry."Closed by Entry No.") then begin
                AppliedVendLedgEntryTemp := ClosingVendLedgEntry;
                if UseLCY then
                    AppliedVendLedgEntryTemp."Amount to Apply" := -VendLedgEntry."Closed by Amount (LCY)"
                else
                    AppliedVendLedgEntryTemp."Amount to Apply" := -VendLedgEntry."Closed by Amount";
                if AppliedVendLedgEntryTemp.Insert then;
                AppliedVendLedgEntryTemp."Posting Date" := VendLedgEntry."Posting Date";
            end;
        end;

        ClosingVendLedgEntry.Reset;
        ClosingVendLedgEntry.SetCurrentkey("Closed by Entry No.");
        ClosingVendLedgEntry.SetRange("Closed by Entry No.", VendLedgEntry."Entry No.");
        if ClosingVendLedgEntry.Find('-') then
            repeat
                AppliedVendLedgEntryTemp := ClosingVendLedgEntry;
                if UseLCY then
                    AppliedVendLedgEntryTemp."Amount to Apply" := ClosingVendLedgEntry."Closed by Amount (LCY)"
                else
                    AppliedVendLedgEntryTemp."Amount to Apply" := ClosingVendLedgEntry."Closed by Amount";
                if AppliedVendLedgEntryTemp.Insert then;
            until ClosingVendLedgEntry.Next = 0;
    end;

    local procedure FnGetTaxAmount(var LCTaxAmt: Decimal; LCInvDocumentNo: Code[20]; var LCLineAmount: Decimal): Decimal
    var
        LCRecPostedSInvLine: Record "Sales Invoice Line";
    begin
        LCRecPostedSInvLine.SetRange("Document No.", LCInvDocumentNo);
        if LCRecPostedSInvLine.FindSet then begin
            repeat
                LCTaxAmt += LCRecPostedSInvLine."Tax Amount";
                LCLineAmount += LCRecPostedSInvLine."Line Amount";
            until LCRecPostedSInvLine.Next = 0;
        end;
    end;
}
*/
