pageextension 50172 CustomerCard extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Gen. Bus. Posting Group")
        {
            field("Shortcut Dimension 3"; Rec."Shortcut Dimension 3")
            {
                ApplicationArea = All;
            }
            field("Balance at Date"; Rec."Balance at Date")
            {
                ApplicationArea = All;
            }
            field(Attachments; Rec.Attachments)
            {
                ApplicationArea = all;
            }

        }
        modify("P.A.N. No.")
        {
            trigger OnAfterValidate()
            var

                Customer: Record Customer;
                i: Integer;
                SamePANErr: TextConst ENU = '3 to 12 in GST Registration No. should be same as it is in PAN No. so delete and then update it.';
            begin
                Customer.RESET();
                Customer.SETRANGE("P.A.N. No.", Rec."P.A.N. No.");
                IF Customer.FIND('-') THEN
                    Message('P.A.N. No. already  attached with Customer %1 - %2', Customer."No.", Customer.Name);
                //Already Exist CCIT AN --
                //CCIT AN 05072023++
                IF Rec."P.A.N. No." <> xRec."P.A.N. No." THEN BEGIN
                    IF Rec."P.A.N. No." <> '' THEN BEGIN
                        IF STRLEN(Rec."P.A.N. No.") <> 10 THEN
                            ERROR('Length of P.A.N. No. must be 10 characters!');

                        FOR i := 1 TO 5 DO BEGIN
                            IF NOT (Rec."P.A.N. No."[i] IN ['A' .. 'Z']) THEN
                                ERROR('First 5 characters of PAN No. should be alphabets');
                        END;
                        FOR i := 6 TO 9 DO BEGIN
                            IF NOT (Rec."P.A.N. No."[i] IN ['0' .. '9']) THEN
                                ERROR('6 to 9 Must be Numbers');
                        END;
                        //IF i = 10 THEN
                        IF NOT (Rec."P.A.N. No."[10] IN ['A' .. 'Z']) THEN
                            ERROR('Last characters of PAN No. should be alphabets');
                    END;
                END;

                IF (Rec."GST Registration No." <> '') AND (Rec."P.A.N. No." <> COPYSTR(Rec."GST Registration No.", 3, 10)) THEN
                    Message(SamePANErr);



            end;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        Cust: Record Customer;
}