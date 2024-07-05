codeunit 50026 PurchValidations
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure AssignTDSSectionCodePurchaseLine(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
        GLAccount: Record "G/L Account";
        VendorGLAccount: Record "Vendor GL Account";
        AllowedSections: Record "Allowed Sections";
    begin
        //>> ST
        if Rec."Document Type" in [Rec."Document Type"::Order, Rec."Document Type"::Invoice] then begin
            IF rec.Type = Type::"G/L Account" THEN BEGIN
                PurchaseHeader.Get(Rec."Document Type", Rec."Document No.");
                if not VendorGLAccount.Get(PurchaseHeader."Buy-from Vendor No.", Rec."No.") then
                    ERROR('Vendor G/L Account Not Available for this %1', PurchaseHeader."Buy-from Vendor No.");

                GLAccount.get(rec."No.");
                Rec.Validate("TDS Section Code", GLAccount."TDS");
            END;
        end;
        //<< ST
    end;

}