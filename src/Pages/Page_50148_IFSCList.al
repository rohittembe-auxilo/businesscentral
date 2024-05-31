Page 50148 "IFSC List"
{
    PageType = List;
    SourceTable = "IFSC Masters";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("IFSC Code"; rec."IFSC Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {

        area(Reporting)
        {
            action("Posted Voucher Auto Payment")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Report.Run(50101);
                end;
            }
            action("BankReconcilationstatement")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Report.Run(50102);
                end;
            }
            action("Trial Balance New")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Report.Run(50104);
                end;
            }
            action("Payment Advice")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Report.Run(50105);
                end;
            }
            action("Sales Credit Note")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Report.Run(50107);
                end;
            }
            action("Summary EIR")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Report.Run(50109);
                end;
            }
            action("Sales Invoice New")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Report.Run(50110);
                end;
            }
            action("Monthly Schedule")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Report.Run(50112);
                end;
            }
            action("Payment Confirmation Letter")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Report.Run(50114);
                end;
            }
            action("Purchase Order")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Report.Run(50115);
                end;
            }
            action("Vendor Ledger")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Report.Run(50116);
                end;
            }
            action("Check Printing HDFC")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Report.Run(50117);
                end;
            }
            action("Check Printing Axis Bank")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Report.Run(50118);
                end;
            }
            action("Purchase Invoice")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Report.Run(50119);
                end;
            }

        }


    }

}