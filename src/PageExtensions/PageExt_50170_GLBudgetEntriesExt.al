pageextension 50170 GLBudgetEntriesExt extends "G/L Budget Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter(Amount)
        {
            field("Remaining Amount"; Rec."Remaining Amount")
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