codeunit 50020 AutoMail
{
    // version CCIT AN


    trigger OnRun()
    begin
        VenLedEntry.SETRANGE("Document Type", VenLedEntry."Document Type"::Payment);
        //VenLedEntry.SETRANGE("Document No.", "Document No.");
        VenLedEntry.SETFILTER("Creation Date", '<>%1', 0D);
        IF VenLedEntry.FINDFIRST THEN
            REPEAT
                Vendor.GET(VenLedEntry."Vendor No.");
                //IF Vendor."E-Mail" <>'' THEN
                BEGIN
                    //Vendor.TESTFIELD("E-Mail");
                    VenLedEntry.CALCFIELDS(Amount);
                    //Amt := FORMAT(VenLedEntry.Amount,0,'<Integer Thosand><Decimals,3>'); pawans@cocoonitservices.com
                    Amt := FORMAT(VenLedEntry.Amount);
                    EmailMessage.Create('ashwini@cocoonitservices.com', 'Payment Advice', '');

                    EmailMessage.AppendToBody('Dear Sir/Madam,');
                    EmailMessage.AppendToBody('<br><br>');
                    EmailMessage.AppendToBody('Please Check Your Payment of Rs. ');
                    EmailMessage.AppendToBody(Amt);
                    EmailMessage.AppendToBody(' is made to your account, Any difference of amount to be informed immediately to accounts team within 3 working days.');
                    EmailMessage.AppendToBody('<br><br>');
                    EmailMessage.AppendToBody('Regards,');
                    EmailMessage.AppendToBody('</br>');
                    EmailMessage.AppendToBody('Accounts.');
                    EmailMessage.AppendToBody('</br>');
                    EmailMessage.AppendToBody('<b>This is a system generated information does not required any signature </b> ');
                    EmailMessage.AppendToBody('<br>');
                    EmailMessage.AppendToBody('This is a auto generated mail and reply this mail will not be attended.');
                    EmailMessage.AppendToBody('<br>');
                    TempBlob.CreateOutStream(OutStr);

                    // ReportParameters := ReportExample.RunRequestPage();
                    // Report.SaveAs(Report::"Payment Advice", ReportParameters, ReportFormat::Pdf, OutStr, VenLedEntry);
                    // TempBlob.CreateInStream(InStr);
                    // REPORT.SaveAsPdf(Report::"Payment Advice", 'D:\CCIT\Report\Payment Advice.PDF', VenLedEntry);
                    // EmailMessage.AddAttachment('Payment Advice.pdf', 'PDF', InStr);
                    // EmailMessage.Send;
                END;
            UNTIL VenLedEntry.NEXT = 0;
    end;


    var
        VenLedEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        Amt: Text;
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        TempBlob: Codeunit "Temp Blob";
        InStr: Instream;
        OutStr: OutStream;
        ReportParameters: Text;
}