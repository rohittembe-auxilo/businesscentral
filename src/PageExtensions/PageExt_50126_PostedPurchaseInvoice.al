pageextension 50126 PostedPurchaseInvoices extends "Posted Purchase Invoices"
{
    layout
    {
        // Add changes to page layout here
        addafter("Shipment Method Code")
        {

            field("GST Group Code"; Rec."GST Group Code")
            {
                ApplicationArea = All;
            }
            field("GST Reverse Charge"; Rec."GST Reverse Charge")
            {
                ApplicationArea = All;
            }
            field("RCM Invoice No."; Rec."RCM Invoice No.")
            {
                ApplicationArea = All;
            }
            field("RCM Payment No."; Rec."RCM Payment No.")
            {
                ApplicationArea = All;
            }
            field("MSME Type"; Rec."MSME Type")
            {
                ApplicationArea = All;
            }
            field("MSME"; Rec."MSME")
            {
                ApplicationArea = All;
            }
            field("MSME No."; Rec."MSME No.")
            {
                ApplicationArea = All;
            }
            field("Bank Account No."; Rec."Bank Account No.")
            {
                ApplicationArea = All;
            }
            field("Bank Account Code"; Rec."Bank Account Code")
            {
                ApplicationArea = All;
            }
            field("Bank Account Name"; Rec."Bank Account Name")
            {
                ApplicationArea = All;
            }
            field("Bank Account IFSC"; Rec."Bank Account IFSC")
            {
                ApplicationArea = All;
            }
            field("Bank Account Email"; Rec."Bank Account Email")
            {
                ApplicationArea = All;
            }
            field("Purch. Order No."; Rec."Purch. Order No.")
            {
                ApplicationArea = All;
            }
            field("Applied Document No."; "AppliedDocNo")
            {
                ApplicationArea = All;
            }
            field("Approver ID"; Rec."Approver ID")
            {
                ApplicationArea = All;
            }
            field("Approver Date"; Rec."Approver Date")
            {
                ApplicationArea = All;
            }

        }

    }

    actions
    {
        // Add changes to page actions here
        addafter("&Print")
        {
            action("Purchase Invoice New")
            {
                ApplicationArea = All;
                RunObject = report "Purchase Invoice";



            }
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        CLEAR(UserDept);
        RecUserDep.RESET;
        RecUserDep.SETRANGE(RecUserDep."User ID", USERID);
        IF RecUserDep.FINDFIRST THEN
            REPEAT
                UserDept := UserDept + '|' + (RecUserDep.Department);
            UNTIL RecUserDep.NEXT = 0;

        rec.SETFILTER("Shortcut Dimension 3", DELCHR(UserDept, '<', '|'));
    END;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        AppliedDocNo := '';
        RECVLE.RESET();
        RECVLE.SETRANGE("Document No.", Rec."No.");
        RECVLE.SETRANGE("Document Type", RECVLE."Document Type"::Payment);
        IF RECVLE.FIND('-') THEN BEGIN
            IF RECVLE."Closed by Entry No." = 0 THEN BEGIN
                RECVLE2.RESET();
                RECVLE2.SETRANGE("Closed by Entry No.", RECVLE."Entry No.");
                IF RECVLE2.FIND('-') THEN
                    REPEAT
                        AppliedDocNo := AppliedDocNo + RECVLE2."Document No." + '   ';
                    UNTIL RECVLE2.NEXT = 0;
            END ELSE BEGIN
                RECVLE2.RESET();
                RECVLE2.SETRANGE("Entry No.", RECVLE."Closed by Entry No.");
                IF RECVLE2.FIND('-') THEN
                    REPEAT
                        AppliedDocNo := AppliedDocNo + RECVLE2."Document No." + '   ';
                    UNTIL RECVLE2.NEXT = 0;

            END;
        END;

        RECVLE.RESET();
        RECVLE.SETRANGE("Document No.", rec."No.");
        RECVLE.SETRANGE("Document Type", RECVLE."Document Type"::Invoice);
        IF RECVLE.FIND('-') THEN BEGIN
            IF RECVLE."Closed by Entry No." <> 0 THEN BEGIN
                RECVLE2.RESET();
                RECVLE2.SETRANGE("Entry No.", RECVLE."Closed by Entry No.");
                IF RECVLE2.FIND('-') THEN
                    AppliedDocNo := AppliedDocNo + RECVLE2."Document No." + '  ';
            END ELSE BEGIN
                RECVLE2.RESET();
                RECVLE2.SETRANGE("Closed by Entry No.", RECVLE."Entry No.");
                IF RECVLE2.FIND('-') THEN BEGIN
                    AppliedDocNo := AppliedDocNo + RECVLE2."Document No." + '  ';

                END;
            END;
        END;


    end;



    var
        UserDept: Text[1024];
        RecUserDep: Record "User Department";
        AppliedDocNo: Text;
        RECVLE: Record 25;
        RECVLE1: Record 25;
        RECVLE2: Record 25;

}