pageextension 50120 PostedSalesCreditMemo extends "Posted Sales Credit Memo"
{
    layout
    {
        // Add changes to page layout here


    }

    actions
    {
        // Add changes to page actions here\
        addafter(Print)
        {
            action("Print Invoice Customize")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                begin
                    SalesCrMemoHeader.RESET;
                    SalesCrMemoHeader.SETRANGE("No.", rec."No.");
                    IF SalesCrMemoHeader.FINDFIRST THEN
                        REPORT.RUNMODAL(50004, TRUE, FALSE, SalesCrMemoHeader);


                end;
            }
        }
    }





    var
        myInt: Integer;
        PostingDateEditable: Boolean;
}