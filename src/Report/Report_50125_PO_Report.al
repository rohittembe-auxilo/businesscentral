Report 50125 "PO Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'PO Report.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.";
            //company info. block
            column(name; compInfo.Name) { }
            column(address; compInfo.Address) { }
            column(address2; compInfo."Address 2") { }
            // column(GstIn_UIN; compInfo."Registration No.") { }
            column(state_name; compInfo."State Code") { }
            column(Email; compInfo."E-Mail") { }
            column(GstNo; compInfo."GST Registration No.") { }
            column(PanNo; compInfo."P.A.N. No.") { }

            column(No_; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }
            column("t1"; "TnC1") { }
            column("t2"; "TnC2") { }
            column("t3"; "TnC3") { }
            column("t4"; "TnC4") { }
            column("t5"; "TnC5") { }
            column("t6"; "TnC6") { }
            column(Vendor_GST_Reg__No_; "gstNo_v") { }
            column(pan_v; pan_v) { }



            column(Pay_to_Name; "Pay-to Name") { }
            column(Pay_to_Address; "Pay-to Address") { }
            column(Pay_to_City; "Pay-to City") { }
            column(Pay_to_Address_2; "Pay-to Address 2") { }
            column(Pay_to_Country_Region_Code; "Pay-to Country/Region Code") { }
            column(State; State) { }
            // column(){}

            // column(Ship_to_Country_Region_Code;"Ship-to Country/Region Code"){}
            // column(){}



            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase header";
                DataItemLink = "Document No." = field("No.");
                // RequestFilterFields = "Document No.";

                column(SR_No_; "No.") { }
                column(Description; ServiceDescription) { }
                column(Quantity; Quantity) { }
                column(Unit_Cost; "Unit Cost") { }

                column(taxTotal; taxTotal) { }
                column(price; price) { }
                column(grandTotal; grandTotal) { }

                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin
                    Clear(comment);
                    Clear(ServiceDescription);
                    clear(grandTotal);
                    clear(taxTotal);
                    Clear(price);

                    purchComLine.Reset();
                    purchComLine.SetRange(purchComLine."No.", "Purchase Header"."No.");
                    purchComLine.SetRange("Document Line No.", "Purchase Line"."Line No.");

                    if purchComLine.FindFirst() then begin
                        repeat
                            comment += (purchComLine.Comment + ', ');
                        until purchComLine.Next() = 0;

                    end;

                    price := ("Purchase Line"."Unit Cost") * ("Purchase Line".Quantity);
                    taxTotal := price * (18 / 100);
                    grandTotal := price + taxTotal;
                    ServiceDescription := "Purchase Line".Description + ', ' + comment;



                end;




            }

            trigger OnPreDataItem()
            var


            begin
                compInfo.get();

                compInfo.CalcFields(compInfo.Picture);


            end;



            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                Clear(State);
                Clear(gstNo_v);
                Clear(pan_v);
                recState.Reset();
                recState.SetRange(code, "Purchase Header"."Location State Code");
                if recState.FindFirst() then
                    State := recState.Description;

                recvendor.Reset();
                recvendor.SetRange("No.", "Purchase Header"."Buy-from Vendor No.");
                if recvendor.FindFirst() then begin
                    gstNo_v := recvendor."GST Registration No.";
                    pan_v := recvendor."P.A.N. No.";
                end;


            end;
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
        recState: record state;
        recvendor: record Vendor;
        gstNo_v: code[50];
        pan_v: code[20];
        state: Text[50];
        compInfo: Record "company Information";
        comment: text[500];
        purchComLine: Record "Purch. Comment Line";
        ServiceDescription: Text[200];
        price: Decimal;
        taxTotal: Decimal;
        total: Decimal;
        "Purchase Line1": Record "Purchase Line";
        "Tax Transaction Value": Record "Tax Transaction Value";
        TotalCGST: Decimal;
        TotalSGST: Decimal;
        TotalIGST: Decimal;
        TotalTDSAmt: Decimal;
        // "Purchase Line1": Record "Purchase Line";
        // "Purchase Header": Record "Purchase Header";
        saleHeader: Record "Purchase Header";
        TotalAmount: Decimal;
        ItemName: Text[30];
        TaxRecordID: RecordId;
        SGSTtxt: Text[30];
        CGSTtxt: Text[30];
        IGSTtxt: Text[30];
        TaxTransactionValue: Record "Tax Transaction Value";
        // total: Decimal;
        CGSTRate: Decimal;
        CGST: Decimal;
        SGSTRate: Decimal;
        SGST: Decimal;
        IGSTRate: Decimal;
        IGST: Decimal;
        grandTotal: Decimal;

}