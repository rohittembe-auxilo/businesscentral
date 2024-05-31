pageextension 50148 ConcessionalCodes extends "Concessional Codes"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            /*//Vikas Mig      field("Lower Bound Amount"; Rec."Lower Bound Amount")
                  {
                      ApplicationArea = All;
                  }
                  field("Start Date"; Rec."Start Date")
                  {
                      ApplicationArea = All;
                  }
                  field("End Date"; Rec."End Date")
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

    var
        myInt: Integer;
}