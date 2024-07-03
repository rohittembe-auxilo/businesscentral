pageextension 50169 vendor extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Balance (LCY)")
        {

            field("Blocked Reason"; Rec."Blocked Reason")
            {
                ApplicationArea = All;
            }
            field(MSME; Rec.MSME)
            {
                ApplicationArea = All;
            }
            field("MSME No."; Rec."MSME No.")
            {
                ApplicationArea = All;
            }
            field("MSME Type"; Rec."MSME Type")
            {
                ApplicationArea = All;
            }

            field("Last Modified Date Time"; Rec."Last Modified Date Time")
            {
                ApplicationArea = All;
            }
            field(Balance; Rec.Balance)
            { ApplicationArea = all; }
            field("Net Change"; Rec."Net Change")
            { ApplicationArea = all; }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = all;
            }
            field("Related party transaction"; Rec."Related party transaction")
            {
                ApplicationArea = all;
            }
            field("GRN Qty"; Rec."GRN Qty")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 3"; Rec."Shortcut Dimension 3")
            {
                ApplicationArea = all;
            }
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
            {
                ApplicationArea = All;
            }

            field("LMS Vendor No"; Rec."LMS Vendor No")
            {
                ApplicationArea = All;

            }
            field("Incoming Document Entry No."; Rec."Incoming Document Entry No.")
            {
                ApplicationArea = all;
            }
            field("E-Mail 2"; Rec."E-Mail 2")
            {
                ApplicationArea = All;
            }
            field("Mobile No"; Rec."Mobile No")
            {
                ApplicationArea = All;
            }
            field("Address 3"; Rec."Address 3")
            {
                ApplicationArea = All;
            }
            field("Created DateTime"; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Caption = 'Created DateTime';
            }
            field("Created By"; CreatedBy)
            {
                ApplicationArea = All;
                Caption = 'Created By';
            }
            field("Modified DateTime"; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Caption = 'Modified DateTime';
            }
            field("Modified By"; ModifiedBy)
            {
                ApplicationArea = All;
                Caption = 'Modified By';
            }
        }
        modify("P.A.N. No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
                RecVendor: Record Vendor;
                i: Integer;
                SamePANErr: TextConst ENU = '3 to 12 in GST Registration No. should be same as it is in PAN No. so delete and then update it.';
            begin
                RecVendor.RESET();
                RecVendor.SETRANGE("P.A.N. No.", Rec."P.A.N. No.");
                IF RecVendor.FIND('-') THEN
                    Message('P.A.N. No. already  attached with Vendor %1 - %2', RecVendor."No.", RecVendor.Name);
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
                    Error(SamePANErr);
            end;
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Bank Accounts")
        {
            action("GL Accounts")
            {
                ApplicationArea = All;
                RunObject = page "Vendor G/L Account";
                RunPageLink = "Vendor No" = FIELD("No.");
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin


                end;
            }
            action("Import Allowed Sections")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Xmlport.Run(50140);
                end;
            }
            action("Import TDS Concessional Code")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Xmlport.Run(50139);
                end;
            }
        }
    }

    var
        myInt: Integer;
        vend: Page "Vendor Card";
        CreatedBy: Text;
        ModifiedBy: Text;

    trigger OnAfterGetRecord()
    var
        User: Record User;
    begin
        CreatedBy := '';
        User.Reset();
        User.SetRange("User Security ID", Rec.SystemCreatedBy);
        If User.FindFirst() then
            CreatedBy := User."User Name";

        ModifiedBy := '';
        User.Reset();
        User.SetRange("User Security ID", Rec.SystemModifiedBy);
        If User.FindFirst() then
            ModifiedBy := User."User Name";
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        myInt: Integer;
    begin
        rec.TestField(Name);
        rec.TestField("P.A.N. No.");
        rec.TestField("Location Code");
        //  rec.TestField("Shortcut Dimension 3 Code");
        rec.TestField("Post Code");
        rec.TestField("State Code");
        rec.TestField(Address);
        rec.TestField("Vendor Posting Group");
        rec.TestField("Gen. Bus. Posting Group");
        rec.TestField("Payment Method Code");
        rec.TestField("Preferred Bank Account Code");
        // rec.TestField("Shortcut Dimension 4 Code");
        // rec.TestField("Shortcut Dimension 5 Code");
        // rec.TestField("Shortcut Dimension 6 Code");
        // rec.TestField("Shortcut Dimension 7 Code");
        // rec.TestField("Shortcut Dimension 8 Code");
    end;
}