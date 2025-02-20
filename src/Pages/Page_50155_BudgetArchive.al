page 50155 "Budget Archive"
{
    Caption = 'Budget Archive';
    DataCaptionExpression = BudgetName;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    PageType = ListPlus;
    PromotedActionCategories = 'New,Process,Report,Period,Column,Budget';
    SaveValues = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(BudgetName; BudgetName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Budget Name';
                    TableRelation = "G/L Budget Name Archive";
                    ToolTip = 'Specifies the name of the budget.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLBudgetNames: Page "G/L Budget Names Archive";
                    begin
                        GLBudgetNames.LookupMode := true;
                        GLBudgetNames.SetRecord(GLBudgetName);
                        if GLBudgetNames.RunModal = ACTION::LookupOK then begin
                            GLBudgetNames.GetRecord(GLBudgetName);
                            BudgetName := GLBudgetName.Name;
                            Text := GLBudgetName.Name;
                            ValidateBudgetName;
                            ValidateLineDimCode;
                            ValidateColumnDimCode;
                            UpdateMatrixSubform();
                            exit(true);
                        end;
                        ValidateBudgetName;
                        ValidateLineDimCode;
                        ValidateColumnDimCode;
                        CurrPage.Update();
                        exit(false);
                    end;

                    trigger OnValidate()
                    begin
                        ValidateBudgetName;
                        ValidateLineDimCode;
                        ValidateColumnDimCode;

                        UpdateMatrixSubform();
                    end;
                }
                field(LineDimCode; LineDimCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Show as Lines';
                    ToolTip = 'Specifies which values you want to show as lines in the window. This allows you to see the same matrix window from various perspectives, especially when you use both the Show as Lines field and the Show as Columns field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        NewCode: Text[30];
                    begin
                        NewCode := GetDimSelection(LineDimCode);
                        if NewCode = LineDimCode then
                            exit(false);

                        Text := NewCode;
                        LineDimCode := NewCode;
                        ValidateLineDimCode;
                        LineDimCodeOnAfterValidate();
                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        if (UpperCase(LineDimCode) = UpperCase(ColumnDimCode)) and (LineDimCode <> '') then begin
                            ColumnDimCode := '';
                            ValidateColumnDimCode;
                        end;
                        ValidateLineDimCode;
                        GenerateColumnCaptions("Matrix Page Step Type"::Initial);
                        LineDimCodeOnAfterValidate();
                    end;
                }
                field(ColumnDimCode; ColumnDimCode)
                {
                    ApplicationArea = Suite;
                    Caption = 'Show as Columns';
                    ToolTip = 'Specifies which values you want to show as columns in the window. This allows you to see the same matrix window from various perspectives, especially when you use both the Show as Lines field and the Show as Columns field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        NewCode: Text[30];
                        "Matrix Page Step Type": Enum "Matrix Page Step Type";
                    begin
                        NewCode := GetDimSelection(ColumnDimCode);
                        if NewCode = ColumnDimCode then
                            exit(false);

                        Text := NewCode;
                        ColumnDimCode := NewCode;
                        ValidateColumnDimCode;
                        GenerateColumnCaptions("Matrix Page Step Type"::Initial);
                        ColumnDimCodeOnAfterValidate();
                        exit(true);
                    end;

                    trigger OnValidate()
                    var
                        "Matrix Page Step Type": Enum "Matrix Page Step Type";
                    begin
                        if (UpperCase(LineDimCode) = UpperCase(ColumnDimCode)) and (LineDimCode <> '') then begin
                            LineDimCode := '';
                            ValidateLineDimCode;
                        end;
                        ValidateColumnDimCode;
                        GenerateColumnCaptions("Matrix Page Step Type"::Initial);
                        ColumnDimCodeOnAfterValidate();
                    end;
                }
                field(PeriodType; PeriodType)
                {
                    ApplicationArea = Suite;
                    Caption = 'View by';
                    Enabled = PeriodTypeEnable;
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        FindPeriod('');
                        PeriodTypeOnAfterValidate();
                    end;
                }
                field(RoundingFactor; RoundingFactor)
                {
                    ApplicationArea = Suite;
                    Caption = 'Rounding Factor';
                    ToolTip = 'Specifies the factor that is used to round the amounts.';

                    trigger OnValidate()
                    begin
                        UpdateMatrixSubform();
                    end;
                }
                field(ShowColumnName; ShowColumnName)
                {
                    ApplicationArea = Suite;
                    Caption = 'Show Column Name';
                    ToolTip = 'Specifies that the names of columns are shown in the matrix window.';

                    trigger OnValidate()
                    begin
                        ShowColumnNameOnPush;
                    end;
                }
                field("Version No."; "VersionNo.")
                {
                    ApplicationArea = All;

                }

            }
            part(MatrixForm; "Budget Matrix Archive")
            {
                ApplicationArea = Suite;
            }
            group(Filters)
            {
                Caption = 'Filters';
                field(DateFilter; DateFilter)
                {
                    ApplicationArea = Suite;
                    Caption = 'Date Filter';
                    ToolTip = 'Specifies the dates that will be used to filter the amounts in the window.';

                    trigger OnValidate()
                    begin
                        ValidateDateFilter(DateFilter);
                    end;
                }
                field(GLAccFilter; GLAccFilter)
                {
                    ApplicationArea = Suite;
                    Caption = 'G/L Account Filter';
                    ToolTip = 'Specifies the G/L accounts for which you will see information in the window.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLAccList: Page "G/L Account List";
                    begin
                        GLAccList.LookupMode(true);
                        if not (GLAccList.RunModal = ACTION::LookupOK) then
                            exit(false);

                        Text := GLAccList.GetSelectionFilter;
                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        GLAccFilterOnAfterValidate();
                    end;
                }
                field(GLAccCategory; GLAccCategoryFilter)
                {
                    ApplicationArea = Suite;
                    Caption = 'G/L Account Category Filter';
                    ToolTip = 'Specifies the category of the G/L account for which you will see information in the window.';

                    trigger OnValidate()
                    begin
                        ValidateGLAccCategoryFilter;
                    end;
                }
                field(IncomeBalGLAccFilter; IncomeBalanceGLAccFilter)
                {
                    ApplicationArea = Suite;
                    Caption = 'Income/Balance G/L Account Filter';
                    ToolTip = 'Specifies the type of the G/L account for which you will see information in the window.';

                    trigger OnValidate()
                    begin
                        ValidateIncomeBalanceGLAccFilter;
                    end;
                }
                field(GlobalDim1Filter; GlobalDim1Filter)
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,3,1';
                    Caption = 'Global Dimension 1 Filter';
                    Enabled = GlobalDim1FilterEnable;
                    ToolTip = 'Specifies by which global dimension data is shown. Global dimensions are the dimensions that you analyze most frequently. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimensionValue: Record "Dimension Value";
                    begin
                        exit(DimensionValue.LookUpDimFilter(GLSetup."Global Dimension 1 Code", Text));
                    end;

                    trigger OnValidate()
                    begin
                        GlobalDim1FilterOnAfterValidate();
                    end;
                }
                field(GlobalDim2Filter; GlobalDim2Filter)
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,3,2';
                    Caption = 'Global Dimension 2 Filter';
                    Enabled = GlobalDim2FilterEnable;
                    ToolTip = 'Specifies by which global dimension data is shown. Global dimensions are the dimensions that you analyze most frequently. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimensionValue: Record "Dimension Value";
                    begin
                        exit(DimensionValue.LookUpDimFilter(GLSetup."Global Dimension 2 Code", Text));
                    end;

                    trigger OnValidate()
                    begin
                        GlobalDim2FilterOnAfterValidate();
                    end;
                }
                field(BudgetDim1Filter; BudgetDim1Filter)
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = GetCaptionClass(1);
                    Caption = 'Budget Dimension 1 Filter';
                    Enabled = BudgetDim1FilterEnable;
                    ToolTip = 'Specifies a filter by a budget dimension. You can specify four additional dimensions on each budget that you create.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimensionValue: Record "Dimension Value";
                    begin
                        exit(DimensionValue.LookUpDimFilter(GLBudgetName."Budget Dimension 1 Code", Text));
                    end;

                    trigger OnValidate()
                    begin
                        BudgetDim1FilterOnAfterValidate();
                    end;
                }
                field(BudgetDim2Filter; BudgetDim2Filter)
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = GetCaptionClass(2);
                    Caption = 'Budget Dimension 2 Filter';
                    Enabled = BudgetDim2FilterEnable;
                    ToolTip = 'Specifies a filter by a budget dimension. You can specify four additional dimensions on each budget that you create.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimensionValue: Record "Dimension Value";
                    begin
                        exit(DimensionValue.LookUpDimFilter(GLBudgetName."Budget Dimension 2 Code", Text));
                    end;

                    trigger OnValidate()
                    begin
                        BudgetDim2FilterOnAfterValidate();
                    end;
                }
                field(BudgetDim3Filter; BudgetDim3Filter)
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = GetCaptionClass(3);
                    Caption = 'Budget Dimension 3 Filter';
                    Enabled = BudgetDim3FilterEnable;
                    ToolTip = 'Specifies a filter by a budget dimension. You can specify four additional dimensions on each budget that you create.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimensionValue: Record "Dimension Value";
                    begin
                        exit(DimensionValue.LookUpDimFilter(GLBudgetName."Budget Dimension 3 Code", Text));
                    end;

                    trigger OnValidate()
                    begin
                        BudgetDim3FilterOnAfterValidate();
                    end;
                }
                field(BudgetDim4Filter; BudgetDim4Filter)
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = GetCaptionClass(4);
                    Caption = 'Budget Dimension 4 Filter';
                    Enabled = BudgetDim4FilterEnable;
                    ToolTip = 'Specifies a filter by a budget dimension. You can specify four additional dimensions on each budget that you create.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimensionValue: Record "Dimension Value";
                    begin
                        exit(DimensionValue.LookUpDimFilter(GLBudgetName."Budget Dimension 4 Code", Text));
                    end;

                    trigger OnValidate()
                    begin
                        BudgetDim4FilterOnAfterValidate();
                    end;
                }
            }
        }
    }
    trigger OnInit()
    begin
        BudgetDim4FilterEnable := true;
        BudgetDim3FilterEnable := true;
        BudgetDim2FilterEnable := true;
        BudgetDim1FilterEnable := true;
        PeriodTypeEnable := true;
        GlobalDim2FilterEnable := true;
        GlobalDim1FilterEnable := true;
    end;

    trigger OnOpenPage()
    var
        GLAcc: Record "G/L Account";
        "Matrix Page Step Type": Enum "Matrix Page Step Type";
        BM: Page "Budget Matrix";
    begin
        if GLAccBudgetBuf.GetFilter("Global Dimension 1 Filter") <> '' then
            GlobalDim1Filter := GLAccBudgetBuf.GetFilter("Global Dimension 1 Filter");
        if GLAccBudgetBuf.GetFilter("Global Dimension 2 Filter") <> '' then
            GlobalDim2Filter := GLAccBudgetBuf.GetFilter("Global Dimension 2 Filter");

        GLSetup.Get();

        GlobalDim1FilterEnable :=
          (GLSetup."Global Dimension 1 Code" <> '') and
          (GLAccBudgetBuf.GetFilter("Global Dimension 1 Filter") = '');
        GlobalDim2FilterEnable :=
          (GLSetup."Global Dimension 2 Code" <> '') and
          (GLAccBudgetBuf.GetFilter("Global Dimension 2 Filter") = '');

        if GLAccBudgetBuf.GetFilter("G/L Account Filter") <> '' then
            GLAccFilter := GLAccBudgetBuf.GetFilter("G/L Account Filter");

        ValidateBudgetName;

        if LineDimCode = '' then
            LineDimCode := GLAcc.TableCaption;
        if ColumnDimCode = '' then
            ColumnDimCode := Text001;

        LineDimType := DimCodeToType(LineDimCode);
        ColumnDimType := DimCodeToType(ColumnDimCode);
        "VersionNo." := "NewVersionNo.";

        if (NewBudgetName <> '') and (NewBudgetName <> BudgetName) then begin
            BudgetName := NewBudgetName;
            "VersionNo." := "NewVersionNo.";
            ValidateBudgetName;
            ValidateLineDimCode;
            ValidateColumnDimCode;
        end;

        PeriodType := PeriodType::Month;
        IncomeBalanceGLAccFilter := IncomeBalanceGLAccFilter::"Income Statement";
        if DateFilter = '' then
            ValidateDateFilter(Format(CalcDate('<-CY>', Today)) + '..' + Format(CalcDate('<CY>', Today)));

        FindPeriod('');
        GenerateColumnCaptions("Matrix Page Step Type"::Initial);

        UpdateMatrixSubform();
    end;

    var
        GLSetup: Record "General Ledger Setup";
        GLBudgetName: Record "G/L Budget Name Archive";
        PrevGLBudgetName: Record "G/L Budget Name Archive";
        MATRIX_MatrixRecords: array[32] of Record "Dimension Code Buffer";
        // MATRIX_MatrixRecords1: array[32] of Record "Dimension Code Buffer Archive";
        MATRIX_CaptionSet: array[32] of Text[80];
        MATRIX_CaptionRange: Text;
        FirstColumn: Text;
        LastColumn: Text;
        MATRIX_PrimKeyFirstCaptionInCu: Text;
        MATRIX_CurrentNoOfColumns: Integer;
        Text001: Label 'Period';
        Text003: Label 'Do you want to delete the budget entries shown?';
        Text004: Label 'DEFAULT';
        Text005: Label 'Default budget';
        Text006: Label '%1 is not a valid line definition.';
        Text007: Label '%1 is not a valid column definition.';
        Text008: Label '1,6,,Budget Dimension 1 Filter';
        Text009: Label '1,6,,Budget Dimension 2 Filter';
        Text010: Label '1,6,,Budget Dimension 3 Filter';
        Text011: Label '1,6,,Budget Dimension 4 Filter';
        InternalDateFilter: Text[30];
        BusUnitFilter: Text;
        [InDataSet]
        GlobalDim1FilterEnable: Boolean;
        [InDataSet]
        GlobalDim2FilterEnable: Boolean;
        [InDataSet]
        PeriodTypeEnable: Boolean;
        [InDataSet]
        BudgetDim1FilterEnable: Boolean;
        [InDataSet]
        BudgetDim2FilterEnable: Boolean;
        [InDataSet]
        BudgetDim3FilterEnable: Boolean;
        [InDataSet]
        BudgetDim4FilterEnable: Boolean;
        "VersionNo.": Integer;

    protected var
        GLAccBudgetBuf: Record "G/L Acc. Budget Buffer Archive";
        BudgetName: Code[10];
        NewBudgetName: Code[10];

        "NewVersionNo.": Integer;
        LineDimType: Enum "G/L Budget Matrix Dimensions";
        ColumnDimType: Enum "G/L Budget Matrix Dimensions";
        LineDimCode: Text[30];
        ColumnDimCode: Text[30];
        PeriodType: Enum "Analysis Period Type";
        RoundingFactor: Enum "Analysis Rounding Factor";
        GLAccCategoryFilter: Enum "G/L Account Category";
        IncomeBalanceGLAccFilter: Enum "G/L Account Income/Balance";
        ShowColumnName: Boolean;
        DateFilter: Text[30];
        GLAccFilter: Text;
        GlobalDim1Filter: Text;
        GlobalDim2Filter: Text;
        BudgetDim1Filter: Text;
        BudgetDim2Filter: Text;
        BudgetDim3Filter: Text;
        BudgetDim4Filter: Text;

    protected procedure GenerateColumnCaptions(StepType: Enum "Matrix Page Step Type")
    var
        MATRIX_PeriodRecords: array[32] of Record Date;
        BusUnit: Record "Business Unit";
        GLAccount: Record "G/L Account";
        MatrixMgt: Codeunit "Matrix Management";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        IncomeBalFieldRef: FieldRef;
        GLAccCategoryFieldRef: FieldRef;
        i: Integer;
    begin
        Clear(MATRIX_CaptionSet);
        Clear(MATRIX_MatrixRecords);
        FirstColumn := '';
        LastColumn := '';
        MATRIX_CurrentNoOfColumns := 12;

        if ColumnDimCode = '' then
            exit;

        case ColumnDimCode of
            Text001:  // Period
                begin
                    MatrixMgt.GeneratePeriodMatrixData(
                      StepType.AsInteger(), MATRIX_CurrentNoOfColumns, ShowColumnName,
                      PeriodType, DateFilter, MATRIX_PrimKeyFirstCaptionInCu,
                      MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrentNoOfColumns, MATRIX_PeriodRecords);
                    for i := 1 to MATRIX_CurrentNoOfColumns do begin
                        MATRIX_MatrixRecords[i]."Period Start" := MATRIX_PeriodRecords[i]."Period Start";
                        MATRIX_MatrixRecords[i]."Period End" := MATRIX_PeriodRecords[i]."Period End";
                    end;
                    FirstColumn := Format(MATRIX_PeriodRecords[1]."Period Start");
                    LastColumn := Format(MATRIX_PeriodRecords[MATRIX_CurrentNoOfColumns]."Period End");
                    PeriodTypeEnable := true;
                end;
            GLAccount.TableCaption:
                begin
                    Clear(MATRIX_CaptionSet);
                    RecRef.GetTable(GLAccount);
                    RecRef.SetTable(GLAccount);
                    if GLAccFilter <> '' then begin
                        FieldRef := RecRef.Field(GLAccount.FieldNo("No."));
                        FieldRef.SetFilter(GLAccFilter);
                    end;
                    if IncomeBalanceGLAccFilter <> IncomeBalanceGLAccFilter::" " then begin
                        IncomeBalFieldRef := RecRef.FieldIndex(GLAccount.FieldNo("Income/Balance"));
                        case IncomeBalanceGLAccFilter of
                            IncomeBalanceGLAccFilter::"Balance Sheet":
                                IncomeBalFieldRef.SetRange(GLAccount."Income/Balance"::"Balance Sheet");
                            IncomeBalanceGLAccFilter::"Income Statement":
                                IncomeBalFieldRef.SetRange(GLAccount."Income/Balance"::"Income Statement");
                        end;
                    end;
                    if GLAccCategoryFilter <> GLAccCategoryFilter::" " then begin
                        GLAccCategoryFieldRef := RecRef.FieldIndex(GLAccount.FieldNo("Account Category"));
                        GLAccCategoryFieldRef.SetRange(GLAccCategoryFilter);
                    end;
                    MatrixMgt.GenerateMatrixData(
                      RecRef, StepType.AsInteger(), 12, 1,
                      MATRIX_PrimKeyFirstCaptionInCu, MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrentNoOfColumns);
                    for i := 1 to MATRIX_CurrentNoOfColumns do
                        MATRIX_MatrixRecords[i].Code := CopyStr(MATRIX_CaptionSet[i], 1, MaxStrLen(MATRIX_MatrixRecords[i].Code));
                    if ShowColumnName then
                        MatrixMgt.GenerateMatrixData(
                          RecRef, "Matrix Page Step Type"::Same.AsInteger(), 12, GLAccount.FieldNo(Name),
                          MATRIX_PrimKeyFirstCaptionInCu, MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrentNoOfColumns);
                end;
            BusUnit.TableCaption:
                begin
                    Clear(MATRIX_CaptionSet);
                    RecRef.GetTable(BusUnit);
                    RecRef.SetTable(BusUnit);
                    if BusUnitFilter <> '' then begin
                        FieldRef := RecRef.FieldIndex(1);
                        FieldRef.SetFilter(BusUnitFilter);
                    end;
                    MatrixMgt.GenerateMatrixData(
                      RecRef, StepType.AsInteger(), 12, 1,
                      MATRIX_PrimKeyFirstCaptionInCu, MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrentNoOfColumns);
                    for i := 1 to MATRIX_CurrentNoOfColumns do
                        MATRIX_MatrixRecords[i].Code := CopyStr(MATRIX_CaptionSet[i], 1, MaxStrLen(MATRIX_MatrixRecords[i].Code));
                    if ShowColumnName then
                        MatrixMgt.GenerateMatrixData(
                          RecRef, "Matrix Page Step Type"::Same.AsInteger(), 12, BusUnit.FieldNo(Name),
                          MATRIX_PrimKeyFirstCaptionInCu, MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrentNoOfColumns);
                end;
            // Apply dimension filter
            GLSetup."Global Dimension 1 Code":
                MatrixMgt.GenerateDimColumnCaption(
                  GLSetup."Global Dimension 1 Code",
                  GlobalDim1Filter, StepType.AsInteger(), MATRIX_PrimKeyFirstCaptionInCu, FirstColumn, LastColumn,
                  MATRIX_CaptionSet, MATRIX_MatrixRecords, MATRIX_CurrentNoOfColumns, ShowColumnName, MATRIX_CaptionRange);
            GLSetup."Global Dimension 2 Code":
                MatrixMgt.GenerateDimColumnCaption(
                  GLSetup."Global Dimension 2 Code",
                  GlobalDim2Filter, StepType.AsInteger(), MATRIX_PrimKeyFirstCaptionInCu, FirstColumn, LastColumn,
                  MATRIX_CaptionSet, MATRIX_MatrixRecords, MATRIX_CurrentNoOfColumns, ShowColumnName, MATRIX_CaptionRange);
            GLBudgetName."Budget Dimension 1 Code":
                MatrixMgt.GenerateDimColumnCaption(
                  GLBudgetName."Budget Dimension 1 Code",
                  BudgetDim1Filter, StepType.AsInteger(), MATRIX_PrimKeyFirstCaptionInCu, FirstColumn, LastColumn,
                  MATRIX_CaptionSet, MATRIX_MatrixRecords, MATRIX_CurrentNoOfColumns, ShowColumnName, MATRIX_CaptionRange);
            GLBudgetName."Budget Dimension 2 Code":
                MatrixMgt.GenerateDimColumnCaption(
                  GLBudgetName."Budget Dimension 2 Code",
                  BudgetDim2Filter, StepType.AsInteger(), MATRIX_PrimKeyFirstCaptionInCu, FirstColumn, LastColumn,
                  MATRIX_CaptionSet, MATRIX_MatrixRecords, MATRIX_CurrentNoOfColumns, ShowColumnName, MATRIX_CaptionRange);
            GLBudgetName."Budget Dimension 3 Code":
                MatrixMgt.GenerateDimColumnCaption(
                  GLBudgetName."Budget Dimension 3 Code",
                  BudgetDim3Filter, StepType.AsInteger(), MATRIX_PrimKeyFirstCaptionInCu, FirstColumn, LastColumn,
                  MATRIX_CaptionSet, MATRIX_MatrixRecords, MATRIX_CurrentNoOfColumns, ShowColumnName, MATRIX_CaptionRange);
            GLBudgetName."Budget Dimension 4 Code":
                MatrixMgt.GenerateDimColumnCaption(
                  GLBudgetName."Budget Dimension 4 Code",
                  BudgetDim4Filter, StepType.AsInteger(), MATRIX_PrimKeyFirstCaptionInCu, FirstColumn, LastColumn,
                  MATRIX_CaptionSet, MATRIX_MatrixRecords, MATRIX_CurrentNoOfColumns, ShowColumnName, MATRIX_CaptionRange);
        end;
        OnAfterGenerateColumnCaptions(ColumnDimCode, StepType, MATRIX_PrimKeyFirstCaptionInCu, MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrentNoOfColumns, MATRIX_MatrixRecords, ShowColumnName);
    end;

    local procedure DimCodeToType(DimCode: Text[30]) Result: Enum "G/L Budget Matrix Dimensions"
    var
        BusUnit: Record "Business Unit";
        GLAcc: Record "G/L Account";
    begin
        case DimCode of
            '':
                Result := "G/L Budget Matrix Dimensions"::Undefined;
            GLAcc.TableCaption():
                Result := "G/L Budget Matrix Dimensions"::"G/L Account";
            Text001:
                Result := "G/L Budget Matrix Dimensions"::Period;
            BusUnit.TableCaption():
                Result := "G/L Budget Matrix Dimensions"::"Business Unit";
            GLSetup."Global Dimension 1 Code":
                Result := "G/L Budget Matrix Dimensions"::"Global Dimension 1";
            GLSetup."Global Dimension 2 Code":
                Result := "G/L Budget Matrix Dimensions"::"Global Dimension 2";
            GLBudgetName."Budget Dimension 1 Code":
                Result := "G/L Budget Matrix Dimensions"::"Budget Dimension 1";
            GLBudgetName."Budget Dimension 2 Code":
                Result := "G/L Budget Matrix Dimensions"::"Budget Dimension 2";
            GLBudgetName."Budget Dimension 3 Code":
                Result := "G/L Budget Matrix Dimensions"::"Budget Dimension 3";
            GLBudgetName."Budget Dimension 4 Code":
                Result := "G/L Budget Matrix Dimensions"::"Budget Dimension 4";
            else
                Result := "G/L Budget Matrix Dimensions"::Undefined;
        end;
        OnAfterDimCodeToType(DimCode, Result);
    end;

    local procedure FindPeriod(SearchText: Code[10])
    var
        GLAcc: Record "G/L Account";
        Calendar: Record Date;
        PeriodPageMgt: Codeunit PeriodPageManagement;
    begin
        if DateFilter <> '' then begin
            Calendar.SetFilter("Period Start", DateFilter);
            if not PeriodPageMgt.FindDate('+', Calendar, PeriodType) then
                PeriodPageMgt.FindDate('+', Calendar, PeriodType::Day);
            Calendar.SetRange("Period Start");
        end;
        PeriodPageMgt.FindDate(SearchText, Calendar, PeriodType);
        GLAcc.SetRange("Date Filter", Calendar."Period Start", Calendar."Period End");
        if GLAcc.GetRangeMin("Date Filter") = GLAcc.GetRangeMax("Date Filter") then
            GLAcc.SetRange("Date Filter", GLAcc.GetRangeMin("Date Filter"));
        InternalDateFilter := GLAcc.GetFilter("Date Filter");
        if (LineDimType <> LineDimType::Period) and (ColumnDimType <> ColumnDimType::Period) then
            DateFilter := InternalDateFilter;
    end;

    local procedure GetDimSelection(OldDimSelCode: Text[30]): Text[30]
    var
        GLAcc: Record "G/L Account";
        BusUnit: Record "Business Unit";
        DimSelection: Page "Dimension Selection";
    begin
        DimSelection.InsertDimSelBuf(false, GLAcc.TableCaption, GLAcc.TableCaption);
        DimSelection.InsertDimSelBuf(false, BusUnit.TableCaption, BusUnit.TableCaption);
        DimSelection.InsertDimSelBuf(false, Text001, Text001);
        if GLSetup."Global Dimension 1 Code" <> '' then
            DimSelection.InsertDimSelBuf(false, GLSetup."Global Dimension 1 Code", '');
        if GLSetup."Global Dimension 2 Code" <> '' then
            DimSelection.InsertDimSelBuf(false, GLSetup."Global Dimension 2 Code", '');
        if GLBudgetName."Budget Dimension 1 Code" <> '' then
            DimSelection.InsertDimSelBuf(false, GLBudgetName."Budget Dimension 1 Code", '');
        if GLBudgetName."Budget Dimension 2 Code" <> '' then
            DimSelection.InsertDimSelBuf(false, GLBudgetName."Budget Dimension 2 Code", '');
        if GLBudgetName."Budget Dimension 3 Code" <> '' then
            DimSelection.InsertDimSelBuf(false, GLBudgetName."Budget Dimension 3 Code", '');
        if GLBudgetName."Budget Dimension 4 Code" <> '' then
            DimSelection.InsertDimSelBuf(false, GLBudgetName."Budget Dimension 4 Code", '');

        OnGetDimSelectionOnBeforeDimSelectionLookup(DimSelection);

        DimSelection.LookupMode := true;
        if DimSelection.RunModal = ACTION::LookupOK then
            exit(DimSelection.GetDimSelCode);

        exit(OldDimSelCode);
    end;

    local procedure DeleteBudget()
    var
        GLBudgetEntry: Record "G/L Budget Entry";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if ConfirmManagement.GetResponseOrDefault(Text003, true) then
            with GLBudgetEntry do begin
                SetRange("Budget Name", BudgetName);
                if BusUnitFilter <> '' then
                    SetFilter("Business Unit Code", BusUnitFilter);
                if GLAccFilter <> '' then
                    SetFilter("G/L Account No.", GLAccFilter);
                if DateFilter <> '' then
                    SetFilter(Date, DateFilter);
                if GlobalDim1Filter <> '' then
                    SetFilter("Global Dimension 1 Code", GlobalDim1Filter);
                if GlobalDim2Filter <> '' then
                    SetFilter("Global Dimension 2 Code", GlobalDim2Filter);
                if BudgetDim1Filter <> '' then
                    SetFilter("Budget Dimension 1 Code", BudgetDim1Filter);
                if BudgetDim2Filter <> '' then
                    SetFilter("Budget Dimension 2 Code", BudgetDim2Filter);
                if BudgetDim3Filter <> '' then
                    SetFilter("Budget Dimension 3 Code", BudgetDim3Filter);
                if BudgetDim4Filter <> '' then
                    SetFilter("Budget Dimension 4 Code", BudgetDim4Filter);
                OnDeleteBudgetOnAfterGLBudgetEntrySetFilters(GLBudgetEntry);
                SetCurrentKey("Entry No.");
                if FindFirst() then
                    UpdateAnalysisView.SetLastBudgetEntryNo("Entry No." - 1);
                SetCurrentKey("Budget Name");
                DeleteAll(true);
            end;
    end;

    local procedure ValidateBudgetName()
    begin
        GLBudgetName.Name := BudgetName;
        GLBudgetName."Version No." := "VersionNo.";

        if not GLBudgetName.Find('=<>') then begin
            GLBudgetName.Init();
            GLBudgetName.Name := Text004;
            GLBudgetName.Description := Text005;
            GLBudgetName.Insert();
        end;
        BudgetName := GLBudgetName.Name;
        "VersionNo." := GLBudgetName."Version No.";
        GLAccBudgetBuf.SetRange("Budget Filter", BudgetName);
        GLAccBudgetBuf.SetRange("Version No. Filter", "VersionNo.");
        if PrevGLBudgetName.Name <> '' then begin
            if GLBudgetName."Budget Dimension 1 Code" <> PrevGLBudgetName."Budget Dimension 1 Code" then
                BudgetDim1Filter := '';
            if GLBudgetName."Budget Dimension 2 Code" <> PrevGLBudgetName."Budget Dimension 2 Code" then
                BudgetDim2Filter := '';
            if GLBudgetName."Budget Dimension 3 Code" <> PrevGLBudgetName."Budget Dimension 3 Code" then
                BudgetDim3Filter := '';
            if GLBudgetName."Budget Dimension 4 Code" <> PrevGLBudgetName."Budget Dimension 4 Code" then
                BudgetDim4Filter := '';
        end;
        GLAccBudgetBuf.SetFilter("Budget Dimension 1 Filter", BudgetDim1Filter);
        GLAccBudgetBuf.SetFilter("Budget Dimension 2 Filter", BudgetDim2Filter);
        GLAccBudgetBuf.SetFilter("Budget Dimension 3 Filter", BudgetDim3Filter);
        GLAccBudgetBuf.SetFilter("Budget Dimension 4 Filter", BudgetDim4Filter);
        BudgetDim1FilterEnable := (GLBudgetName."Budget Dimension 1 Code" <> '');
        BudgetDim2FilterEnable := (GLBudgetName."Budget Dimension 2 Code" <> '');
        BudgetDim3FilterEnable := (GLBudgetName."Budget Dimension 3 Code" <> '');
        BudgetDim4FilterEnable := (GLBudgetName."Budget Dimension 4 Code" <> '');

        PrevGLBudgetName := GLBudgetName;

        //v  OnAfterValidateBudgetName(GLAccBudgetBuf, GLBudgetName);
    end;

    local procedure ValidateLineDimCode()
    begin
        ClearDimCodeOnChange(LineDimCode, Text006);
        LineDimType := DimCodeToType(LineDimCode);
        DateFilter := InternalDateFilter;
        if (LineDimType <> LineDimType::Period) and (ColumnDimType <> ColumnDimType::Period) then begin
            DateFilter := InternalDateFilter;
            if StrPos(DateFilter, '&') > 1 then
                DateFilter := CopyStr(DateFilter, 1, StrPos(DateFilter, '&') - 1);
        end else
            DateFilter := '';
    end;

    local procedure ValidateColumnDimCode()
    begin
        ClearDimCodeOnChange(ColumnDimCode, Text007);
        ColumnDimType := DimCodeToType(ColumnDimCode);
        DateFilter := InternalDateFilter;
        if (LineDimType <> LineDimType::Period) and (ColumnDimType <> ColumnDimType::Period) then begin
            DateFilter := InternalDateFilter;
            if StrPos(DateFilter, '&') > 1 then
                DateFilter := CopyStr(DateFilter, 1, StrPos(DateFilter, '&') - 1);
        end else
            DateFilter := '';
    end;

    local procedure ClearDimCodeOnChange(var DimCode: Text[30]; MessageText: Text)
    var
        BusUnit: Record "Business Unit";
        GLAcc: Record "G/L Account";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeClearDimCodeOnChange(DimCode, IsHandled);
        if IsHandled then
            exit;

        if (UpperCase(DimCode) <> UpperCase(GLAcc.TableCaption)) and
            (UpperCase(DimCode) <> UpperCase(BusUnit.TableCaption)) and
            (UpperCase(DimCode) <> UpperCase(Text001)) and
            (UpperCase(DimCode) <> GLBudgetName."Budget Dimension 1 Code") and
            (UpperCase(DimCode) <> GLBudgetName."Budget Dimension 2 Code") and
            (UpperCase(DimCode) <> GLBudgetName."Budget Dimension 3 Code") and
            (UpperCase(DimCode) <> GLBudgetName."Budget Dimension 4 Code") and
            (UpperCase(DimCode) <> GLSetup."Global Dimension 1 Code") and
            (UpperCase(DimCode) <> GLSetup."Global Dimension 2 Code") and
            (DimCode <> '')
        then begin
            Message(MessageText, DimCode);
            DimCode := '';
        end;
    end;

    local procedure GetCaptionClass(BudgetDimType: Integer): Text[250]
    begin
        if GLBudgetName.Name <> BudgetName then
            GLBudgetName.Get(BudgetName);
        case BudgetDimType of
            1:
                begin
                    if GLBudgetName."Budget Dimension 1 Code" <> '' then
                        exit('1,6,' + GLBudgetName."Budget Dimension 1 Code");

                    exit(Text008);
                end;
            2:
                begin
                    if GLBudgetName."Budget Dimension 2 Code" <> '' then
                        exit('1,6,' + GLBudgetName."Budget Dimension 2 Code");

                    exit(Text009);
                end;
            3:
                begin
                    if GLBudgetName."Budget Dimension 3 Code" <> '' then
                        exit('1,6,' + GLBudgetName."Budget Dimension 3 Code");

                    exit(Text010);
                end;
            4:
                begin
                    if GLBudgetName."Budget Dimension 4 Code" <> '' then
                        exit('1,6,' + GLBudgetName."Budget Dimension 4 Code");

                    exit(Text011);
                end;
        end;
    end;

    procedure SetBudgetName(NextBudgetName: Code[10]; Versionn: Integer)
    begin
        NewBudgetName := NextBudgetName;
        "newVersionNo." := Versionn;
    end;

    procedure GetBudgetName(): Code[10]
    begin
        exit(BudgetName);
    end;

    procedure SetGLAccountFilter(NewGLAccFilter: Code[250])
    begin
        GLAccFilter := NewGLAccFilter;
        GLAccFilterOnAfterValidate();
    end;

    protected procedure UpdateMatrixSubform()
    begin
        CurrPage.MatrixForm.PAGE.LoadMatrix(
          MATRIX_CaptionSet, MATRIX_MatrixRecords, MATRIX_CurrentNoOfColumns, LineDimCode,
          LineDimType, ColumnDimType, GlobalDim1Filter, GlobalDim2Filter, BudgetDim1Filter,
          BudgetDim2Filter, BudgetDim3Filter, BudgetDim4Filter, GLBudgetName, DateFilter,
          GLAccFilter, IncomeBalanceGLAccFilter, GLAccCategoryFilter, RoundingFactor, PeriodType);

        CurrPage.Update();

    end;

    local procedure LineDimCodeOnAfterValidate()
    begin
        UpdateMatrixSubform();
    end;

    local procedure ColumnDimCodeOnAfterValidate()
    begin
        UpdateMatrixSubform();
    end;

    local procedure PeriodTypeOnAfterValidate()
    begin
        if ColumnDimType = ColumnDimType::Period then
            GenerateColumnCaptions("Matrix Page Step Type"::Initial);
        UpdateMatrixSubform();
    end;

    local procedure GLAccFilterOnAfterValidate()
    begin
        GLAccBudgetBuf.SetFilter("G/L Account Filter", GLAccFilter);
        if ColumnDimType = ColumnDimType::"G/L Account" then
            GenerateColumnCaptions("Matrix Page Step Type"::Initial);
        UpdateMatrixSubform();
    end;

    local procedure ValidateIncomeBalanceGLAccFilter()
    begin
        GLAccBudgetBuf.SetRange("Income/Balance", IncomeBalanceGLAccFilter);
        if ColumnDimType = ColumnDimType::"G/L Account" then
            GenerateColumnCaptions("Matrix Page Step Type"::Initial);
        UpdateMatrixSubform();
    end;

    local procedure ValidateGLAccCategoryFilter()
    begin
        GLAccBudgetBuf.SetRange("Account Category", GLAccCategoryFilter);
        if ColumnDimType = ColumnDimType::"G/L Account" then
            GenerateColumnCaptions("Matrix Page Step Type"::Initial);
        UpdateMatrixSubform();
    end;

    local procedure GlobalDim2FilterOnAfterValidate()
    begin
        GLAccBudgetBuf.SetFilter("Global Dimension 2 Filter", GlobalDim2Filter);
        if ColumnDimType = ColumnDimType::"Global Dimension 2" then
            GenerateColumnCaptions("Matrix Page Step Type"::Initial);
        UpdateMatrixSubform();
    end;

    local procedure GlobalDim1FilterOnAfterValidate()
    begin
        GLAccBudgetBuf.SetFilter("Global Dimension 1 Filter", GlobalDim1Filter);
        if ColumnDimType = ColumnDimType::"Global Dimension 1" then
            GenerateColumnCaptions("Matrix Page Step Type"::Initial);
        UpdateMatrixSubform();
    end;

    local procedure BudgetDim2FilterOnAfterValidate()
    begin
        GLAccBudgetBuf.SetFilter("Budget Dimension 2 Filter", BudgetDim2Filter);
        if ColumnDimType = ColumnDimType::"Budget Dimension 2" then
            GenerateColumnCaptions("Matrix Page Step Type"::Initial);
        UpdateMatrixSubform();
    end;

    local procedure BudgetDim1FilterOnAfterValidate()
    begin
        GLAccBudgetBuf.SetFilter("Budget Dimension 1 Filter", BudgetDim1Filter);
        if ColumnDimType = ColumnDimType::"Budget Dimension 1" then
            GenerateColumnCaptions("Matrix Page Step Type"::Initial);
        UpdateMatrixSubform();
    end;

    local procedure BudgetDim4FilterOnAfterValidate()
    begin
        GLAccBudgetBuf.SetFilter("Budget Dimension 4 Filter", BudgetDim4Filter);
        if ColumnDimType = ColumnDimType::"Budget Dimension 4" then
            GenerateColumnCaptions("Matrix Page Step Type"::Initial);
        UpdateMatrixSubform();
    end;

    local procedure BudgetDim3FilterOnAfterValidate()
    begin
        GLAccBudgetBuf.SetFilter("Budget Dimension 3 Filter", BudgetDim3Filter);
        if ColumnDimType = ColumnDimType::"Budget Dimension 3" then
            GenerateColumnCaptions("Matrix Page Step Type"::Initial);
        UpdateMatrixSubform();
    end;

    local procedure DateFilterOnAfterValidate()
    begin
        if ColumnDimType = ColumnDimType::Period then
            GenerateColumnCaptions("Matrix Page Step Type"::Initial);
        UpdateMatrixSubform();
    end;

    local procedure ShowColumnNameOnPush()
    begin
        GenerateColumnCaptions("Matrix Page Step Type"::Same);
        UpdateMatrixSubform();
    end;

    protected procedure ValidateDateFilter(NewDateFilter: Text[30])
    var
        FilterTokens: Codeunit "Filter Tokens";
    begin
        FilterTokens.MakeDateFilter(NewDateFilter);
        GLAccBudgetBuf.SetFilter("Date Filter", NewDateFilter);
        DateFilter := CopyStr(GLAccBudgetBuf.GetFilter("Date Filter"), 1, MaxStrLen(DateFilter));
        InternalDateFilter := NewDateFilter;
        DateFilterOnAfterValidate();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGenerateColumnCaptions(ColumnDimCode: Text[30]; StepType: Enum "Matrix Page Step Type"; var PrimKeyFirstCaptionInCu: Text; var CaptionSet: array[32] of Text[80]; var CaptionRange: Text; var CurrentNoOfColumns: Integer; var MatrixRecords: array[32] of Record "Dimension Code Buffer"; ShowColumnName: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterDimCodeToType(DimCode: Text[30]; var Result: Enum "G/L Budget Matrix Dimensions")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateBudgetName(var GLAccBudgetBuf: Record "G/L Acc. Budget Buffer"; var GLBudgetName: Record "G/L Budget Name Archive")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeClearDimCodeOnChange(DimensionCode: Text[30]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnDeleteBudgetOnAfterGLBudgetEntrySetFilters(var GLBudgetEntry: Record "G/L Budget Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetDimSelectionOnBeforeDimSelectionLookup(var DimensionSelection: Page "Dimension Selection")
    begin
    end;
}


