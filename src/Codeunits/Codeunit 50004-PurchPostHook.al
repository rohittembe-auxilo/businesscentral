codeunit 50004 "Purch.-Post Hook"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterCheckPurchDoc, '', false, false)]
    local procedure OnAfterCheckPurchDoc(var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean; PreviewMode: Boolean; var ErrorMessageMgt: Codeunit "Error Message Management")
    var
        BudgetAmountExceededCnf: Label 'Budgeted amount is less than the amount on line %1 for G/L Account %2, Budget Name %3. Do you want to continue?';
        PurchaseLine: Record "Purchase Line";
        GLBudgetEntry: Record "G/L Budget Entry";
        GLBudgetName: Record "G/L Budget Name";
        DimensionSetEntry: Record "Dimension Set Entry";
        NewPostingDate: Date;
        DimSetID: Integer;
        PurchInvHeader: Record "Purch. Inv. Header";
        continue: Boolean;
    begin
        NewPostingDate := CalcDate('CM+1d-1M', PurchHeader."Posting Date");

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::"G/L Account");
        if PurchaseLine.FindSet() then
            repeat
                GLBudgetName.Reset();
                if GLBudgetName.FindSet() then
                    repeat
                        GLBudgetEntry.Reset();
                        GLBudgetEntry.SetRange("Budget Name", GLBudgetName.Name);
                        GLBudgetEntry.SetRange("G/L Account No.", PurchaseLine."No.");
                        GLBudgetEntry.SetRange(Date, NewPostingDate);
                        //GLBudgetEntry.SetRange("Dimension Set ID", DimSetID);

                        if DimensionSetEntry.Get(PurchaseLine."Dimension Set ID", 'BRANCHES') then
                            GLBudgetEntry.SetRange("Global Dimension 1 Code", DimensionSetEntry."Dimension Value Code");

                        if DimensionSetEntry.Get(PurchaseLine."Dimension Set ID", 'BUSINESS SEGMENTS') then
                            GLBudgetEntry.SetRange("Global Dimension 2 Code", DimensionSetEntry."Dimension Value Code");

                        if DimensionSetEntry.Get(PurchaseLine."Dimension Set ID", GLBudgetName."Budget Dimension 1 Code") then
                            GLBudgetEntry.SetRange("Budget Dimension 1 Code", DimensionSetEntry."Dimension Value Code");

                        if DimensionSetEntry.Get(PurchaseLine."Dimension Set ID", GLBudgetName."Budget Dimension 2 Code") then
                            GLBudgetEntry.SetRange("Budget Dimension 2 Code", DimensionSetEntry."Dimension Value Code");

                        if DimensionSetEntry.Get(PurchaseLine."Dimension Set ID", GLBudgetName."Budget Dimension 3 Code") then
                            GLBudgetEntry.SetRange("Budget Dimension 3 Code", DimensionSetEntry."Dimension Value Code");

                        IF GLBudgetEntry.FindFirst() then begin
                            if GLBudgetEntry."Remaining Amount" < PurchaseLine.Amount then
                                if not Confirm(StrSubstNo(BudgetAmountExceededCnf, PurchaseLine."Line No.", PurchaseLine."No.", GLBudgetName.Name)) then
                                    Error('');
                        end;
                    until GLBudgetName.Next() = 0;
            until PurchaseLine.Next() = 0;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterCopyGenJnlLineFromPurchHeader, '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    var
        VendRec: record Vendor;
    begin
        //CCIT AN 20092023++
        IF VendRec.GET(PurchaseHeader."Pay-to Vendor No.") THEN
            GenJournalLine."Related party transaction" := VendRec."Related party transaction";

        //CCIT AN 13022023
        GenJournalLine."Bank Account Code" := PurchaseHeader."Bank Account Code";
        GenJournalLine."Bank Account No." := PurchaseHeader."Bank Account No.";
        GenJournalLine."Bank Account Name" := PurchaseHeader."Bank Account Name";
        GenJournalLine."Bank Account IFSC" := PurchaseHeader."Bank Account IFSC";
        GenJournalLine."Bank Account E-Mail" := PurchaseHeader."Bank Account Email";
        //CCIT AN 13022023
        GenJournalLine."PO Type" := PurchaseHeader."PO Type";
        GenJournalLine."PO Sub Type" := PurchaseHeader."PO Sub Type";
        GenJournalLine."MSME Type" := PurchaseHeader."MSME Type"; //Vikas
        GenJournalLine."Purch. Order No." := PurchaseHeader."Purch. Order No.";
        //CCIT AN 21092023--
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", OnPostBalancingEntryOnAfterInitNewLine, '', false, false)]
    local procedure "Purch. Post Invoice Events_OnPostBalancingEntryOnAfterInitNewLine"(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header")
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        //CCIT AN 13032023++
        IF GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment THEN BEGIN
            GenJnlLine."Document No." := NoSeriesMgt.GetNextNo('AUTOPAY', GenJnlLine."Posting Date", TRUE);
        END
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforePurchInvHeaderInsert, '', false, false)]
    local procedure OnBeforePurchInvHeaderInsert(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    var
        NoSeriesMgnt: Codeunit NoSeriesManagement;
        Loc: Record Location;
        RecPurchLine: Record "Purchase Line";
        GSTGroup: Record "GST Group";
    begin
        //CCIT Vikas 24-08-2020
        RecPurchLine.RESET();
        RecPurchLine.SETRANGE("Document No.", PurchHeader."No.");
        RecPurchLine.SETFILTER("No.", '<>%1', '');
        RecPurchLine.SETFILTER("GST Group Code", '<>%1', '');
        IF RecPurchLine.FIND('-') THEN BEGIN
            GSTGroup.RESET();
            GSTGroup.SETRANGE(Code, RecPurchLine."GST Group Code");
            GSTGroup.SETRANGE("Reverse Charge", TRUE);
            IF GSTGroup.FIND('-') THEN BEGIN
                IF Loc.GET(PurchInvHeader."Location Code") THEN BEGIN
                    PurchInvHeader."RCM Invoice No." := NoSeriesMgnt.GetNextNo(Loc."RCM Invoice No. Nos.", 0D, TRUE);
                    PurchInvHeader."RCM Payment No." := NoSeriesMgnt.GetNextNo(Loc."RCM payment No. Nos.", 0D, TRUE);
                END;

            END;
        END;
        //CCIt Vikas 24082020
    end;



    var
        Genjnlline1: Record "Gen. Journal Line";
        Genjnlline2: Record "Gen. Journal Line";
        NoSeries: Record "No. Series";
        NoseriesLine: Record "No. Series Line";
        temp: Codeunit "Purch.-Post";

}