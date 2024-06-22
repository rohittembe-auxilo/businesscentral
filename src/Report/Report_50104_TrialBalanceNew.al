Report 50036 "Trial Balance New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/TrialBalanceNew.rdl';
    Caption = 'Trial Balance New';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;


    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            CalcFields = "Credit Amount", "Debit Amount";
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Account Type", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(ReportForNavId_6710; 6710)
            {
            }
            column(STRSUBSTNO_Text000_PeriodText_; StrSubstNo(Text000, PeriodText))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CompInfo_Address_3; '')
            {
            }
            column(CompInfo_Picture; CompInfo.Picture)
            {
            }
            column(PeriodText; PeriodText)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter; TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(G_L_Account_No_; "No.")
            {
            }
            column(Trial_BalanceCaption; Trial_BalanceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Net_ChangeCaption; Net_ChangeCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(G_L_Account___No__Caption; FieldCaption("No."))
            {
            }
            column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaption; PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl)
            {
            }
            column(G_L_Account___Net_Change_Caption; G_L_Account___Net_Change_CaptionLbl)
            {
            }
            column(G_L_Account___Net_Change__Control22Caption; G_L_Account___Net_Change__Control22CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date_Caption; G_L_Account___Balance_at_Date_CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date__Control24Caption; G_L_Account___Balance_at_Date__Control24CaptionLbl)
            {
            }
            column(G_L_Account___Opening_Caption; G_L_Account___Opening_CaptionLbl)
            {
            }
            column(G_L_Account___Opening_Control7Caption; G_L_Account___Opening_Control7CaptionLbl)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(G_L_Account___No__; "G/L Account"."No.")
                {
                }
                column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__Name; PadStr('', "G/L Account".Indentation * 2) + "G/L Account".Name)
                {
                }
                column(G_L_Account___Net_Change_; "G/L Account"."Net Change")
                {
                }
                column(G_L_Account___Net_Change__Control22; -"G/L Account"."Net Change")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Balance_at_Date_; "G/L Account"."Balance at Date")
                {
                }
                column(G_L_Account___Balance_at_Date__Control24; -"G/L Account"."Balance at Date")
                {
                    AutoFormatType = 1;
                }
                column(G_L_Account___Account_Type_; Format("G/L Account"."Account Type", 0, 2))
                {
                }
                column(No__of_Blank_Lines; "G/L Account"."No. of Blank Lines")
                {
                }
                column(GLAcc_Balance_at_Date; GLAcc."Balance at Date")
                {
                }
                column(GLAcc_Balance_at_Date_Control7; -GLAcc."Balance at Date")
                {
                }
                column(GTotalOpnDebit; GTotalOpnDebit)
                {
                }
                column(GTotalOpnCredit; GTotalOpnCredit)
                {
                }
                column(GTotalNetDebit; GTotalNetDebit)
                {
                }
                column(GTotalNetCredit; GTotalNetCredit)
                {
                }
                column(GTotalClosingDebit; GTotalClosingDebit)
                {
                }
                column(GTotalClosingCredit; GTotalClosingCredit)
                {
                }
                column(GL_Account_Debit_Amount; "G/L Account"."Debit Amount")
                {
                }
                column(GL_Account_Credit_Amount; "G/L Account"."Credit Amount")
                {
                }
                column(TotalCredit; TotalCredit)
                {
                }
                column(TotalDebit; TotalDebit)
                {
                }
                column(TotalNetChange; TotalNetChange)
                {
                }
                column(GLAccount_ArabicDescription; '')
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if ShowBal then begin
                        if (GLAcc."Balance at Date" = 0) and ("G/L Account"."Net Change" = 0) and ("G/L Account"."Balance at Date" = 0) then
                            CurrReport.Skip;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Net Change", "Balance at Date", "Credit Amount", "Debit Amount");

                GLAcc.Reset;
                GLAcc.SetRange("No.", "G/L Account"."No.");
                GLAcc.SetFilter("Date Filter", '%1..%2', 0D, ClosingDate("G/L Account".GetRangeMin("Date Filter") - 1));//
                if GLAcc.FindFirst then
                    GLAcc.CalcFields(GLAcc."Balance at Date");


                if "G/L Account"."Account Type" = "G/L Account"."account type"::Posting then begin
                    //opn Total
                    if GLAcc."Balance at Date" > 0 then
                        GTotalOpnDebit += Abs(GLAcc."Balance at Date")
                    else
                        GTotalOpnCredit += Abs(GLAcc."Balance at Date");



                    //Net Change Total
                    if "G/L Account"."Net Change" > 0 then
                        GTotalNetDebit += Abs("G/L Account"."Net Change")
                    else
                        GTotalNetCredit += Abs("G/L Account"."Net Change");

                    TotalCredit += Abs("G/L Account"."Credit Amount");
                    TotalDebit += "G/L Account"."Debit Amount";
                    TotalNetChange += "G/L Account"."Net Change";

                    //Closing total
                    if "G/L Account"."Balance at Date" > 0 then
                        GTotalClosingDebit += Abs("G/L Account"."Balance at Date")
                    else
                        GTotalClosingCredit += Abs("G/L Account"."Balance at Date");

                end;


                if PrintToExcel then
                    MakeExcelDataBody;
            end;

            trigger OnPreDataItem()
            begin
                CompInfo.Get;
                CompInfo.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintToExcel; PrintToExcel)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print to Excel';
                    }
                    field("Show Only Having Balances"; ShowBal)
                    {
                        ApplicationArea = Basic;
                    }
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
        if PrintToExcel then
            CreateExcelbook;
    end;

    trigger OnPreReport()
    begin
        GLFilter := "G/L Account".GetFilters;
        PeriodText := "G/L Account".GetFilter("Date Filter");
        if PrintToExcel then
            MakeExcelInfo;
    end;

    var
        Text000: label 'Period: %1';
        ExcelBuf: Record "Excel Buffer" temporary;
        GLFilter: Text[250];
        PeriodText: Text[30];
        PrintToExcel: Boolean;
        Text001: label 'Trial Balance';
        Text002: label 'Data';
        Text003: label 'Debit';
        Text004: label 'Credit';
        Text005: label 'Company Name';
        Text006: label 'Report No.';
        Text007: label 'Report Name';
        Text008: label 'User ID';
        Text009: label 'Date';
        Text010: label 'G/L Filter';
        Text011: label 'Period Filter';
        Trial_BalanceCaptionLbl: label 'Trial Balance';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Net_ChangeCaptionLbl: label 'Net Change';
        BalanceCaptionLbl: label 'Balance';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl: label 'GL Name';
        G_L_Account___Net_Change_CaptionLbl: label 'Debit';
        G_L_Account___Net_Change__Control22CaptionLbl: label 'Credit';
        G_L_Account___Balance_at_Date_CaptionLbl: label 'Debit';
        G_L_Account___Balance_at_Date__Control24CaptionLbl: label 'Credit';
        GLAcc: Record "G/L Account";
        G_L_Account___Opening_CaptionLbl: label 'Debit';
        G_L_Account___Opening_Control7CaptionLbl: label 'Credit';
        CompInfo: Record "Company Information";
        ShowBal: Boolean;
        GTotalOpnDebit: Decimal;
        GTotalOpnCredit: Decimal;
        GTotalNetDebit: Decimal;
        GTotalNetCredit: Decimal;
        GTotalClosingDebit: Decimal;
        GTotalClosingCredit: Decimal;
        TotalCredit: Decimal;
        TotalDebit: Decimal;
        TotalNetChange: Decimal;
        Enddate: Text;


    procedure MakeExcelInfo()
    begin
        ExcelBuf.DeleteAll;
        ExcelBuf.DeleteAll;
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Format(Text005), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(COMPANYNAME, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Format(Text007), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Format(Text001), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Format(Text006), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Report::"Trial Balance New", false, '', false, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Format(Text008), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(UserId, false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Format(Text009), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(Today, false, '', false, false, false, '', ExcelBuf."cell type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Format(Text010), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Account".GetFilter("No."), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Format(Text011), false, '', true, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn("G/L Account".GetFilter("Date Filter"), false, '', false, false, false, '', ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.AddColumn('GL No.', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('GL Name', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(
          Format('Opening Balance'), false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(
          Format(Text003), false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(
          Format(Text004), false, '', true, false, true, '', ExcelBuf."cell type"::Text);

        //added>
        //ExcelBuf.AddColumn(
        //  FORMAT("G/L Account".FIELDCAPTION("Net Change")),FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuf."Cell Type"::Text);
        //added<

        ExcelBuf.AddColumn(
          Format('Closing Balance'), false, '', true, false, true, '',
          ExcelBuf."cell type"::Text);
    end;


    procedure MakeExcelDataBody()
    var
        BlankFiller: Text[250];
    begin
        if ShowBal = true then begin
            if (GLAcc."Balance at Date" = 0) and ("G/L Account"."Debit Amount" = 0) and ("G/L Account"."Credit Amount" = 0) and ("G/L Account"."Net Change" = 0) and ("G/L Account"."Balance at Date" = 0) then //Manish
                CurrReport.Skip;
        end;

        BlankFiller := PadStr(' ', MaxStrLen(BlankFiller), ' ');
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(
          "G/L Account"."No.", false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '',
          ExcelBuf."cell type"::Number);
        if "G/L Account".Indentation = 0 then
            ExcelBuf.AddColumn(
              "G/L Account".Name, false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '',
              ExcelBuf."cell type"::Number)//manish 06-12-22
        else
            ExcelBuf.AddColumn(
              CopyStr(BlankFiller, 1, 2 * "G/L Account".Indentation) + "G/L Account".Name,
              false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '', ExcelBuf."cell type"::Number);//manish 06-12-22

        case true of
            //opening
            GLAcc."Balance at Date" = 0:
                begin
                    ExcelBuf.AddColumn(
                      '0', false, '', GLAcc."Account Type" <> GLAcc."account type"::Posting, false, false, '#,##0.00',
                      ExcelBuf."cell type"::Number);//Manish
                                                    //ExcelBuf."Cell Type"::Text);
                                                    // ExcelBuf.AddColumn(
                                                    //  '',FALSE,'',GLAcc."Account Type" <> GLAcc."Account Type"::Posting,FALSE,FALSE,'',
                                                    //  ExcelBuf."Cell Type"::Text);
                end;
            GLAcc."Balance at Date" > 0:
                begin
                    ExcelBuf.AddColumn(
                      GLAcc."Balance at Date", false, '', GLAcc."Account Type" <> GLAcc."account type"::Posting,
                      false, false, '#,##0.00', ExcelBuf."cell type"::Number);
                    //  ExcelBuf.AddColumn(
                    //  '',FALSE,'',GLAcc."Account Type" <> GLAcc."Account Type"::Posting,FALSE,FALSE,'',
                    //ExcelBuf."Cell Type"::Text);
                end;
            GLAcc."Balance at Date" < 0:
                begin
                    // ExcelBuf.AddColumn(
                    // '',FALSE,'',GLAcc."Account Type" <> GLAcc."Account Type"::Posting,FALSE,FALSE,'',
                    // ExcelBuf."Cell Type"::Text);
                    ExcelBuf.AddColumn(
                      GLAcc."Balance at Date", false, '', GLAcc."Account Type" <> GLAcc."account type"::Posting,//'-'manish 06-02-22
                      false, false, '#,##0.00', ExcelBuf."cell type"::Number);//manish
                end;
        end;
        //opening

        ExcelBuf.AddColumn(
          "G/L Account"."Debit Amount", false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,
          false, false, '#,##0.00', ExcelBuf."cell type"::Number);
        //ExcelBuf.AddColumn(
        //  "G/L Account"."Debit Amount",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
        // ExcelBuf."Cell Type"::Text);

        ExcelBuf.AddColumn(
          Abs("G/L Account"."Credit Amount"), false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '#,##0.00',
          ExcelBuf."cell type"::Number);

        //ExcelBuf.AddColumn(
        //  "G/L Account"."Net Change",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
        //  FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
        //ExcelBuf.AddColumn(
        //"G/L Account"."Net Change",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
        //ExcelBuf."Cell Type"::Text);

        /*
        CASE TRUE OF
          "G/L Account"."Net Change" = 0:
            BEGIN
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
            END;
          "G/L Account"."Net Change" > 0:
            BEGIN
              ExcelBuf.AddColumn(
                "G/L Account"."Net Change",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
            END;
          "G/L Account"."Net Change" < 0:
            BEGIN
              ExcelBuf.AddColumn(
                '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                ExcelBuf."Cell Type"::Text);
              ExcelBuf.AddColumn(
                -"G/L Account"."Net Change",FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,
                FALSE,FALSE,'#,##0.00',ExcelBuf."Cell Type"::Number);
            END;
        END;
        */
        case true of
            "G/L Account"."Balance at Date" = 0:
                begin
                    ExcelBuf.AddColumn(
                      '0', false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting, false, false, '#,##0.00',
                      ExcelBuf."cell type"::Number);
                    //      ExcelBuf.AddColumn(
                    //        '',FALSE,'',"G/L Account"."Account Type" <> "G/L Account"."Account Type"::Posting,FALSE,FALSE,'',
                    //        ExcelBuf."Cell Type"::Text);
                end;
            "G/L Account"."Balance at Date" > 0:
                begin
                    ExcelBuf.AddColumn(
                      "G/L Account"."Balance at Date", false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,
                      false, false, '#,##0.00', ExcelBuf."cell type"::Number);
                end;

            "G/L Account"."Balance at Date" < 0:
                begin
                    ExcelBuf.AddColumn(
                      "G/L Account"."Balance at Date", false, '', "G/L Account"."Account Type" <> "G/L Account"."account type"::Posting,//'-'Manish 06-02-22
                      false, false, '#,##0.00', ExcelBuf."cell type"::Number);//Manish
                end;
        end;

    end;


    procedure CreateExcelbook()
    begin
        //ExcelBuf.CreateBookAndOpenExcel(Text001,Text002,Text001,COMPANYNAME,USERID);
        // ExcelBuf.CreateBookAndOpenExcel('',Text001,'',COMPANYNAME,UserId);
        ExcelBuf.CreateNewBook('Trial Balance');
        ExcelBuf.WriteSheet('Trial Balance', CompanyName, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.OpenExcel();
        Error('');
    end;
}

