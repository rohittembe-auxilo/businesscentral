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
            field("Asset Tag no."; Rec."Asset Tag no.")
            {
                ApplicationArea = All;
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

    end;

    var
        myInt: Integer;
        DepStartDate: Date;
        DepEndDate: Date;


}