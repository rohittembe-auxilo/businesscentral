pageextension 50180 PurchaseSetupExtn extends "Purchases & Payables Setup"
{
    layout
    {
        addafter(General)
        {
            group(SFTP)
            {
                field("SFTP Hostname"; Rec."SFTP Hostname")
                {
                    ApplicationArea = All;
                }
                field("SFTP Port"; Rec."SFTP Port")
                {
                    ApplicationArea = All;
                }
                field("SFTP UserName"; Rec."SFTP UserName")
                {
                    ApplicationArea = All;
                }
                field("SFTP Password"; Rec."SFTP Password")
                {
                    ApplicationArea = All;
                }
                field("SFTP Path"; Rec."SFTP Path")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
