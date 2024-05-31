Page 50151 "Cancel Bank RTGS Entries-New"
{
    InsertAllowed = false;
    PageType = Worksheet;
    Permissions = TableData "Bank Account Ledger Entry" = rimd;
    SourceTable = "Bank RTGS Entries-New";
    SourceTableView = sorting("Bank No", "Line No")
                      where("Exported to File" = filter(true));
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Control1000000039)
            {
                field(GlbBankAccountNo; GlbBankAccountNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Account No';
                    TableRelation = "Bank Account"."No.";

                    trigger OnValidate()
                    begin
                        Rec.SetRange("Bank No", GlbBankAccountNo);
                        if Rec.FindSet then;
                        CurrPage.Update(false);
                    end;
                }
            }
            repeater(Group)
            {
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = Basic;
                }
                field("Corporate Code"; Rec."Corporate Code")
                {
                    ApplicationArea = Basic;
                }
                field("Customer Ref No"; Rec."Customer Ref No")
                {
                    ApplicationArea = Basic;
                }
                field("Debit Bank Account No"; Rec."Debit Bank Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Amount"; Rec."Transaction Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Amount(LCY)"; Rec."Transaction Amount(LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Name"; Rec."Beneficiary Name")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Bank Account No"; Rec."Vendor Bank Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Code"; Rec."Beneficiary Code")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Account Type"; Rec."Beneficiary Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Address1"; Rec."Beneficiary Address1")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Address2"; Rec."Beneficiary Address2")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Address3"; Rec."Beneficiary Address3")
                {
                    ApplicationArea = Basic;
                }
                field("Benficiary City"; Rec."Benficiary City")
                {
                    ApplicationArea = Basic;
                }
                field("Benficiary State"; Rec."Benficiary State")
                {
                    ApplicationArea = Basic;
                }
                field("Benficiary Pin Code"; Rec."Benficiary Pin Code")
                {
                    ApplicationArea = Basic;
                }
                field("Benficiary IFSC Code"; Rec."Benficiary IFSC Code")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Bank Name"; Rec."Beneficiary Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field("Base Code"; Rec."Base Code")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque No"; Rec."Cheque No")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    ApplicationArea = Basic;
                }
                field("Payable Location"; Rec."Payable Location")
                {
                    ApplicationArea = Basic;
                }
                field("Print Location"; Rec."Print Location")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Email address 1"; Rec."Beneficiary Email address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Email address 2"; Rec."Beneficiary Email address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Mobile Number"; Rec."Beneficiary Mobile Number")
                {
                    ApplicationArea = Basic;
                }
                field("Corp Batch No"; Rec."Corp Batch No")
                {
                    ApplicationArea = Basic;
                }
                field("Company Code"; Rec."Company Code")
                {
                    ApplicationArea = Basic;
                }
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = Basic;
                }
                field("Extra 1"; Rec."Extra 1")
                {
                    ApplicationArea = Basic;
                }
                field("Extra 2"; Rec."Extra 2")
                {
                    ApplicationArea = Basic;
                }
                field("Extra 3"; Rec."Extra 3")
                {
                    ApplicationArea = Basic;
                }
                field("Extra 4"; Rec."Extra 4")
                {
                    ApplicationArea = Basic;
                }
                field("Extra 5"; Rec."Extra 5")
                {
                    ApplicationArea = Basic;
                }
                field(PayType; Rec.PayType)
                {
                    ApplicationArea = Basic;
                }
                field(CORP_EMAIL_ADDR; Rec.CORP_EMAIL_ADDR)
                {
                    ApplicationArea = Basic;
                }
                field("User Department"; Rec."User Department")
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
            action("&Cancel RTGS Entries")
            {
                ApplicationArea = Basic;
                Caption = '&Cancel RTGS Entries';
                Image = CancelAllLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    LCRecRTGSEntries: Record "Bank RTGS Entries-New";
                begin
                    if not Confirm('Do you want to cancel RTGS entries?') then
                        Error('');

                    CurrPage.SetSelectionFilter(LCRecRTGSEntries);

                    if LCRecRTGSEntries.FindSet then begin
                        repeat
                            LCRecRTGSEntries."Exported to File" := false;
                            LCRecRTGSEntries."Export File Name" := '';
                            LCRecRTGSEntries.Modify;
                        until LCRecRTGSEntries.Next = 0;
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        LCRecBankAccount: Record "Bank Account";
    begin
        LCRecBankAccount.FindFirst;
        Rec.SetRange("Bank No", LCRecBankAccount."No.");
        GlbBankAccountNo := LCRecBankAccount."No.";
        //IF FINDFIRST THEN;
        CurrPage.Update(false);
    end;

    var
        GlbBankAccountNo: Code[20];
}

