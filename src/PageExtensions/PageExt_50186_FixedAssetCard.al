pageextension 50186 FixedAssetCard extends "Fixed Asset Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("FA Location Code")
        {
            field("Asset Tag no."; Rec."Asset Tag no.")
            {
                ApplicationArea = All;
            }
            field("Created DateTime"; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Caption = 'Created DateTime';
            }
            field("Created By"; CreatedBy)
            {
                ApplicationArea = All;
                Caption = 'Created By';
            }
            field("Modified DateTime"; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Caption = 'Modified DateTime';
            }
            field("Modified By"; ModifiedBy)
            {
                ApplicationArea = All;
                Caption = 'Modified By';
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        User: Record User;
    begin
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
        CreatedBy: Text;
        ModifiedBy: Text;
}