Report 50106 "Auto Payment Mail"
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            RequestFilterFields = "Document No.";


            trigger OnAfterGetRecord()
            begin
                // SMTPSetup.Get;
                VenLedEntry.SetRange("Document Type", VenLedEntry."document type"::Payment);
                //VenLedEntry.SETFILTER(VenLedEntry."Posting Date",'%1..%2',FromDate,ToDate);
                VenLedEntry.SetRange("Document No.", "Document No.");
                if VenLedEntry.FindFirst then
                    repeat
                        // BEGIN
                        Vendor.Get(VenLedEntry."Vendor No.");
                        Vendor.TestField("E-Mail");
                        if Vendor."E-Mail" <> '' then begin
                            EmailList := Vendor."E-Mail";
                            if Vendor."E-Mail 2" <> '' then
                                EmailList := EmailList + ';' + Vendor."E-Mail 2";
                            VenLedEntry.CalcFields(Amount);
                            Amt := Format(VenLedEntry.Amount); //pawans@cocoonitservices.com ashwini@cocoonitservices.com
                                                               //  SMTPSetup.Get;
                            EMailMessage.Create(Vendor."E-Mail", 'Payment Details for ' + Vendor.Name + '', '', true);   //Vendor."E-Mail",'Payment Advice','',TRUE);
                                                                                                                         //SMTPMail.AppendToBody('Dear Sir/Madam,');
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
                            EMailMessage.AppendtoBody('For any queries, please contact us through +912262463319 or accounts.payable@auxilo.com');
                            EMailMessage.AppendtoBody('<br>');
                            EMailMessage.AppendtoBody('<br><br>');
                            recRef.GetTable(VenLedEntry);
                            Tempblob.CreateOutStream(OutStr);
                            PaymentAdvice.SetTableView(VenLedEntry);
                            Report.SaveAs(Report::"Payment Advice", '', ReportFormat::Pdf, OutStr, recRef);
                            Tempblob.CreateInStream(InStr);
                            EMailMessage.AddAttachment('Payment Advice.pdf', 'PDF', InStr);
                            Email.Send(EMailMessage);

                        end;
                    until VenLedEntry.Next = 0;
                //END;
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
                    Visible = false;
                }
                field(ToDate; ToDate)
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
        Email: Codeunit Email;
        EMailMessage: Codeunit "Email Message";

        VenLedEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        Amt: Text;
        FromDate: Date;
        ToDate: Date;
        recRef: RecordRef;
        Tempblob: Codeunit "Temp Blob";
        InStr: InStream;
        OutStr: OutStream;
        PaymentAdvice: Report "Payment Advice";
        EmailList: Text;
}


