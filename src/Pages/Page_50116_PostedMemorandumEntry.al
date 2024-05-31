Page 50116 "Posted Memorandum Entry"
{
    Editable = false;
    PageType = Worksheet;
    SourceTable = "Memorandom Entry";
    SourceTableView = where(Posted = const(true));
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

                    trigger OnValidate()
                    begin
                        if Rec.Amount < 0 then
                            Rec."Credit Amount" := Abs(Rec.Amount)
                        else if Rec.Amount > 0 then
                            Rec."Debit Amount" := (Rec.Amount);
                    end;
                }
                field("Debit Amount"; Rec."Debit Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create General Journal Entries")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(MemorandomEntry);
                    if MemorandomEntry.Find('-') then
                        repeat
                            MemorandomEntry1.Reset();
                            MemorandomEntry1.SetRange("Document No.", MemorandomEntry."Document No.");
                            MemorandomEntry1.SetRange("General Journal Created", false);
                            if MemorandomEntry1.Find('-') then
                                repeat
                                    GenJournalLine1.Reset;
                                    GenJournalLine1.SetRange("Journal Batch Name", 'MEMORANDUM');
                                    GenJournalLine1.SetRange("Journal Template Name", 'GENERAL');
                                    if GenJournalLine1.FindLast then;



                                    GenJournalLine.Init;
                                    GenJournalLine."Journal Batch Name" := 'MEMORANDUM';
                                    GenJournalLine."Journal Template Name" := 'GENERAL';
                                    GenJournalLine."Document No." := MemorandomEntry1."Document No.";
                                    GenJournalLine."Line No." := GenJournalLine1."Line No." + 10000;
                                    GenJournalLine.Validate("Posting Date", MemorandomEntry1."Posting Date");
                                    GenJournalLine."Account Type" := GenJournalLine."account type"::"G/L Account";
                                    GenJournalLine.Validate("Account No.", MemorandomEntry1."G/L Account No.");
                                    GenJournalLine.Validate(Amount, MemorandomEntry1.Amount);
                                    GenJournalLine.Insert(true);

                                    MemorandomEntry1."General Journal Created" := true;
                                    MemorandomEntry1.Modify;

                                until MemorandomEntry1.Next = 0;
                        until MemorandomEntry.Next = 0;
                    Message('Journal Entries Created..');
                end;
            }
            action(Delete)
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin

                    MemoEntry := Rec;
                    CurrPage.SetSelectionFilter(MemoEntry);
                    MemoEntry.Next;
                    if MemoEntry.FindSet then
                        repeat
                            MemoEntry.Delete;
                        until MemoEntry.Next = 0;
                    Message('Selected data deleted successfully');
                end;
            }
        }
    }

    var
        MemorandomEntry: Record "Memorandom Entry";
        MemorandomEntry1: Record "Memorandom Entry";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine1: Record "Gen. Journal Line";
        MemoEntry: Record "Memorandom Entry";
}

