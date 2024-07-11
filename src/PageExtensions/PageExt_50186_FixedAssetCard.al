pageextension 50186 FixedAssetCard extends "Fixed Asset Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("FA Location Code")
        {
            field("Asset Tag no."; Rec."Asset Tag no.")
            {
                ApplicationArea = All;
            }
            field("Created DateTime"; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Caption = 'Created DateTime';
            }
            field("Created By"; CreatedBy)
            {
                ApplicationArea = All;
                Caption = 'Created By';
            }
            field("Modified DateTime"; Rec.SystemModifiedAt)
            {
                ApplicationArea = All;
                Caption = 'Modified DateTime';
            }
            field("Modified By"; ModifiedBy)
            {
                ApplicationArea = All;
                Caption = 'Modified By';
            }
        }

        addafter(General)
        {
            group(DefaultDimensions)
            {
                Caption = 'Dimensions';
                field("Branches Code"; BranchesCode)
                {
                    ApplicationArea = All;
                    TableRelation = "Dimension Value".Code where("Dimension Code" = filter('BRANCHES 1'));
                    trigger OnValidate()
                    begin
                        if DefaultDimension.Get(Database::"Fixed Asset", Rec."No.", GeneralLedgerSetup."Shortcut Dimension 1 Code") then begin
                            DefaultDimension."Dimension Value Code" := BranchesCode;
                            DefaultDimension.Modify();
                        end else begin
                            DefaultDimension.Init();
                            DefaultDimension."Table ID" := Database::"Fixed Asset";
                            DefaultDimension."No." := Rec."No.";
                            DefaultDimension."Dimension Code" := GeneralLedgerSetup."Shortcut Dimension 1 Code";
                            DefaultDimension."Dimension Value Code" := BranchesCode;
                            DefaultDimension.Insert();
                        end;
                    end;
                }
                field("Business SegmentsCode"; BusinessSegmentsCode)
                {
                    ApplicationArea = All;
                    TableRelation = "Dimension Value".Code where("Dimension Code" = filter('BUSINESS SEGMENTS'));
                    trigger OnValidate()
                    begin
                        if DefaultDimension.Get(Database::"Fixed Asset", Rec."No.", GeneralLedgerSetup."Shortcut Dimension 2 Code") then begin
                            DefaultDimension."Dimension Value Code" := BusinessSegmentsCode;
                            DefaultDimension.Modify();
                        end else begin
                            DefaultDimension.Init();
                            DefaultDimension."Table ID" := Database::"Fixed Asset";
                            DefaultDimension."No." := Rec."No.";
                            DefaultDimension."Dimension Code" := GeneralLedgerSetup."Shortcut Dimension 2 Code";
                            DefaultDimension."Dimension Value Code" := BusinessSegmentsCode;
                            DefaultDimension.Insert();
                        end;
                    end;
                }
                field("Department Code"; DepartmentCode)
                {
                    ApplicationArea = All;
                    TableRelation = "Dimension Value".Code where("Dimension Code" = filter('DEPARTMENT'));
                    trigger OnValidate()
                    begin
                        if DefaultDimension.Get(Database::"Fixed Asset", Rec."No.", GeneralLedgerSetup."Shortcut Dimension 3 Code") then begin
                            DefaultDimension."Dimension Value Code" := DepartmentCode;
                            DefaultDimension.Modify();
                        end else begin
                            DefaultDimension.Init();
                            DefaultDimension."Table ID" := Database::"Fixed Asset";
                            DefaultDimension."No." := Rec."No.";
                            DefaultDimension."Dimension Code" := GeneralLedgerSetup."Shortcut Dimension 3 Code";
                            DefaultDimension."Dimension Value Code" := DepartmentCode;
                            DefaultDimension.Insert();
                        end;
                    end;
                }
                field("Product SegmentCode"; ProductSegmentCode)
                {
                    ApplicationArea = All;
                    TableRelation = "Dimension Value".Code where("Dimension Code" = filter('PRODUCT SEGMENT'));
                    trigger OnValidate()
                    begin
                        if DefaultDimension.Get(Database::"Fixed Asset", Rec."No.", GeneralLedgerSetup."Shortcut Dimension 4 Code") then begin
                            DefaultDimension."Dimension Value Code" := ProductSegmentCode;
                            DefaultDimension.Modify();
                        end else begin
                            DefaultDimension.Init();
                            DefaultDimension."Table ID" := Database::"Fixed Asset";
                            DefaultDimension."No." := Rec."No.";
                            DefaultDimension."Dimension Code" := GeneralLedgerSetup."Shortcut Dimension 4 Code";
                            DefaultDimension."Dimension Value Code" := ProductSegmentCode;
                            DefaultDimension.Insert();
                        end;
                    end;
                }
                field("Investment Code"; InvestmentCode)
                {
                    ApplicationArea = All;
                    TableRelation = "Dimension Value".Code where("Dimension Code" = filter('INVESTMENT'));
                    trigger OnValidate()
                    begin
                        if DefaultDimension.Get(Database::"Fixed Asset", Rec."No.", GeneralLedgerSetup."Shortcut Dimension 5 Code") then begin
                            DefaultDimension."Dimension Value Code" := InvestmentCode;
                            DefaultDimension.Modify();
                        end else begin
                            DefaultDimension.Init();
                            DefaultDimension."Table ID" := Database::"Fixed Asset";
                            DefaultDimension."No." := Rec."No.";
                            DefaultDimension."Dimension Code" := GeneralLedgerSetup."Shortcut Dimension 2 Code";
                            DefaultDimension."Dimension Value Code" := InvestmentCode;
                            DefaultDimension.Insert();
                        end;
                    end;
                }
                field("Sub Product Code"; SubProductCode)
                {
                    ApplicationArea = All;
                    TableRelation = "Dimension Value".Code where("Dimension Code" = filter('SUB PRODUCT'));
                    trigger OnValidate()
                    begin
                        if DefaultDimension.Get(Database::"Fixed Asset", Rec."No.", GeneralLedgerSetup."Shortcut Dimension 6 Code") then begin
                            DefaultDimension."Dimension Value Code" := SubProductCode;
                            DefaultDimension.Modify();
                        end else begin
                            DefaultDimension.Init();
                            DefaultDimension."Table ID" := Database::"Fixed Asset";
                            DefaultDimension."No." := Rec."No.";
                            DefaultDimension."Dimension Code" := GeneralLedgerSetup."Shortcut Dimension 6 Code";
                            DefaultDimension."Dimension Value Code" := SubProductCode;
                            DefaultDimension.Insert();
                        end;
                    end;
                }
                field("Lan Code"; LanCode)
                {
                    ApplicationArea = All;
                    TableRelation = "Dimension Value".Code where("Dimension Code" = filter('LAN'));
                    trigger OnValidate()
                    begin
                        if DefaultDimension.Get(Database::"Fixed Asset", Rec."No.", GeneralLedgerSetup."Shortcut Dimension 8 Code") then begin
                            DefaultDimension."Dimension Value Code" := LanCode;
                            DefaultDimension.Modify();
                        end else begin
                            DefaultDimension.Init();
                            DefaultDimension."Table ID" := Database::"Fixed Asset";
                            DefaultDimension."No." := Rec."No.";
                            DefaultDimension."Dimension Code" := GeneralLedgerSetup."Shortcut Dimension 8 Code";
                            DefaultDimension."Dimension Value Code" := LanCode;
                            DefaultDimension.Insert();
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        User: Record User;
    begin
        CreatedBy := '';
        User.Reset();
        User.SetRange("User Security ID", Rec.SystemCreatedBy);
        If User.FindFirst() then
            CreatedBy := User."User Name";

        ModifiedBy := '';
        User.Reset();
        User.SetRange("User Security ID", Rec.SystemModifiedBy);
        If User.FindFirst() then
            ModifiedBy := User."User Name";

        BranchesCode := '';
        if DefaultDimension.Get(Database::"Fixed Asset", Rec."No.", GeneralLedgerSetup."Shortcut Dimension 1 Code") then
            BranchesCode := DefaultDimension."Dimension Value Code";

        BusinessSegmentsCode := '';
        if DefaultDimension.Get(Database::"Fixed Asset", Rec."No.", GeneralLedgerSetup."Shortcut Dimension 2 Code") then
            BusinessSegmentsCode := DefaultDimension."Dimension Value Code";

        DepartmentCode := '';
        if DefaultDimension.Get(Database::"Fixed Asset", Rec."No.", GeneralLedgerSetup."Shortcut Dimension 3 Code") then
            DepartmentCode := DefaultDimension."Dimension Value Code";

        ProductSegmentCode := '';
        if DefaultDimension.Get(Database::"Fixed Asset", Rec."No.", GeneralLedgerSetup."Shortcut Dimension 4 Code") then
            ProductSegmentCode := DefaultDimension."Dimension Value Code";

        InvestmentCode := '';
        if DefaultDimension.Get(Database::"Fixed Asset", Rec."No.", GeneralLedgerSetup."Shortcut Dimension 5 Code") then
            InvestmentCode := DefaultDimension."Dimension Value Code";

        SubProductCode := '';
        if DefaultDimension.Get(Database::"Fixed Asset", Rec."No.", GeneralLedgerSetup."Shortcut Dimension 6 Code") then
            SubProductCode := DefaultDimension."Dimension Value Code";

        LanCode := '';
        if DefaultDimension.Get(Database::"Fixed Asset", Rec."No.", GeneralLedgerSetup."Shortcut Dimension 8 Code") then
            LanCode := DefaultDimension."Dimension Value Code";
    end;

    trigger OnOpenPage()
    begin
        GeneralLedgerSetup.Get();
    end;

    var
        CreatedBy: Text;
        ModifiedBy: Text;
        DefaultDimension: Record "Default Dimension";
        GeneralLedgerSetup: Record "General Ledger Setup";
        BranchesCode: Code[30];
        BusinessSegmentsCode: Code[30];
        DepartmentCode: Code[30];
        ProductSegmentCode: Code[30];
        InvestmentCode: Code[30];
        SubProductCode: Code[30];
        LanCode: Code[30];
}