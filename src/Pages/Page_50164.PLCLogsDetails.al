page 50164 "PLC Logs Details"
{
    ApplicationArea = All;
    Caption = 'PLC Logs Details';
    PageType = List;
    SourceTable = "PLC Logs Details";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("PLC Log No."; Rec."PLC Log No.")
                {
                    ToolTip = 'Specifies the value of the PLC Log No. field.';
                }
                field("Record No."; Rec."Record No.")
                {
                    ToolTip = 'Specifies the value of the Record No. field.';
                }
                field("Identifier 1"; Rec."Identifier 1")
                {
                    ToolTip = 'Specifies the value of the Identifier 1 field.';
                }
                field(Sucess; Rec.Sucess)
                {
                    ToolTip = 'Specifies the value of the Sucess field.';
                }
                field(Error; Rec.Error)
                {
                    ToolTip = 'Specifies the value of the Error field.';
                }
                field("Identifier 2"; Rec."Identifier 2")
                {
                    ToolTip = 'Specifies the value of the Identifier 2 field.';
                }
                field("Identifier 3"; Rec."Identifier 3")
                {
                    ToolTip = 'Specifies the value of the Identifier 3 field.';
                }
                field("Identifier 4"; Rec."Identifier 4")
                {
                    ToolTip = 'Specifies the value of the Identifier 4 field.';
                }
                field("Date & Time"; Rec."Date & Time")
                {
                    ToolTip = 'Specifies the value of the Date & Time field.';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Filename; Rec.Filename)
                {
                    ToolTip = 'Specifies the value of the Filename field.';
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
