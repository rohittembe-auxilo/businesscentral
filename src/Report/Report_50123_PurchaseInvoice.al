Report 50123 "Purchase - Invoice1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PurchaseInvoiceNew.rdl';
    Caption = 'Purchase - Invoice';
    PreviewMode = PrintLayout;
    UseSystemPrinter = true;


    dataset
    {

        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")

        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.", "RCM Invoice No.", "No. Printed";
            RequestFilterHeading = 'Posted Purchase Invoice';

            column(No_PurchInvHeader; "No.")
            {
            }
            column(InvDiscountAmountCaption; InvDiscountAmountCaptionLbl)
            {
            }
            column(InvoiceNO; "RCM Invoice No.")
            {
            }
            column(PIno; "Vendor Invoice No.")
            {
            }
            column(RCMPaymentNo; "RCM Payment No.")
            {
            }
            column(GSTComponentCode1; GSTComponentCode[1] + '')
            {
            }
            column(GSTComponentCode2; GSTComponentCode[2] + ' ')
            {
            }
            column(GSTComponentCode3; GSTComponentCode[3] + '')
            {
            }
            column(GSTComponentCode4; GSTComponentCode[4] + '')
            {
            }
            column(GSTCompAmount1; Abs(GSTCompAmount[1]))
            {
            }
            column(GSTCompAmount2; Abs(GSTCompAmount[2]))
            {
            }
            column(GSTCompAmount3; Abs(GSTCompAmount[3]))
            {
            }
            column(GSTCompAmount4; Abs(GSTCompAmount[4]))
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_5701; 5701)
                {
                }
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(ReportForNavId_6455; 6455)
                    {
                    }
                    column(PaymentTermsDesc; PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodDesc; ShipmentMethod.Description)
                    {
                    }
                    column(DocCaptionCopyText; StrSubstNo(DocumentCaption, CopyText))
                    {
                    }
                    column(VendAddr1; VendAddr[1])
                    {
                    }
                    column(CompanyAddr1; Location.Address)
                    {
                    }
                    column(VendAddr2; VendAddr[2])
                    {
                    }
                    column(ComName; CompanyInfo.Name)
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
                    column(CmpState; CmpState)
                    {
                    }
                    column(CmpPhone; CmpPhone)
                    {
                    }
                    column(COMREgNO; CompanyInfo."Registration No.")
                    {
                    }
                    column(CompanyAddr2; Location."Address 2")
                    {
                    }
                    column(VendAddr3; VendAddr[3])
                    {
                    }
                    column(CompanyAddr3; Location."Post Code")
                    {
                    }
                    column(VendAddr4; VendAddr[4])
                    {
                    }
                    column(CompanyAddr4; Location.City)
                    {
                    }
                    column(VendAddr5; VendAddr[5])
                    {
                    }
                    column(CompanyInfoPhoneNo; Location."Phone No.")
                    {
                    }
                    column(Logo; CompanyInfo.Picture)
                    {
                    }
                    column(VendAddr6; VendAddr[6])
                    {
                    }
                    column(CompanyRegistrationLbl; CompanyRegistrationLbl)
                    {
                    }
                    column(CompanyInfo_GST_RegistrationNo; Location."GST Registration No.")
                    {
                    }
                    column(VendorRegistrationLbl; VendorRegistrationLbl)
                    {
                    }
                    column(Vendor_GST_RegistrationNo; Vendor."GST Registration No.")
                    {
                    }
                    column(CompanyInfoEMail; Location."E-Mail")
                    {
                    }
                    column(CompanyInfoHomePage; Location."Phone No.")
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(PayVendNo_PurchInvHeader; "Purch. Inv. Header"."Pay-to Vendor No.")
                    {
                    }
                    column(BuyfrVendNo_PurchInvHeaderCaption; "Purch. Inv. Header".FieldCaption("Buy-from Vendor No."))
                    {
                    }
                    column(BuyfrVendNo_PurchInvHeader; "Purch. Inv. Header"."Buy-from Vendor No.")
                    {
                    }
                    column(DocDate_PurchInvHeader; Format("Purch. Inv. Header"."Document Date", 0, 4))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_PurchInvHeader; "Purch. Inv. Header"."VAT Registration No.")
                    {
                    }
                    column(DueDate_PurchInvHeader; Format("Purch. Inv. Header"."Due Date"))
                    {
                    }
                    column(PurchaserText; PurchaserText)
                    {
                    }
                    column(SalesPurchPersonName; Locstate.Description)
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourRef_PurchInvHeader; "Purch. Inv. Header"."Your Reference")
                    {
                    }
                    column(OrderNoText; OrderNoText)
                    {
                    }
                    column(OrderNo_PurchInvHeader; "Purch. Inv. Header"."Order No.")
                    {
                    }
                    column(VendAddr7; VendAddr[7])
                    {
                    }
                    column(VendAddr8; States.Description)
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(PostDate_PurchInvHeader; Format("Purch. Inv. Header"."Posting Date"))
                    {
                    }
                    column(PricIncVAT_PurchInvHeader; "Purch. Inv. Header"."Prices Including VAT")
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(ShowInternalInfo; ShowInternalInfo)
                    {
                    }
                    column(VATBasDisc_PurchInvHeader; "Purch. Inv. Header"."VAT Base Discount %")
                    {
                    }
                    column(PricesInclVATtxt; PricesInclVATtxt)
                    {
                    }
                    column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoEMailCaption; CompanyInfoEMailCaptionLbl)
                    {
                    }
                    column(CompanyInfoHomePageCaption; CompanyInfoHomePageCaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegistrationNoCaption; CompanyInfoVATRegistrationNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoGiroNoCaption; CompanyInfoGiroNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankNameCaption; CompanyInfoBankNameCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankAccountNoCaption; CompanyInfoBankAccountNoCaptionLbl)
                    {
                    }
                    column(PurchInvHeaderDueDateCaption; PurchInvHeaderDueDateCaptionLbl)
                    {
                    }
                    column(InvoiceNoCaption; InvoiceNoCaptionLbl)
                    {
                    }
                    column(PurchInvHeaderPostingDateCaption; "Purch. Inv. Header"."Posting Date")
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(PaymentTermsDescriptionCaption; PaymentTermsDescriptionCaptionLbl)
                    {
                    }
                    column(ShipmentMethodDescriptionCaption; ShipmentMethodDescriptionCaptionLbl)
                    {
                    }
                    column(VATAmountLineVATCaption; VATAmountLineVATCaptionLbl)
                    {
                    }
                    column(VATAmountLineVATBaseVTCCaption; VATAmountLineVATBaseVTCCaptionLbl)
                    {
                    }
                    column(VATAmtLineVATAmtVTCCaption; VATAmtLineVATAmtVTCCaptionLbl)
                    {
                    }
                    column(VATAmountSpecificationCaption; VATAmountSpecificationCaptionLbl)
                    {
                    }
                    column(VATAmtLineInvDiscBaseAmtVTCCaption; VATAmtLineInvDiscBaseAmtVTCCaptionLbl)
                    {
                    }
                    column(VATAmtLineLineAmtVTCCaption; VATAmtLineLineAmtVTCCaptionLbl)
                    {
                    }
                    column(VATAmountLineVATIdentifierCaption; VATAmountLineVATIdentifierCaptionLbl)
                    {
                    }
                    column(VATAmountLineVATBaseVTC1Caption; VATAmountLineVATBaseVTC1CaptionLbl)
                    {
                    }
                    column(DocumentDateCaption; DocumentDateCaptionLbl)
                    {
                    }
                    column(PayVendNo_PurchInvHeaderCaption; "Purch. Inv. Header".FieldCaption("Pay-to Vendor No."))
                    {
                    }
                    column(PricIncVAT_PurchInvHeaderCaption; "Purch. Inv. Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    column(LocAdd1; Location.Address)
                    {
                    }
                    column(LocAdd2; Location."Address 2")
                    {
                    }
                    column(LocCity; Location.City)
                    {
                    }
                    column(LocPostCOde; Location."Post Code")
                    {
                    }
                    column(LocCountry; Location.County)
                    {
                    }
                    column(LocEmail; Location."E-Mail")
                    {
                    }
                    column(LocPhone; Location."Phone No.")
                    {
                    }
                    column(LocGST; Location."GST Registration No.")
                    {
                    }
                    column(VendGST; Vendor."GST Registration No.")
                    {
                    }
                    column(Statename; States.Description)
                    {
                    }
                    column(LocState; Locstate.Description)
                    {
                    }
                    column(postDate; "Purch. Inv. Header"."Posting Date")
                    {
                    }
                    column(bankName; BankAccount.Name)
                    {
                    }
                    column(bankAccno; BankAccount."Bank Account No.")
                    {
                    }
                    column(bankifsc; BankAccount.IFSC)
                    {
                    }
                    column(innerdesc; ShowInnerDescription)
                    {
                    }
                    column(PurchCommentDescription; PurchCommDescription)
                    {
                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Purch. Inv. Header";
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                        column(ReportForNavId_7574; 7574)
                        {
                        }
                        column(DimText; DimText)
                        {
                        }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.FindFirst then
                                    CurrReport.Break;
                            end else
                                if not Continue then
                                    CurrReport.Break;

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo(
                                      '%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until (DimSetEntry1.Next = 0);
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break;
                        end;
                    }
                    dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Purch. Inv. Header";
                        DataItemTableView = sorting("Document No.", "Line No.") where("No." = filter(<> ''));
                        column(ReportForNavId_5707; 5707)
                        {
                        }

                        column(IsGSTApplicable; IsGSTApplicable)
                        {
                        }
                        column(ServiceTaxAmt; ServiceTaxAmt)
                        {
                        }
                        column(ServiceTaxECessAmt; ServiceTaxECessAmt)
                        {
                        }
                        column(ServiceTaxSHECessAmt; ServiceTaxSHECessAmt)
                        {
                        }
                        column(ServiceTaxSBCAmount; ServiceTaxSBCAmount)
                        {
                        }
                        column(ApplServiceTaxSBCAmount; AppliedServiceTaxSBCAmount)
                        {
                        }
                        column(KKCessAmount; KKCessAmount)
                        {
                        }
                        column(AppliedKKCessAmount; AppliedKKCessAmount)
                        {
                        }
                        column(AppliedServTaxAmt; AppliedServiceTaxAmt)
                        {
                        }
                        column(ApplServTaxECessAmt; AppliedServiceTaxECessAmt)
                        {
                        }
                        column(ApplServTaxSHECessAmt; AppliedServiceTaxSHECessAmt)
                        {
                        }
                        column(LineAmt_PurchInvLine; "Purch. Inv. Line"."Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Desc_PurchInvLine; Description)
                        {
                        }
                        column(No_PurchInvLine; "No.")
                        {
                        }
                        column(No_PurchInvLineCaption; FieldCaption("No."))
                        {
                        }
                        column(Quantity_PurchInvLine; Quantity)
                        {
                        }
                        column(UOM_PurchInvLine; "Unit of Measure")
                        {
                        }
                        column(HSNCode; "HSN/SAC Code")
                        {
                        }
                        column(DirectUnitCost_PurchInvLine; "Direct Unit Cost")
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 2;
                        }
                        column(LineDisc_PurchInvLine; "Line Discount %")
                        {
                        }
                        column(AllowInvDisc_PurchInvLine; "Allow Invoice Disc.")
                        {
                            IncludeCaption = false;
                        }
                        column(LineDiscAmt_PurchInvLine; "Line Discount Amount")
                        {
                        }
                        column(LineNo_PurchInvLine; "Purch. Inv. Line"."Line No.")
                        {
                        }
                        column(AllowVATDisctxt; AllowVATDisctxt)
                        {
                        }
                        column(PurchInLineTypeNo; PurchInLineTypeNo)
                        {
                        }
                        column(VATAmtText; VATAmountText)
                        {
                        }
                        column(SourceDocNo_PurchInvLine; "Source Document No.")
                        {
                        }
                        column(InvDiscAmt_PurchInvLine; -"Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(Amt_PurchInvLine; Amount)
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(AmtToVend_PurchInvLine; "Purch. Inv. Line".Amount)// "Amount To Vendor")
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(ExciseAmt_PurchInvLine; Amount)// "Excise Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TaxAmt_PurchInvLine; Amount)// "Tax Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TtlTDSIncSHECESS_PurchInvLine; Amount)//-"Total TDS Including SHE CESS")
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(WorkTaxAmt_PurchInvLine; Amount)// -"Work Tax Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(OtherTaxesAmt; OtherTaxesAmount)
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(ChargesAmt; ChargesAmount)
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AmtIncVATAmt_PurchInvLine; "Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = "Purch. Inv. Line".GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvDiscAmt; TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmt; TotalAmount)
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmtInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalPaymentDiscOnVAT; TotalPaymentDiscountOnVAT)
                        {
                            AutoFormatType = 1;
                        }
                        column(DirectUnitCostCaption; DirectUnitCostCaptionLbl)
                        {
                        }
                        column(PurchInvLineLineDiscountCaption; PurchInvLineLineDiscountCaptionLbl)
                        {
                        }
                        column(AmountCaption; AmountCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(PurchInvLineExciseAmountCaption; PurchInvLineExciseAmountCaptionLbl)
                        {
                        }
                        column(PurchInvLineTaxAmountCaption; PurchInvLineTaxAmountCaptionLbl)
                        {
                        }
                        column(ServiceTaxAmountCaption; ServiceTaxAmountCaptionLbl)
                        {
                        }
                        column(TotalTDSIncludingSHECESSCaption; TotalTDSIncludingSHECESSCaptionLbl)
                        {
                        }
                        column(WorkTaxAmountCaption; WorkTaxAmountCaptionLbl)
                        {
                        }
                        column(OtherTaxesAmountCaption; OtherTaxesAmountCaptionLbl)
                        {
                        }
                        column(ChargesAmountCaption; ChargesAmountCaptionLbl)
                        {
                        }
                        column(ServiceTaxeCessAmountCaption; ServiceTaxeCessAmountCaptionLbl)
                        {
                        }
                        column(SvcTaxAmtAppliedCaption; SvcTaxAmtAppliedCaptionLbl)
                        {
                        }
                        column(SvcTaxeCessAmtAppliedCaption; SvcTaxeCessAmtAppliedCaptionLbl)
                        {
                        }
                        column(ServiceTaxSHECessAmountCaption; ServiceTaxSHECessAmountCaptionLbl)
                        {
                        }
                        column(LineAmtInvDiscountAmtAmtInclVATCaption; LineAmtInvDiscountAmtAmtInclVATCaptionLbl)
                        {
                        }
                        column(AllowInvDiscountCaption; AllowInvDiscountCaptionLbl)
                        {
                        }
                        column(Desc_PurchInvLineCaption; FieldCaption(Description))
                        {
                        }
                        column(Quantity_PurchInvLineCaption; FieldCaption(Quantity))
                        {
                        }
                        column(UOM_PurchInvLineCaption; FieldCaption("Unit of Measure"))
                        {
                        }
                        column(LineDiscAmt_PurchInvLineCaption; FieldCaption("Line Discount Amount"))
                        {
                        }
                        column(ServTaxSBCAmtCaption; ServTaxSBCAmtCaptionLbl)
                        {
                        }
                        column(SvcTaxSBCAmtAppliedCaption; SvcTaxSBCAmtAppliedCaptionLbl)
                        {
                        }
                        column(KKCessAmtCaption; KKCessAmtCaptionLbl)
                        {
                        }
                        column(KKCessAmtAppliedCaption; KKCessAmtAppliedCaptionLbl)
                        {
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                            column(ReportForNavId_3591; 3591)
                            {
                            }
                            column(DimText1; DimText)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FindFirst then
                                        CurrReport.Break;
                                end else
                                    if not Continue then
                                        CurrReport.Break;

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo(
                                          '%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until (DimSetEntry2.Next = 0);
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.Break;

                                DimSetEntry2.SetRange("Dimension Set ID", "Purch. Inv. Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                        //    StructureLineDetails: Record 13798;
                        begin
                            if (Type = Type::"G/L Account") and (not ShowInternalInfo) then
                                "No." := '';

                            VATAmountLine.Init;
                            VATAmountLine."VAT Identifier" := "Purch. Inv. Line"."VAT Identifier";
                            VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                            VATAmountLine."Tax Group Code" := "Tax Group Code";
                            VATAmountLine."Use Tax" := "Use Tax";
                            VATAmountLine."VAT %" := "VAT %";
                            VATAmountLine."VAT Base" := Amount;
                            VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                            VATAmountLine."Line Amount" := "Line Amount";
                            if "Allow Invoice Disc." then
                                VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                            VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                            VATAmountLine.InsertLine;

                            //    if IsGSTApplicable and (Type <> Type::" ") then begin

                            //     GSTComponent.Reset;
                            //     GSTComponent.SetRange("GST Jurisdiction Type", "GST Jurisdiction Type");
                            //     if GSTComponent.FindSet then
                            //         repeat
                            //             GSTComponentCode[j] := GSTComponent.Code;
                            //             DetailedGSTLedgerEntry.Reset;
                            //             DetailedGSTLedgerEntry.SetCurrentkey("Transaction Type", "Document Type", "Document No.", "Document Line No.");
                            //             DetailedGSTLedgerEntry.SetRange("Transaction Type", DetailedGSTLedgerEntry."transaction type"::Purchase);
                            //             DetailedGSTLedgerEntry.SetRange("Document No.", "Document No.");
                            //             DetailedGSTLedgerEntry.SetRange("Document Line No.", "Line No.");
                            //             DetailedGSTLedgerEntry.SetRange("GST Component Code", GSTComponentCode[j]);
                            //             DetailedGSTLedgerEntry.SetFilter("Entry Type", '<>%1', DetailedGSTLedgerEntry."entry type"::Application);
                            //             if DetailedGSTLedgerEntry.FindSet then begin
                            //                 repeat
                            //                     GSTCompAmount[j] +=
                            //                       CurrExchRate.ExchangeAmtLCYToFCY(
                            //                         DetailedGSTLedgerEntry."Posting Date", DetailedGSTLedgerEntry."Currency Code",
                            //                         DetailedGSTLedgerEntry."GST Amount", DetailedGSTLedgerEntry."Currency Factor");
                            //                     TotalGSTAmt += GSTCompAmountGSTCompAmount[j];
                            //                 until DetailedGSTLedgerEntry.Next = 0;
                            //                 //Vikas
                            //                 if GSTComponent.Code = 'IGST' then
                            //                     GSTComponentCode[j] := GSTComponent.Code + ' @ 18%'
                            //                 else
                            //                     GSTComponentCode[j] := GSTComponent.Code + ' @ 9%';

                            //                 j += 1;
                            //             end;
                            //         until GSTComponent.Next = 0;
                            // end;

                            // StructureLineDetails.Reset;
                            // StructureLineDetails.SetRange(Type, StructureLineDetails.Type::Purchase);
                            // StructureLineDetails.SetRange("Document Type", StructureLineDetails."document type"::Invoice);
                            // StructureLineDetails.SetRange("Invoice No.", "Document No.");
                            // StructureLineDetails.SetRange("Item No.", "No.");
                            // StructureLineDetails.SetRange("Line No.", "Line No.");
                            // if StructureLineDetails.Find('-') then
                            //     repeat
                            //         if not StructureLineDetails."Payable to Third Party" then begin
                            //             if StructureLineDetails."Tax/Charge Type" = StructureLineDetails."tax/charge type"::Charges then
                            //                 ChargesAmount := ChargesAmount + ROUND(StructureLineDetails.Amount);
                            //             if StructureLineDetails."Tax/Charge Type" = StructureLineDetails."tax/charge type"::"Other Taxes" then
                            //                 OtherTaxesAmount := OtherTaxesAmount + ROUND(StructureLineDetails.Amount);
                            //         end;
                            //     until StructureLineDetails.Next = 0;

                            // SumServiceTaxAmt := SumServiceTaxAmt + "Service Tax Amount";
                            // SumServiceTaxECessAmt := SumServiceTaxECessAmt + "Service Tax eCess Amount";
                            // SumServiceTaxSHECessAmt := SumServiceTaxSHECessAmt + "Service Tax SHE Cess Amount";
                            // SumServiceTaxSBCAmount := SumServiceTaxSBCAmount + "Service Tax SBC Amount";
                            // SumKKCessAmount := SumKKCessAmount + "KK Cess Amount";
                            // AllowVATDisctxt := Format("Purch. Inv. Line"."Allow Invoice Disc.");
                            // PurchInLineTypeNo := "Purch. Inv. Line".Type;
                            // if "Purch. Inv. Header"."Transaction No. Serv. Tax" <> 0 then begin
                            //     ServiceTaxEntry.Reset;
                            //     ServiceTaxEntry.SetRange(Type, ServiceTaxEntry.Type::Purchase);
                            //     ServiceTaxEntry.SetRange("Document Type", ServiceTaxEntry."document type"::Invoice);
                            //     ServiceTaxEntry.SetRange("Document No.", "Purch. Inv. Header"."No.");
                            //     if ServiceTaxEntry.FindFirst then begin
                            //         ServiceTaxAmt := Abs(ServiceTaxEntry."Service Tax Amount");
                            //         ServiceTaxECessAmt := Abs(ServiceTaxEntry."eCess Amount");
                            //         ServiceTaxSHECessAmt := Abs(ServiceTaxEntry."SHE Cess Amount");
                            //         ServiceTaxSBCAmount := Abs(ServiceTaxEntry."Service Tax SBC Amount");
                            //         KKCessAmount := Abs(ServiceTaxEntry."KK Cess Amount");
                            //         AppliedServiceTaxAmt := SumServiceTaxAmt - Abs(ServiceTaxEntry."Service Tax Amount");
                            //         AppliedServiceTaxECessAmt := SumServiceTaxECessAmt - Abs(ServiceTaxEntry."eCess Amount");
                            //         AppliedServiceTaxSHECessAmt := SumServiceTaxSHECessAmt - Abs(ServiceTaxEntry."SHE Cess Amount");
                            //         AppliedServiceTaxSBCAmount := SumServiceTaxSBCAmount - Abs(ServiceTaxEntry."Service Tax SBC Amount");
                            //         AppliedKKCessAmount := SumKKCessAmount - Abs(ServiceTaxEntry."KK Cess Amount");
                            //     end else begin
                            //         AppliedServiceTaxAmt := "Service Tax Amount";
                            //         AppliedServiceTaxECessAmt := "Service Tax eCess Amount";
                            //         AppliedServiceTaxSHECessAmt := "Service Tax SHE Cess Amount";
                            //         AppliedServiceTaxSBCAmount := "Service Tax SBC Amount";
                            //         AppliedKKCessAmount := "KK Cess Amount";
                            //     end;
                            // end else begin
                            //     ServiceTaxAmt := "Service Tax Amount";
                            //     ServiceTaxECessAmt := "Service Tax eCess Amount";
                            //     ServiceTaxSHECessAmt := "Service Tax SHE Cess Amount";
                            //     ServiceTaxSBCAmount := "Service Tax SBC Amount";
                            //     KKCessAmount := "KK Cess Amount";
                            // end;

                            TotalSubTotal += "Line Amount";
                            TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
                            TotalAmount += Amount;
                            TotalAmountVAT += "Amount Including VAT" - Amount;
                            TotalAmountInclVAT += TotalGSTAmt + "Line Amount";//Vikas
                            TotalPaymentDiscountOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");
                            //CCIT VIkas 04092020
                            PurchCommDescription := '';
                            k := 0;
                            PurchComment.Reset();
                            PurchComment.SetRange("Document Type", PurchComment."document type"::"Posted Invoice");
                            PurchComment.SetRange("No.", "Purch. Inv. Line"."Document No.");
                            PurchComment.SetRange("Document Line No.", "Line No.");
                            if PurchComment.Find('-') then
                                repeat
                                    if k = 0 then begin
                                        PurchCommDescription := PurchComment.Comment;
                                        k := 1;
                                    end else begin
                                        PurchCommDescription := PurchCommDescription + ', ' + PurchComment.Comment;
                                    end;

                                until PurchComment.Next = 0;
                            //CCIT VIkas 04092020
                        end;
                        //end;

                        trigger OnPreDataItem()
                        var
                            PurchInvLine: Record 123;
                            VATIdentifier: Code[10];
                        begin

                            VATAmountLine.DeleteAll;
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do
                                MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break;
                            SetRange("Line No.", 0, "Line No.");
                            //v     CurrReport.CreateTotals("Line Amount", "Inv. Discount Amount", Amount, "Amount Including VAT", "Excise Amount", "Tax Amount",
                            //v      "Service Tax Amount", "Service Tax eCess Amount");
                            //v    CurrReport.CreateTotals("Total TDS Including SHE CESS", "Work Tax Amount", "Amount To Vendor", "Service Tax SHE Cess Amount");

                            PurchInvLine.SetRange("Document No.", "Purch. Inv. Header"."No.");
                            PurchInvLine.SetFilter(Type, '<>%1', 0);
                            VATAmountText := '';
                            if PurchInvLine.Find('-') then begin
                                VATAmountText := StrSubstNo(Text011, PurchInvLine."VAT %");
                                VATIdentifier := PurchInvLine."VAT Identifier";
                                repeat
                                    if (PurchInvLine."VAT Identifier" <> VATIdentifier) and (PurchInvLine.Quantity <> 0) then
                                        VATAmountText := Text012;
                                until PurchInvLine.Next = 0;
                            end;
                            i := Count;
                            SumServiceTaxAmt := 0;
                            SumServiceTaxECessAmt := 0;
                            SumServiceTaxSHECessAmt := 0;
                            SumServiceTaxSBCAmount := 0;
                            SumKKCessAmount := 0;
                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_6558; 6558)
                        {
                        }
                        column(VATAmtLineVATBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, VATAmountLine.Count);
                            CurrReport.CreateTotals(
                              VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VATCounterLCY; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_2038; 2038)
                        {
                        }
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALVATAmtLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT1; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier1; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Purch. Inv. Header"."Posting Date", "Purch. Inv. Header"."Currency Code",
                                "Purch. Inv. Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Purch. Inv. Header"."Posting Date", "Purch. Inv. Header"."Currency Code",
                                "Purch. Inv. Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Purch. Inv. Header"."Currency Code" = '')
                            then
                                CurrReport.Break;

                            SetRange(Number, 1, VATAmountLine.Count);
                            CurrReport.CreateTotals(VALVATBaseLCY, VALVATAmountLCY);

                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text007 + Text008
                            else
                                VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Purch. Inv. Header"."Posting Date", "Purch. Inv. Header"."Currency Code", 1);
                            CalculatedExchRate := ROUND(1 / "Purch. Inv. Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.000001);
                            VALExchRate := StrSubstNo(Text009, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                        column(ReportForNavId_3476; 3476)
                        {
                        }
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                        column(ReportForNavId_3363; 3363)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if "Purch. Inv. Header"."Buy-from Vendor No." = "Purch. Inv. Header"."Pay-to Vendor No." then
                                CurrReport.Break;
                        end;
                    }
                    dataitem(Total3; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                        column(ReportForNavId_8272; 8272)
                        {
                        }
                        column(ShipToAddr1; ShipToAddr[1])
                        {
                        }
                        column(ShipToAddr2; ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr3; ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr4; ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr5; ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr6; ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr7; ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr8; ShipToAddr[8])
                        {
                        }
                        column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if ShipToAddr[1] = '' then
                                CurrReport.Break;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        OutputNo := OutputNo + 1;
                        CopyText := Text003;
                    end;
                    CurrReport.PageNo := 1;

                    TotalSubTotal := 0;
                    TotalInvoiceDiscountAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclVAT := 0;
                    TotalPaymentDiscountOnVAT := 0;
                    Clear(GSTCompAmount);
                    ServiceTaxSHECessAmt := 0;
                    ServiceTaxECessAmt := 0;
                    ServiceTaxAmt := 0;
                    ServiceTaxSBCAmount := 0;
                    KKCessAmount := 0;
                    AppliedServiceTaxSHECessAmt := 0;
                    AppliedServiceTaxECessAmt := 0;
                    AppliedServiceTaxAmt := 0;
                    AppliedServiceTaxSBCAmount := 0;
                    AppliedKKCessAmount := 0;
                    ChargesAmount := 0;
                    OtherTaxesAmount := 0;
                    TotalGSTAmt := 0;
                end;

                trigger OnPostDataItem()
                begin
                    /*IF NOT CurrReport.PREVIEW THEN
                      PurchInvCountPrinted.RUN("Purch. Inv. Header");
                    */

                end;

                trigger OnPreDataItem()
                begin
                    OutputNo := 1;
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                end;
            }

            trigger OnAfterGetRecord()
            var
                PurchInvLine: Record 123;
            begin
                //CCIT AN 05072023++
                Comp_info.Reset();
                Comp_info.SetFilter("From Date", '<=%1', "Purch. Inv. Header"."Posting Date");
                Comp_info.SetFilter("To Date", '>=%1', "Purch. Inv. Header"."Posting Date");
                if Comp_info.FindFirst then begin
                    CmpName := Comp_info.Name;
                    CmpAddress := Comp_info.Address;
                    CmpAddress2 := Comp_info."Address 2";
                    CmpCity := Comp_info.City;
                    CmpPostCode := Comp_info."Post Code";
                    CmpPhone := Comp_info."Phone No.";
                    //v     CmpState := Comp_info.state;
                end;
                //CCIT AN--
                //   CurrReport.Language := Language.GetLanguageID("Language Code");

                //CompanyInfo.GET;
                //v   IsGSTApplicable := GSTManagement.IsGSTApplicable(Structure);
                Vendor.Get("Buy-from Vendor No.");
                if States.Get(Vendor."State Code") then;
                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                DimSetEntry1.SetRange("Dimension Set ID", "Purch. Inv. Header"."Dimension Set ID");

                if "Order No." = '' then
                    OrderNoText := ''
                else
                    OrderNoText := FieldCaption("Order No.");
                if "Purchaser Code" = '' then begin
                    Clear(SalesPurchPerson);
                    PurchaserText := '';
                end else begin
                    SalesPurchPerson.Get("Purchaser Code");
                    PurchaserText := Text000
                end;
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FieldCaption("Your Reference");
                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := FieldCaption("VAT Registration No.");
                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text13700, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text13701, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text001, "Currency Code");
                    TotalInclVATText := StrSubstNo(Text13700, "Currency Code");
                    TotalExclVATText := StrSubstNo(Text13701, "Currency Code");
                end;
                FormatAddr.PurchInvPayTo(VendAddr, "Purch. Inv. Header");
                if "Payment Terms Code" = '' then
                    PaymentTerms.Init
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;
                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;

                FormatAddr.PurchInvShipTo(ShipToAddr, "Purch. Inv. Header");

                if LogInteraction then
                    if not CurrReport.Preview then
                        SegManagement.LogDocument(
                          14, "No.", 0, 0, Database::Vendor, "Buy-from Vendor No.", "Purchaser Code", '', "Posting Description", '');
                SupplementaryText := '';
                PurchInvLine.SetRange("Document No.", "No.");
                PurchInvLine.SetRange(Supplementary, true);
                if PurchInvLine.FindFirst then
                    SupplementaryText := Text16500;

                PricesInclVATtxt := Format("Purch. Inv. Header"."Prices Including VAT");
                Location.Reset;
                if Location.Get("Purch. Inv. Header"."Location Code") then;
                Locstate.Reset;
                if Locstate.Get(Location."State Code") then;
                j := 1;
                RecPurchInvCGST.Reset;
                RecPurchInvCGST.SetRange(RecPurchInvCGST."Document No.", "Purch. Inv. Header"."No.");
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
                                GSTComponentCode[1] := 'CGST';
                                GSTCompAmount[1] := GSTCompAmount[1] + Abs(DetailedGSTLedgerEntry."GST Amount");
                                GSTComponentCode[2] := 'SGST';
                                GSTCompAmount[2] := GSTCompAmount[2] + Abs(DetailedGSTLedgerEntry."GST Amount");
                            //   Message('%1', GSTCompAmount[1])
                            //
                            //   CGST := CGST + Abs(DetailedGSTLedgerEntry."GST Amount");
                            //  CGSTRate := DetailedGSTLedgerEntry."GST %";
                            UNTIL DetailedGSTLedgerEntry.NEXT() = 0;
                    //Totals

                    until RecPurchInvCGST.Next = 0;
                //  Clear(IGST);
                RecPurchInvIGST.Reset;
                RecPurchInvIGST.SetRange(RecPurchInvIGST."Document No.", "Purch. Inv. Header"."No.");
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
                                GSTComponentCode[3] := 'IGST';
                                GSTCompAmount[3] := GSTCompAmount[3] + Abs(DetailedGSTLedgerEntry."GST Amount");

                            //   IGST := IGST + Abs(DetailedGSTLedgerEntry."GST Amount");
                            //  CGSTRate := DetailedGSTLedgerEntry."GST %";
                            UNTIL DetailedGSTLedgerEntry.NEXT() = 0;

                    until RecPurchInvIGST.Next = 0;


            end;

            trigger OnPreDataItem()
            begin
                //CLEARALL;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Internal Information';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }
                    field("Invoice No"; InvoiceNO)
                    {
                        ApplicationArea = Basic;
                        Visible = false;
                    }
                    field("Show Inner Description"; ShowInnerDescription)
                    {
                        ApplicationArea = Basic;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            LogInteraction := SegManagement.FindInteractTmplCode(14) <> '';
            LogInteractionEnable := LogInteraction;
            ShowInnerDescription := false;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
    end;

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        //IF BankAccount.GET(CompanyInfo."Bank Account No.") THEN;
    end;

    var
        Text000: label 'Purchaser';
        Text001: label 'Total %1';
        Text003: label 'COPY';
        Text004: label 'Purchase - Invoice %1';
        GLSetup: Record 98;
        CompanyInfo: Record 79;
        ShipmentMethod: Record 10;
        PaymentTerms: Record 3;
        SalesPurchPerson: Record 13;
        VATAmountLine: Record 290 temporary;
        DimSetEntry1: Record 480;
        DimSetEntry2: Record 480;
        RespCenter: Record 5714;
        Language: Record 8;
        CurrExchRate: Record 330;
        GSTComponent: Record "GST Component Distribution";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        Vendor: Record 23;
        PurchInvCountPrinted: Codeunit 319;
        FormatAddr: Codeunit 365;
        SegManagement: Codeunit 5051;
        GSTManagement: Codeunit "GST Stats Management";
        GSTCompAmount: array[20] of Decimal;
        GSTComponentCode: array[20] of Code[10];
        VendAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        PurchaserText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        OrderNoText: Text[80];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[10];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        InvoiceNO: Code[16];
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        Text007: label 'VAT Amount Specification in ';
        Text008: label 'Local Currency';
        Text009: label 'Exchange rate: %1/%2';
        CalculatedExchRate: Decimal;
        Text010: label 'Purchase - Prepayment Invoice %1';
        OutputNo: Integer;
        PricesInclVATtxt: Text[30];
        AllowVATDisctxt: Text[30];
        VATAmountText: Text[30];
        Text011: label '%1% VAT';
        Text012: label 'VAT Amount';
        PurchInLineTypeNo: Integer;
        OtherTaxesAmount: Decimal;
        ChargesAmount: Decimal;
        Text13700: label 'Total %1 Incl. Taxes';
        Text13701: label 'Total %1 Excl. Taxes';
        SupplementaryText: Text[30];
        Text16500: label 'Supplementary Invoice';
        //v  ServiceTaxEntry: Record 16473;
        ServiceTaxAmt: Decimal;
        ServiceTaxECessAmt: Decimal;
        AppliedServiceTaxAmt: Decimal;
        AppliedServiceTaxECessAmt: Decimal;
        ServiceTaxSHECessAmt: Decimal;
        AppliedServiceTaxSHECessAmt: Decimal;
        i: Integer;
        SumServiceTaxAmt: Decimal;
        SumServiceTaxECessAmt: Decimal;
        SumServiceTaxSHECessAmt: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        CompanyInfoPhoneNoCaptionLbl: label 'Phone No.';
        CompanyInfoEMailCaptionLbl: label 'E-Mail';
        CompanyInfoHomePageCaptionLbl: label 'Home Page';
        CompanyInfoVATRegistrationNoCaptionLbl: label 'VAT Reg. No.';
        CompanyInfoGiroNoCaptionLbl: label 'Giro No.';
        CompanyInfoBankNameCaptionLbl: label 'Bank';
        CompanyInfoBankAccountNoCaptionLbl: label 'Account No.';
        PurchInvHeaderDueDateCaptionLbl: label 'Due Date';
        InvoiceNoCaptionLbl: label 'Invoice No.';
        PurchInvHeaderPostingDateCaptionLbl: label 'Posting Date';
        PageCaptionLbl: label 'Page';
        PaymentTermsDescriptionCaptionLbl: label 'Payment Terms';
        ShipmentMethodDescriptionCaptionLbl: label 'Shipment Method';
        DocumentDateCaptionLbl: label 'Document Date';
        HeaderDimensionsCaptionLbl: label 'Header Dimensions';
        DirectUnitCostCaptionLbl: label 'Direct Unit Cost';
        PurchInvLineLineDiscountCaptionLbl: label 'Discount %';
        AmountCaptionLbl: label 'Amount';
        SubtotalCaptionLbl: label 'Subtotal';
        PurchInvLineExciseAmountCaptionLbl: label 'Excise Amount';
        PurchInvLineTaxAmountCaptionLbl: label 'Tax Amount';
        ServiceTaxAmountCaptionLbl: label 'Service Tax Amount';
        TotalTDSIncludingSHECESSCaptionLbl: label 'Total TDS Including eCess';
        WorkTaxAmountCaptionLbl: label 'Work Tax Amount';
        OtherTaxesAmountCaptionLbl: label 'Other Taxes Amount';
        ChargesAmountCaptionLbl: label 'Charges Amount';
        ServiceTaxeCessAmountCaptionLbl: label 'Service Tax eCess Amount';
        SvcTaxAmtAppliedCaptionLbl: label 'Svc Tax Amt (Applied)';
        SvcTaxeCessAmtAppliedCaptionLbl: label 'Svc Tax eCess Amt (Applied)';
        ServiceTaxSHECessAmountCaptionLbl: label 'Service Tax SHECess Amount';
        LineAmtInvDiscountAmtAmtInclVATCaptionLbl: label 'Payment Discount on VAT';
        AllowInvDiscountCaptionLbl: label 'Allow Invoice Discount';
        LineDimensionsCaptionLbl: label 'Line Dimensions';
        VATAmountLineVATCaptionLbl: label 'VAT %';
        VATAmountLineVATBaseVTCCaptionLbl: label 'VAT Base';
        VATAmtLineVATAmtVTCCaptionLbl: label 'VAT Amount';
        VATAmountSpecificationCaptionLbl: label 'VAT Amount Specification';
        VATAmtLineInvDiscBaseAmtVTCCaptionLbl: label 'Inv. Disc. Base Amount';
        VATAmtLineLineAmtVTCCaptionLbl: label 'Line Amount';
        VATAmountLineVATIdentifierCaptionLbl: label 'VAT Identifier';
        VATAmountLineVATBaseVTC1CaptionLbl: label 'Total';
        ShiptoAddressCaptionLbl: label 'Ship-to Address';
        InvDiscountAmountCaptionLbl: label 'Invoice Discount Amount';
        ServiceTaxSBCAmount: Decimal;
        AppliedServiceTaxSBCAmount: Decimal;
        SumServiceTaxSBCAmount: Decimal;
        ServTaxSBCAmtCaptionLbl: label 'SBC Amount';
        SvcTaxSBCAmtAppliedCaptionLbl: label 'SBC Amt (Applied)';
        KKCessAmount: Decimal;
        AppliedKKCessAmount: Decimal;
        SumKKCessAmount: Decimal;
        KKCessAmtCaptionLbl: label 'KK Cess Amount';
        KKCessAmtAppliedCaptionLbl: label 'KK Cess Amt (Applied)';
        IsGSTApplicable: Boolean;
        j: Integer;
        CompanyRegistrationLbl: label 'Company GSTIN';
        VendorRegistrationLbl: label 'Vendor GST Reg No.';
        Location: Record 14;
        States: Record State;
        Locstate: Record State;
        BankAccount: Record "Bank Account";
        PurchComment: Record "Purch. Comment Line";
        PurchCommDescription: Text[250];
        k: Integer;
        ShowInnerDescription: Boolean;
        TotalGSTAmt: Decimal;
        RCMInvNo: Text;
        VendInvNo: Text;
        PurchInvHdr: Record 122;
        Comp_info: Record "Company Information2";
        CmpName: Text;
        CmpAddress: Text;
        CmpAddress2: Text;
        CmpCity: Text;
        CmpPostCode: Code[20];
        CmpState: Text;
        CmpPhone: Text;
        sdasdn: report 406;
        RecPurchInvCGST: Record "Purch. Inv. Line";
        RecPurchInvIGST: Record "Purch. Inv. Line";

    local procedure DocumentCaption(): Text[250]
    begin
        if "Purch. Inv. Header"."Prepayment Invoice" then
            exit(Text010);
        exit(Text004);
    end;


    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
    end;
}

