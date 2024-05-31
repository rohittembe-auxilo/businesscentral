XmlPort 50125 "LMS Purch.Trans. Import"
{
    Format = VariableText;

    schema
    {
        textelement(LMSDATA)
        {
            tableelement("LMS Purchase Trans. Stagings"; "LMS Purchase Trans. Stagings")
            {
                XmlName = 'LMSPURCHTRANS';
                fieldattribute(DocType; "LMS Purchase Trans. Stagings"."Document Type")
                {
                }
                fieldattribute(DocNo; "LMS Purchase Trans. Stagings"."Document No")
                {
                }
                fieldattribute(BuyFromVend; "LMS Purchase Trans. Stagings"."Buy-from Vendor No.")
                {
                }
                fieldattribute(BuyFromVendName; "LMS Purchase Trans. Stagings"."Buy-from Vendor Name")
                {
                }
                fieldattribute(DocDate; "LMS Purchase Trans. Stagings"."Document Date")
                {
                }
                fieldattribute(OrderDate; "LMS Purchase Trans. Stagings"."Order Date")
                {
                }
                fieldattribute(PostingDate; "LMS Purchase Trans. Stagings"."Posting Date")
                {
                }
                fieldattribute(PayTermCode; "LMS Purchase Trans. Stagings"."Payment Terms Code")
                {
                }
                fieldattribute(LocCode; "LMS Purchase Trans. Stagings"."Location Code")
                {
                }
                fieldattribute(ShortDim1; "LMS Purchase Trans. Stagings"."Shortcut Dimension 1 Code")
                {
                }
                fieldattribute(ShortDim2; "LMS Purchase Trans. Stagings"."Shortcut Dimension 2 Code")
                {
                }
                fieldattribute(ShortDim3; "LMS Purchase Trans. Stagings"."Shortcut Dimension 3 Code")
                {
                }
                fieldattribute(ShortDim4; "LMS Purchase Trans. Stagings"."Shortcut Dimension 4 Code")
                {
                }
                fieldattribute(ShortDim5; "LMS Purchase Trans. Stagings"."Shortcut Dimension 5 Code")
                {
                }
                fieldattribute(ShortDim6; "LMS Purchase Trans. Stagings"."Shortcut Dimension 6 Code")
                {
                }
                fieldattribute(ShortDim7; "LMS Purchase Trans. Stagings"."Shortcut Dimension 7 Code")
                {
                }
                fieldattribute(ShortDim8; "LMS Purchase Trans. Stagings"."Shortcut Dimension 8 Code")
                {
                }
                fieldattribute(VendPostingGr; "LMS Purchase Trans. Stagings"."Vendor Posting Group")
                {
                }
                fieldattribute(VendInvNo; "LMS Purchase Trans. Stagings"."Vendor Invoice No.")
                {
                }
                fieldattribute(GenBusPostGr; "LMS Purchase Trans. Stagings"."Gen. Bus. Posting Group")
                {
                }
                fieldattribute(Structure; "LMS Purchase Trans. Stagings".Structure)
                {
                }
                fieldattribute(GstVendType; "LMS Purchase Trans. Stagings"."GST Vendor Type")
                {
                }
                fieldattribute(LineNo; "LMS Purchase Trans. Stagings"."Line No.")
                {
                }
                fieldattribute(Type; "LMS Purchase Trans. Stagings".Type)
                {
                }
                fieldattribute(No; "LMS Purchase Trans. Stagings"."No.")
                {
                }
                fieldattribute(Disc; "LMS Purchase Trans. Stagings".Description)
                {
                }
                fieldattribute(Disc2; "LMS Purchase Trans. Stagings"."Description 2")
                {
                }
                fieldattribute(QTY; "LMS Purchase Trans. Stagings".Quantity)
                {
                }
                fieldattribute(DirectUnitCost; "LMS Purchase Trans. Stagings"."Direct Unit Cost")
                {
                }
                fieldattribute(Amt; "LMS Purchase Trans. Stagings".Amount)
                {
                }
                fieldattribute(TdsNatureOfDed; "LMS Purchase Trans. Stagings"."TDS Nature of Deduction")
                {
                }
                fieldattribute(GstCredit; "LMS Purchase Trans. Stagings"."GST Credit")
                {
                }
                fieldattribute(GstGrCode; "LMS Purchase Trans. Stagings"."GST Group Code")
                {
                }
                fieldattribute(GstGrType; "LMS Purchase Trans. Stagings"."GST Group Type")
                {
                }
                fieldattribute(HSNCode; "LMS Purchase Trans. Stagings"."HSN/SAC Code")
                {
                }
                fieldattribute(GstBaseAmt; "LMS Purchase Trans. Stagings"."GST Base Amount")
                {
                }
                fieldattribute(GSTPER; "LMS Purchase Trans. Stagings"."GST %")
                {
                }
                fieldattribute(TotGstAmt; "LMS Purchase Trans. Stagings"."Total GST Amount")
                {
                }
                fieldattribute(Exempted; "LMS Purchase Trans. Stagings".Exempted)
                {
                }
                fieldattribute(GstJurType; "LMS Purchase Trans. Stagings"."GST Jurisdiction Type")
                {
                }
                fieldattribute(Comment; "LMS Purchase Trans. Stagings".Comment)
                {
                }
                fieldattribute(PHComment; "LMS Purchase Trans. Stagings"."PH Comment")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    EntryNo += 1;
                end;

                trigger OnBeforeInsertRecord()
                begin
                    "LMS Purchase Trans. Stagings"."Entry No" := EntryNo;
                    //ERROR('%1',EntryNo);

                    if PLCLog.FindLast then
                        "LMS Purchase Trans. Stagings"."PLC Log No." := PLCLog."Entry No."
                    else
                        "LMS Purchase Trans. Stagings"."PLC Log No." := 1;
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
        RecLMSPurchTrans.Reset;
        if RecLMSPurchTrans.FindLast then
            EntryNo := RecLMSPurchTrans."Entry No" + 1
        else
            EntryNo := 1;
    end;

    var
        RecLMSPurchTrans: Record "LMS Purchase Trans. Stagings";
        PLCLog: Record "PLC Logs";
        EntryNo: Integer;
}

