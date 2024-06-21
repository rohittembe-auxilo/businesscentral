pageextension 50163 PostedSalesInvoices extends "Posted Sales Invoices"
{
    layout
    {
        // Add changes to page layout here
        addafter(Cancelled)
        {
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
        addafter(Print)
        {
            action("Print Invoice Customize")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    SalesInvHeader.RESET;
                    SalesInvHeader.SETRANGE("No.", rec."No.");
                    IF SalesInvHeader.FINDFIRST THEN
                        REPORT.RUNMODAL(50007, TRUE, FALSE, SalesInvHeader);


                end;
            }
        }
    }

    var
        myInt: Integer;
        SalesInvHeader: Record "Sales Invoice Header";
}