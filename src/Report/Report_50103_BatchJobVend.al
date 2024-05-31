Report 50000 "Batch Job Vend"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Vendor.Blocked := Vendor.Blocked::" ";
                Vendor.Modify;
            end;
        }
        dataitem(Customer; Customer)
        {
            column(ReportForNavId_1000000001; 1000000001)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Customer.Blocked := Customer.Blocked::" ";
                Customer.Modify;
            end;
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

    labels
    {
    }

    trigger OnPostReport()
    begin
        Message('Changed Successfully');
    end;
}

