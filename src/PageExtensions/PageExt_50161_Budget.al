pageextension 50161 BudgetExtension extends Budget
{
    layout
    {
        // Add changes to page layout here
        addafter(ShowColumnName)
        {
            field("No. of Archived Versions"; Versions)
            {

                ApplicationArea = all;
                Editable = false;
                trigger OnDrillDown()
                var

                    BudgetArchive: Record "G/L Budget Name Archive";
                begin
                    BudgetArchive.Reset();
                    BudgetArchive.SetRange(Name, BudgetName);
                    if BudgetArchive.FindSet then
                        Page.Run(0, BudgetArchive);


                end;
            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter("F&unctions")
        {
            action(Archive)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    GLBudgetName.Reset();
                    GLBudgetName.SetRange(Name, BudgetName);
                    if GLBudgetName.find('-') then begin
                        GLBudgetNameArchive.Reset();
                        GLBudgetNameArchive.setrange(Name, BudgetName);
                        if GLBudgetNameArchive.FindLast() then;

                        GLBudgetNameArchive1.Init();
                        GLBudgetNameArchive1.TransferFields(GLBudgetName);
                        GLBudgetNameArchive1."Version No." := GLBudgetNameArchive."version No." + 1;
                        GLBudgetNameArchive1.insert;

                        GLBudgetEntry.reset();
                        GLBudgetEntry.SetRange("Budget Name", BudgetName);
                        if GLBudgetEntry.Find('-') then
                            repeat
                                GLBudgetEntryArchive1.Reset();
                                if GLBudgetEntryArchive1.FindLast() then;


                                GLBudgetEntryArchive.Init();
                                GLBudgetEntryArchive.TransferFields(GLBudgetEntry);
                                GLBudgetEntryArchive."Entry No." := GLBudgetEntryArchive1."Entry No." + 1;
                                GLBudgetEntryArchive."Version No." := GLBudgetNameArchive."version No." + 1;
                                GLBudgetEntryArchive.Insert();
                            until GLBudgetEntry.next = 0;
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
        GLBudgetName: Record "G/L Budget Name";
        GLBudgetNameArchive: Record "G/L Budget Name Archive";

        GLBudgetNameArchive1: Record "G/L Budget Name Archive";
        GLBudgetNameArchive2: Record "G/L Budget Name Archive";
        GLBudgetEntry: Record "G/L Budget Entry";
        GLBudgetEntryArchive: Record "G/L Budget Entry Archive";
        GLBudgetEntryArchive1: Record "G/L Budget Entry Archive";
        SalesHeader: Record "sales Header";
        Versions: Integer;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        Versions := 0;
        GLBudgetNameArchive2.Reset();
        GLBudgetNameArchive2.SetRange(Name, BudgetName);
        if GLBudgetNameArchive2.FindSet() then
            Versions := GLBudgetNameArchive2.Count;

    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Versions := 0;
        GLBudgetNameArchive2.Reset();
        GLBudgetNameArchive2.SetRange(Name, BudgetName);
        if GLBudgetNameArchive2.FindSet() then
            Versions := GLBudgetNameArchive2.Count;

    end;

}