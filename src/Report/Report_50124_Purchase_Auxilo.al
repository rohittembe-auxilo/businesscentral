report 50124 "Purchase Auxilo"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'POAuxilo.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.")
            {

            }
            column(Pay_to_Vendor_No_; "Pay-to Vendor No.")
            {

            }
            column(Pay_to_Name; "Pay-to Name")
            {

            }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code")
            {

            }
            column(Status; Status)
            {

            }
            column(PO_type; "PO type")
            {

            }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document No." = field("No.");
                //DataItemTableView = sorting("No.");
                // DataItemTableView=sorting

                column(No_s; "No.")
                {

                }

                column(Description; Description)
                {

                }
                column(Total; Total)
                {

                }
                column(ToalGSTAmount; ToalGSTAmount)
                {

                }
                column(AmountToVendor; AmountToVendor)
                {

                }
                column(UndefinedPOamt; UndefinedPOamt)
                {

                }
                column(UndefinedGSTamt; UndefinedGSTamt)
                {

                }
                column(UndefinedTotalAmnt; UndefinedTotalAmnt)
                {

                }
                column(Outstanding_Qty___Base_; "Outstanding Qty. (Base)")
                {

                }
                column(Outstanding_Amount; "Outstanding Amount")
                {

                }
                column(Line_Amount; "Line Amount")
                {

                }
                column(TotalCGST; TotalCGST)
                {

                }
                column(TotalSGST; TotalSGST)
                {

                }
                column(TotalIGST; TotalIGST) { }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                    LineAmount: Decimal;
                    LineCGST: Decimal;
                    LineSGST: Decimal;
                    LineIGST: Decimal;
                    RemainingQty: Decimal;
                    RemainingAmount: Decimal;
                    RemainingCGST: Decimal;
                    RemainingSGST: Decimal;
                    RemainingIGST: Decimal;

                begin
                    RecPurchaseLine.Reset();
                    RecPurchaseLine.SetRange("Document Type", "Purchase Header"."Document Type");
                    RecPurchaseLine.SetRange("Document No.", "Purchase Header"."No.");
                    RecPurchaseLine.SetFilter("GST Group Code", '<>%1', '');
                    UndefinedPOamt := 0;
                    UndefinedGSTamt := 0;
                    UndefinedTotalAmnt := 0;
                    TotalCGST := 0;
                    TotalSGST := 0;
                    TotalIGST := 0;
                    Total := 0;
                    RemainingCGST := 0;
                    RemainingSGST := 0;
                    RemainingIGST := 0;

                    if RecPurchaseLine.FindSet() then
                        repeat
                            TaxRecordID := RecPurchaseLine.RecordId();//tk
                                                                      // PurchaseHeaderRecordID := RecPurchaseLine.RecordId();
                                                                      //                                                                       //Message('%1', PurchHeaderRecordID);
                            TaxTransactionValue.Reset();
                            TaxTransactionValue.SetRange("Tax Record ID", TaxRecordID);//tk
                            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                            TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                            TaxTransactionValue.SetRange("Visible on Interface", true);
                            TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
                            if TaxTransactionValue.FindSet() then begin

                                CGSTRate := TaxTransactionValue.Percent;
                                SGSTRate := TaxTransactionValue.Percent;
                                CGST := TaxTransactionValue.Amount;
                                SGST := TaxTransactionValue.Amount;

                                LineCGST := CGSTRate * RecPurchaseLine."Line Amount" / 100;
                                LineSGST := SGSTRate * RecPurchaseLine."Line Amount" / 100;

                                SGSTtxt := 'SGST';
                                CGSTtxt := 'CGST';
                                TotalCGST := CGST;
                                TotalSGST := SGST;
                            end else begin
                                TaxTransactionValue.Reset();
                                TaxTransactionValue.SetRange("Tax Record ID", TaxRecordID);//tk
                                TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                                TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
                                TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                                TaxTransactionValue.SetRange("Visible on Interface", true);
                                TaxTransactionValue.SetFilter("Value ID", '%1', 3);
                                if TaxTransactionValue.FindSet() then
                                    IGSTRate := TaxTransactionValue.Percent;
                                IGST := TaxTransactionValue.Amount;
                                LineIGST := IGSTRate * RecPurchaseLine."Line Amount" / 100;
                                IGSTtxt := 'IGST';
                                TotalIGST := IGST;

                            END;

                            // Total += RecPurchaseLine."Line Amount";

                            RemaningGST := CGSTRate + SGSTRate + IGSTRate;

                            UndefinedGSTamt := RemaningGST * "Outstanding Amount" / 100;

                        //logic2
                        // if RecPurchaseLine."Quantity Received" < RecPurchaseLine.Quantity then begin
                        //  UndefinedPOamt := (RecPurchaseLine.Quantity - RecPurchaseLine."Quantity Received") * RecPurchaseLine."Direct Unit Cost";
                        //UndefinedGSTamt := CGST + SGST + IGST;
                        //  UndefinedTotalAmnt := (RecPurchaseLine.Quantity - RecPurchaseLine."Quantity Received") * RecPurchaseLine."Direct Unit Cost" + CGST + SGST + IGST;
                        //end;
                        //  ToalGSTAmount := IGST + SGST + CGST;

                        until RecPurchaseLine.Next() = 0;
                    // 

                    // ToalGSTAmount := TotalCGST + TotalSGST + TotalIGST;
                    GSTAMOUNT := CGSTRate + SGSTRate + IGSTRate;
                    ToalGSTAmount := GSTAMOUNT * "Purchase Line"."Line Amount" / 100;

                    AmountToVendor += LineAmount + CGST + SGST + IGST;


                    PostedVoucher.InitTextVariable();
                    "Purchase Header".CalcFields(Amount);
                    // PostedVoucher.FormatNoText(AmountinWords, Round("Purchase Header".Amount), "Purchase Header"."Currency Code");
                    PostedVoucher.FormatNoText(AmountinWords, Round(AmountToVendor), "Purchase Header"."Currency Code");
                    Amtinwrds := AmountinWords[1] + AmountinWords[2];
                end;


            }

            // column()
            // {

            // }
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = Excel;
    //         LayoutFile = 'mySpreadsheet.xlsx';
    //     }
    // }

    var
        myInt: Integer;
        vendor: Record Vendor;
        Nettotal: Decimal;
        GSTAMOUNT: Decimal;
        Email1: Text[80];
        Phone1: Text[80];
        RemaningGST: Decimal;
        ToalGSTAmount: Decimal;
        RecPurchaseLine: Record "Purchase Line";
        sales: Record "Purchase Line";
        AmountToVendor: Decimal;
        IGSTtxt: text[10];
        CGSTtxt: text[10];
        SGSTtxt: text[10];
        States: Text[30];
        UndefinedPOamt: Decimal;
        UndefinedGSTamt: Decimal;
        UndefinedTotalAmnt: Decimal;
        PostCode: Code[20];
        companyinfo: Record "Company Information";
        Amount: Decimal;
        WholeAmount: Decimal;
        Amtinwrds: Text;
        FractionalAmount: Decimal;
        AmountinWords: array[2] of Text;
        // AmntinWrds: Text;
        CGST: Decimal;
        SGST: Decimal;
        IGST: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        Total: Decimal;
        GrandTotal: Decimal;
        Currency: Code[20];
        PostedVoucher: Report "Posted Voucher New";
        TaxtransactionValue: Record "Tax Transaction Value";
        TaxRecordId: RecordId;

        Txatotal: Decimal;


    local procedure ClearData()
    Begin
        IGSTRate := 0;
        SGSTRate := 0;
        CGSTRate := 0;
        SGSTtxt := '';
        CGSTtxt := '';
        TotalCGST := 0;
        TotalSGST := 0;
        TotalIGST := 0;
        CGSTtxt := '';
        IGSTtxt := '';

        IGST := 0;
        CGST := 0;
        SGST := 0;
        Clear(AmountinWords);
        AmountToVendor := 0;

    End;

}