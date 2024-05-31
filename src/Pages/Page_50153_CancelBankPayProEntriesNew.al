Page 50153 "Cancel Bank PayPro Entries-New"
{
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Bank Pay Pro Entries-New";
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
                field("Payment Method identifier"; Rec."Payment Method identifier")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Value Date"; Rec."Value Date")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Name"; Rec."Beneficiary Name")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Address 1"; Rec."Beneficiary Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Address 2"; Rec."Beneficiary Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary Address 3"; Rec."Beneficiary Address 3")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary City"; Rec."Beneficiary City")
                {
                    ApplicationArea = Basic;
                }
                field("Beneficiary State"; Rec."Beneficiary State")
                {
                    ApplicationArea = Basic;
                }
                field("PIN Code"; Rec."PIN Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bene Account Number"; Rec."Bene Account Number")
                {
                    ApplicationArea = Basic;
                }
                field("Email ID of beneficiary"; Rec."Email ID of beneficiary")
                {
                    ApplicationArea = Basic;
                }
                field("Email Body"; Rec."Email Body")
                {
                    ApplicationArea = Basic;
                }
                field("Debit Account Number"; Rec."Debit Account Number")
                {
                    ApplicationArea = Basic;
                }
                field("CRN (Narration  / Remarks)"; Rec."CRN (Narration  / Remarks)")
                {
                    ApplicationArea = Basic;
                }
                field("Receiver IFSC"; Rec."Receiver IFSC")
                {
                    ApplicationArea = Basic;
                }
                field("Receiver A/c type"; Rec."Receiver A/c type")
                {
                    ApplicationArea = Basic;
                }
                field("Print Branch"; Rec."Print Branch")
                {
                    ApplicationArea = Basic;
                }
                field("Payable Location"; Rec."Payable Location")
                {
                    ApplicationArea = Basic;
                }
                field("Instrument Date"; Rec."Instrument Date")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 1"; Rec."Payment Details 1")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 2"; Rec."Payment Details 2")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 3"; Rec."Payment Details 3")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 4"; Rec."Payment Details 4")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 5"; Rec."Payment Details 5")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 6"; Rec."Payment Details 6")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 7"; Rec."Payment Details 7")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 8"; Rec."Payment Details 8")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 9"; Rec."Payment Details 9")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 10"; Rec."Payment Details 10")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 11"; Rec."Payment Details 11")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 12"; Rec."Payment Details 12")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 13"; Rec."Payment Details 13")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 14"; Rec."Payment Details 14")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 15"; Rec."Payment Details 15")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 16"; Rec."Payment Details 16")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 17"; Rec."Payment Details 17")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 18"; Rec."Payment Details 18")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Details 19"; Rec."Payment Details 19")
                {
                    ApplicationArea = Basic;
                }
                field("Additional Info 99"; Rec."Additional Info 99")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("Phone No"; Rec."Phone No")
                {
                    ApplicationArea = Basic;
                }
                field("Exported to File"; Rec."Exported to File")
                {
                    ApplicationArea = Basic;
                }
                field("RTGS Ref No"; Rec."RTGS Ref No")
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
            action("&Cancel PayPro Entries")
            {
                ApplicationArea = Basic;
                Caption = '&Cancel PayPro Entries';
                Image = CancelAllLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    LCRecPayProEntries: Record "Bank Pay Pro Entries-New";
                begin
                    if not Confirm('Do you want to cancel entries?') then
                        Error('');

                    CurrPage.SetSelectionFilter(LCRecPayProEntries);

                    if LCRecPayProEntries.FindSet then begin
                        repeat
                            LCRecPayProEntries."Exported to File" := false;
                            LCRecPayProEntries.Modify;
                        until LCRecPayProEntries.Next = 0;
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

