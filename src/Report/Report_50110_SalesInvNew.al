Report 50007 "Sales Inv New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SalesInvNew.rdl';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(No; "Sales Invoice Header"."No.")
            {
            }
            column(SelltoCustomerNo; "Sales Invoice Header"."Sell-to Customer No.")
            {
            }
            column(YourReference; "Sales Invoice Header"."Your Reference")
            {
            }
            column(ShiptoAddress; "Sales Invoice Header"."Ship-to Address")
            {
            }
            column(PostingDate; "Sales Invoice Header"."Posting Date")
            {
                IncludeCaption = true;
            }
            column(SelltoCustomerName; "Sales Invoice Header"."Sell-to Customer Name")
            {
            }
            column(SelltoAddress; "Sales Invoice Header"."Sell-to Address")
            {
            }
            column(SelltoAddress2; "Sales Invoice Header"."Sell-to Address 2")
            {
            }
            column(ExtDocNo; "Sales Invoice Header"."External Document No.")
            {
            }
            column(State; "Sales Invoice Header".State)
            {
            }
            column(SelltoCity; "Sales Invoice Header"."Sell-to City")
            {
            }
            column(SelltoPostCode; "Sales Invoice Header"."Sell-to Post Code")
            {
            }
            column(Name; CompanyInformation.Name)
            {
            }
            column(CompanyGST; CompanyInformation."GST Registration No.")
            {
            }
            column(PANno; CompanyInformation."P.A.N. No.")
            {
            }
            column(CompanyPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyAddress; CompanyInformation.Address)
            {
            }
            column(CompanyAddress2; CompanyInformation."Address 2")
            {
            }
            column(CompanyCity; CompanyInformation.City)
            {
            }
            column(CompanyPhone; CompanyInformation."Phone No.")
            {
            }
            column(ComapanyEmail; CompanyInformation."E-Mail")
            {
            }
            column(CompanyPostCode; CompanyInformation."Post Code")
            {
            }
            column(CompBankName; CompanyInformation."Bank Name")
            {
            }
            column(CompAccountNo; CompanyInformation."Bank Account No.")
            {
            }
            column(CompanyInfoRegistrationNo; CompanyInformation."Registration No.")
            {
            }
            column(CmpWebsit; CompanyInformation."Home Page")
            {
            }
            column(IFSC; IFSC)
            {
            }
            column(GSTIN; GSTIN)
            {
            }
            column(LName; LName)
            {
            }
            column(Add; Add)
            {
            }
            column(Add2; Aadd2)
            {
            }
            column(City; City)
            {
            }
            column(PostCode; PostCode)
            {
            }
            column(Country; Country)
            {
            }
            column(Conact; Conact)
            {
            }
            column(Email; Email)
            {
            }
            column(GstReg; GstReg)
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where(Type = filter("G/L Account"), "Line No." = filter(10000));
                column(ReportForNavId_1000000008; 1000000008)
                {
                }
                column(Description_SalesInvoiceLine; "Sales Invoice Line".Description)
                {
                }
                column(Description2_SalesInvoiceLine; "Sales Invoice Line"."Description 2")
                {
                }
                column(LineNo; "Sales Invoice Line"."Line No.")
                {
                }
                column(HSNSACCode_SalesInvoiceLine; "Sales Invoice Line"."HSN/SAC Code")
                {
                }
                column(LineAmount_SalesInvoiceLine; "Sales Invoice Line"."Line Amount")
                {
                }
                column(GSTGroupCode_SalesInvoiceLine; "Sales Invoice Line"."GST Group Code")
                {
                }
                column(GSTGroupType_SalesInvoiceLine; "Sales Invoice Line"."GST Group Type")
                {
                }
                column(GST_SalesInvoiceLine; '')//v"Sales Invoice Line"."GST %")
                {
                }
                column(TotalGSTAmount_SalesInvoiceLine; '')//v"Sales Invoice Line"."Total GST Amount")
                {
                }
                column(GSTJurisdictionType_SalesInvoiceLine; "Sales Invoice Line"."GST Jurisdiction Type")
                {
                }
                column(CGSTRate; CGSTRate)
                {
                }
                column(SGSTRate; SGSTRate)
                {
                }
                column(IGSTRate; IGSTRate)
                {
                }
                column(CGSTAmt; Abs(CGSTAmt))
                {
                }
                column(SGSTAmt; Abs(SGSTAmt))
                {
                }
                column(IGSTAmt; Abs(IGSTAmt))
                {
                }
                column(Total; Total)
                {
                }
                column(TotalAmount; TotalAmount)
                {
                }
                dataitem("Sales Comment Line"; "Sales Comment Line")
                {
                    DataItemLink = "No." = field("Document No.");
                    DataItemTableView = sorting("Document Type", "No.", "Document Line No.", "Line No.");
                    column(ReportForNavId_1000000032; 1000000032)
                    {
                    }
                    column(Comment; "Sales Comment Line".Comment)
                    {
                    }
                    column(DocLineNo; "Sales Comment Line"."Document Line No.")
                    {
                    }
                    column(CommentLineNo; "Sales Comment Line"."Line No.")
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin

                    if (Type <> Type::" ") then begin

                        DetailedGSTLedgerEntry.Reset;
                        DetailedGSTLedgerEntry.SetCurrentkey("Document Type", "Document No.", "Document Line No.");
                        //v   DetailedGSTLedgerEntry.SetRange("Transaction Type", DetailedGSTLedgerEntry."transaction type"::Sales);
                        DetailedGSTLedgerEntry.SetRange("Document No.", "Document No.");
                        //DetailedGSTLedgerEntry.SETRANGE("Document Line No.","Line No.");  //
                        DetailedGSTLedgerEntry.SetFilter("Document Line No.", '=%1', 0);
                        //v   DetailedGSTLedgerEntry.SetRange("GST Component Code", 'CGST'); //GSTComponentCode[J]);
                        if DetailedGSTLedgerEntry.FindSet then begin
                            repeat
                                CGSTAmt += DetailedGSTLedgerEntry."GST Amount";
                                CGSTRate := DetailedGSTLedgerEntry."GST %";
                            until DetailedGSTLedgerEntry.Next = 0;
                        end;
                        DetailedGSTLedgerEntry.Reset;
                        DetailedGSTLedgerEntry.SetCurrentkey("Document Type", "Document No.", "Document Line No.");
                        //v   DetailedGSTLedgerEntry.SetRange("Transaction Type", DetailedGSTLedgerEntry."transaction type"::Sales);
                        DetailedGSTLedgerEntry.SetRange("Document No.", "Document No.");
                        //DetailedGSTLedgerEntry.SETRANGE("Document Line No.","Line No.");//
                        DetailedGSTLedgerEntry.SetFilter("Document Line No.", '=%1', 0);
                        //v      DetailedGSTLedgerEntry.SetRange("GST Component Code", 'SGST'); //GSTComponentCode[J]);
                        if DetailedGSTLedgerEntry.FindSet then begin
                            repeat
                                SGSTAmt += DetailedGSTLedgerEntry."GST Amount";
                                SGSTRate := DetailedGSTLedgerEntry."GST %";
                            until DetailedGSTLedgerEntry.Next = 0;
                        end;
                        DetailedGSTLedgerEntry.Reset;
                        DetailedGSTLedgerEntry.SetCurrentkey("Document Type", "Document No.", "Document Line No.");
                        //v      DetailedGSTLedgerEntry.SetRange("Transaction Type", DetailedGSTLedgerEntry."transaction type"::Sales);
                        DetailedGSTLedgerEntry.SetRange("Document No.", "Document No.");
                        //DetailedGSTLedgerEntry.SETRANGE("Document Line No.","Line No.");
                        DetailedGSTLedgerEntry.SetFilter("Document Line No.", '=%1', 0); //
                                                                                         //v    DetailedGSTLedgerEntry.SetRange("GST Component Code", 'IGST'); //GSTComponentCode[J]);
                        if DetailedGSTLedgerEntry.FindSet then begin
                            repeat
                                IGSTAmt += DetailedGSTLedgerEntry."GST Amount";
                                IGSTRate := DetailedGSTLedgerEntry."GST %";
                            until DetailedGSTLedgerEntry.Next = 0;
                        end;
                    end;
                    /*
                    i := 1;
                    SalesCommentLine.RESET;
                    SalesCommentLine.SETRANGE("No.", "Sales Invoice Line"."Document No.");
                    SalesCommentLine.SETFILTER("Document Line No.",'<>%1',0);
                    IF SalesCommentLine.FINDSET THEN REPEAT
                         CommentsLine[i] := FORMAT(i) + '. ' + SalesCommentLine.Comment;
                          i +=1;
                      UNTIL SalesCommentLine.NEXT = 0;
                    */
                    Total += "Sales Invoice Line"."Line Amount";
                    //TaxTotal := CGSTAmt + SGSTAmt + IGSTAmt;
                    TotalAmount := Total + CGSTAmt + SGSTAmt + IGSTAmt;  // TaxTotal;

                end;
            }

            trigger OnAfterGetRecord()
            begin
                //      IsGSTApplicable := GSTManagement.IsGSTApplicable(Structure);
                Customer.Reset();
                Customer.SetRange("No.", "Sales Invoice Header"."Sell-to Customer No.");
                if Customer.FindFirst then
                    GSTIN := Customer."GST Registration No.";

                BankAccount.Reset();
                BankAccount.SetRange("Bank Account No.", CompanyInformation."Bank Account No.");
                if BankAccount.FindFirst then
                    IFSC := BankAccount.IFSC;

                Location.Reset();
                Location.SetRange(Code, "Sales Invoice Header"."Location Code");
                if Location.FindFirst then begin
                    LName := Location.Name;
                    Add := Location.Address;
                    Aadd2 := Location."Address 2";
                    City := Location.City;
                    PostCode := Location."Post Code";
                    Country := Location.County;
                    Conact := Location.Contact;
                    GstReg := Location."GST Registration No.";
                    Email := Location."E-Mail";
                end;

                i := 1;
                SalesCommentLine.Reset;
                SalesCommentLine.SetRange("No.", "Sales Invoice Line"."Document No.");
                SalesCommentLine.SetFilter("Document Line No.", '=%1', 0);  //'<>%1',0);
                if SalesCommentLine.FindSet then
                    repeat
                        CommentsLine[i] := Format(i) + '. ' + SalesCommentLine.Comment;
                        i += 1;
                    until SalesCommentLine.Next = 0;
            end;
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

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInformation.Get;
        CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        RecSalesLine: Record "Sales Line";
        SaleInvoiceHeader: Record "Sales Header";
        Total: Decimal;
        TotalAmount: Decimal;
        //  GSTManagement: Codeunit gstma;
        IsGSTApplicable: Boolean;
        DetailedGSTLedgerEntry: Record "Detailed GST Dist. Entry";
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        CGSTTotal: Decimal;
        SGSTTotal: Decimal;
        IGSTTotal: Decimal;
        CommentsLine: array[10] of Text[80];
        SalesCommentLine: Record "Sales Comment Line";
        i: Integer;
        TaxTotal: Decimal;
        Customer: Record Customer;
        GSTIN: Code[20];
        IFSC: Code[20];
        BankAccount: Record "Bank Account";
        Location: Record Location;
        LName: Text[50];
        Add: Text[50];
        Aadd2: Text[50];
        City: Text[30];
        PostCode: Code[20];
        GstReg: Code[15];
        Conact: Code[15];
        Email: Text[30];
        Country: Text[30];
}

