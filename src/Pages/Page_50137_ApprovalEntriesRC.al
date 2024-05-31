Page 50137 "Approval Entries RC"
{
    PageType = CardPart;
    SourceTable = "Finance Cue";

    layout
    {
        area(content)
        {
            cuegroup(Approvals)
            {
                Caption = 'Approvals';
                /* v               field("Requests Sent for Approval"; rec."Requests Sent for Approval")
                                {
                                    ApplicationArea = Basic;
                                    DrillDownPageID = "Approval Entries";
                                }
                                field("Requests to Approve"; rec."Requests to Approve")
                                {
                                    ApplicationArea = Basic;
                                    DrillDownPageID = "Requests to Approve";
                                }
                                */
            }
            cuegroup("Document Approvals")
            {
                Caption = 'Document Approvals';
                field("POs Pending Approval"; rec."POs Pending Approval")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Purchase Order List";
                }
                field("Approved Purchase Orders"; rec."Approved Purchase Orders")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Purchase Order List";
                }
                field("SOs Pending Approval"; rec."SOs Pending Approval")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Sales Order List";
                }
                field("Approved Sales Orders"; rec."Approved Sales Orders")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Sales Order List";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        //SETRANGE("User ID",USERID);
        rec.Reset;
        if not rec.Get then begin
            rec.Init;
            rec.Insert;
        end;

        rec.SetFilter("Due Date Filter", '<=%1', WorkDate);
        rec.SetFilter("Overdue Date Filter", '<%1', WorkDate);
        //v   rec.SetFilter("User ID Filter", UserId);
    end;
}

