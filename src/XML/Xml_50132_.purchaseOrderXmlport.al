/*xmlport 50132 "Sales order Creation"

{
    Format = VariableText;
    Caption = 'Sales order Creation';
    schema
    {
        textelement(root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                textelement(DocType)
                {
                    MinOccurs = Zero;
                }
                textelement(DocNo)
                {
                    MinOccurs = Zero;
                }
                textelement(BuyFromVend)
                {
                    MinOccurs = Zero;
                }
                textelement(BuyFromVendName)
                {
                    MinOccurs = Zero;
                }
                textelement(DocDate)
                {
                    MinOccurs = Zero;
                }
                textelement(OrderDate)
                {
                    MinOccurs = Zero;
                }
                textelement(PostingDate)
                {
                    MinOccurs = Zero;
                }
                textelement(PayTermCode)
                {
                    MinOccurs = Zero;
                }
                textelement(LocCode)
                {
                    MinOccurs = Zero;
                }
                textelement(ShortDim1)
                {
                    MinOccurs = Zero;
                }
                textelement(ShortDim2)
                {
                    MinOccurs = Zero;
                }

                textelement(VendPostingGr)
                {
                    MinOccurs = Zero;
                }
                textelement(VendInvNo)
                {
                    MinOccurs = Zero;
                }
                textelement(GenBusPostGr)
                {
                    MinOccurs = Zero;
                }
                textelement(Structure)
                {
                    MinOccurs = Zero;
                }
                textelement(GstVendType)
                {
                    MinOccurs = Zero;
                }
                textelement(LineNo)
                {
                    MinOccurs = Zero;
                }
                textelement(Type)
                {
                    MinOccurs = Zero;
                }
                textelement(No)
                {
                    MinOccurs = Zero;
                }
                textelement(Disc)
                {
                    MinOccurs = Zero;
                }
                textelement(Disc2)
                {
                    MinOccurs = Zero;
                }
                textelement(QTY)
                {
                    MinOccurs = Zero;
                }
                textelement(UOM)
                {
                    MinOccurs = Zero;
                }

                textelement(DirectUnitCost)
                {
                    MinOccurs = Zero;
                }
                textelement(Amt)
                {
                    MinOccurs = zero;
                }

                textelement(GstCredit)
                {
                    MinOccurs = zero;
                }
                textelement(GstGrCode)
                {
                    MinOccurs = zero;
                }
                textelement(GstGrType)
                {
                    MinOccurs = zero;
                }
                textelement(HSNCode)
                {
                    MinOccurs = zero;
                }
                textelement(GenpostingGroup)
                {
                    MinOccurs = zero;
                }
                textelement(VATpostinfGr)
                {
                    MinOccurs = zero;
                }

                textelement(GSTPER)
                {
                    MinOccurs = zero;
                }

                textelement(UomNew)
                {
                    MinOccurs = zero;

                }
                textelement(UnitpriceNew)
                {
                    MinOccurs = zero;

                }

                trigger OnAfterInsertRecord()
                var
                    Dcode: code[20];
                    ODate: date;
                    doc: Code[40];
                begin

                    Evaluate(Pdate, PostingDate);
                    Evaluate(Ddate, DocDate);
                    Evaluate(ODate, OrderDate);

                    //   Evaluate(Qty1, Qty);
                    //  Evaluate(UnitPrice1, UnitpriceNew);
                    // Evaluate(type2, Type1);
                    // Evaluate(Dcode, DriverValueCode);
                    // Evaluate(PayMode, paymentmode);
                    // Evaluate(PartnerType1, PartnerType);


                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetRange("No.", DocNo);
                    if not SalesHeader.Find('-') then begin
                        SalesnRecSetup.Get();
                        Clear(SalesHeader);
                        SalesHeader.INIT;
                        if DocType = 'Order' then
                            SalesHeader."Document Type" := SalesHeader."document type"::Order;
                        // SalesHeader.Validate("No.", Noseriesmgmt.GetNextNo(SalesnRecSetup."Order Nos.", Today, true));
                        SalesHeader."No." := DocNo;


                        SalesHeader.INSERT(TRUE);
                        SalesHeader.VALIDATE("Sell-to Customer No.", BuyFromVend);
                        SalesHeader."Posting Date" := Pdate;
                        SalesHeader."Document Date" := Ddate;
                        SalesHeader."Document Date" := ODate;
                        SalesHeader.Validate("Sell-to Customer Name", BuyFromVendName);

                        SalesHeader.Validate(LocationNew, LocCode);

                        SalesHeader.Modify();



                    end;
                    Counter += 1;


                    Lineno1 += 1;
                    Clear(SalesLine);
                    SalesLine.INIT;
                    if Type = 'Item' then
                        SalesLine.Type := SalesLine.Type::Item
                    else
                        if Type = 'G/L Account' then
                            SalesLine.Type := SalesLine.Type::"G/L Account";

                    SalesLine."Document Type" := SalesLine."Document Type"::Order;
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine."Line No." := Lineno1 * 10000;

                    SalesLine.Validate(Type, type2);
                    SalesLine."No." := No;
                    SalesLine.Insert();
                    SalesLine.Validate("No.", No);
                    SalesLine.Validate(Description, Disc);
                    SalesLine.Validate("Description 2", Disc2);
                    SalesLine.Validate("Gen. Bus. Posting Group", GenpostingGroup);
                    SalesLine.Validate("VAT Bus. Posting Group", VATpostinfGr);
                    Evaluate(Qty2, QTY);
                    SalesLine.Validate(Quantity, Qty2);
                    Evaluate(UnitPrice, DirectUnitCost);
                    SalesLine.Validate("Unit Price", UnitPrice);
                    Evaluate(AMT2, Amt);
                    SalesLine.Validate(Amount, AMT2);

                    if GstCredit = 'Availment' then
                        SalesLine."GST Credit" := SalesLine."gst credit"::Availment
                    else
                        if GstCredit = 'Non-Availment' then
                            SalesLine."GST Credit" := SalesLine."gst credit"::"Non-Availment";
                    if GstGrType = 'Goods' then
                        SalesLine."GST Group Type" := SalesLine."gst group type"::Goods
                    else
                        if GstGrType = 'Service' then
                            SalesLine.Validate("GST Group Code", GstGrCode);
                    SalesLine.Validate("HSN/SAC Code", HSNCode);

                    if GstCredit = 'Availment' then
                        GstPerce := 0
                    else
                        GstPerce := 1;

                    SalesLine.Modify();






                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnPostXmlPort()
    begin
        Message(Text001, Counter);
    end;

    var

        Noseriesmgmt: Codeunit NoSeriesManagement;
        SalesnRecSetup: Record "Sales & Receivables Setup";
        DocNo1: Code[20];
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Counter: Integer;
        Lineno1: Integer;
        Pdate: Date;
        Ddate: Date;
        Qty1: Decimal;
        UnitPrice1: Decimal;
        type2: Enum "Sales Line Type";
        L2: Integer;
        Text001: Label '%1 Sales order Created.';
        Sub_Order_no: Code[30];
        DimSetEnt: Record "Dimension Set Entry";
        //PayMode: Enum "Payment Mode";
        SalePost: Codeunit "Sales-Post";
        SalePostYesNo: Codeunit "Sales-Post (Yes/No)";
        // PartnerType1: Enum "Partners Type";
        Salescomment: Record "Sales Comment Line";
        Qty2: Decimal;
        PostingDate2: Date;
        OrderDate2: Date;
        UnitPrice: Decimal;
        RateInPcs2: Decimal;
        ExpiryDate2: Date;
        ManufacturingDate2: Date;
        AMT2: Decimal;
        GstPerce: Decimal;
        //GSTBAMT: Decimal;
        TotalGST: Decimal;
        Exemp: Boolean;
        RecPH: Record 36;
        Rec_PurchHeader1: Record 36;

    // Type: Code[20];
    // ItemNo: Code[30];
    // Qty: Decimal;
    // UnitPrice: Decimal;
}
*/