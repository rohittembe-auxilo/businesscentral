XmlPort 50126 "LMS GL Transaction Import"
{
    Format = VariableText;

    schema
    {
        textelement(LMSDATA)
        {
            tableelement("LMS GL Data Stagings"; "LMS GL Data Stagings")
            {
                XmlName = 'LMSGLTRANS';
                fieldattribute(LineNo; "LMS GL Data Stagings"."Line No")
                {
                }
                fieldattribute(PostingDate; "LMS GL Data Stagings"."Posting Date")
                {
                }
                fieldattribute(DocumentType; "LMS GL Data Stagings"."Document Type")
                {
                }
                fieldattribute(ExternalDocNo; "LMS GL Data Stagings"."External Document No.")
                {
                }
                fieldattribute(AccountType; "LMS GL Data Stagings"."Account Type")
                {
                }
                fieldattribute(AccountNo; "LMS GL Data Stagings"."Account No.")
                {
                }
                fieldattribute(Disc; "LMS GL Data Stagings".Description)
                {
                }
                fieldattribute(LocCode; "LMS GL Data Stagings"."Location Code")
                {
                }
                fieldattribute(DebitAmt; "LMS GL Data Stagings"."Debit Amount")
                {
                }
                fieldattribute(CreditAmt; "LMS GL Data Stagings"."Credit Amount")
                {
                }
                fieldattribute(GSTGroupCode; "LMS GL Data Stagings"."GST Group Code")
                {
                }
                fieldattribute(GSTBaseAmt; "LMS GL Data Stagings"."GST Base Amount")
                {
                }
                fieldattribute(GSTPER; "LMS GL Data Stagings"."GST %")
                {
                }
                fieldattribute(TotalGSTAmt; "LMS GL Data Stagings"."Total GST Amount")
                {
                }
                fieldattribute(GSTCustType; "LMS GL Data Stagings"."GST Customer Type")
                {
                }
                fieldattribute(HSNSACCode; "LMS GL Data Stagings"."HSN/SAC Code")
                {
                }
                fieldattribute(GSTBilltoBuyFrStCode; "LMS GL Data Stagings"."GST Bill-to/BuyFrom State Code")
                {
                }
                fieldattribute(GSTShiptoStCode; "LMS GL Data Stagings"."GST Ship-to State Code")
                {
                }
                fieldattribute(GSTRegNo; "LMS GL Data Stagings"."GST Reg. No")
                {
                }
                fieldattribute(GlobalDim1; "LMS GL Data Stagings"."Global Dimension 1 Code")
                {
                }
                fieldattribute(GlobalDim2; "LMS GL Data Stagings"."Global Dimension 2 Code")
                {
                }
                fieldattribute(GlobalDim3; "LMS GL Data Stagings"."Shortcut Dimension 3 Code")
                {
                }
                fieldattribute(GlobalDim4; "LMS GL Data Stagings"."Shortcut Dimension 4 Code")
                {
                }
                fieldattribute(GlobalDim5; "LMS GL Data Stagings"."Shortcut Dimension 5 Code")
                {
                }
                fieldattribute(GlobalDim6; "LMS GL Data Stagings"."Shortcut Dimension 6 Code")
                {
                }
                fieldattribute(GlobalDim7; "LMS GL Data Stagings"."Shortcut Dimension 7 Code")
                {
                }
                fieldattribute(GlobalDim8; "LMS GL Data Stagings"."Shortcut Dimension 8 Code")
                {
                }
                fieldattribute(Comment; "LMS GL Data Stagings".Comment)
                {
                }
                fieldattribute(RecurringMethod; "LMS GL Data Stagings"."Recurring Method")
                {
                }
                fieldattribute(RecurringFrequency; "LMS GL Data Stagings"."Recurring Frequency")
                {
                }
                fieldattribute(ExpirationDate; "LMS GL Data Stagings"."Expiration Date")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    EntryNo += 1;
                end;

                trigger OnBeforeInsertRecord()
                begin
                    "LMS GL Data Stagings"."Entry No" := EntryNo;
                    //ERROR('%1',EntryNo);
                    if not GuiAllowed then
                        "LMS GL Data Stagings"."Direct Upload" := true;

                    if PLCLog.FindLast then
                        "LMS GL Data Stagings"."PLC Log No." := PLCLog."Entry No."
                    else
                        "LMS GL Data Stagings"."PLC Log No." := 1;
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

    trigger OnPreXmlPort()
    begin
        RecLMSGL.Reset;
        if RecLMSGL.FindLast then
            EntryNo := RecLMSGL."Entry No" + 1
        else
            EntryNo := 1;
    end;

    var
        RecLMSGL: Record "LMS GL Data Stagings";
        PLCLog: Record "PLC Logs";
        EntryNo: Integer;
}

