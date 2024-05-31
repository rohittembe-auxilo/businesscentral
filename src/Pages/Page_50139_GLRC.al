Page 50139 "G/L RC"
{
    Caption = 'G/L Account';
    PageType = ListPart;
    SourceTable = "G/L Account";
    SourceTableView = sorting("No.")
                      order(ascending)
                      where(Balance = filter(<> 0));
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(No; GLAccount."No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No';
                }
                field("G/L Name"; GLAccount.Name)
                {
                    ApplicationArea = Basic;
                    Caption = 'G/L Name';
                }
                field(Balance; GLAccount.Balance)
                {
                    ApplicationArea = Basic;
                }
                field("Account Type"; GLAccount."Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Net Change"; GLAccount."Net Change")
                {
                    ApplicationArea = Basic;
                }
                field("Dept."; GLAccount."Shortcut Dimension 3")
                {
                    ApplicationArea = Basic;
                }
                field("Income/Balance"; GLAccount."Income/Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Net Change Memorandum"; GLAccount."Net Change Memorandum")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetGLAcc;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(GLAccount);
    end;

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID",USERID);
    end;

    var
        GLAccount: Record "G/L Account";

    local procedure GetGLAcc()
    begin
        Clear(GLAccount);

        if GLAccount.Get(Rec."No.") then
            GLAccount.CalcFields(Balance);
    end;
}

