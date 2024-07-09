Page 50150 "Bank Ledger Entries Copy-New"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    Permissions = TableData "Bank Account Ledger Entry" = rimd;
    SourceTable = "Bank Account Ledger Entry";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Acc. Posting Group"; Rec."Bank Acc. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Our Contact Code"; Rec."Our Contact Code")
                {
                    ApplicationArea = Basic;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = Basic;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic;
                }
                field(Positive; Rec.Positive)
                {
                    ApplicationArea = Basic;
                }
                field("Closed by Entry No."; Rec."Closed by Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Closed at Date"; Rec."Closed at Date")
                {
                    ApplicationArea = Basic;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = Basic;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = Basic;
                }
                field("Statement Status"; Rec."Statement Status")
                {
                    ApplicationArea = Basic;
                }
                field("Statement No."; Rec."Statement No.")
                {
                    ApplicationArea = Basic;
                }
                field("Statement Line No."; Rec."Statement Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = Basic;
                }
                field("Reversed by Entry No."; Rec."Reversed by Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Reversed Entry No."; Rec."Reversed Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Check Ledger Entries"; Rec."Check Ledger Entries")
                {
                    ApplicationArea = Basic;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = Basic;
                }
                /*   field("Location Code"; Rec."Location Code")
                   {
                       ApplicationArea = Basic;
                   }
                   */
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    ApplicationArea = Basic;
                }
                field("Stale Cheque"; Rec."Stale Cheque")
                {
                    ApplicationArea = Basic;
                }
                field("Stale Cheque Expiry Date"; Rec."Stale Cheque Expiry Date")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque Stale Date"; Rec."Cheque Stale Date")
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
            action("&Copy Bank Ledger Entries")
            {
                ApplicationArea = Basic;
                Caption = '&Copy Bank Ledger Entries';
                Image = CopyWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if not Confirm('Do you want copy bank entries?') then
                        Error('');

                    if not GlbPayPro then
                        FnCopyBankLedgerentries
                    else
                        FnCopyPayProBankLedgerentries;

                    Message('Process complete');
                end;
            }
            action("&Copy Bank Contra Entris")
            {
                ApplicationArea = Basic;
                Caption = '&Copy Bank Contra Entris';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if not Confirm('Do you want copy bank Contra entries?') then
                        Error('');

                    if not GlbPayPro then
                        FnCopyBankContra
                    else
                        FnCopyPayProBankContra;

                    Message('Process complete');
                end;
            }
        }
    }

    var
        GlbBankNo: Code[20];
        GlbPayPro: Boolean;


    procedure FnSetBankAccountNo(LCBankNo: Code[20])
    begin
        GlbBankNo := LCBankNo;
    end;

    local procedure FnCopyBankLedgerentries()
    var
        LCRecBankLedgerEntriesCopy: Record "Bank Account Ledger Entry";
        LCRecBankRTGSEntries: Record "Bank RTGS Entries-New";
        LCLineNo: Integer;
        LCRecVendLedgerEntries: Record "Vendor Ledger Entry";
        LCRecCompanyInfo: Record "Company Information";
    begin
        LCRecCompanyInfo.Get;
        LCRecBankRTGSEntries.SetRange("Bank No", GlbBankNo);
        if LCRecBankRTGSEntries.FindLast then
            LCLineNo := LCRecBankRTGSEntries."Line No" + 1
        else
            LCLineNo := 1;

        CurrPage.SetSelectionFilter(LCRecBankLedgerEntriesCopy);

        if LCRecBankLedgerEntriesCopy.FindSet then begin
            repeat
                LCRecBankRTGSEntries.Init;
                LCRecBankRTGSEntries."Bank No" := GlbBankNo;
                LCRecBankRTGSEntries."Line No" := LCLineNo;
                LCRecBankRTGSEntries."Customer Ref No" := LCRecBankLedgerEntriesCopy."Document No.";
                LCRecBankRTGSEntries."Debit Bank Account No" := GlbBankNo;
                LCRecBankRTGSEntries."Transaction Amount" := LCRecBankLedgerEntriesCopy.Amount;
                LCRecBankRTGSEntries."Transaction Amount(LCY)" := LCRecBankLedgerEntriesCopy."Amount (LCY)";
                LCRecBankRTGSEntries."Cheque No" := LCRecBankLedgerEntriesCopy."Cheque No.";
                LCRecBankRTGSEntries."Cheque Date" := LCRecBankLedgerEntriesCopy."Cheque Date";
                LCRecBankRTGSEntries.CORP_EMAIL_ADDR := LCRecCompanyInfo."Corporate Email ID";
                LCRecVendLedgerEntries.SetRange("Document No.", LCRecBankLedgerEntriesCopy."Document No.");
                if LCRecVendLedgerEntries.FindFirst then
                    LCRecBankRTGSEntries."Vendor Ledger Entry No" := LCRecVendLedgerEntries."Entry No.";
                //Update Vendor RTGS details
                FnUpdateVendorInformation(LCRecBankRTGSEntries, LCRecBankRTGSEntries."Vendor Ledger Entry No");
                //Update Vendor RTGS details
                LCRecBankRTGSEntries."Bank Ledger Entry No" := LCRecBankLedgerEntriesCopy."Entry No.";
                LCRecBankRTGSEntries.Insert;
                LCLineNo += 1;
                LCRecBankLedgerEntriesCopy."RTGS Entry Exist" := true;
                LCRecBankLedgerEntriesCopy.Modify;
            until LCRecBankLedgerEntriesCopy.Next = 0;
        end;
    end;

    local procedure FnUpdateVendorInformation(var LCRecRTGSEntries: Record "Bank RTGS Entries-New"; LCRecVendLedgerEntryNo: Integer)
    var
        LCRecVendorLedgerEntries: Record "Vendor Ledger Entry";
        LCRecVendor: Record Vendor;
        LCRecVendBankAccount: Record "Vendor Bank Account";
    begin
        if LCRecVendorLedgerEntries.Get(LCRecVendLedgerEntryNo) then begin
            if LCRecVendor.Get(LCRecVendorLedgerEntries."Vendor No.") then begin
                LCRecRTGSEntries."Beneficiary Name" := LCRecVendor.Name;
                LCRecRTGSEntries."Beneficiary Code" := LCRecVendor."No.";
                LCRecRTGSEntries."Beneficiary Address1" := LCRecVendor.Address;
                LCRecRTGSEntries."Beneficiary Address2" := LCRecVendor."Address 2";
                LCRecRTGSEntries."Beneficiary Address3" := LCRecVendor."Address 3";
                LCRecRTGSEntries."Benficiary City" := LCRecVendor.City;
                LCRecRTGSEntries."Benficiary State" := LCRecVendor."State Code";
                LCRecRTGSEntries."Benficiary Pin Code" := LCRecVendor."Post Code";
                LCRecRTGSEntries."Beneficiary Email address 1" := LCRecVendor."E-Mail";
                LCRecRTGSEntries."Beneficiary Email address 2" := LCRecVendor."E-Mail 2";
                LCRecRTGSEntries."Beneficiary Mobile Number" := LCRecVendor."Mobile No";
                LCRecRTGSEntries."User Department" := LCRecVendor."Shortcut Dimension 3";

                if LCRecVendor."Currency Code" <> '' then
                    LCRecRTGSEntries."Currency Code" := LCRecVendor."Currency Code"
                else
                    LCRecRTGSEntries."Currency Code" := 'INR';
                //Capturing vendors Bank details
                Clear(LCRecVendBankAccount);
                LCRecVendBankAccount.Reset;
                LCRecVendBankAccount.SetRange("Vendor No.", LCRecVendor."No.");
                LCRecVendBankAccount.SetRange(Code, LCRecVendorLedgerEntries."Recipient Bank Account");
                if LCRecVendBankAccount.FindFirst then begin
                    //CCIT-vikas
                    // LCRecRTGSEntries."Beneficiary Name":= LCRecVendBankAccount.Name;
                    LCRecRTGSEntries."Vendor Bank Account No" := LCRecVendBankAccount.Code;
                    LCRecRTGSEntries."Benficiary IFSC Code" := LCRecVendBankAccount.IFSC;
                    LCRecRTGSEntries."Beneficiary Bank Name" := LCRecVendBankAccount.Name;
                end;
                //Capturing vendors Bank details
            end;
        end;
    end;


    procedure FunSetPayProFlag(LCPayPro: Boolean)
    begin
        GlbPayPro := LCPayPro;
    end;

    local procedure FnCopyPayProBankLedgerentries()
    var
        LCRecBankLedgerEntriesCopy1: Record "Bank Account Ledger Entry";
        LCRecBankPayProEntries1: Record "Bank Pay Pro Entries-New";
        LCLineNo: Integer;
        LCRecVendLedgerEntries: Record "Vendor Ledger Entry";
        LCRecBankAccount: Record "Bank Account";
        LCRecBankAcc: Record "Bank Account";
        LCVenLedEntry: Record "Vendor Ledger Entry";
        VLE2: Record "Vendor Ledger Entry";
        LCRecPPI: Record "Purch. Inv. Header";
        LCRecPurchInv: Record "Purch. Inv. Line";
        AppliedInvNo: Code[20];
        LCRecVendBankAccount: Record "Vendor Bank Account";
        VLE3: Record "Vendor Ledger Entry";
        LCRecVendor: Record Vendor;
        Str: Text;
        Position: Integer;
        Length: Integer;
        NewStr: Text;
        RecVLE: Record "Vendor Ledger Entry";
        RecBALE: Record "Bank Account Ledger Entry";
        RecParty: Record Party;
    begin
        //CCIT AN 02012023 //Changes
        LCRecBankPayProEntries1.SetRange("Bank No", GlbBankNo);
        if LCRecBankPayProEntries1.FindLast then
            LCLineNo := LCRecBankPayProEntries1."Line No" + 1
        else
            LCLineNo := 1;
        CurrPage.SetSelectionFilter(LCRecBankLedgerEntriesCopy1);
        Clear(LCRecBankPayProEntries1);
        if LCRecBankLedgerEntriesCopy1.FindSet then begin
            repeat
                LCRecBankPayProEntries1."Bank No" := GlbBankNo;
                LCRecBankPayProEntries1."Line No" := LCLineNo;
                LCRecBankPayProEntries1.Amount := Abs(LCRecBankLedgerEntriesCopy1."Amount (LCY)");
                LCRecBankPayProEntries1."Value Date" := LCRecBankLedgerEntriesCopy1."Posting Date";
                LCRecBankPayProEntries1."Instrument Date" := LCRecBankLedgerEntriesCopy1."Cheque Date";
                LCRecVendLedgerEntries.SetRange("Document No.", LCRecBankLedgerEntriesCopy1."Document No.");
                if LCRecVendLedgerEntries.FindFirst then
                    LCRecBankPayProEntries1."Vendor Ledger Entry No" := LCRecVendLedgerEntries."Entry No.";
                //New 14022023
                LCVenLedEntry.Reset();
                LCVenLedEntry.SetRange("Document No.", LCRecBankLedgerEntriesCopy1."Document No.");
                LCVenLedEntry.SetRange("Document Type", LCVenLedEntry."document type"::Payment);
                if LCVenLedEntry.FindFirst() then begin
                    LCRecBankPayProEntries1."Bene Account Number" := LCVenLedEntry."Bank Account No.";
                    LCRecBankPayProEntries1."Receiver IFSC" := LCVenLedEntry."Bank Account IFSC";
                    //LCRecBankPayProEntries1."Phone No":=LCRecVendBankAccount."Phone No.";
                    //LCRecBankPayProEntries1."Print Branch":=LCRecVendBankAccount."Bank Branch No.";
                    LCRecBankPayProEntries1."Beneficiary Name" := LCVenLedEntry."Bank Account Name";
                    //LCRecBankPayProEntries1."Receiver A/c type" := ;
                    LCRecBankPayProEntries1."Email ID of beneficiary" := LCVenLedEntry."Bank Account E-Mail";
                    if LCRecVendor.Get(LCVenLedEntry."Vendor No.") then begin
                        LCRecBankPayProEntries1."Beneficiary Address 1" := LCRecVendor.Address;
                        LCRecBankPayProEntries1."Beneficiary Address 2" := LCRecVendor."Address 2";
                        LCRecBankPayProEntries1."Beneficiary Address 3" := LCRecVendor."Address 3";
                        LCRecBankPayProEntries1."Beneficiary City" := LCRecVendor.City;
                        LCRecBankPayProEntries1."Beneficiary State" := LCRecVendor."State Code";
                        LCRecBankPayProEntries1."PIN Code" := LCRecVendor."Post Code";
                        Str := LCRecVendor."Payment Method Code";  //CCIT AN For Conver str lenght into 1
                        Position := 1;
                        Length := 1;
                        NewStr := CopyStr(Str, Position, Length);
                        LCRecBankPayProEntries1."Payment Method identifier" := NewStr;
                        if Abs(LCRecBankPayProEntries1.Amount) > 200000 then begin
                            if LCRecBankPayProEntries1."Payment Method identifier" = 'N' then
                                LCRecBankPayProEntries1."Payment Method identifier" := 'R';

                        end;
                    end;
                end;
                //FnUpdatePayProVendorInformation(LCRecBankPayProEntries1,LCRecBankPayProEntries1."Vendor Ledger Entry No",LCRecBankLedgerEntriesCopy1);
                //CCIT AN 250823++
                if LCRecBankLedgerEntriesCopy1."Party Code" <> '' then begin
                    //MESSAGE("Party Code");
                    RecParty.Reset();
                    RecParty.SetRange(RecParty.Code, LCRecBankLedgerEntriesCopy1."Party Code");
                    if RecParty.FindSet then begin
                        LCRecBankPayProEntries1."Bene Account Number" := RecParty."Bank Account No";
                        LCRecBankPayProEntries1."Receiver IFSC" := RecParty.IFSC;
                        LCRecBankPayProEntries1."Beneficiary Name" := RecParty.Name;
                        LCRecBankPayProEntries1."Email ID of beneficiary" := RecParty."Bank Email";
                        LCRecBankPayProEntries1."Beneficiary Address 1" := RecParty.Address;
                        LCRecBankPayProEntries1."Beneficiary Address 2" := RecParty."Address 2";
                        LCRecBankPayProEntries1."Beneficiary State" := RecParty.State;
                        LCRecBankPayProEntries1."PIN Code" := RecParty."Post Code";
                        Str := RecParty."Payment Method code";  //CCIT AN For Conver str lenght into 1
                        Position := 1;
                        Length := 1;
                        NewStr := CopyStr(Str, Position, Length);
                        LCRecBankPayProEntries1."Payment Method identifier" := NewStr;
                        if Abs(LCRecBankPayProEntries1.Amount) > 200000 then begin
                            if LCRecBankPayProEntries1."Payment Method identifier" = 'N' then
                                LCRecBankPayProEntries1."Payment Method identifier" := 'R';

                        end;
                    end;
                end;
                //CCIT AN 230823++
                if LCRecBankAccount.Get(GlbBankNo) then
                    LCRecBankPayProEntries1."Debit Account Number" := LCRecBankAccount."Bank Account No.";

                LCRecBankPayProEntries1."Bank Ledger Entry No" := LCRecBankLedgerEntriesCopy1."Entry No.";
                LCRecBankPayProEntries1."CRN (Narration  / Remarks)" := LCRecBankLedgerEntriesCopy1."Document No.";
                LCRecBankPayProEntries1."Exported to File" := false;
                LCRecBankPayProEntries1."External Document No." := LCRecBankLedgerEntriesCopy1."External Document No.";

                LCRecBankPayProEntries1.Insert;
                LCLineNo += 1;
                LCRecBankLedgerEntriesCopy1."PayPro Entry Exit" := true;
                LCRecBankLedgerEntriesCopy1.Modify;
            until LCRecBankLedgerEntriesCopy1.Next = 0;
        end;
    end;

    local procedure FnUpdatePayProVendorInformation(var LCRecPayProEntries: Record "Bank Pay Pro Entries-New"; LCRecVendLedgerEntryNo: Integer; LCRecBankLedgerEntriesCopy1: Record "Bank Account Ledger Entry")
    var
        LCRecVendorLedgerEntries: Record "Vendor Ledger Entry";
        LCRecVendor: Record Vendor;
        LCRecVendBankAccount: Record "Vendor Bank Account";
        Str: Text;
        Position: Integer;
        Length: Integer;
        NewStr: Text;
        LCRecBankAccountLedEntry: Record "Bank Account Ledger Entry";
        LCRecBankAcc: Record "Bank Account";
        LCVenLedEntry: Record "Vendor Ledger Entry";
        VLE2: Record Vendor;
        LCRecPPI: Record "Sales Invoice Header";
        LCRecPurchInv: Record "Purch. Inv. Header";
        AppliedInvNo: Code[20];
        VLE3: Record "Vendor Ledger Entry";
    begin
        /*IF LCRecVendorLedgerEntries.GET(LCRecVendLedgerEntryNo) THEN
          BEGIN
            IF LCRecVendor.GET(LCRecVendorLedgerEntries."Vendor No.") THEN BEGIN
              LCRecPayProEntries."Beneficiary Name":=LCRecVendor.Name;
              LCRecPayProEntries."Beneficiary Address 1":=LCRecVendor.Address;
              LCRecPayProEntries."Beneficiary Address 2":=LCRecVendor."Address 2";
              LCRecPayProEntries."Beneficiary Address 3" :=LCRecVendor."Address 3";
              LCRecPayProEntries."Beneficiary City":=LCRecVendor.City;
              LCRecPayProEntries."Beneficiary State":=LCRecVendor."State Code";
              LCRecPayProEntries."PIN Code":=LCRecVendor."Post Code";
              LCRecPayProEntries."Email ID of beneficiary":=LCRecVendor."E-Mail";
              //CCIT AN For Conver str lenght into 1
              Str := LCRecVendor."Payment Method Code";;
              Position := 1;
              Length := 1;
              NewStr := COPYSTR(Str, Position, Length);
              LCRecPayProEntries."Payment Method identifier" := NewStr;
        
              LCVenLedEntry.RESET();
              LCVenLedEntry.SETRANGE("Document No.",LCRecBankLedgerEntriesCopy1."Document No.");
              IF LCVenLedEntry.FINDFIRST() THEN
               BEGIN
               VLE2.RESET();
               VLE2.SETRANGE("Closed by Entry No.",LCVenLedEntry."Entry No.");
               VLE2.SETRANGE("Vendor No.",LCVenLedEntry."Vendor No.");
                 IF VLE2.FIND('-') THEN BEGIN
                    AppliedInvNo :=  VLE2."Document No.";
                    LCRecPurchInv.RESET();
                    LCRecPurchInv.SETRANGE("No.",AppliedInvNo);
                    IF LCRecPurchInv.FINDFIRST THEN
                     BEGIN
                          MESSAGE('Posted purchase inv Bank details');
                      LCRecPayProEntries."Bene Account Number":=LCRecPurchInv."Bank Account No.";
                      LCRecPayProEntries."Receiver IFSC":=LCRecPurchInv."Bank Account IFSC";
                      LCRecPayProEntries."Beneficiary Name":= LCRecPurchInv."Bank Account Name";
                      LCRecPayProEntries."Email ID of beneficiary" := LCRecPurchInv."Bank Account Email";
                    END;
                 END;
               END  ELSE
                  BEGIN
                    LCRecVendBankAccount.SETRANGE("Vendor No.",LCRecVendor."No.");
                     IF LCRecVendBankAccount.FINDFIRST THEN BEGIN
                      MESSAGE('Vendor master bank details');
                      LCRecPayProEntries."Bene Account Number":=LCRecVendBankAccount."Bank Account No.";
                      LCRecPayProEntries."Receiver IFSC":=LCRecVendBankAccount.IFSC;
                      LCRecPayProEntries."Phone No":=LCRecVendBankAccount."Phone No.";
                      LCRecPayProEntries."Print Branch":=LCRecVendBankAccount."Bank Branch No.";
                      LCRecPayProEntries."Beneficiary Name":= LCRecVendBankAccount.Name;
                      LCRecPayProEntries."Receiver A/c type" := LCRecVendBankAccount."Receiver A/c type";
                      LCRecPayProEntries."Email ID of beneficiary" := LCRecVendBankAccount."E-Mail";
                     END;
                  END;
           END;
          END;
        
          */

    end;

    local procedure FnCopyBankContra()
    var
        LCRecBankLedgerEntriesCopy: Record "Bank Account Ledger Entry";
        LCRecBankRTGSEntries: Record "Bank RTGS Entries-New";
        LCLineNo: Integer;
        LCRecVendLedgerEntries: Record "Vendor Ledger Entry";
        LCRecCompanyInfo: Record "Company Information";
    begin
        LCRecCompanyInfo.Get;
        LCRecBankRTGSEntries.SetRange("Bank No", GlbBankNo);
        if LCRecBankRTGSEntries.FindLast then
            LCLineNo := LCRecBankRTGSEntries."Line No" + 1
        else
            LCLineNo := 1;

        CurrPage.SetSelectionFilter(LCRecBankLedgerEntriesCopy);

        if LCRecBankLedgerEntriesCopy.FindSet then begin
            repeat
                LCRecBankRTGSEntries.Init;
                LCRecBankRTGSEntries."Bank No" := GlbBankNo;
                LCRecBankRTGSEntries."Line No" := LCLineNo;
                LCRecBankRTGSEntries."Customer Ref No" := LCRecBankLedgerEntriesCopy."Document No.";
                LCRecBankRTGSEntries."Debit Bank Account No" := GlbBankNo;
                LCRecBankRTGSEntries."Transaction Amount" := LCRecBankLedgerEntriesCopy.Amount;
                LCRecBankRTGSEntries."Transaction Amount(LCY)" := LCRecBankLedgerEntriesCopy."Amount (LCY)";
                LCRecBankRTGSEntries."Cheque No" := LCRecBankLedgerEntriesCopy."Cheque No.";
                LCRecBankRTGSEntries."Cheque Date" := LCRecBankLedgerEntriesCopy."Cheque Date";
                LCRecBankRTGSEntries.CORP_EMAIL_ADDR := LCRecCompanyInfo."Corporate Email ID";
                LCRecVendLedgerEntries.SetRange("Document No.", LCRecBankLedgerEntriesCopy."Document No.");
                if LCRecVendLedgerEntries.FindFirst then
                    LCRecBankRTGSEntries."Vendor Ledger Entry No" := LCRecVendLedgerEntries."Entry No.";
                //Update Vendor RTGS details
                FnUpdateVendorInformation(LCRecBankRTGSEntries, LCRecBankRTGSEntries."Vendor Ledger Entry No");
                //Update Vendor RTGS details
                LCRecBankRTGSEntries."Bank Ledger Entry No" := LCRecBankLedgerEntriesCopy."Entry No.";
                LCRecBankRTGSEntries.Insert;
                LCLineNo += 1;
                LCRecBankLedgerEntriesCopy."RTGS Entry Exist" := true;
                LCRecBankLedgerEntriesCopy.Modify;
            until LCRecBankLedgerEntriesCopy.Next = 0;
        end;
    end;

    local procedure FnCopyPayProBankContra()
    var
        LCRecBankLedgerEntriesCopy: Record "Bank Account Ledger Entry";
        LCRecBankPayProEntries: Record "Bank Pay Pro Entries-New";
        LCLineNo: Integer;
        LCRecVendLedgerEntries: Record "Vendor Ledger Entry";
        LCRecBankAccount: Record "Bank Account";
        LCBALE: Record "Bank Account Ledger Entry";
    begin
        LCRecBankPayProEntries.SetRange("Bank No", GlbBankNo);
        if LCRecBankPayProEntries.FindLast then
            LCLineNo := LCRecBankPayProEntries."Line No" + 1
        else
            LCLineNo := 1;
        CurrPage.SetSelectionFilter(LCRecBankLedgerEntriesCopy);

        if LCRecBankLedgerEntriesCopy.FindSet then begin
            repeat
                LCRecBankPayProEntries."Bank No" := GlbBankNo;
                LCRecBankPayProEntries."Line No" := LCLineNo;
                LCRecBankPayProEntries.Amount := Abs(LCRecBankLedgerEntriesCopy."Amount (LCY)");
                LCRecBankPayProEntries."Value Date" := LCRecBankLedgerEntriesCopy."Posting Date";
                LCRecVendLedgerEntries.SetRange("Document No.", LCRecBankLedgerEntriesCopy."Document No.");
                if LCRecBankAccount.Get(GlbBankNo) then
                    LCRecBankPayProEntries."Debit Account Number" := LCRecBankAccount."Bank Account No.";
                LCRecBankPayProEntries."Instrument Date" := LCRecBankLedgerEntriesCopy."Cheque Date";
                if LCRecVendLedgerEntries.FindFirst then
                    LCRecBankPayProEntries."Vendor Ledger Entry No" := LCRecVendLedgerEntries."Entry No.";

                FnUpdateContraPayProBankVendorInfo(LCRecBankPayProEntries, LCRecBankPayProEntries."Vendor Ledger Entry No", LCRecBankLedgerEntriesCopy);
                //CCIT AN
                LCBALE.SetRange("Document No.", LCRecBankLedgerEntriesCopy."Document No.");
                LCBALE.SetRange("Transaction No.", LCRecBankLedgerEntriesCopy."Transaction No.");
                LCBALE.SetFilter(Amount, '>%1', 0);
                if LCBALE.FindFirst then begin
                    if LCRecBankAccount.Get(LCBALE."Bank Account No.") then begin
                        LCRecBankPayProEntries."Bene Account Number" := LCRecBankAccount."Bank Account No.";
                        LCRecBankPayProEntries."Receiver IFSC" := LCRecBankAccount.IFSC;
                        LCRecBankPayProEntries."Phone No" := LCRecBankAccount."Phone No.";
                        LCRecBankPayProEntries."Beneficiary Name" := LCRecBankAccount."Search Name";
                        //LCRecPayProEntries."Print Branch":=LCRecVendBankAccount."Bank Branch No.";
                        //LCRecPayProEntries."Beneficiary Name":= LCRecVendBankAccount.Name;
                        //LCRecPayProEntries."Receiver A/c type" := LCRecVendBankAccount."Receiver A/c type";
                        //LCRecPayProEntries."Email ID of beneficiary" := LCRecVendBankAccount."E-Mail";
                    end;
                end;//newly added
                LCRecBankPayProEntries."Bank Ledger Entry No" := LCRecBankLedgerEntriesCopy."Entry No.";
                LCRecBankPayProEntries."CRN (Narration  / Remarks)" := LCRecBankLedgerEntriesCopy."Document No.";
                LCRecBankPayProEntries."Exported to File" := false;    //CCIT-Vikas
                LCRecBankPayProEntries."External Document No." := LCRecBankLedgerEntriesCopy."External Document No.";     //CCIT-Vikas

                LCRecBankPayProEntries.Insert;
                LCLineNo += 1;
                LCRecBankLedgerEntriesCopy."PayPro Entry Exit" := true;
                LCRecBankLedgerEntriesCopy.Modify;
            until LCRecBankLedgerEntriesCopy.Next = 0;
        end;
    end;

    local procedure FnUpdateContraPayProBankVendorInfo(var LCRecPayProEntries: Record "Bank Pay Pro Entries-New"; LCRecVendLedgerEntryNo: Integer; LCRecBankLedgerEntriesCopy: Record "Bank Account Ledger Entry")
    var
        LCRecVendorLedgerEntries: Record "Vendor Ledger Entry";
        LCRecVendor: Record Vendor;
        LCRecVendBankAccount: Record "Vendor Bank Account";
        Str: Text;
        Position: Integer;
        Length: Integer;
        NewStr: Text;
        LCRecBankAccountLedEntry: Record "Bank Account Ledger Entry";
        LCRecBankAcc: Record "Bank Account";
        LCVenLedEntry: Record "Vendor Ledger Entry";
        VLE2: Record "Vendor Ledger Entry";
        LCRecPPI: Record "Sales Invoice Header";
        LCRecPurchInv: Record "Purch. Inv. Header";
        AppliedInvNo: Code[20];
    begin
        if LCRecVendorLedgerEntries.Get(LCRecVendLedgerEntryNo) then begin
            if LCRecVendor.Get(LCRecVendorLedgerEntries."Vendor No.") then begin
                LCRecPayProEntries."Beneficiary Name" := LCRecVendor.Name;
                LCRecPayProEntries."Beneficiary Address 1" := LCRecVendor.Address;
                LCRecPayProEntries."Beneficiary Address 2" := LCRecVendor."Address 2";
                LCRecPayProEntries."Beneficiary Address 3" := LCRecVendor."Address 3";
                LCRecPayProEntries."Beneficiary City" := LCRecVendor.City;
                LCRecPayProEntries."Beneficiary State" := LCRecVendor."State Code";
                LCRecPayProEntries."PIN Code" := LCRecVendor."Post Code";
                LCRecPayProEntries."Email ID of beneficiary" := LCRecVendor."E-Mail";
                Str := LCRecVendor."Payment Method Code";
                Position := 1;
                Length := 1;
                NewStr := CopyStr(Str, Position, Length);
                LCRecPayProEntries."Payment Method identifier" := NewStr;
                if Abs(LCRecPayProEntries.Amount) > 200000 then begin
                    if LCRecPayProEntries."Payment Method identifier" = 'N' then
                        LCRecPayProEntries."Payment Method identifier" := 'R';

                end;

                //Capturing vendors Bank details
                /* LCRecVendBankAccount.SETRANGE("Vendor No.",LCRecVendor."No.");
                 IF LCRecVendBankAccount.FINDFIRST THEN BEGIN
                     LCRecPayProEntries."Bene Account Number":=LCRecVendBankAccount."Bank Account No.";
                     LCRecPayProEntries."Receiver IFSC":=LCRecVendBankAccount.IFSC;
                     LCRecPayProEntries."Phone No":=LCRecVendBankAccount."Phone No.";
                     LCRecPayProEntries."Print Branch":=LCRecVendBankAccount."Bank Branch No.";
                     LCRecPayProEntries."Beneficiary Name":= LCRecVendBankAccount.Name;
                     LCRecPayProEntries."Receiver A/c type" := LCRecVendBankAccount."Receiver A/c type";
                     LCRecPayProEntries."Email ID of beneficiary" := LCRecVendBankAccount."E-Mail";
                 END;*/
                //Capturing vendors Bank details
            end;
        end;

    end;
}

