pageextension 50117 GLEntriesPreview extends "G/L Entries Preview"
{
    layout
    {
        // Add changes to page layout here
        addafter("Gen. Prod. Posting Group")
        {
            field("GSTCredit 50%"; Rec."GSTCredit 50%")
            {
                ApplicationArea = All;
            }
            field("Purch. Order No."; Rec."Purch. Order No.")
            {
                ApplicationArea = All;
            }
            field("MSME Type"; Rec."MSME Type")
            {
                ApplicationArea = All;
            }
            field("Party Code"; Rec."Party Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    myInt: Integer;
                begin
                    IF RecParty.GET(Rec."Party Code") THEN
                        Rec."Party Name" := RecParty.Name
                    ELSE IF RecVendor.GET(Rec."Party Code") THEN
                        Rec."Party Name" := RecVendor.Name
                    ELSE IF RecCustomer.GET(Rec."Party Code") THEN
                        Rec."Party Name" := RecCustomer.Name;
                END;


            }
            field("Party Name"; Rec."Party Name")
            {
                ApplicationArea = All;
            }
            field("Related Party Transaction"; Rec."Related Party Transaction")
            {
                ApplicationArea = All;
            }
            field("PO Type"; Rec."PO Type")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;

        RecParty: Record Party;
        RecVendor: Record 23;
        RecCustomer: Record 18;
}