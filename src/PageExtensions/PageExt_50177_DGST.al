pageextension 50177 DGST extends "Detailed GST Ledger Entry"
{
    layout
    {
        // Add changes to page layout here
        addafter("GST Exempted Goods")
        {
            field("Shortcut Dimention 8 Code"; Rec."Shortcut Dimention 8 Code")
            {
                ApplicationArea = All;
            }
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = All;
            }
            field("Vendor Invoice No."; Rec."Vendor Invoice No.")
            {
                ApplicationArea = All;
            }
            field("Purchase Invoice Comment"; Rec."Purchase Invoice Comment")
            {
                ApplicationArea = All;
            }
            field("Payment Date"; Rec."Payment Date")
            {
                ApplicationArea = All;
            }
            field("Payment Doc No."; Rec."Payment Doc No.")
            {
                ApplicationArea = All;
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
            }
            field("RCM Invoice No."; Rec."RCM Invoice No.")
            {
                ApplicationArea = All;
            }
            field("RCM Invoice No"; Rec."RCM Invoice No")
            {
                ApplicationArea = All;
            }
            field("RCM Payment No"; Rec."RCM Payment No")
            {
                ApplicationArea = All;
            }
            field("GST Credit 50%"; Rec."GST Credit 50%")
            {
                ApplicationArea = All;
            }

        }

    }

    actions
    {
        // Add changes to page actions here
        addafter("Show Related Information")
        {
            action("Check E-Mail")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    EMailMessage: Codeunit "Email Message";
                    Email: Codeunit Email;

                begin
                    EMailMessage.Create('vikas@cocoonitservices.com', 'Payment Details for ', '', true);
                    EMailMessage.AppendToBody('This is a test E-Mail');
                    //EMailMessage.AppendToBody('</br>');
                    //EMailMessage.AppendToBody(Vendor.Address);
                    // EMailMessage.AppendToBody(',');
                    // EMailMessage.AppendToBody('</br>');
                    // EMailMessage.AppendToBody(Vendor."Address 2");
                    // EMailMessage.AppendToBody(',');
                    // EMailMessage.AppendToBody('</br>');
                    // EMailMessage.AppendToBody(Vendor.City);
                    // EMailMessage.AppendToBody('-');
                    // EMailMessage.AppendToBody(Vendor."Post Code");
                    // EMailMessage.AppendToBody(',');
                    // EMailMessage.AppendToBody(Vendor."State Code");
                    // EMailMessage.AppendToBody('</br>');
                    // EMailMessage.AppendToBody('Invoice No. ');
                    // EMailMessage.AppendToBody(VenLedEntry."External Document No.");
                    // EMailMessage.AppendToBody('<br><br>');
                    // EMailMessage.AppendToBody('We have initiated payment of INR ');
                    // EMailMessage.AppendToBody(Amt);
                    // EMailMessage.AppendToBody(' and the same is expected to be credited to your bank account within 3 working days. Upon successful completion of the payment, you will receive an email confirmation along with the payment reference number.');
                    // EMailMessage.AppendToBody('<br><br>');
                    // EMailMessage.AppendToBody('Please find attached herewith this mail the details of the payment processed.');
                    // EMailMessage.AppendToBody('<br><br>');
                    // EMailMessage.AppendToBody('Regards,');
                    // EMailMessage.AppendToBody('</br>');
                    // EMailMessage.AppendToBody('Accounts Payable Team');
                    // EMailMessage.AppendToBody('</br>');
                    // EMailMessage.AppendToBody('For any queries, please contact us through +912262463319 or accounts.payable@auxilo.com');
                    // EMailMessage.AppendToBody('<br>');
                    // EMailMessage.AppendToBody('<br><br>');
                    // Tempblob.CreateOutStream(OutStr);
                    // Report.SaveAs(Report::"Payment Advice", '', ReportFormat::Pdf, OutStr);
                    // Tempblob.CreateInStream(InStr);
                    // EMailMessage.AddAttachment('Advice.PDF', 'PDF', InStr);
                    Email.Send(EMailMessage);


                end;
            }
        }
    }
    var
        myInt: Integer;
}