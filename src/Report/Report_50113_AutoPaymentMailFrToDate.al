Report 50113 "Auto Payment Mail FrTo Date"
{
    ProcessingOnly = true;
    UseRequestPage = false;
    ApplicationArea = all;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {

            trigger OnAfterGetRecord()
            begin
                //v  SMTPSetup.Get;
                VenLedEntry.SetRange("Document Type", VenLedEntry."document type"::Payment);
                VenLedEntry.SetFilter(VenLedEntry."Posting Date", '%1..%2', FromDate, ToDate);
                VenLedEntry.SetRange("Document No.", "Document No.");
                if VenLedEntry.FindFirst then // REPEAT
                  begin
                    Vendor.Get(VenLedEntry."Vendor No.");
                    if Vendor."E-Mail" <> '' then begin
                        Vendor.TestField("E-Mail");
                        VenLedEntry.CalcFields(Amount);
                        Amt := Format(VenLedEntry.Amount); //pawans@cocoonitservices.com ashwini@cocoonitservices.com

                        //EMailMessage.Create(Vendor."E-Mail", 'Payment Details for ' + Vendor.Name + '', '', true);
                        EMailMessage.Create('vikas@cocoonitservices.com', 'Payment Details for ' + Vendor.Name + '', '', true);
                        EMailMessage.AppendToBody(Vendor.Name);
                        EMailMessage.AppendToBody('</br>');
                        EMailMessage.AppendToBody(Vendor.Address);
                        EMailMessage.AppendToBody(',');
                        EMailMessage.AppendToBody('</br>');
                        EMailMessage.AppendToBody(Vendor."Address 2");
                        EMailMessage.AppendToBody(',');
                        EMailMessage.AppendToBody('</br>');
                        EMailMessage.AppendToBody(Vendor.City);
                        EMailMessage.AppendToBody('-');
                        EMailMessage.AppendToBody(Vendor."Post Code");
                        EMailMessage.AppendToBody(',');
                        EMailMessage.AppendToBody(Vendor."State Code");
                        EMailMessage.AppendToBody('</br>');
                        EMailMessage.AppendToBody('Invoice No. ');
                        EMailMessage.AppendToBody(VenLedEntry."External Document No.");
                        EMailMessage.AppendToBody('<br><br>');
                        EMailMessage.AppendToBody('We have initiated payment of INR ');
                        EMailMessage.AppendToBody(Amt);
                        EMailMessage.AppendToBody(' and the same is expected to be credited to your bank account within 3 working days. Upon successful completion of the payment, you will receive an email confirmation along with the payment reference number.');
                        EMailMessage.AppendToBody('<br><br>');
                        EMailMessage.AppendToBody('Please find attached herewith this mail the details of the payment processed.');
                        EMailMessage.AppendToBody('<br><br>');
                        EMailMessage.AppendToBody('Regards,');
                        EMailMessage.AppendToBody('</br>');
                        EMailMessage.AppendToBody('Accounts Payable Team');
                        EMailMessage.AppendToBody('</br>');
                        EMailMessage.AppendToBody('For any queries, please contact us through +912262463319 or accounts.payable@auxilo.com');
                        EMailMessage.AppendToBody('<br>');
                        EMailMessage.AppendToBody('<br><br>');
                        Tempblob.CreateOutStream(OutStr);
                        Report.SaveAs(Report::"Payment Advice", '', ReportFormat::Pdf, OutStr);
                        Tempblob.CreateInStream(InStr);
                        EMailMessage.AddAttachment('Advice.PDF', 'PDF', InStr);
                        Email.Send(EMailMessage);
                    end;
                    //UNTIL VenLedEntry.NEXT = 0;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(FromDate; FromDate)
                {
                    ApplicationArea = Basic;
                }
                field(ToDate; ToDate)
                {
                    ApplicationArea = Basic;
                }
            }
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
        Message('Mail Successfully Sent');
    end;

    var
        //  SMTPSetup: Record "SMTP Mail Setup";
        Email: Codeunit Email;
        EMailMessage: Codeunit "Email Message";
        VenLedEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        Amt: Text;
        FromDate: Date;
        ToDate: Date;
        Tempblob: Codeunit "Temp Blob";
        InStr: InStream;
        OutStr: OutStream;
}

