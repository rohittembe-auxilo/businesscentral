Page 50145 "EIR Subpage"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "EIR Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("LAN No."; rec."LAN No.")
                {
                    ApplicationArea = Basic;
                }
                field("SCH Date"; rec."SCH Date")
                {
                    ApplicationArea = Basic;
                }
                field("Repay Amount"; rec."Repay Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Balance for PFTCAL"; Rec."Balance for PFTCAL")
                {
                    ApplicationArea = Basic;
                }
                field("Disb Amount"; Rec."Disb Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Principal SCHD"; Rec."Principal SCHD")
                {
                    ApplicationArea = Basic;
                }
                field("Profit Calculation"; Rec."Profit Calculation")
                {
                    ApplicationArea = Basic;
                }
                field("CPZ Amount"; Rec."CPZ Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Closing Balance"; Rec."Closing Balance")
                {
                    ApplicationArea = Basic;
                }
                field(Cost; Rec.Cost)
                {
                    ApplicationArea = Basic;
                }
                field(Income; Rec.Income)
                {
                    ApplicationArea = Basic;
                }
                field(EIR; Rec.EIR)
                {
                    ApplicationArea = Basic;
                }
                field("Opening Balance"; Rec."Opening Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Calculated Rate"; Rec."Calculated Rate")
                {
                    ApplicationArea = Basic;
                }
                field("SCH Date Out"; Rec."SCH Date Out")
                {
                    ApplicationArea = Basic;
                }
                field("Revised Disburshment Amt"; Rec."Revised Disburshment Amt")
                {
                    ApplicationArea = Basic;
                }
                field("Repay Amount Out"; Rec."Repay Amount Out")
                {
                    ApplicationArea = Basic;
                }
                field(Interest; Rec.Interest)
                {
                    ApplicationArea = Basic;
                }
                field("Closing Balance Out"; Rec."Closing Balance Out")
                {
                    ApplicationArea = Basic;
                }
                field(Amortization; Rec.Amortization)
                {
                    ApplicationArea = Basic;
                }
                field("Cumulative Amortization"; Rec."Cumulative Amortization")
                {
                    ApplicationArea = Basic;
                }
                field(Unamortization; Rec.Unamortization)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

