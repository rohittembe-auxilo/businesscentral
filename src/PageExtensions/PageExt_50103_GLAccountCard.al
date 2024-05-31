pageextension 50103 GLAccountCard extends "G/L Account Card"
{
    layout
    {
        // Add changes to page layout here
        modify(Blocked)
        {
            Editable = false;
        }
        addafter("Blocked")
        {
            field("Shortcut Dimension 3"; Rec."Shortcut Dimension 3")
            {
                ApplicationArea = All;
            }
            field("TDS Nature Of Deduction"; Rec.TDS)
            {
                ApplicationArea = All;
            }

        }
        addafter("GST Credit")
        {
            field("GST Ledger Type"; Rec."GST Ledger Type")
            {
                ApplicationArea = All;
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = all;
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
            }
            field("Balance at Date Memorandum"; Rec."Balance at Date Memorandum")
            {
                ApplicationArea = all;
            }
            field("Net Change Memorandum"; Rec."Net Change Memorandum")
            {
                ApplicationArea = all;
            }
            field("Location Filter"; Rec."Location Filter")
            {
                ApplicationArea = all;
            }


        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Receivables-Payables")
        {
            action(TDS)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Page.Run(50031);
                end;
            }
        }
    }

    var
        myInt: Integer;
}