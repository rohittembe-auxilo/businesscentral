pageextension 50158 GeneralJournalBatchesExt extends "General Journal Batches"
{
    layout
    {
        // Add changes to page layout here
        addafter("Location Code")
        {
            field("Comments Mandatory"; Rec."Comments Mandatory")
            {
                ApplicationArea = All;
            }
            field("Ext. Docuemnt No. Mandatory"; Rec."Ext. Docuemnt No. Mandatory")
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
}