Page 50115 "Memorandum Entry"
{
    PageType = Worksheet;
    SourceTable = "Memorandom Entry";
    SourceTableView = where(Posted = const(false));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    ApplicationArea = Basic;
                }
                field("Gen. Bus Posting Group"; Rec."Gen. Bus Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Gen. Prod Posting Group"; Rec."Gen. Prod Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                ApplicationArea = Basic;

                trigger OnAction()
                var
                    MemorandomEntry: Record "Memorandom Entry";
                begin
                    if Confirm('Dou You want to Post') then begin
                        CurrPage.SetSelectionFilter(MemorandomEntry);
                        if MemorandomEntry.FindSet then
                            repeat
                                CheckAmountAndPost(MemorandomEntry);

                            // MemorandomEntry.Posted :=TRUE;
                            // MemorandomEntry.MODIFY;
                            until MemorandomEntry.Next = 0;
                    end;
                end;
            }
            action("Import Memorandum Entries")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    Xmlport.Run(50104, true, true);
                end;
            }
        }
    }

    var
        aaa: Decimal;

    local procedure CheckAmountAndPost(MemorandomEntry: Record "Memorandom Entry")
    var
        MemorandomEntries: Record "Memorandom Entry";
    begin
        MemorandomEntries.Reset();
        MemorandomEntries.SetCurrentkey("Document No.");
        MemorandomEntries.SetRange("Document No.", MemorandomEntry."Document No.");
        if MemorandomEntries.FindSet then begin
            MemorandomEntries.CalcSums(Amount);
            aaa := MemorandomEntries.Amount;
            if MemorandomEntries.Amount <> 0 then
                Error('Check Amount for document no %1', MemorandomEntries."Document No.");

            MemorandomEntries.Posted := true;
            MemorandomEntries.ModifyAll(Posted, true);
        end;
        // UNTIL MemorandomEntries.NEXT=0;

    end;
}

