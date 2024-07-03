pageextension 50171 MyExtension extends "General Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Shortcut Dimension 8 Code")
        {
            field("Purchase Comment"; rec."Purchase Comment")
            {
                ApplicationArea = all;
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
            }
            field("Creation DateTime"; Rec."Creation DateTime")
            {
                ApplicationArea = All;
            }
            field("Purchase Comments"; Rec."Purchase Comments")
            {
                ApplicationArea = All;
            }
            field("Approver ID"; Rec."Approver ID")
            {
                ApplicationArea = All;
            }
            field("RCM Invoice No"; Rec."RCM Invoice No")
            {
                ApplicationArea = All;
            }
            field("RCM Payment No"; Rec."RCM Payment No")
            { ApplicationArea = All; }
            field("RCM Invoice No."; Rec."RCM Invoice No.")
            {
                ApplicationArea = All;
            }
            field("GSTCredit 50%"; Rec."GSTCredit 50%")
            {
                ApplicationArea = All;
            }
            field("MSME Type"; Rec."MSME Type")
            {
                ApplicationArea = All;
            }
            field("Purch. Order No."; Rec."Purch. Order No.")
            {
                ApplicationArea = All;
            }
            field("Applies-to ID"; Rec."Applies-to ID")
            {
                ApplicationArea = All;
            }
            field("Party Code"; Rec."Party Code")
            {
                ApplicationArea = All;
            }
            field("Party Name"; Rec."Party Name")
            {
                ApplicationArea = All;
            }
            field("Related Party Transaction"; Rec."Related Party Transaction")
            {
                ApplicationArea = all;
            }
            field("PO Type"; Rec."PO Type")
            {
                ApplicationArea = All;
            }
            field("PO Sub Type"; Rec."PO Sub Type")
            {
                ApplicationArea = All;
            }
            field("GST Bill-to/BuyFrom State Code"; Rec."GST Bill-to/BuyFrom State Code")
            {
                ApplicationArea = All;
            }
            field(Attachments; Rec.Attachments)
            {
                ApplicationArea = All;
                Editable = false;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Print Voucher")
        {
            action("Print Voucher New")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                    PostedVoucherReport: Report "Posted Voucher New";
                begin
                    GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
                    GLEntry.SETRANGE("Document No.", rec."Document No.");
                    GLEntry.SETRANGE("Posting Date", rec."Posting Date");
                    IF GLEntry.FINDFIRST THEN BEGIN
                        CLEAR(PostedVoucherReport);
                        PostedVoucherReport.SetParameter(rec."User ID");
                        PostedVoucherReport.SETTABLEVIEW(GLEntry);
                        PostedVoucherReport.RUNMODAL;
                        // REPORT.RUNMODAL(REPORT::"Posted Voucher",TRUE,TRUE,GLEntry);
                        // PostedVoucherReport.RUN(GLEntry);
                    END;
                end;
            }
        }
        addafter(ReverseTransaction)
        {
            action(ReverseTransactionNew)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reverse Transaction';
                Ellipsis = true;
                Image = ReverseRegister;
                Scope = Repeater;
                ToolTip = 'Reverse a posted general ledger entry without posting date restriction.';

                trigger OnAction()
                var
                    ReversalEntry: Record "Reversal Entry";
                begin
                    Clear(ReversalEntry);
                    if Rec.Reversed then
                        ReversalEntry.AlreadyReversedEntry(Rec.TableCaption, Rec."Entry No.");
                    CheckEntryPostedFromJournal();
                    Rec.TestField("Transaction No.");
                    ReversalEntry.ReverseEntries2(Rec."Transaction No.", ReversalEntry."Reversal Type"::Transaction);
                end;
            }
        }
    }

    local procedure CheckEntryPostedFromJournal()
    var
        ReversalEntry: Record "Reversal Entry";
        IsHandled: Boolean;
    begin
        if Rec."Journal Batch Name" = '' then
            ReversalEntry.TestFieldError();
    end;

    var
        myInt: Integer;
}