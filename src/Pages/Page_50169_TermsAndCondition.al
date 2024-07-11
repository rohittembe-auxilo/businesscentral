page 50169 "Term and Condition"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = 38;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {


                field("TnC1"; Rec."TnC1") { }
                field("TnC2"; Rec."TnC2") { }
                field("TnC3"; Rec."TnC3") { }
                field("TnC4"; Rec."TnC4") { }
                field("TnC5"; Rec."TnC5") { }
                field("TnC6"; Rec."TnC6") { }
                // field(){}
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}