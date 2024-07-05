pageextension 50115 PurchaseInvoiceSubforms extends "Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Description")
        {
            field("Comments"; Rec."Comments")
            {
                ApplicationArea = All;
            }
            field("Comment"; Rec."Comment")
            {
                ApplicationArea = All;
            }
        }

        modify("No.")
        {
            trigger OnAfterValidate()
            var
                GLAccount: Record "G/L Account";
                PurchaseHeader: Record "Purchase Header";
                PurchaseLine: Record "Purchase Line";
                VendorGLAccount: Record "Vendor GL Account";
            begin
                //>> ST
                IF rec.Type = Type::"G/L Account" THEN BEGIN
                    PurchaseHeader.Get(PurchaseHeader."Document Type"::Invoice, Rec."Document No.");
                    if not VendorGLAccount.Get(PurchaseHeader."Buy-from Vendor No.", Rec."No.") then
                        ERROR('Vendor G/L Account Not Available for this %1', PurchaseHeader."Buy-from Vendor No.");

                    GLAccount.get(rec."No.");
                    PurchaseLine.get(Rec."Document Type", Rec."Document No.", Rec."Line No.");
                    PurchaseLine.Validate("TDS Section Code", GLAccount."TDS");
                    PurchaseLine.Modify();
                    CurrPage.Update();
                END;
                //<< ST
            end;
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}