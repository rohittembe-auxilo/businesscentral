codeunit 50001 "Gen. Jnl.-Post Batch Hook"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", OnBeforeCheckRecurringLine, '', false, false)]
    local procedure OnBeforeCheckRecurringLine(GenJnlLine2: Record "Gen. Journal Line"; GenJnlTemplate: Record "Gen. Journal Template"; var IsHandled: Boolean)
    var
        DummyDateFormula: DateFormula;
        Text021: Label 'cannot be specified when using recurring journals.';
    begin
        if GenJnlLine2."Account No." <> '' then
            if GenJnlTemplate.Recurring then begin
                GenJnlLine2.TestField("Recurring Method");
                GenJnlLine2.TestField("Recurring Frequency");
                if GenJnlLine2."Bal. Account No." <> '' then
                    GenJnlLine2.FieldError("Bal. Account No.", Text021);
                case GenJnlLine2."Recurring Method" of
                    GenJnlLine2."Recurring Method"::"V  Variable", GenJnlLine2."Recurring Method"::"RV Reversing Variable",
                  GenJnlLine2."Recurring Method"::"F  Fixed", GenJnlLine2."Recurring Method"::"RF Reversing Fixed":
                        if not GenJnlLine2."Allow Zero-Amount Posting" then
                            GenJnlLine2.TestField(Amount);
                    GenJnlLine2."Recurring Method"::"B  Balance", GenJnlLine2."Recurring Method"::"RB Reversing Balance":
                        GenJnlLine2.TestField(Amount, 0);
                end;
            end else begin
                //GenJnlLine2.TestField("Recurring Method", 0);
                //GenJnlLine2.TestField("Recurring Frequency", DummyDateFormula);
            end;
        IsHandled := true;
    end;

    var
        myInt: Integer;
        cu: Codeunit "Gen. Jnl.-Post Line";
}