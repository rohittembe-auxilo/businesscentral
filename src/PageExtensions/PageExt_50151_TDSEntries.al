pageextension 50151 TDSEntries extends "TDS Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Account Type")
        {
            /*  //Vikas Mig    field("Tds Section"; rec."Tds Section")
                  {
                      ApplicationArea = All;
                  }
                  field("Party Name"; "Party Name")
                  {
                      ApplicationArea = All;
                  }
                  field("Deductee P.A.N. No."; rec."Deductee P.A.N. No.")
                  {
                      ApplicationArea = All;
                  }
                  field("Concessional Form"; rec."Concessional Form")
                  {
                      ApplicationArea = All;
                  }
                  */
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


    end;

    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        "Party Name": Text[100];
        Party: Record Party;

}