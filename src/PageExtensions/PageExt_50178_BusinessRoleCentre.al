pageextension 50178 ABCD extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Financial Statements")
        {
            action("Posted Voucher Auto Payment")
            {
                ApplicationArea = All;
                RunObject = report "Posted Voucher Auto Payment";
            }
            action("Bank Reconcilation Statement")
            {
                ApplicationArea = All;
                RunObject = report "Bank Reconcilation Statement";
            }
            action("Batch Job Vend")
            {
                ApplicationArea = All;
                RunObject = report "Batch Job Vend";
            }
            action("Trial Balance New")
            {
                ApplicationArea = All;
                RunObject = report "Trial Balance New";
            }
            action("Payment Advice")
            {
                ApplicationArea = All;
                RunObject = report "Payment Advice";
            }
            action("Sales Credit Note")
            {
                ApplicationArea = All;
                RunObject = report "Sales Credit Note";
            }
            action("Summary EIR")
            {
                ApplicationArea = All;
                RunObject = report "Summary EIR";
            }
            action("Monthly Schedule")
            {
                ApplicationArea = All;
                RunObject = report "Monthly Schedule";
            }
            action("Party confirmation letters")
            {
                ApplicationArea = All;
                RunObject = report "Party confirmation letters";
            }
            action("Purchase Order")
            {
                ApplicationArea = All;
                RunObject = report "Purchase Order";
            }
            action("Vendor Ledger")
            {
                ApplicationArea = All;
                RunObject = report "Vendor Ledger";
            }
            action("Cheque Printing -HDFC")
            {
                ApplicationArea = All;
                RunObject = report "Cheque Printing -HDFC";
            }
            action("Check Print - AXIES BANK")
            {
                ApplicationArea = All;
                RunObject = report "Check Print - AXIES BANK";
            }
            action("Purchase Invoice New")
            {
                ApplicationArea = All;
                RunObject = report "Purchase Invoice";
            }
            action(CopyGLBudgetNew)
            {
                ApplicationArea = All;
                RunObject = report CopyGLBudgetNew;
            }
            action(AutoPaymentMail)
            {
                ApplicationArea = All;
                RunObject = report "Auto Payment Mail FrTo Date";
            }



        }// Add changes to page actions here
    }

    var
        myInt: Integer;
}