Page 50133 "Company Info Card"
{
    Caption = 'Company Information';
    DeleteAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Company Information2";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Start Date';
                    ShowMandatory = true;
                }
                field("Code"; Rec."Primary Key")
                {
                    ApplicationArea = Basic;
                    Caption = 'Code';
                    ShowMandatory = true;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                /*  field(State; Rec.State)
                  {
                      ApplicationArea = Basic;
                  }
                  field("STD Code"; Rec."STD Code")
                  {
                      ApplicationArea = Basic;
                  }
                  */
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(GLN; Rec.GLN)
                {
                    ApplicationArea = Basic;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'End Date';
                    ShowMandatory = true;
                }
                field("Industrial Classification"; Rec."Industrial Classification")
                {
                    ApplicationArea = Basic;
                }
                /*   field("Factories Act. Regd. No."; Rec."Factories Act. Regd. No.")
                   {
                       ApplicationArea = Basic;
                   }
                   field("Company Status"; Rec."Company Status")
                   {
                       ApplicationArea = Basic;
                   }
                   field("Company Registration  No."; Rec."Company Registration  No.")
                   {
                       ApplicationArea = Basic;
                   }
                   */
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No.2"; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Corporate Email ID"; Rec."Corporate Email ID")
                {
                    ApplicationArea = Basic;
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = Basic;
                }
                /*   field("IC Partner Code"; Rec."IC Partner Code")
                   {
                       ApplicationArea = Basic;
                   }
                   field("IC Inbox Type"; Rec."IC Inbox Type")
                   {
                       ApplicationArea = Basic;
                   }

                   field("IC Inbox Details"; Rec."IC Inbox Details")
                   {
                       ApplicationArea = Basic;
                   }
                   */
            }
            group(Payments)
            {
                Caption = 'Payments';
                field("Allow Blank Payment Info."; Rec."Allow Blank Payment Info.")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = IBANMissing;

                    trigger OnValidate()
                    begin
                        SetShowMandatoryConditions
                    end;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = IBANMissing;

                    trigger OnValidate()
                    begin
                        SetShowMandatoryConditions
                    end;
                }
                field("Payment Routing No."; Rec."Payment Routing No.")
                {
                    ApplicationArea = Basic;
                }
                field("Giro No."; Rec."Giro No.")
                {
                    ApplicationArea = Basic;
                }
                field("SWIFT Code"; Rec."SWIFT Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        SetShowMandatoryConditions
                    end;
                }
                field(Iban; Rec.Iban)
                {
                    ApplicationArea = Basic;
                    ShowMandatory = BankBranchNoOrAccountNoMissing;

                    trigger OnValidate()
                    begin
                        SetShowMandatoryConditions
                    end;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Check-Avail. Period Calc."; Rec."Check-Avail. Period Calc.")
                {
                    ApplicationArea = Basic;
                }
                field("Check-Avail. Time Bucket"; Rec."Check-Avail. Time Bucket")
                {
                    ApplicationArea = Basic;
                }
                field("Base Calendar Code"; Rec."Base Calendar Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                }

                field("Cal. Convergence Time Frame"; Rec."Cal. Convergence Time Frame")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Tax Information")
            {
                Caption = 'Tax Information';
                group("Tax / VAT")
                {
                    Caption = 'Tax / VAT';

                }
                group("System Indicator")
                {
                    Caption = 'System Indicator';
                    field(Control100; Rec."System Indicator")
                    {
                        ApplicationArea = Basic;

                        trigger OnValidate()
                        begin
                            SystemIndicatorOnAfterValidate;
                        end;
                    }
                    field("System Indicator Style"; Rec."System Indicator Style")
                    {
                        ApplicationArea = Basic;
                    }
                    field("System Indicator Text"; SystemIndicatorText)
                    {
                        ApplicationArea = Basic;
                        Caption = 'System Indicator Text';
                        Editable = SystemIndicatorTextEditable;

                        trigger OnValidate()
                        begin
                            Rec."Custom System Indicator Text" := SystemIndicatorText;
                            SystemIndicatorTextOnAfterVali;
                        end;
                    }
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action("Test Email")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    EmailMessage: Codeunit "Email Message";
                    TempBlob: Codeunit "Temp Blob";
                    outstr: OutStream;
                    Email: Codeunit Email;
                    ExcelBuf: Record "Excel Buffer";
                begin
                    // DisplayMap;
                    /*   EmailMessage.Create('vikas@cocoonitservices.com', 'Payment Advice', '');

                       EmailMessage.AppendToBody('Dear Sir/Madam,');
                       EmailMessage.AppendToBody('<br><br>');
                       EmailMessage.AppendToBody('Please Check Your Payment of Rs. ');
                       EmailMessage.AppendToBody('100');
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
                       Email.Send(EmailMessage)
   */
                    ExcelBuf.NewRow;
                    ExcelBuf.AddColumn('Balance as on specified date', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn('jbj', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
                    ExcelBuf.AddColumn('kkk', false, '', true, false, true, '', ExcelBuf."cell type"::Date);
                    ExcelBuf.CreateNewBook('vikas');
                    ExcelBuf.WriteSheet('cus', CompanyName, UserId);
                    ExcelBuf.CloseBook();
                    ExcelBuf.OpenExcel();
                end;
            }
            action("Bank Acc Reconcillation")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var

                begin
                    Xmlport.Run(50100);
                end;
            }
            action("ALM Sheet1")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var

                begin
                    Xmlport.Run(50101);
                end;
            }
            action("ALM Sheet2")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var

                begin
                    Xmlport.Run(50102);
                end;
            }
            action("ALM Sheet3")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var

                begin
                    Xmlport.Run(50103);
                end;
            }
            action("Memorandum Entries")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var

                begin
                    Xmlport.Run(50104);
                end;
            }
            action("Advance CL Balance")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var

                begin
                    Xmlport.Run(50105);
                end;
            }
            action("Advances Lanwise")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var

                begin
                    Xmlport.Run(50106);
                end;
            }
            action("Advance CustID")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var

                begin
                    Xmlport.Run(50107);
                end;
            }
            action("Advance OD Report")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var

                begin
                    Xmlport.Run(50108);
                end;
            }
            action("Advance Interest Accrual")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50109);
                end;
            }
            action("Advance EIR")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50110);
                end;
            }
            action("Advance ECL")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50111);
                end;
            }
            action("Dimvalue update")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50112);
                end;
            }
            action("ALM Update")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50113);
                end;
            }
            action("ALM Line Import")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50114);
                end;
            }
            action("LMS Purch Order Update")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50115);
                end;
            }
            action("LMSGLTransaction")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50116);
                end;
            }

            action("Voucher Entry Archive")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50119);
                end;
            }
            action("Export GL Transaction")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50120);
                end;
            }
            action("EIR IMPORT")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50121);
                end;
            }
            action("EIR Export")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50122);
                end;
            }
            action("EIR Cost")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50123);
                end;
            }
            action("LMS Vendor Date Import")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50124);
                end;
            }
            action("LMS Purc Trans Import")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50125);
                end;
            }
            action("LMS GL Transaction Import")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50126);
                end;
            }
            action("Opening Balance Upload")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50127);
                end;
            }


            action("Customer Xmlport")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50130);
                end;
            }
            action("Dimention Value Xmlport")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50131);
                end;
            }

            action("Fixed Asset")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50133);
                end;
            }
            action("Gen Voucher")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50134);
                end;
            }
            action("Purchase oder Uploads")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50135);
                end;
            }
            action("Sales Xmlport")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50136);
                end;
            }
            action("vendor bank account")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50137);
                end;
            }
            action("Vendor")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var

                begin
                    Xmlport.Run(50138);
                end;
            }
            action("Partyconfirmation")
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



        }
        area(navigation)
        {
            group("&Company")
            {
                Caption = '&Company';
                Image = Company;
                action("Responsibility Centers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Responsibility Centers';
                    Image = Position;
                    //   RunObject = Page UnknownPage5715;
                }
                separator(Action91)
                {
                }
                action("Online Map")
                {
                    ApplicationArea = Basic;
                    Caption = 'Online Map';
                    Image = Map;

                    trigger OnAction()
                    begin
                        // DisplayMap;

                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateSystemIndicator;
    end;

    trigger OnAfterGetRecord()
    begin
    end;

    trigger OnInit()
    begin
        "Ministry TypeEnable" := true;
        "Ministry CodeEnable" := true;
        "PAO Registration No.Enable" := true;
        "PAO CodeEnable" := true;
        "DDO Registration No.Enable" := true;
        "DDO CodeEnable" := true;
        "P.A.N. No.Editable" := true;
        MapPointVisible := true;
        LargeTaxPayerCityVisible := true;
        "Composition TypeEnable" := true;
        SetShowMandatoryConditions;
    end;

    trigger OnOpenPage()
    var
    //   MapMgt: Codeunit UnknownCodeunit802;
    begin
        /*RESET;
        IF NOT GET THEN BEGIN
          INIT;
          INSERT;
        END;
        IF NOT MapMgt.TestSetup THEN
          MapPointVisible := FALSE;
        */

    end;

    var
        // CustomizedCalEntry: Record UnknownRecord7603;
        // CustomizedCalendar: Record UnknownRecord7602;
        // CalendarMgmt: Codeunit UnknownCodeunit7600;
        SystemIndicatorText: Text[250];
        Text16500: label 'You can not uncheck Large Tax Payer until Large Tax Payer City is Blank.';
        [InDataSet]
        "Composition TypeEnable": Boolean;
        [InDataSet]
        LargeTaxPayerCityVisible: Boolean;
        [InDataSet]
        MapPointVisible: Boolean;
        [InDataSet]
        SystemIndicatorTextEditable: Boolean;
        [InDataSet]
        "P.A.N. No.Editable": Boolean;
        [InDataSet]
        "DDO CodeEnable": Boolean;
        [InDataSet]
        "DDO Registration No.Enable": Boolean;
        [InDataSet]
        "PAO CodeEnable": Boolean;
        [InDataSet]
        "PAO Registration No.Enable": Boolean;
        [InDataSet]
        "Ministry CodeEnable": Boolean;
        [InDataSet]
        "Ministry TypeEnable": Boolean;
        IBANMissing: Boolean;
        BankBranchNoOrAccountNoMissing: Boolean;

    local procedure UpdateSystemIndicator()
    var
        IndicatorStyle: Option;
    begin
        //  GetSystemIndicator(SystemIndicatorText, IndicatorStyle); // IndicatorStyle is not used
        //  SystemIndicatorTextEditable := CurrPage.Editable and ("System Indicator" = "system indicator"::"Custom Text");
    end;

    local procedure SystemIndicatorTextOnAfterVali()
    begin
        UpdateSystemIndicator
    end;

    local procedure SystemIndicatorOnAfterValidate()
    begin
        UpdateSystemIndicator
    end;



    local procedure CompositionOnAfterValidate()
    begin
        // "Composition TypeEnable" := Composition;
    end;

    local procedure DeductorCategoryOnAfterValidat()
    begin
        // UpdateEnabled;
    end;

    local procedure PANStatusOnAfterValidate()
    begin
        //UpdateEnabled;
    end;

    local procedure SetShowMandatoryConditions()
    var

    begin
        BankBranchNoOrAccountNoMissing := (Rec."Bank Branch No." = '') or (Rec."Bank Account No." = '');
        IBANMissing := rec.Iban = ''
    end;
}

