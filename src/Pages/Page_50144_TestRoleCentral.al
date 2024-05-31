Page 50144 "Test Role Central"
{
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1000000001)
            {
                part(Control1000000002; "My Vendors RC")
                {
                    AccessByPermission = TableData Vendor = R;
                }
                part(Control1000000004; "G/L RC")
                {
                    AccessByPermission = TableData "G/L Account" = R;
                }
                group(Control1000000005)
                {
                }
                part(Control1000000003; "Approval Entries RC")
                {
                    Caption = 'Approval Entries';
                }
                group(Control1000000006)
                {
                    part(Control1000000007; "My Job Queue")
                    {
                        Visible = false;
                    }
                    part(Control1000000008; "My Job Queue RC")
                    {
                    }
                }
                group(Control1000000009)
                {
                    part(Control1000000010; "Trial Balance RC")
                    {
                    }
                }
            }
        }
    }

    actions
    {
    }
}

