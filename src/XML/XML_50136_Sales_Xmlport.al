#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50136 "Sales order Uploads"
{
    Format = VariableText;
    Caption = 'Sales order Uploads';
    schema
    {
        textelement(Root)
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

                textelement(SelltoCustNo)
                {
                    MinOccurs = Zero;
                }
                textelement(ShipTocustNo)
                {
                    MinOccurs = Zero;
                }

                textelement(DocDate)
                {
                    MinOccurs = Zero;
                }

                textelement(PostingDate)
                {
                    MinOccurs = Zero;
                }
                textelement(OrderDate)
                {
                    MinOccurs = Zero;
                }
                textelement(LocCode)
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

                textelement(QTY)
                {
                    MinOccurs = Zero;
                }
                textelement(UOM)
                {
                    MinOccurs = Zero;
                }

                textelement(UnitPrice)
                {
                    MinOccurs = Zero;
                }


                textelement(TCSnatureofcoll)
                {
                    MinOccurs = zero;
                }
                textelement(GstGrCode)
                {
                    MinOccurs = zero;
                }

                textelement(HSNCode)
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

                    if DocNo1 <> DocNo then begin
                        SalesHeader.Reset();
                        if DocType = 'Order' then
                            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                        if DocType = 'Invoice' then
                            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);

                        SalesHeader.SetRange("No.", DocNo);
                        if not SalesHeader.Find('-') then begin
                            SalesnRecSetup.Get();
                            Clear(SalesHeader);
                            SalesHeader.INIT;
                            if DocType = 'Order' then begin
                                SalesHeader."Document Type" := SalesHeader."document type"::Order;
                                SalesHeader.Validate("No.", Noseriesmgmt.GetNextNo(SalesnRecSetup."Order Nos.", Today, true));

                            end;
                            if DocType = 'Invoice' then begin
                                SalesHeader."Document Type" := SalesHeader."document type"::Invoice;
                                SalesHeader.Validate("No.", Noseriesmgmt.GetNextNo(SalesnRecSetup."Invoice Nos.", Today, true));
                                //
                            end;
                            if DocType = 'Credit Memo' then begin
                                SalesHeader."Document Type" := SalesHeader."document type"::Invoice;
                                SalesHeader.Validate("No.", Noseriesmgmt.GetNextNo(SalesnRecSetup."Credit Memo Nos.", Today, true));
                                //
                            end;
                            // DocNo := SalesHeader."No.";
                            DocNo1 := DocNo;

                            SalesHeader.INSERT(TRUE);
                            SalesHeader.VALIDATE("Sell-to Customer No.", SelltoCustNo);
                            SalesHeader.Validate("Posting Date", Pdate);
                            SalesHeader.Validate("Document Date", Ddate);
                            SalesHeader.validate("Document Date", ODate);
                            SalesHeader.Validate("location code", LocCode);
                            SalesHeader.Modify();



                        end;
                    end;
                    Counter += 1;


                    Lineno1 += 1;
                    Clear(SalesLine);
                    SalesLine.INIT;
                    if DocType = 'Order' then
                        SalesLine."Document Type" := SalesLine."Document Type"::Order
                    else
                        SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine."Line No." := Lineno1 * 10000;
                    if Type = 'Item' then
                        SalesLine.Type := SalesLine.Type::Item
                    else
                        if Type = 'G/L Account' then
                            SalesLine.Type := SalesLine.Type::"G/L Account"
                        else
                            if Type = 'Fixed Assets' then
                                SalesLine.Type := SalesLine.Type::"Fixed Asset";
                    //SalesLine.Validate(Type, type2);
                    SalesLine."No." := No;
                    SalesLine.Insert();
                    SalesLine.Validate("Sell-to Customer No.", SelltoCustNo);
                    SalesLine.Validate("No.", No);
                    Evaluate(Qty2, QTY);
                    SalesLine.Validate(Quantity, Qty2);
                    SalesLine.Validate("Unit of Measure", UOM);
                    Evaluate(UnitPrice1, UnitPrice);
                    SalesLine.Validate("Unit Cost", UnitPrice1);
                    SalesLine.Validate("Unit Price", UnitPrice1);
                    SalesLine.Validate("Unit Price Incl. of Tax", UnitPrice1);
                    SalesLine.Validate("TCS Nature of Collection", TCSnatureofcoll);
                    SalesLine.Validate("GST Group Code", GstGrCode);
                    SalesLine.Validate("HSN/SAC Code", HSNCode);
                    SalesLine.Validate("HSN/SAC Code");
                    SalesLine.Modify();
                    SalesLine.CalcLineAmount();
                    // SalesLine.Modify();
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
        // UnitPrice: Decimal;
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


}
