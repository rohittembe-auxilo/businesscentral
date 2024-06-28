report 50122 TDS_Register
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItemName; "G/L Entry")
        {
            trigger OnAfterGetRecord()
            begin
                SrNo := SrNo + 1;

                TDSAmount := 0;
                TDSEntry.Reset();
                TDSEntry.SetCurrentKey("Posting Date", "Document No.");
                TDSEntry.SetRange("Posting Date", "Posting Date");
                TDSEntry.SetRange("Document No.", "Document No.");
                if TDSEntry.FindSet() then
                    repeat
                        TDSAmount := TDSAmount + TDSEntry."TDS Amount"
                    until TDSEntry.Next() = 0;

                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(Format(SrNo), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("G/L Account No.", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("Document No.", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn("Document Type", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Format("Posting Date"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Format(Amount), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Format(TDSAmount), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn('TDS Section', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn('TDS Concession Code', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
            end;
        }
    }

    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Sr. No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('G/L Account No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document Type', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Posting Date', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Amount', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('TDS Amount', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('TDS Section', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('TDS Concession Code', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    trigger OnPostReport()
    begin
        TempExcelBuffer.CreateNewBook('Test Export To Excel');
        TempExcelBuffer.WriteSheet('My Sheet', CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo('TestExcelFileName', CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TDSEntry: Record "TDS Entry";
        SrNo: Integer;
        TDSAmount: Decimal;
}