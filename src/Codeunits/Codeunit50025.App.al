codeunit 50025 Subscribers
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeUpdateAllLineDim', '', false, false)]
    local procedure UpdateDimensions()
    begin

    end;

    var
        myInt: Integer;
}