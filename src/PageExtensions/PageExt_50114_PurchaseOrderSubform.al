pageextension 50114 PurchaseOrderSubforms extends "Purchase Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {


            field("Comments"; Rec."Comments")
            {
                ApplicationArea = All;
            }
            /* field("TDS Nature of Deduction"; Rec."TDS Nature of Deduction")
             {
                 ApplicationArea = All;
             }
             */

        }
        modify("No.")
        {

            trigger OnAfterValidate()
            begin
                //CCIT-PRI
                IF rec.Type = Type::"G/L Account" THEN BEGIN
                    RecGL.RESET;
                    RecGL.SETRANGE(RecGL."No.", rec."No.");
                    IF RecGL.FINDFIRST THEN BEGIN
                        TDS := RecGL.TDS;
                        //Vikas Mig   Rec."TDS Nature of Deduction" := TDS;
                        //Vikas Mig   Rec.VALIDATE("TDS Nature of Deduction");
                    END;

                    //CCIT AN 19072023
                    RecPurchHdr.RESET();
                    RecPurchHdr.SETRANGE(RecPurchHdr."No.", Rec."Document No.");
                    IF RecPurchHdr.FINDFIRST THEN BEGIN
                        VendorGLAccount.RESET();
                        VendorGLAccount.SETRANGE(VendorGLAccount."Vendor No", RecPurchHdr."Buy-from Vendor No.");
                        VendorGLAccount.SETRANGE("G/L Account No", Rec."No.");
                        //VendorGLAccount.SETFILTER(VendorGLAccount."G/L Account No",'<>%1',"No.");
                        IF NOT VendorGLAccount.FINDSET THEN
                            //REPEAT
                            ERROR('Vendor G/L Account Not Available for this %1', RecPurchHdr."Buy-from Vendor No.");
                        // UNTIL VendorGLAccount.NEXT=0;
                    END;
                    //CCIT AN--

                    RecPurchHdr.RESET;
                    RecPurchHdr.SETRANGE(RecPurchHdr."No.", Rec."Document No.");
                    IF RecPurchHdr.FINDFIRST THEN BEGIN
                        //Vikas Mig            RecNODLine.RESET;
                        //Vikas Mig           RecNODLine.SETRANGE(RecNODLine.Type, RecNODLine.Type::Vendor);
                        //Vikas Mig           RecNODLine.SETRANGE(RecNODLine."No.", RecPurchHdr."Buy-from Vendor No.");
                        //Vikas Mig           RecNODLine.SETRANGE(RecNODLine."NOD/NOC", TDS);
                        //Vikas Mig          IF NOT RecNODLine.FINDFIRST THEN
                        //Vikas Mig              ERROR('TDS Nature Of Deduction %1 Not available for Vendor %2', TDS, RecPurchHdr."Buy-from Vendor No.");
                    END;
                END;
                //CCIT-PRI

            end;

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        //V  RecNODLine: Record 13785;
        RecPurchHdr: Record 38;
        RecGL: Record 15;
        TDS: Code[20];
        VendorGLAccount: Record "Vendor GL Account";
        RecPurLine: Record 39;

}