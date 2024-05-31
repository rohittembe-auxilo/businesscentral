page 50162 "LMS GL Data Stagings"
{
    ApplicationArea = All;
    Caption = 'LMS GL Data Stagings';
    PageType = List;
    SourceTable = "LMS GL Data Stagings";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Line No"; Rec."Line No")
                {
                    ToolTip = 'Specifies the value of the Line No field.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Specifies the value of the External Document No. field.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ToolTip = 'Specifies the value of the Bal. Account Type field.';
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ToolTip = 'Specifies the value of the Bal. Account No. field.';
                }
                field("Bank Payment Type"; Rec."Bank Payment Type")
                {
                    ToolTip = 'Specifies the value of the Bank Payment Type field.';
                }
                field("GST Group Code"; Rec."GST Group Code")
                {
                    ToolTip = 'Specifies the value of the GST Group Code field.';
                }
                field("GST Group Type"; Rec."GST Group Type")
                {
                    ToolTip = 'Specifies the value of the GST Group Type field.';
                }
                field("GST Base Amount"; Rec."GST Base Amount")
                {
                    ToolTip = 'Specifies the value of the GST Base Amount field.';
                }
                field("GST %"; Rec."GST %")
                {
                    ToolTip = 'Specifies the value of the GST % field.';
                }
                field("Total GST Amount"; Rec."Total GST Amount")
                {
                    ToolTip = 'Specifies the value of the Total GST Amount field.';
                }
                field("GST Customer Type"; Rec."GST Customer Type")
                {
                    ToolTip = 'Specifies the value of the GST Customer Type field.';
                }
                field("GST Vendor Type"; Rec."GST Vendor Type")
                {
                    ToolTip = 'Specifies the value of the GST Vendor Type field.';
                }
                field("HSN/SAC Code"; Rec."HSN/SAC Code")
                {
                    ToolTip = 'Specifies the value of the HSN/SAC Code field.';
                }
                field(Exempted; Rec.Exempted)
                {
                    ToolTip = 'Specifies the value of the Exempted field.';
                }
                field("GST Bill-to/BuyFrom State Code"; Rec."GST Bill-to/BuyFrom State Code")
                {
                    ToolTip = 'Specifies the value of the GST Bill-to/BuyFrom State Code field.';
                }
                field("GST Ship-to State Code"; Rec."GST Ship-to State Code")
                {
                    ToolTip = 'Specifies the value of the GST Ship-to State Code field.';
                }
                field("Location State Code"; Rec."Location State Code")
                {
                    ToolTip = 'Specifies the value of the Location State Code field.';
                }
                field("GST Input Service Distribution"; Rec."GST Input Service Distribution")
                {
                    ToolTip = 'Specifies the value of the GST Input Service Distribution field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code field.';
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 6 Code field.';
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 7 Code field.';
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 8 Code field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ToolTip = 'Specifies the value of the Debit Amount field.';
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ToolTip = 'Specifies the value of the Credit Amount field.';
                }
                field("Entry No"; Rec."Entry No")
                {
                    ToolTip = 'Specifies the value of the Entry No field.';
                }
                field("PLC Log No."; Rec."PLC Log No.")
                {
                    ToolTip = 'Specifies the value of the PLC Log No. field.';
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ToolTip = 'Specifies the value of the Journal Template Name field.';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';
                }
                field("GST Reg. No"; Rec."GST Reg. No")
                {
                    ToolTip = 'Specifies the value of the GST Reg. No field.';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field("Recurring Method"; Rec."Recurring Method")
                {
                    ToolTip = 'Specifies the value of the Recurring Method field.';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ToolTip = 'Specifies the value of the Expiration Date field.';
                }
                field("Recurring Frequency"; Rec."Recurring Frequency")
                {
                    ToolTip = 'Specifies the value of the Recurring Frequency field.';
                }
                field("Direct Upload"; Rec."Direct Upload")
                {
                    ToolTip = 'Specifies the value of the Direct Upload field.';
                }
            }
        }
    }
}
