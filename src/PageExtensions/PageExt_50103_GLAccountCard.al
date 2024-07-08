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
            field("TDS Section"; Rec."TDS")
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

            field("Created DateTime"; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Caption = 'Created DateTime';
                Editable = false;
            }
            field("Created By"; CreatedBy)
            {
                ApplicationArea = All;
                Caption = 'Created By';
                Editable = false;
            }
            field("Modified DateTime"; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Caption = 'Modified DateTime';
                Editable = false;
            }
            field("Modified By"; ModifiedBy)
            {
                ApplicationArea = All;
                Caption = 'Modified By';
                Editable = false;
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

    var
        CreatedBy: Text;
        ModifiedBy: Text;
}