XmlPort 50117 "PO Data Load"
{
    DefaultFieldsValidation = false;
    Direction = Both;
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = UTF16;

    schema
    {
        textelement(Root)
        {
            tableelement("Purchase Header"; "Purchase Header")
            {
                XmlName = 'PurchHeader';
                fieldattribute(DocType; "Purchase Header"."Document Type")
                {
                }
                fieldattribute(DocNo; "Purchase Header"."No.")
                {
                }
                fieldattribute(BuyFromVend; "Purchase Header"."Buy-from Vendor No.")
                {
                }
                fieldattribute(BuyFromVendName; "Purchase Header"."Buy-from Vendor Name")
                {
                }
                fieldattribute(DocDate; "Purchase Header"."Document Date")
                {
                }
                fieldattribute(OrderDate; "Purchase Header"."Order Date")
                {
                }
                fieldattribute(PostingDate; "Purchase Header"."Posting Date")
                {
                }
                fieldattribute(PayTermCode; "Purchase Header"."Payment Terms Code")
                {
                }
                fieldattribute(LocCode; "Purchase Header"."Location Code")
                {
                }
                fieldattribute(ShortDim1; "Purchase Header"."Shortcut Dimension 1 Code")
                {
                }
                fieldattribute(ShortDim2; "Purchase Header"."Shortcut Dimension 2 Code")
                {
                }
                fieldattribute(ShortDim3; "Purchase Header"."Shortcut Dimension 3 Code")
                {
                }
                fieldattribute(ShortDim4; "Purchase Header"."Shortcut Dimension 4 Code")
                {
                }
                fieldattribute(ShortDim5; "Purchase Header"."Shortcut Dimension 5 Code")
                {
                }
                fieldattribute(ShortDim6; "Purchase Header"."Shortcut Dimension 6 Code")
                {
                }
                fieldattribute(ShortDim7; "Purchase Header"."Shortcut Dimension 7 Code")
                {
                }
                fieldattribute(ShortDim8; "Purchase Header"."Shortcut Dimension 8 Code")
                {
                }
                fieldattribute(VendPostingGr; "Purchase Header"."Vendor Posting Group")
                {
                }
                fieldattribute(VendInvNo; "Purchase Header"."Vendor Invoice No.")
                {
                }
                fieldattribute(GenBusPostGr; "Purchase Header"."Gen. Bus. Posting Group")
                {
                }
                //vMig    fieldattribute(Structure;"Purchase Header".Structure)
                //vMig    {
                //vMig    }
                fieldattribute(GstVendType; "Purchase Header"."GST Vendor Type")
                {
                }
            }
            tableelement("Purchase Line"; "Purchase Line")
            {
                LinkTable = "Purchase Header";
                MinOccurs = Zero;
                XmlName = 'PurchLine';
                fieldattribute(LineNo; "Purchase Line"."Line No.")
                {
                }
                fieldattribute(Type; "Purchase Line"."Document Type")
                {
                }
                fieldattribute(No; "Purchase Line"."No.")
                {
                }
                fieldattribute(Disc; "Purchase Line".Description)
                {
                }
                fieldattribute(Disc2; "Purchase Line"."Description 2")
                {
                }
                fieldattribute(QTY; "Purchase Line".Quantity)
                {
                }
                fieldattribute(DirectUnitCost; "Purchase Line"."Direct Unit Cost")
                {
                }
                fieldattribute(Amt; "Purchase Line".Amount)
                {
                }
                //vMig  fieldattribute(TdsNatureOfDed; "Purchase Line"."TDS Nature of Deduction")
                //vMig  {
                //vMig  }
                fieldattribute(GstCredit; "Purchase Line"."GST Credit")
                {
                }
                fieldattribute(GstGrCode; "Purchase Line"."GST Group Code")
                {
                }
                fieldattribute(GstGrType; "Purchase Line"."GST Group Type")
                {
                }
                fieldattribute(HSNCode; "Purchase Line"."HSN/SAC Code")
                {
                }
                //vMig   fieldattribute(GstBaseAmt; "Purchase Line"."GST Base Amount")
                //vMig   {
                //vMig   }
                //vMig fieldattribute(GSTPER; "Purchase Line"."GST %")
                //vMig  {
                //vMig  }
                //vMig   fieldattribute(TotGstAmt; "Purchase Line"."Total GST Amount")
                //vMig   {
                //vMig   }
                fieldattribute(Exempted; "Purchase Line".Exempted)
                {
                }
                fieldattribute(GstJurType; "Purchase Line"."GST Jurisdiction Type")
                {
                }
                fieldattribute(Comment; "Purchase Line".Comment)
                {
                }
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
        if GuiAllowed then
            Message('File successfully imported!');
    end;
}

