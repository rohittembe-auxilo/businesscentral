pageextension 50151 TDSEntries extends "TDS Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Account Type")
        {
            field("Party Name"; "Party Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("TDS Section Description"; "TDS Section Description")
            {
                ApplicationArea = All;
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
        myInt: Integer;
    begin
        //CCIT Vikas 25082023
        "Party Name" := '';
        "TDS Section Description" := '';
        IF Rec."Party Type" = rec."Party Type"::Customer THEN BEGIN
            IF Customer.GET(rec."Party Code") THEN
                "Party Name" := Customer.Name;
        END ELSE
            IF rec."Party Type" = rec."Party Type"::Vendor THEN BEGIN
                IF Vendor.GET(rec."Party Code") THEN
                    "Party Name" := Vendor.Name;
            END ELSE
                IF rec."Party Type" = rec."Party Type"::Party THEN BEGIN
                    IF Party.GET(rec."Party Code") THEN
                        "Party Name" := Party.Name;
                END;
        //CCIT An 25082023
        if tdsSec.Get(rec.Section) then begin
            "TDS Section Description" := tdsSec.Description;
        end;


    end;

    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        "Party Name": Text[100];
        Party: Record Party;
        tdsSec: Record "TDS Section";
        "TDS Section Description": Text[100];
        TDSent: Record "TDS Entry";

}