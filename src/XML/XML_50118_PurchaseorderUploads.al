XmlPort 50118 "Purchase order Uploads New"
{
    DefaultFieldsValidation = false;
    Direction = Both;
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = UTF16;

    schema
    {
        textelement(Root)
        {
            tableelement("Purchase Header"; "Purchase Header")
            {
                AutoSave = false;
                XmlName = 'PurchaseHeader';
                textelement(DocType)
                {
                }
                textelement(DocNo)
                {
                }
                textelement(BuyFromVend)
                {
                }
                textelement(BuyFromVendName)
                {
                }
                textelement(DocDate)
                {
                }
                textelement(OrderDate)
                {
                }
                textelement(PostingDate)
                {
                }
                textelement(PayTermCode)
                {
                }
                textelement(LocCode)
                {
                }
                textelement(ShortDim1)
                {
                }
                textelement(ShortDim2)
                {
                }
                textelement(ShortDim3)
                {
                }
                textelement(ShortDim4)
                {
                }
                textelement(ShortDim5)
                {
                }
                textelement(ShortDim6)
                {
                }
                textelement(ShortDim7)
                {
                }
                textelement(ShortDim8)
                {
                }
                textelement(VendPostingGr)
                {
                }
                textelement(VendInvNo)
                {
                }
                textelement(GenBusPostGr)
                {
                }
                textelement(Structure)
                {
                }
                textelement(GstVendType)
                {
                }
                textelement(LineNo)
                {
                }
                textelement(Type)
                {
                }
                textelement(No)
                {
                    MinOccurs = Zero;
                }
                textelement(Disc)
                {
                    MinOccurs = Once;
                }
                textelement(Disc2)
                {
                }
                textelement(QTY)
                {
                }
                textelement(DirectUnitCost)
                {
                }
                textelement(Amt)
                {
                }
                textelement(TdsNatureOfDed)
                {
                }
                textelement(GstCredit)
                {
                }
                textelement(GstGrCode)
                {
                }
                textelement(GstGrType)
                {
                }
                textelement(HSNCode)
                {
                }
                textelement(GstBaseAmt)
                {
                }
                textelement(GSTPER)
                {
                }
                textelement(TotGstAmt)
                {
                }
                textelement(Exempted)
                {
                }
                textelement(GstJurType)
                {
                }
                textelement(Comment)
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    cnt += 1;
                    //IF cnt=1 THEN
                    //  currXMLport.SKIP;
                    /* Rec_PurchHeader1.RESET;
                     Rec_PurchHeader1.SETRANGE("Vendor Invoice No.",VendInvNo);
                     Rec_PurchHeader1.SETRANGE("Buy-from Vendor No.",BuyFromVend);//CCIT Added Line For Vendor order  no Can be same for different Vendor
                     IF Rec_PurchHeader1.FINDFIRST THEN BEGIN*/

                    Clear(PurchaseHeader);
                    PurchaseHeader.Init();
                    if DocType = 'Order' then
                        PurchaseHeader."Document Type" := PurchaseHeader."document type"::Order;

                    PurchaseHeader.Validate("Buy-from Vendor No.", BuyFromVend);
                    PurchaseHeader.Validate("Buy-from Vendor Name", BuyFromVendName);
                    Evaluate(PostingDate2, PostingDate);
                    PurchaseHeader.Validate("Posting Date", PostingDate2);
                    Evaluate(OrderDate2, OrderDate);
                    PurchaseHeader.Validate("Order Date", OrderDate2);
                    PurchaseHeader.Validate("Location Code", LocCode);
                    PurchaseHeader.Validate("Payment Terms Code", PayTermCode);
                    PurchaseHeader.Validate("Vendor Invoice No.", VendInvNo);
                    PurchaseHeader.Validate("Vendor Posting Group", VendPostingGr);
                    PurchaseHeader.Validate("Gen. Bus. Posting Group", GenBusPostGr);
                    if GstVendType = 'Composite' then
                        PurchaseHeader."GST Vendor Type" := PurchaseHeader."gst vendor type"::Composite
                    else if GstVendType = 'Exempted' then
                        PurchaseHeader."GST Vendor Type" := PurchaseHeader."gst vendor type"::Exempted
                    else if GstVendType = 'Import' then
                        PurchaseHeader."GST Vendor Type" := PurchaseHeader."gst vendor type"::Import
                    else if GstVendType = 'Registered' then
                        PurchaseHeader."GST Vendor Type" := PurchaseHeader."gst vendor type"::Registered
                    else if GstVendType = 'SEZ' then
                        PurchaseHeader."GST Vendor Type" := PurchaseHeader."gst vendor type"::SEZ
                    else if GstVendType = 'Unregistered' then
                        PurchaseHeader."GST Vendor Type" := PurchaseHeader."gst vendor type"::Unregistered;

                    //vmig   PurchaseHeader.Validate(Structure, Structure);
                    PurchaseHeader.Insert;
                    //PurchaseHeader.MODIFY;
                    if PurchaseHeader.Insert(true) then begin
                        RecPH.Reset;
                        RecPH.SetRange(RecPH."No.", PurchaseHeader."No.");
                        if RecPH.FindFirst then begin
                            RecPH.Validate("Shortcut Dimension 1 Code", ShortDim1);
                            RecPH.Validate("Shortcut Dimension 2 Code", ShortDim2);
                            RecPH.Validate("Shortcut Dimension 3 Code", ShortDim3);
                            RecPH.Validate("Shortcut Dimension 4 Code", ShortDim4);
                            RecPH.Validate("Shortcut Dimension 5 Code", ShortDim5);
                            RecPH.Validate("Shortcut Dimension 6 Code", ShortDim6);
                            RecPH.Validate("Shortcut Dimension 7 Code", ShortDim7);
                            RecPH.Validate("Shortcut Dimension 8 Code", ShortDim8);
                            RecPH.Modify;
                        end;
                    end;

                    PurchaseLine2.Reset();
                    PurchaseLine2.SetRange("Document Type", PurchaseLine2."document type"::Order);
                    PurchaseLine2.SetRange("Document No.", PurchaseHeader."No.");
                    if PurchaseLine2.FindLast then
                        "LineNo." := PurchaseLine2."Line No." + 10000
                    else
                        "LineNo." := 10000;

                    PurchaseLine.Init();
                    PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                    PurchaseLine."Document No." := PurchaseHeader."No.";
                    PurchaseLine."Line No." := "LineNo.";
                    PurchaseLine."Buy-from Vendor No." := BuyFromVend;
                    if Type = 'Item' then
                        PurchaseLine.Type := PurchaseLine.Type::Item
                    else if Type = 'G/L Account' then
                        PurchaseLine.Type := PurchaseLine.Type::"G/L Account";

                    PurchaseLine.Validate("No.", No);
                    PurchaseLine.Validate(Description, Disc);
                    PurchaseLine.Validate("Description 2", Disc2);
                    Evaluate(Qty2, QTY);
                    PurchaseLine.Validate(Quantity, Qty2);
                    Evaluate(UnitPrice, DirectUnitCost);
                    PurchaseLine.Validate("Direct Unit Cost", UnitPrice);
                    Evaluate(AMT2, Amt);
                    PurchaseLine.Validate(Amount, AMT2);
                    //vmig    PurchaseLine.Validate("TDS Nature of Deduction", TdsNatureOfDed);
                    if GstCredit = 'Availment' then
                        PurchaseLine."GST Credit" := PurchaseLine."gst credit"::Availment
                    else if GstCredit = 'Non-Availment' then
                        PurchaseLine."GST Credit" := PurchaseLine."gst credit"::"Non-Availment";
                    if GstGrType = 'Goods' then
                        PurchaseLine."GST Group Type" := PurchaseLine."gst group type"::Goods
                    else if GstGrType = 'Service' then
                        PurchaseLine."GST Group Type" := PurchaseLine."gst group type"::Service;
                    if GstJurType = 'Interstate' then
                        PurchaseLine."GST Jurisdiction Type" := PurchaseLine."gst jurisdiction type"::Interstate
                    else if GstJurType = 'Intrastate' then
                        PurchaseLine."GST Jurisdiction Type" := PurchaseLine."gst jurisdiction type"::Intrastate;

                    PurchaseLine.Validate("GST Group Code", GstGrCode);
                    PurchaseLine.Validate("HSN/SAC Code", HSNCode);
                    Evaluate(GSTBAMT, GstBaseAmt);
                    //vmig    PurchaseLine.Validate("GST Base Amount", GSTBAMT);
                    if GstCredit = 'Availment' then
                        GstPerce := 0
                    else
                        GstPerce := 1;
                    //EVALUATE(GstPerce,GSTPER);
                    //vmig  PurchaseLine.Validate("GST %", GstPerce);
                    Evaluate(TotalGST, TotGstAmt);
                    //vmig  PurchaseLine.Validate("Total GST Amount", TotalGST);
                    Evaluate(Exemp, Exempted);
                    PurchaseLine.Validate(Exempted, Exemp);
                    PurchaseLine.Validate(Comment, Comment);

                    PurchaseLine.Insert();
                    //END;
                    //END;
                    //END;

                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        Message('Total %1 lines uploaded successfully..', cnt);
    end;

    trigger OnPreXmlPort()
    begin
        cnt := 0;
    end;

    var
        lastEntryNo: Integer;
        cnt: Integer;
        EIRCnt: Integer;
        NewNo: Code[25];
        PrevNo: Code[25];
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchaseLine2: Record "Purchase Line";
        "LineNo.": Integer;
        Qty2: Decimal;
        PostingDate2: Date;
        OrderDate2: Date;
        UnitPrice: Decimal;
        RateInPcs2: Decimal;
        ExpiryDate2: Date;
        ManufacturingDate2: Date;
        AMT2: Decimal;
        GstPerce: Decimal;
        GSTBAMT: Decimal;
        TotalGST: Decimal;
        Exemp: Boolean;
        RecPH: Record "Purchase Header";
        Rec_PurchHeader1: Record "Purchase Header";

    local procedure CreateReservationSales(PurchaseHeader1: Record "Purchase Header"; PurchaseLine1: Record "Purchase Line"; LotNo: Text)
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        /*ReservationEntry.INIT;
        ReservationEntry.VALIDATE("Item No.",PurchaseLine1."No.");
        ReservationEntry.VALIDATE("Location Code",PurchaseLine1."Location Code");
        ReservationEntry.VALIDATE("Quantity (Base)",PurchaseLine1."Quantity (Base)");
        ReservationEntry.VALIDATE("Reservation Status",ReservationEntry."Reservation Status"::Surplus);
        ReservationEntry.VALIDATE(Description,PurchaseLine1.Description);
        ReservationEntry.VALIDATE("Creation Date",PurchaseHeader1."Order Date");
        ReservationEntry.VALIDATE("Source Type",39);
        ReservationEntry.VALIDATE("Source Subtype",1);
        ReservationEntry.VALIDATE("Source ID",PurchaseHeader1."No.");
        ReservationEntry.VALIDATE("Source Ref. No.",PurchaseLine1."Line No.");
        ReservationEntry.VALIDATE("Created By",USERID);
        ReservationEntry.VALIDATE("Qty. per Unit of Measure",PurchaseLine1."Qty. per Unit of Measure");
        ReservationEntry.VALIDATE(Quantity,PurchaseLine1.Quantity);
        ReservationEntry."Planning Flexibility" := ReservationEntry."Planning Flexibility"::Unlimited;
        ReservationEntry.VALIDATE("Qty. to Handle (Base)",PurchaseLine1."Quantity (Base)");
        ReservationEntry.VALIDATE("Qty. to Invoice (Base)",PurchaseLine1."Quantity (Base)");
        ReservationEntry.VALIDATE("Lot No.",LotNo);
        ReservationEntry.VALIDATE("Item Tracking",ReservationEntry."Item Tracking"::"Lot No.");
        EVALUATE(ExpiryDate2,ExpiryDate);
        ReservationEntry."Expiration Date" := ExpiryDate2;
        EVALUATE(ManufacturingDate2,ManufacturingDate);
        ReservationEntry."Manufacturing Date" := ManufacturingDate2;
        ReservationEntry.INSERT;*/

    end;
}

