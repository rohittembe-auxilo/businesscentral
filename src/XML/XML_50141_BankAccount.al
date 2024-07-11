#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 50141 "Bank Account"
{
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement(BankAccount; "Bank Account")
            {
                XmlName = 'BankAccount';
                AutoSave = false;
                textelement(NO)
                {
                }

                textelement(Name)
                {
                }

                textelement(Address)
                {
                    MinOccurs = Zero;
                }
                textelement(Address2)
                {
                    MinOccurs = Zero;
                }
                textelement(PostCode)
                {
                    MinOccurs = Zero;
                }

                textelement(City)
                {
                    MinOccurs = Zero;
                }
                textelement(regioncode)
                {
                    MinOccurs = Zero;
                }
                textelement(BankAccountNo)
                {

                }
                textelement(IFSC)
                {
                    MinOccurs = Zero;
                }
                textelement(SearchName)
                {
                    MinOccurs = Zero;
                }
                textelement(BankPostingGroup)
                {
                    MinOccurs = Zero;
                }
                textelement(Blocked)
                {
                    MinOccurs = Zero;
                }
                trigger OnAfterInsertRecord()
                var
                    BankAccounts: Record "Bank Account";
                begin
                    BankAccounts.Reset();
                    BankAccounts.SetRange("No.", NO);
                    if not BankAccounts.Find('-') then begin
                        Clear(BankAccounts);
                        BankAccounts.Init();

                        BankAccounts."No." := NO;
                        BankAccounts.Validate(Name, Name);
                        BankAccounts.Validate(Address, Address);
                        BankAccounts.Validate("Address 2", Address2);
                        BankAccounts.Validate("Post Code", postCode);
                        BankAccounts.Validate(City, City);
                        BankAccount.Validate("Country/Region Code", regioncode);
                        BankAccounts.Validate("Bank Account No.", BankAccountNo);
                        BankAccounts.Validate(IFSC, IFSC);
                        BankAccounts.Validate("IFSC Code", IFSC);
                        BankAccounts.Validate("Search Name", SearchName);
                        BankAccounts.Validate("Bank Acc. Posting Group", BankPostingGroup);
                        BankAccounts.Insert(true);
                        if ApprovalsMgmt.CheckBankAccountApprovalsWorkflowEnabled(BankAccounts) then
                            ApprovalsMgmt.OnSendBankAccountForApproval(BankAccounts);
                    end;
                end;

            }
        }
    }



    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
    trigger OnPostXmlPort()
    begin
        Message('Bank Account uploaded successfully');
    end;

    var
        ApprovalsMgmt: Codeunit "Approval Management hook";
}



