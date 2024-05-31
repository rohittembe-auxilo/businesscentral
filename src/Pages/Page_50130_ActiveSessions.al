Page 50130 "Active Sessions"
{
    PageType = List;
    SourceTable = "Active Session";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User SID"; rec."User SID")
                {
                    ApplicationArea = Basic;
                }
                field("Server Instance ID"; rec."Server Instance ID")
                {
                    ApplicationArea = Basic;
                }
                field("Session ID"; rec."Session ID")
                {
                    ApplicationArea = Basic;
                }
                field("Server Instance Name"; rec."Server Instance Name")
                {
                    ApplicationArea = Basic;
                }
                field("Server Computer Name"; rec."Server Computer Name")
                {
                    ApplicationArea = Basic;
                }
                field("User ID"; rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Client Type"; rec."Client Type")
                {
                    ApplicationArea = Basic;
                }
                field("Client Computer Name"; rec."Client Computer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Login Datetime"; rec."Login Datetime")
                {
                    ApplicationArea = Basic;
                }
                field("Database Name"; rec."Database Name")
                {
                    ApplicationArea = Basic;
                }
                field("Session Unique ID"; rec."Session Unique ID")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Kill Session")
            {
                ApplicationArea = Basic;
                Image = delete;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm(Text00001, false) then
                        StopSession(rec."Session ID");
                end;
            }
        }
    }

    var
        Text00001: label 'Do you want to kill the Session?';
}

