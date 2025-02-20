pageextension 50162 FixedAssets extends "Fixed Asset List"
{
    layout
    {
        // Add changes to page layout here
        addafter("FA Location Code")
        {
            field(DepStartDate; DepStartDate)
            {
                Caption = 'Depreciation Starting Date';
                ApplicationArea = All;
                Editable = false;
            }
            field(DepEndDate; DepEndDate)
            {
                Caption = 'Depreciation Ending Date';
                ApplicationArea = All;
                Editable = false;
            }
            field("Shortcut Dimension 3"; Rec."Shortcut Dimension 3")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
            }
            field("Asset Tag no."; Rec."Asset Tag no.")
            {
                ApplicationArea = All;
            }
            field("Created DateTime"; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Caption = 'Created DateTime';
                Editable = false;
            }
            field("Created By"; CreatedBy)
            {
                ApplicationArea = All;
                Caption = 'Created By';
                Editable = false;
            }
            field("Modified DateTime"; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Caption = 'Modified DateTime';
                Editable = false;
            }
            field("Modified By"; ModifiedBy)
            {
                ApplicationArea = All;
                Caption = 'Modified By';
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here

    }
    trigger OnAfterGetRecord()
    var
        FADeprBook: Record "FA Depreciation Book";
        User: Record User;
    begin
        DepStartDate := 0D;
        DepEndDate := 0D;
        FADeprBook.Reset();
        FADeprBook.SetRange("FA No.", Rec."No.");
        FADeprBook.SetRange("Depreciation Book Code", 'COMPANY');
        if FADeprBook.find('-') then begin
            DepStartDate := FADeprBook."Depreciation Starting Date";
            DepEndDate := FADeprBook."Depreciation Ending Date";
        end;

        CreatedBy := '';
        User.Reset();
        User.SetRange("User Security ID", Rec.SystemCreatedBy);
        If User.FindFirst() then
            CreatedBy := User."User Name";

        ModifiedBy := '';
        User.Reset();
        User.SetRange("User Security ID", Rec.SystemModifiedBy);
        If User.FindFirst() then
            ModifiedBy := User."User Name";
    end;

    var
        myInt: Integer;
        DepStartDate: Date;
        DepEndDate: Date;
        CreatedBy: Text;
        ModifiedBy: Text;
}