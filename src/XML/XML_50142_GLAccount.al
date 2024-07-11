XmlPort 50142 "GL Accounts"
{
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement(GLAccount; "G/L Account")
            {
                XmlName = 'GLAccounts';
                AutoSave = false;
                textelement(NO)
                {
                }

                textelement(Name)
                {
                }

                textelement(IncomeBalance)
                {
                    MinOccurs = Zero;
                }
                textelement(DebitCredit)
                {
                    MinOccurs = Zero;
                }
                textelement(AccountingType)
                {
                    MinOccurs = Zero;
                }

                textelement(DirectPosting)
                {
                    MinOccurs = Zero;
                }
                textelement(Department)
                {
                    MinOccurs = Zero;

                }
                textelement(GSTCredit)
                {
                    MinOccurs = Zero;
                }

                textelement(SearchName)
                {
                    MinOccurs = Zero;
                }

                textelement(Blocked)
                {
                    MinOccurs = Zero;
                }

                textelement(TDSNatureofdeduction)
                {
                    MinOccurs = Zero;
                }
                trigger OnAfterInsertRecord()
                var
                    GLAccounts: Record "G/L Account";
                begin
                    GLAccounts.Reset();
                    GLAccounts.SetRange("No.", NO);
                    if not GLAccounts.Find('-') then begin
                        Clear(GLAccounts);
                        GLAccounts.Init();
                        GLAccounts."No." := NO;
                        GLAccounts.Validate(Name, Name);

                        if IncomeBalance = 'Balance Sheet' then
                            GLAccounts.Validate("Income/Balance", GLAccounts."Income/Balance"::"Balance Sheet")
                        else if IncomeBalance = 'Income Statement' then
                            GLAccounts.Validate("Income/Balance", GLAccounts."Income/Balance"::"Income Statement");

                        if DebitCredit = 'Both' then
                            GLAccounts.Validate("Debit/Credit", GLAccounts."Debit/Credit"::Both)
                        else if DebitCredit = 'Credit' then
                            GLAccounts.Validate("Debit/Credit", GLAccounts."Debit/Credit"::Credit)
                        else if DebitCredit = 'Debit' then
                            GLAccounts.Validate("Debit/Credit", GLAccounts."Debit/Credit"::Debit);

                        if AccountingType = 'Begin-Total' then
                            GLAccounts.Validate("Account Type", GLAccount."Account Type"::"Begin-Total")
                        else if AccountingType = 'End-Total' then
                            GLAccounts.Validate("Account Type", GLAccount."Account Type"::"End-Total")
                        else if AccountingType = 'Heading' then
                            GLAccounts.Validate("Account Type", GLAccount."Account Type"::Heading)
                        else if AccountingType = 'Posting' then
                            GLAccounts.Validate("Account Type", GLAccount."Account Type"::Posting)
                        else if AccountingType = 'Total' then
                            GLAccounts.Validate("Account Type", GLAccount."Account Type"::Total);

                        if DirectPosting = 'Yes' then
                            GLAccounts.Validate("Direct Posting", true);

                        if AccountingType = 'Availment' then
                            GLAccounts.Validate("GST Credit", GLAccounts."GST Credit"::Availment)
                        else if AccountingType = 'Non-Availment' then
                            GLAccounts.Validate("GST Credit", GLAccounts."GST Credit"::"Non-Availment");

                        GLAccounts.Validate("Search Name", SearchName);
                        if Blocked = 'Yes' then
                            GLAccounts.Validate(Blocked, true);
                        GLAccounts.Validate("Shortcut Dimension 3", Department);
                        GLAccounts.Insert(true);
                        if ApprovalsMgmt.CheckGLAccountApprovalsWorkflowEnabled(GLAccounts) then
                            ApprovalsMgmt.OnSendGLAccountForApproval(GLAccounts);
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
        Message('GL Account uploaded successfully');
    end;

    var
        ApprovalsMgmt: Codeunit "Approval Management hook";
}



