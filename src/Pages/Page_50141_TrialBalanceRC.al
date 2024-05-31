Page 50141 "Trial Balance RC"
{
    Caption = 'GL Account';
    PageType = ListPart;
    SourceTable = "G/L Account";
    SourceTableView = sorting("No.")
                      order(ascending)
                      where("Account Type" = filter(Posting),
                            "Net Change" = filter(<> 0));
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; GLAccount."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name; GLAccount.Name)
                {
                    ApplicationArea = Basic;
                }
                field("Net Change"; GLAccount."Net Change")
                {
                    ApplicationArea = Basic;
                    Caption = 'Net Change';
                }
                field("Account Type"; GLAccount."Account Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Account Type';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                ApplicationArea = Basic;
                Caption = 'Open';
                Image = ViewDetails;
                RunPageMode = View;
                ShortCutKey = 'Return';
            }
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

        if GLAccount.Get(rec."No.") then
            GLAccount.CalcFields("Net Change");
    end;
}

