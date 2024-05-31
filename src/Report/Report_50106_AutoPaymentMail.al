/*Report 50106 "Auto Payment Mail"
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
                SMTPSetup.Get;
                VenLedEntry.SetRange("Document Type", VenLedEntry."document type"::Payment);
                //VenLedEntry.SETFILTER(VenLedEntry."Posting Date",'%1..%2',FromDate,ToDate);
                VenLedEntry.SetRange("Document No.", "Document No.");
                if VenLedEntry.FindFirst then
                    repeat
                        // BEGIN
                        Vendor.Get(VenLedEntry."Vendor No.");
                        if Vendor."E-Mail" <> '' then begin
                            Vendor.TestField("E-Mail");
                            VenLedEntry.CalcFields(Amount);
                            Amt := Format(VenLedEntry.Amount); //pawans@cocoonitservices.com ashwini@cocoonitservices.com
                            SMTPSetup.Get;
                            SMTPMail.CreateMessage('Accounts', SMTPSetup."User ID", Vendor."E-Mail", 'Payment Details for ' + Vendor.Name + '', '', true);   //Vendor."E-Mail",'Payment Advice','',TRUE);
                                                                                                                                                             //SMTPMail.AppendBody('Dear Sir/Madam,');
                            SMTPMail.AppendBody(Vendor.Name);
                            SMTPMail.AppendBody('</br>');
                            SMTPMail.AppendBody(Vendor.Address);
                            SMTPMail.AppendBody(',');
                            SMTPMail.AppendBody('</br>');
                            SMTPMail.AppendBody(Vendor."Address 2");
                            SMTPMail.AppendBody(',');
                            SMTPMail.AppendBody('</br>');
                            SMTPMail.AppendBody(Vendor.City);
                            SMTPMail.AppendBody('-');
                            SMTPMail.AppendBody(Vendor."Post Code");
                            SMTPMail.AppendBody(',');
                            SMTPMail.AppendBody(Vendor."State Code");
                            SMTPMail.AppendBody('</br>');
                            SMTPMail.AppendBody('Invoice No. ');
                            SMTPMail.AppendBody(VenLedEntry."External Document No.");
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('We have initiated payment of INR ');
                            SMTPMail.AppendBody(Amt);
                            SMTPMail.AppendBody(' and the same is expected to be credited to your bank account within 3 working days. Upon successful completion of the payment, you will receive an email confirmation along with the payment reference number.');
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('Please find attached herewith this mail the details of the payment processed.');
                            SMTPMail.AppendBody('<br><br>');
                            SMTPMail.AppendBody('Regards,');
                            SMTPMail.AppendBody('</br>');
                            SMTPMail.AppendBody('Accounts Payable Team');
                            SMTPMail.AppendBody('</br>');
                            SMTPMail.AppendBody('For any queries, please contact us through +912262463319 or accounts.payable@auxilo.com');
                            SMTPMail.AppendBody('<br>');
                            SMTPMail.AppendBody('<br><br>');
                            Report.SaveAsPdf(50002, 'D:\CCIT\Report\Payment Advice.PDF', VenLedEntry);
                            SMTPMail.AddAttachment('D:\CCIT\Report\Payment Advice.PDF', '.pdf');
                            SMTPMail.Send;
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
        SMTPSetup: Record smtp;
        SMTPMail: Codeunit smtp m;
        VenLedEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        Amt: Text;
        FromDate: Date;
        ToDate: Date;
}
*/

