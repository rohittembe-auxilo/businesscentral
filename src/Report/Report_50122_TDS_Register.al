report 50122 TDS_Register
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            RequestFilterFields = "Posting Date", "Document No.";
            trigger OnAfterGetRecord()
            begin
                GLAccount.Get(GLEntry."G/L Account No.");
                TDSEntry.Reset();
                TDSEntry.SetRange("Document No.", "Document No.");
                TDSEntry.SetRange("Posting Date", "Posting Date");
                //TDSEntry.SetRange(Section,GLAccount.);
                if TDSEntry.FindSet() then
                    repeat
                        SrNo := SrNo + 1;
                        Window.Update(1, SrNo);

                        TempExcelBuffer.NewRow();
                        TempExcelBuffer.AddColumn(Format(SrNo), false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(GLEntry."G/L Account No.", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("Document No.", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn("Document Type", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Format("Posting Date"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Format(GLEntry.Amount), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(Format(TDSEntry."TDS Amount"), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(TDSEntry.Section, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                        TempExcelBuffer.AddColumn(TDSEntry."Concessional Code", false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
                    until TDSEntry.Next() = 0;
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

        Window.Open(ProcessingMsg);
        Window.Update(2, GLEntry.Count);
    end;

    trigger OnPostReport()
    begin
        Window.Close();

        TempExcelBuffer.CreateNewBook('Test Export To Excel');
        TempExcelBuffer.WriteSheet('My Sheet', CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo('TestExcelFileName', CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TDSEntry: Record "TDS Entry";
        GLAccount: Record "G/L Account";
        SrNo: Integer;
        TDSAmount: Decimal;
        Window: Dialog;
        ProcessingMsg: Label 'Processing Records #1##### of #2######';
}