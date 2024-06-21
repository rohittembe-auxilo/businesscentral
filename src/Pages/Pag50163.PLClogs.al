page 50163 "PLC logs"
{
    ApplicationArea = All;
    Caption = 'PLC logs';
    PageType = List;
    SourceTable = "PLC Logs";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {

            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    trigger OnDrillDown()
                    var
                        PLCLogsDetails: Record "PLC Logs Details";
                    begin
                        PLCLogsDetails.Reset();
                        PLCLogsDetails.SetRange("PLC Log No.", Rec."Entry No.");
                        if PLCLogsDetails.FindFirst() then begin
                            Page.RunModal(Page::"PLC Logs Details", PLCLogsDetails)
                        end;
                    end;
                }
                field("Interface Type"; Rec."Interface Type")
                {
                    ToolTip = 'Specifies the value of the Interface Type field.';
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the File Name field.';
                }
                field("Start Date Time"; Rec."Start Date Time")
                {
                    ToolTip = 'Specifies the value of the Start Date Time field.';
                }
                field("End Date Time"; Rec."End Date Time")
                {
                    ToolTip = 'Specifies the value of the End Date Time field.';
                }
                field("Total Records"; Rec."Total Records")
                {
                    ToolTip = 'Specifies the value of the Total Records field.';
                }
                field(Success; Rec.Success)
                {
                    ToolTip = 'Specifies the value of the Success field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("File Error"; Rec."File Error")
                {
                    ToolTip = 'Specifies the value of the File Error field.';
                }
                field("Header Exported"; Rec."Header Exported")
                {
                    ToolTip = 'Specifies the value of the Header Exported field.';
                }
                field("Line Exported"; Rec."Line Exported")
                {
                    ToolTip = 'Specifies the value of the Line Exported field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
            }
        }

    }
}
