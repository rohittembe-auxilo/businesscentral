Report 50115 "Purchase Order"
{

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;


    RDLCLayout = './Layouts/PurchaseOrder.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            column(No; "Purchase Header"."No.")
            {
            }
            column(OrderDate; "Purchase Header"."Order Date")
            {
            }
            column(BuyfromVendorName_PurchaseHeader; "Purchase Header"."Buy-from Vendor Name")
            {
            }
            column(BuyfromAddress_PurchaseHeader; "Purchase Header"."Buy-from Address")
            {
            }
            column(BuyfromCity_PurchaseHeader; "Purchase Header"."Buy-from City")
            {
            }
            column(BuyfromPostCode_PurchaseHeader; "Purchase Header"."Buy-from Post Code")
            {
            }
            column(CurrencyCode_PurchaseHeader; "Purchase Header"."Currency Code")
            {
            }
            column(VendPhoneNo; VendPhoneNo)
            {
            }
            column(Supplier_GST; SuppGST)
            {
            }
            column(CmpName; CmpName)
            {
            }
            column(CmpAddress; CmpAddress)
            {
            }
            column(CmpAddress2; CmpAddress2)
            {
            }
            column(CmpCity; CmpCity)
            {
            }
            column(CmpPostCode; CmpPostCode)
            {
            }
            column(CompEmail; RecCompInfo."E-Mail")
            {
            }
            column(CompFaxNo; RecCompInfo."Fax No.")
            {
            }
            column(CompWeb; RecCompInfo."Home Page")
            {
            }
            column(PaymentDescript; PaymentDescript)
            {
            }
            dataitem("Purch. Comment Line"; "Purch. Comment Line")
            {
                DataItemLink = "No." = field("No.");
                column(Cmt; "Purch. Comment Line".Comment)
                {
                }
                trigger OnPreDataItem();
                begin
                    //	ReportForNav.OnPreDataItem('Table43',UnknownTable43);
                end;
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(SrNo; SrNo)
                {
                }
                column(GSTPercent; GSTRate) // "Purchase Line"."GST %"
                {
                }
                column(UnitRate; "Purchase Line"."Direct Unit Cost")
                {
                }
                column(HSNSACCode_PurchaseLine; "Purchase Line"."HSN/SAC Code")
                {
                }
                column(Description_PurchaseLine; "Purchase Line".Description)
                {
                }
                column(Quantity_PurchaseLine; "Purchase Line".Quantity)
                {
                }
                column(Amount_PurchaseLine; "Purchase Line".Amount)
                {
                }
                column(GSTJuridictionType; "Purchase Line"."GST Jurisdiction Type")
                {
                }
                column(LineDiscountAmt; "Purchase Line"."Line Discount Amount")
                {
                }
                column(CSGSTPercent; CSGSTRate)
                {
                }
                column(IGSTPercent; IGSTRate)
                {
                }
                column(NetAmt; NetAmt)
                {
                }
                column(GrossAmt; GrossAmt)
                {
                }
                column(AmountInWords; AmountInWords[1])
                {
                }
                column(TotwithoutChargesTotal; TotwithoutChargesTotal)
                {
                }
                trigger OnPreDataItem();
                begin
                    CSGSTRate := 0;
                    IGSTRate := 0;
                    TotalAmt := 0;
                    GrossAmt := 0;


                    //		ReportForNav.OnPreDataItem('Table39',UnknownTable39);
                end;

                trigger OnAfterGetRecord();
                var
                    TaxTransactionValue: Record "Tax Transaction Value";
                    TaxRecordID: RecordId;
                begin
                    SrNo := SrNo + 1;
                    CSGSTAmt := 0;
                    IGSTAmt := 0;

                    if ("Purchase Line"."GST Jurisdiction Type" = "Purchase Line"."gst jurisdiction type"::Intrastate) then begin
                        TaxRecordID := "Purchase Line".RecordId();

                        TaxTransactionValue.Reset();
                        TaxTransactionValue.SetRange("Tax Record ID", TaxRecordID);
                        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                        TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                        TaxTransactionValue.SetRange("Visible on Interface", true);
                        TaxTransactionValue.SetFilter("Value ID", '%1 | %2', 6, 2);
                        TaxTransactionValue.SetFilter("Line No. Filter", format("Purchase Line"."Line No."));  //Vikas from Line Amount to line no
                        if TaxTransactionValue.FindSet() then begin
                            GSTRate := TaxTransactionValue.Percent;  /// 2;
                            //   SGSTRate := TaxTransactionValue.Percent;   /// 2;
                            CSGSTRate += TaxTransactionValue.Amount;  /// 2;

                        end;
                    end;
                    //v      CSGSTRate += ("Purchase Line"."Total GST Amount") / 2;
                    if "Purchase Line"."GST Jurisdiction Type" = "Purchase Line"."gst jurisdiction type"::Interstate then begin
                        TaxRecordID := "Purchase Line".RecordId();

                        TaxTransactionValue.Reset();
                        TaxTransactionValue.SetRange("Tax Record ID", TaxRecordID);
                        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                        TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                        TaxTransactionValue.SetRange("Visible on Interface", true);
                        TaxTransactionValue.SetFilter("Value ID", '%1', 3);
                        TaxTransactionValue.SetFilter("Line No. Filter", format("Purchase Line"."Line No."));
                        if TaxTransactionValue.FindSet() then begin
                            GSTRate := TaxTransactionValue.Percent;  /// 2;
                            //   SGSTRate := TaxTransactionValue.Percent;   /// 2;
                            IGSTRate += TaxTransactionValue.Amount;  /// 2;

                        end;
                    end;

                    //v     IGSTRate += "Purchase Line"."Total GST Amount";
                    TotwithoutCharges := ("Purchase Line".Amount - "Purchase Line"."Line Discount Amount");
                    TotwithoutChargesTotal += TotwithoutCharges;
                    //TotalAmt := ("Purchase Line".Amount-"Purchase Line"."Line Discount Amount" + "Purchase Line"."Charges To Vendor") ;
                    TotalAmt := ("Purchase Line".Amount - "Purchase Line"."Line Discount Amount");
                    NetAmt += TotalAmt;
                    if "Purchase Header"."GST Vendor Type" = "Purchase Header"."gst vendor type"::Unregistered then
                        GrossAmt := ROUND(NetAmt, 1, '>')
                    else
                        GrossAmt := ROUND((NetAmt + Abs(CSGSTRate) + Abs(IGSTRate) + Abs(CSGSTRate)), 1, '>');
                    RecCheck.InitTextVariable;
                    if "Purchase Header"."Currency Code" = '' then
                        RecCheck.FormatNoText(AmountInWords, ROUND((NetAmt + Abs(CSGSTRate) + Abs(IGSTRate) + Abs(CSGSTRate)), 1, '>'), '')
                    else
                        RecCheck.FormatNoText(AmountInWords, ROUND((NetAmt + Abs(CSGSTRate) + Abs(IGSTRate) + Abs(CSGSTRate)), 1, '>'), "Purchase Header"."Currency Code");
                end;

            }
            trigger OnPreDataItem();
            begin
                RecCompInfo.Reset;
                CompPAN := RecCompInfo."P.A.N. No.";
                //CompCIN := RecCompInfo."CIN No.";
                //CompCIN := RecCompInfo."CIN NO.";
                /*
				RecLocation.RESET;
				IF RecLocation.GET(RecCompInfo."Location Code") THEN
				  IF RecLocation.FINDFIRST THEN
					BEGIN
					LocName := RecLocation.Name;
					LocAddr := RecLocation.Address + RecLocation."Address 2";
					LocTel := RecLocation."Phone No.";
					LocTel2 := RecLocation."Phone No. 2";
					LocEmail := RecLocation."E-Mail";
					LocGSTN := RecLocation."GST Registration No.";
					END;
				*/
                RecPurchHdrArchive.Reset;
                RecPurchHdrArchive.SetRange("Buy-from Vendor No.", "Purchase Header"."Buy-from Vendor No.");
                if RecPurchHdrArchive.FindFirst then
                    AmmendNo := RecPurchHdrArchive."Version No.";

                //	ReportForNav.OnPreDataItem('Table38',UnknownTable38);
            end;

            trigger OnAfterGetRecord();
            begin
                //CCIT AN 05072023++
                Comp_info.Reset();
                Comp_info.SetFilter("From Date", '<=%1', "Purchase Header"."Posting Date");
                Comp_info.SetFilter("To Date", '>=%1', "Purchase Header"."Posting Date");
                if Comp_info.FindFirst then begin
                    CmpName := Comp_info.Name;
                    CmpAddress := Comp_info.Address;
                    CmpAddress2 := Comp_info."Address 2";
                    CmpCity := Comp_info.City;
                    CmpPostCode := Comp_info."Post Code";
                    CmpPhone := Comp_info."Phone No.";
                    //v CmpState := Comp_info.
                end;
                //CCIT AN--
                if RecLocation.Get("Purchase Header"."Location Code") then begin
                    LocName := RecLocation.Name;
                    LocAddr := RecLocation.Address + RecLocation."Address 2";
                    LocTel := RecLocation."Phone No.";
                    LocTel2 := RecLocation."Phone No. 2";
                    LocEmail := RecLocation."E-Mail";
                    LocGSTN := RecLocation."GST Registration No.";
                end;
                VendorRec.Reset;
                VendorRec.SetRange("No.", "Purchase Header"."Buy-from Vendor No.");
                if VendorRec.FindFirst then begin
                    SuppGST := VendorRec."GST Registration No.";
                    VendPhoneNo := VendorRec."Phone No.";
                end;
                i := 1;
                //CLEAR(ChargePercent) ;
                //vmigration  /*    struct.Reset;
                /*     struct.SetRange(struct.Code, "Purchase Header".Structure);
                     struct.SetRange(struct.Type, struct.Type::Charges);
                     if struct.FindFirst then
                         repeat
                             PostedStrOrderLineDtls.Reset;
                             PostedStrOrderLineDtls.SetRange(PostedStrOrderLineDtls."Document Type", PostedStrOrderLineDtls."document type"::Order);
                             PostedStrOrderLineDtls.SetRange(PostedStrOrderLineDtls."Document No.", "Purchase Header"."No.");
                             PostedStrOrderLineDtls.SetRange(PostedStrOrderLineDtls."Tax/Charge Type", PostedStrOrderLineDtls."tax/charge type"::Charges);
                             PostedStrOrderLineDtls.SetRange(PostedStrOrderLineDtls."Tax/Charge Group", struct."Tax/Charge Group");
                             if PostedStrOrderLineDtls.FindFirst then
                                 repeat
                                     TaxChargeGrp[i] := Format(struct."Tax/Charge Group");
                                     TaxChargeGrpAmt[i] += PostedStrOrderLineDtls.Amount;
                                     TotalCharges += PostedStrOrderLineDtls.Amount;
                                     if PostedStrOrderLineDtls."Calculation Type" = PostedStrOrderLineDtls."calculation type"::Percentage then
                                         ChargePercent[i] := '@' + Format(PostedStrOrderLineDtls."Calculation Value") + '%'
                                     else
                                         ChargePercent[i] := '';
                                 until PostedStrOrderLineDtls.Next = 0;
                             i += 1;
                         until struct.Next = 0;

                         */
                RecPayTerms.Reset;
                RecPayTerms.SetRange(RecPayTerms.Code, "Purchase Header"."Payment Terms Code");
                if RecPayTerms.FindFirst then
                    PaymentDescript := RecPayTerms.Description;
            end;

        }
    }
    requestpage
    {
        SaveValues = false;
        layout
        {
        }

    }

    trigger OnInitReport()
    begin
        RecCompInfo.Get;
        RecCompInfo.CalcFields(Picture);


    end;

    var
        RecCompInfo: Record "Company Information";
        RecLocation: Record Location;
        RecPurchHdrArchive: Record "Purchase Header Archive";
        LocName: Text[100];
        LocAddr: Text[250];
        LocTel: Text;
        LocTel2: Text;
        LocEmail: Code[50];
        LocGSTN: Code[25];
        CompPAN: Code[25];
        CompCIN: Code[25];
        Text01: label 'With reference to your above mentioned quotation no. you are requested to supply the following materials as per  Terms & Conditions mentioned hereunder.';
        SrNo: Integer;
        Text02: label 'FREIGHT EXTRA AT ACTUAL WITH SUPPORTING DOCUMENTS: Yes  No   ';
        RecPayTerms: Record "Payment Terms";
        Text03: label '***';
        CSGSTAmt: Decimal;
        IGSTAmt: Decimal;
        CSGSTRate: Decimal;
        GSTRate: Decimal;
        IGSTRate: Decimal;
        CSGSTTotal: Decimal;
        IGSTTotal: Decimal;
        GSTTotal: Decimal;
        TotalAmt: Decimal;
        NetAmt: Decimal;
        GrossAmt: Decimal;
        SetUpGSTRec: Record "GST Setup";
        RecCheck: Report "Posted Voucher New";
        AmountInWords: array[5] of Text[250];
        AmmendNo: Integer;
        i: Integer;
        //v PostedStrOrderLineDtls: Record "Structure Order Line Details";
        //v struct: Record "Structure Details";
        TaxChargeGrpAmt: array[8] of Decimal;
        TaxChargeGrp: array[8] of Code[20];
        TotalCharges: Decimal;
        ChargePercent: array[8] of Text[20];
        VendorRec: Record Vendor;
        SuppGST: Code[25];
        PaymentDescript: Text[50];
        TotwithoutCharges: Decimal;
        TotwithoutChargesTotal: Decimal;
        VendPhoneNo: Text[30];
        Comp_info: Record "Company Information2";
        CmpName: Text;
        CmpAddress: Text;
        CmpAddress2: Text;
        CmpCity: Text;
        CmpPostCode: Code[20];
        CmpState: Text;
        CmpPhone: Text;

    trigger OnPreReport();
    begin
    end;

}
