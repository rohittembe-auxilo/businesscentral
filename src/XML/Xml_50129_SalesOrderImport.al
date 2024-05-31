#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50129 "Sales Order-Import"
{


    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("Sales Header"; "Sales Header")
            {
                XmlName = 'SalesHeader';
                textelement(CustNo)
                {
                }
                textelement(Location)
                {
                }
                textelement(OrderDate)
                {
                }
                textelement(ItemNo)
                {
                }
                textelement(UOM)
                {
                }
                textelement(Qty)
                {
                }
                textelement(LineNo)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    InsertSalesData;
                    currXMLport.Skip;
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
        Message('File Imported Successfully')
    end;

    var
        SalesLine: Record "Sales Line";
        DocNo: Code[20];
        SalesInvoiceNo: Code[20];
        SalesHeader: Record "Sales Header";
        ShortcutDim1Value: Code[20];
        ShortcutDim2Value: Code[20];
        ShortcutDim3Value: Code[20];
        ShortcutDim4Value: Code[20];
        ShortcutDim5Value: Code[20];
        SalesLineNo: Integer;
        SalesCustomerNo: Code[20];
        RowCtr: Integer;
        InvoiceCount: Integer;
        CreditmemoCount: Integer;
        InvoiceAmt: Decimal;
        CreditMemoAMT: Decimal;
        ItemUnitofMeasure: Record "Item Unit of Measure";

    local procedure InsertSalesData()
    begin
        RowCtr += 1;
        if RowCtr = 1 then currXMLport.Skip;

        if (LineNo = '10000') then begin
            SalesHeader.Reset;
            SalesHeader.Init;
            SalesHeader."Document Type" := SalesHeader."document type"::Order;
            SalesHeader."No." := '';
            if SalesHeader.Insert(true) then
                SalesHeader.Validate("Sell-to Customer No.", CustNo);
            // SalesHeader.Validate(Structure);//RUSHAB
            if OrderDate <> '' then
                Evaluate(SalesHeader."Order Date", OrderDate)
            else
                SalesHeader."Order Date" := WorkDate;
            SalesHeader.Validate("Order Date");
            "Sales Header".Validate("Sales Header"."Location Code", Location);
            SalesHeader.Modify(true);
        end;
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine.Validate("Sell-to Customer No.", "Sales Header"."Sell-to Customer No.");
        SalesLine.Type := SalesLine.Type::Item;
        Evaluate(SalesLine."Line No.", LineNo);
        SalesLine.Validate("No.", ItemNo);
        SalesLine.Insert(true);
        ItemUnitofMeasure.Get(ItemNo, UOM);
        SalesLine.Validate("Unit of Measure Code", UOM);
        Evaluate(SalesLine.Quantity, Qty);
        SalesLine.Validate(Quantity);
        SalesLine.Modify(true);
    end;
}

