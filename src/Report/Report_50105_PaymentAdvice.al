Report 50002 "Payment Advice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PaymentAdvice.rdl';

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemTableView = where("Document Type" = filter(Payment));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Comp_Info_Name; Comp_Info.Name)
            {
            }
            column(Comp_Info_Address; Comp_Info.Address)
            {
            }
            column(Comp_Info_Address2; Comp_Info."Address 2")
            {
            }
            column(Comp_Info_City; Comp_Info.City)
            {
            }
            column(Comp_Info_PostCode; Comp_Info."Post Code")
            {
            }
            column(Comp_Info_PhoneNo; Comp_Info."Phone No.")
            {
            }
            column(Comp_Info_EMail; Comp_Info."E-Mail")
            {
            }
            column(PostingDate_VendorLedgerEntry; Format("Vendor Ledger Entry"."Posting Date", 0, 4))
            {
            }
            column(Amount_VendorLedgerEntry; "Vendor Ledger Entry".Amount)
            {
            }
            column(DocumentNo_VendorLedgerEntry; "Vendor Ledger Entry"."Document No.")
            {
            }
            column(VendorNo_VendorLedgerEntry; "Vendor Ledger Entry"."Vendor No.")
            {
            }
            column(ExternalDocumentNo; "Vendor Ledger Entry"."External Document No.")
            {
            }
            column(VenName; VenName)
            {
            }
            column(VenAdd; VenAdd)
            {
            }
            column(VenCity; VenCity)
            {
            }
            column(VendPostCode; VendPostCode)
            {
            }
            column(VenState; VenState)
            {
            }
            column(VenContry; VenContry)
            {
            }
            column(AppliedDocNo; AppliedDocNo)
            {
            }
            column(AmtInWord; AmtInWord)
            {
            }
            column(BeneAccName; BeneAccName)
            {
            }
            column(BeneAccNo; BeneAccNo)
            {
            }
            column(IFSC; IFSC)
            {
            }
            column(TDSAmt; TDSAmt)
            {
            }

            trigger OnAfterGetRecord()
            begin
                VendorInfo.Reset();
                VendorInfo.SetRange("No.", "Vendor Ledger Entry"."Vendor No.");
                if VendorInfo.FindFirst then begin
                    VenName := VendorInfo.Name;
                    VenAdd := VendorInfo.Address + VendorInfo."Address 2";
                    VenCity := VendorInfo.City;
                    VendPostCode := VendorInfo."Post Code";
                    VenState := VendorInfo."State Code";
                    VenContry := VendorInfo."Country/Region Code";
                end;

                //Invoice no
                AppliedDocNo := '';
                VLE.Reset();
                VLE.SetRange("Document No.", "Document No.");
                VLE.SetRange("Document Type", VLE."document type"::Payment);
                if VLE.Find('-') then begin
                    if VLE."Closed by Entry No." = 0 then begin
                        VLE2.Reset();
                        VLE2.SetRange("Closed by Entry No.", VLE."Entry No.");
                        if VLE2.Find('-') then
                            repeat
                                AppliedDocNo := AppliedDocNo + VLE2."Document No." + '   ';
                            until VLE2.Next = 0;
                    end else begin
                        VLE2.Reset();
                        VLE2.SetRange("Entry No.", VLE."Closed by Entry No.");
                        if VLE2.Find('-') then
                            repeat
                                AppliedDocNo := AppliedDocNo + VLE2."Document No." + '   ';
                            until VLE2.Next = 0;

                    end;
                end;

                TDSEntry.Reset();
                TDSEntry.SetRange("Document No.", "Vendor Ledger Entry"."Document No.");
                TDSEntry.SetRange("Party Code", "Vendor Ledger Entry"."Vendor No.");
                if TDSEntry.Find('-') then begin
                    TDSAmt := TDSEntry."TDS Amount";
                end
                else
                    TDSEntry2.Reset();
                TDSEntry2.SetRange("Document No.", AppliedDocNo);
                if TDSEntry2.Find('-') then begin
                    TDSAmt := TDSEntry2."TDS Amount";
                end;

                VendBankAcc.Reset();
                VendBankAcc.SetRange(Code, "Vendor Ledger Entry"."Recipient Bank Account");
                VendBankAcc.SetRange("Vendor No.", "Vendor Ledger Entry"."Vendor No.");
                if VendBankAcc.Find('-') then begin
                    BeneAccName := VendBankAcc.Name;
                    BeneAccNo := VendBankAcc."Bank Account No.";
                    IFSC := VendBankAcc.IFSC;
                end
                else
                    PPI.Reset();
                PPI.SetRange("No.", "Vendor Ledger Entry"."Document No.");
                PPI.SetRange("Buy-from Vendor No.", "Vendor Ledger Entry"."Vendor No.");
                if PPI.FindFirst then begin
                    BeneAccName := PPI."Bank Account Name";
                    BeneAccNo := PPI."Bank Account No.";
                    IFSC := PPI."Bank Account IFSC";
                end;

                if BeneAccName = '' then begin
                    BeneAccName := "Vendor Ledger Entry"."Bank Account Name";
                    BeneAccNo := "Vendor Ledger Entry"."Bank Account No.";
                    IFSC := "Vendor Ledger Entry"."Bank Account IFSC";
                    //END;
                end
                else
                    BeneAccName := 'NA';
                if BeneAccNo = '' then
                    BeneAccNo := 'NA';
                if IFSC = '' then
                    IFSC := 'NA';

                /* VLEntry.RESET();
                 VLEntry.SETFILTER("Posting Date",'%1..%2',FromDate,"To Date");
                 VLEntry.SETFILTER("Vendor No.",'=%1',VendorNo);
                 IF VLEntry.FINDSET THEN
                   REPEAT
                     Total += VLEntry.Amount;
                   UNTIL VLEntry.NEXT=0;*/

                Total := Total + "Vendor Ledger Entry".Amount;



                Repcheck.InitTextVariable;
                Repcheck.FormatNoText(NoText, Total, "Vendor Ledger Entry"."Currency Code");
                AmtInWord := NoText[1];

            end;

            trigger OnPreDataItem()
            begin
                /*IF (FromDate = 0D) OR ("To Date" = 0D) THEN
                  ERROR('You Must Enter From And To Dates');
                IF VendorNo = '' THEN
                  ERROR('Vendor No must have value');
                
                "Vendor Ledger Entry".SETFILTER("Vendor Ledger Entry"."Posting Date",'%1..%2',FromDate,"To Date");
                "Vendor Ledger Entry".SETFILTER("Vendor Ledger Entry"."Vendor No.",'=%1',VendorNo);
                */

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("From Date"; FromDate)
                {
                    ApplicationArea = Basic;
                }
                field("To Date"; "To Date")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor No"; VendorNo)
                {
                    ApplicationArea = Basic;
                    TableRelation = Vendor."No.";
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        Comp_Info.Get;
        Comp_Info.CalcFields(Picture);
    end;

    var
        Comp_Info: Record "Company Information";
        VendorInfo: Record Vendor;
        VenName: Text;
        VenAdd: Text;
        VenCity: Text;
        VendPostCode: Text;
        VenState: Text;
        VenContry: Text;
        AppliedDocNo: Text;
        VLE: Record "Vendor Ledger Entry";
        VLE2: Record "Vendor Ledger Entry";
        Repcheck: Report Check;
        NoText: array[2] of Text;
        AmtInWord: Text;
        Total: Decimal;
        VendBankAcc: Record "Vendor Bank Account";
        BeneAccName: Text;
        BeneAccNo: Text;
        IFSC: Code[20];
        PPI: Record "Purch. Inv. Header";
        TDSEntry: Record "TDS Entry";
        TDSAmt: Decimal;
        TDSEntry2: Record "TDS Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        FromDate: Date;
        "To Date": Date;
        VendorNo: Code[20];
        VLEntry: Record "Vendor Ledger Entry";
}

