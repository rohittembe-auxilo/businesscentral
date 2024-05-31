pageextension 50156 BankPaymentVoucher extends "Bank Payment Voucher"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Recipient Bank Account"; rec."Recipient Bank Account")
            {
                ApplicationArea = all;
            }
            field("Bank Account Code"; rec."Bank Account Code")
            {
                ApplicationArea = all;
            }

            field("Bank Account No."; rec."Bank Account No.")
            {
                ApplicationArea = all;
            }
            field("Bank Account Name"; rec."Bank Account Name")
            {
                ApplicationArea = all;
            }
            field("Bank Account IFSC"; rec."Bank Account IFSC")
            {
                ApplicationArea = all;
            }
            field("Bank Account E-Mail"; rec."Bank Account E-Mail")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here\
        addbefore("Tax payments")
        {
            action("Check Printing HDFC")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    RecGenJnlLineH: Record "Gen. Journal Line";
                begin
                    RecGenJnlLineH.RESET;
                    RecGenJnlLineH.SETRANGE("Journal Template Name", rec."Journal Template Name");
                    RecGenJnlLineH.SETRANGE("Journal Batch Name", rec."Journal Batch Name");
                    RecGenJnlLineH.SETRANGE("Document No.", rec."Document No.");
                    RecGenJnlLineH.SETRANGE("Posting Date", rec."Posting Date");
                    IF RecGenJnlLineH.FIND('-') THEN
                        REPORT.RUN(1304, TRUE, FALSE, RecGenJnlLineH);


                end;
            }
            action("Check Printing Axis")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    RecGenJnlLineA: Record "Gen. Journal Line";
                begin
                    RecGenJnlLineA.RESET;
                    RecGenJnlLineA.SETRANGE("Journal Template Name", rec."Journal Template Name");
                    RecGenJnlLineA.SETRANGE("Journal Batch Name", rec."Journal Batch Name");
                    RecGenJnlLineA.SETRANGE("Document No.", rec."Document No.");
                    RecGenJnlLineA.SETRANGE("Posting Date", rec."Posting Date");
                    IF RecGenJnlLineA.FIND('-') THEN
                        REPORT.RUN(1405, TRUE, FALSE, RecGenJnlLineA);


                end;
            }

        }
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                UserSetup: Record "User Setup";
                Location: Record Location;
            begin
                UserSetup.RESET();
                UserSetup.SETRANGE("User ID", USERID);
                UserSetup.SETRANGE(Blocked, TRUE);
                IF UserSetup.FINDFIRST THEN
                    ERROR('This User Is Blocked, Can not Post This Invoice ');
                if Location.Get(rec."Location Code") then begin
                    if Location."Blocked Location" = true then
                        Error('Location is blocked');
                end;
            end;


        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                UserSetup: Record "User Setup";
            begin
                UserSetup.RESET();
                UserSetup.SETRANGE("User ID", USERID);
                UserSetup.SETRANGE(Blocked, TRUE);
                IF UserSetup.FINDFIRST THEN
                    ERROR('This User Is Blocked, Can not Post This Invoice ');
            end;


        }


    }

    var
        myInt: Integer;
}