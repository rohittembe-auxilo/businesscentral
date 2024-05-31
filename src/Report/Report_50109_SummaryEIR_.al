Report 50006 "Summary EIR"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SummaryEIR.rdl';

    dataset
    {
        dataitem("EIR Header"; "EIR Header")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                EIRLine.Reset();
                EIRLine.SetRange("Document No.", "EIR Header"."No.");
                if EIRLine.FindFirst then begin
                    ExcelBuf.NewRow;
                    ExcelBuf.AddColumn(EIRLine."Document No.", false, '', true, false, false, '', ExcelBuf."cell type"::Number);
                    ExcelBuf.AddColumn(EIRLine.Cost, false, '', true, false, false, '', ExcelBuf."cell type"::Number);
                    Cost := Cost + EIRLine.Cost;
                end;
                EIRLine.SetFilter("SCH Date", '<=%1', ScheduleDate);
                if EIRLine.FindLast then begin

                    ExcelBuf.AddColumn(EIRLine."Cumulative Amortization", false, '', true, false, false, '', ExcelBuf."cell type"::Number);
                    ExcelBuf.AddColumn(EIRLine.Unamortization, false, '', true, false, false, '', ExcelBuf."cell type"::Number);
                    Amort := Amort + EIRLine."Cumulative Amortization";
                    UnAmort := UnAmort + EIRLine.Unamortization;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if ScheduleDate = 0D then
                    Error('Scheduled date must not be blank');
                MakeExcelDataHeader;
                Amort := 0;
                UnAmort := 0;
                Cost := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Schedule date"; ScheduleDate)
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
        ExcelBuf.NewRow;

        ExcelBuf.AddColumn('Total', false, '', true, false, false, '', ExcelBuf."cell type"::Text);

        ExcelBuf.AddColumn(Cost, false, '', true, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(Amort, false, '', true, false, false, '', ExcelBuf."cell type"::Number);
        ExcelBuf.AddColumn(UnAmort, false, '', true, false, false, '', ExcelBuf."cell type"::Number);
        CreateExcelBook;
    end;

    trigger OnPreReport()
    begin
        ExcelBuf.DeleteAll;
    end;

    var
        ScheduleDate: Date;
        EIRLine: Record "EIR Line";
        ExcelBuf: Record "Excel Buffer";
        Amort: Decimal;
        UnAmort: Decimal;
        Cost: Decimal;

    local procedure CreateExcelBook()
    begin
        // ExcelBuf.CreateBookAndOpenExcel('D:\CCIT\EIR.xlsx','EIR','EIR',COMPANYNAME,UserId);
        ExcelBuf.CreateNewBook('EIR');
        ExcelBuf.WriteSheet('EIR', CompanyName, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.OpenExcel();
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('Balance as on specified date', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn(ScheduleDate, false, '', true, false, true, '', ExcelBuf."cell type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn('LAN', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Income', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Cum Amort ', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
        ExcelBuf.AddColumn('Unamort', false, '', true, false, true, '', ExcelBuf."cell type"::Text);
    end;
}

