reportextension 50001 PurchaseInvoice extends "Purchase - Invoice"
{
    RDLCLayout = './Layouts/PurchaseInvNew.rdl';
    dataset
    {
        // Add changes to dataitems and columns here
        add("Purch. Inv. Header")
        {
            column(RCM_Invoice_No_; "RCM Invoice No.") { }
            column(Vendor_Invoice_No_; "Vendor Invoice No.") { }
            column(RCM_Payment_No_; "RCM Payment No.") { }
            column(CmpName; CmpName) { }
            column(ComName; CompanyInfo.Name) { }
            column(CmpAddress; CmpAddress) { }
            column(CmpAddress2; CmpAddress2) { }
            column(CmpCity; CmpCity) { }
            column(CmpPostCode; CmpPostCode) { }
            column(CmpState; CmpState) { }
            column(CmpPhone; CmpPhone) { }
            column(COMREgNO; CompanyInfo."Registration No.") { }
            column(Logo; CompanyInfo.Picture) { }
            column(CompanyInfo_GST_RegistrationNo; location."GST Registration No.") { }
            Column(LocAdd1; Location.Address) { }
            Column(LocAdd2; Location."Address 2") { }
            Column(LocCity; Location.City) { }
            Column(LocPostCOde; Location."Post Code") { }

            Column(LocCountry; Location.County) { }

            Column(LocPhone; Location."Phone No.") { }

            Column(LocGST; Location."GST Registration No.") { }

            Column(VendGST; Vendor."GST Registration No.") { }

            Column(Statename; States.Description) { }

            Column(LocState; Locstate.Description) { }

            Column(postDate; "Purch. Inv. Header"."Posting Date") { }

            Column(bankName; BankAccount.Name) { }
            Column(bankAccno; BankAccount."Bank Account No.") { }
            Column(bankifsc; BankAccount.IFSC) { }
            Column(innerdesc; ShowInnerDescription) { }
            Column(PurchCommentDescription; PurchCommDescription) { }


        }
        modify("Purch. Inv. Header")
        {


            trigger OnAfterAfterGetRecord()
            var
                myInt: Integer;
            begin
                Comp_info.RESET();
                Comp_info.SETFILTER("From Date", '<=%1', "Purch. Inv. Header"."Posting Date");
                Comp_info.SETFILTER("To Date", '>=%1', "Purch. Inv. Header"."Posting Date");
                IF Comp_info.FINDFIRST THEN BEGIN
                    CmpName := Comp_info.Name;
                    CmpAddress := Comp_info.Address;
                    CmpAddress2 := Comp_info."Address 2";
                    CmpCity := Comp_info.City;
                    CmpPostCode := Comp_info."Post Code";
                    CmpPhone := Comp_info."Phone No.";
                    //v   CmpState := Comp_info.state;
                END;
                IF States.GET(Vendor."State Code") THEN;
                Location.RESET;
                IF Location.GET("Purch. Inv. Header"."Location Code") THEN;
                Locstate.RESET;
                IF Locstate.GET(Location."State Code") THEN;


            end;



        }
        modify("Purch. Inv. Line")
        {
            trigger OnAfterAfterGetRecord()
            var
                myInt: Integer;
            begin
                //CCIT VIkas 04092020
                PurchCommDescription := '';
                k := 0;
                PurchComment.RESET();
                PurchComment.SETRANGE("Document Type", PurchComment."Document Type"::"Posted Invoice");
                PurchComment.SETRANGE("No.", "Purch. Inv. Line"."Document No.");
                PurchComment.SETRANGE("Document Line No.", "Line No.");
                IF PurchComment.FIND('-') THEN
                    REPEAT
                        IF k = 0 THEN BEGIN
                            PurchCommDescription := PurchComment.Comment;
                            k := 1;
                        END ELSE BEGIN
                            PurchCommDescription := PurchCommDescription + ', ' + PurchComment.Comment;
                        END;

                    UNTIL PurchComment.NEXT = 0;
                //CCIT VIkas 04092020
            END;


        }
        add("Purch. Inv. Line")
        {
            column(HSNCode; "HSN/SAC Code") { }

        }
        add(DimensionLoop1)
        {
            column(Dimtext1; Dimtext1) { }
        }





    }

    requestpage
    {
        // Add changes to the requestpage here
    }

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = RDLC;
    //         LayoutFile = 'mylayout.rdl';
    //     }

    // }
    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);


    end;

    var
        Comp_info: Record "Company Information2";
        CmpName: text[250];
        CmpAddress: text[250];
        CmpAddress2: text[250];
        CmpCity: text[250];
        CmpPostCode: text[250];
        CmpPhone: text[250];
        CmpState: text[250];
        States: Record State;
        Vendor: Record Vendor;
        Locstate: Record State;
        Location: Record Location;
        BankAccount: Record "Bank Account";
        ShowInnerDescription: Boolean;
        PurchCommDescription: Text;
        PurchComment: Record "Purch. Comment Line";
        k: integer;
        Dimtext1: Text;
        sfds: Codeunit 18001;


}