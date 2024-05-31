Page 50136 "Defferal G/L Entries"
{
    Caption = 'Defferal G/L Entries';
    DataCaptionExpression = GetCaption;
    Editable = false;
    PageType = List;
    SourceTable = "Deferral G/L Entries";
    SourceTableView = where("Source Code" = filter('<> UNAPPPURCH'));
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Tax Type"; Rec."Tax Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Visible = false;
                }
                field(Description; Rec.Description)
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
                }
                field("Credit Amount"; Rec."Credit Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = Basic;
                }
                field("Source Name"; SourceName)
                {
                    ApplicationArea = Basic;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Department; Rec."Shortcut Dimension 3")
                {
                    ApplicationArea = Basic;
                }
                field("Product Segment"; Rec."Shortcut Dimension 4")
                {
                    ApplicationArea = Basic;
                }
                field(LAN; Rec."Shortcut Dimension 8")
                {
                    ApplicationArea = Basic;
                }
                field("GST Bill-to/BuyFrom State Code"; Rec."GST Bill-to/BuyFrom State Code")
                {
                    ApplicationArea = Basic;
                }
                field("Purchase Comment"; Rec."Purchase Comment")
                {
                    ApplicationArea = Basic;
                }
                field("Purchase Comments"; Rec."Purchase Comments")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                    ApplicationArea = Basic;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Bal. Account No."; rec."Bal. Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Creation DateTime"; Rec."Creation DateTime")
                {
                    ApplicationArea = Basic;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = Basic;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction No."; Rec."Transaction No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart("?"; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
            part(IncomingDocAttachFactBox; "Incoming Document Attachments")
            {
                ShowFilter = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'P&ost';
                Ellipsis = true;
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F9';

                trigger OnAction()
                var
                    DeferralGLEntries: Record "Deferral G/L Entries";
                begin
                    if not Confirm(Text001, false) then
                        exit;

                    CurrPage.SetSelectionFilter(Rec);
                    if Rec.FindFirst then
                        repeat
                            if UserSetup.Get(UserId) then begin
                                AllowPostingFrom := UserSetup."Allow Posting From";
                                AllowPostingTo := UserSetup."Allow Posting To";
                            end;

                            if (Rec."Posting Date" < AllowPostingFrom) or (Rec."Posting Date" > AllowPostingTo) then
                                rec.FieldError(Rec."Posting Date", Text045);

                            uniqDeffEntryRec.Reset;
                            uniqDeffEntryRec.SetRange("Transaction No.", Rec."Transaction No.");
                            if not uniqDeffEntryRec.FindFirst then begin
                                uniqDeffEntryRec.Copy(Rec);
                                uniqDeffEntryRec.Insert;

                                DeferralGLEntries.Reset();
                                //DeferralGLEntries.SETRANGE("Document No.","Document No.");
                                DeferralGLEntries.SetRange("Transaction No.", uniqDeffEntryRec."Transaction No.");
                                DeferralGLEntries.SetRange("Document No.", uniqDeffEntryRec."Document No.");
                                DeferralGLEntries.SetFilter("Posting Date", '<=%1', AllowPostingTo);
                                if DeferralGLEntries.FindFirst then
                                    repeat
                                        GLEntry.Init;
                                        //GLEntry.CopyFromGenJnlLine(GenJnlLine);
                                        GLEntry.LockTable;
                                        if GLEntry.FindLast then begin
                                            NextEntryNo := GLEntry."Entry No." + 1;
                                            NextTransactionNo := GLEntry."Transaction No." + 1;
                                        end else begin
                                            NextEntryNo := 1;
                                            NextTransactionNo := 1;
                                        end;
                                        GLEntry."Entry No." := NextEntryNo;
                                        GLEntry."Transaction No." := NextTransactionNo;
                                        GLEntry."G/L Account No." := DeferralGLEntries."G/L Account No.";
                                        GLEntry.Comment := DeferralGLEntries.Comment;
                                        GLEntry."GSTCredit 50%" := DeferralGLEntries."GSTCredit 50%";
                                        //v      GLEntry."GST Bill-to/BuyFrom State Code" := DeferralGLEntries."GST Bill-to/BuyFrom State Code";
                                        GLEntry."Approver ID" := DeferralGLEntries."Approver ID"; //GLEntry."System-Created Entry" := SystemCreatedEntry;
                                                                                                  //v       GLEntry."Location Code" := DeferralGLEntries."Location Code";
                                        GLEntry."Posting Date" := DeferralGLEntries."Posting Date";
                                        GLEntry."Document Date" := DeferralGLEntries."Document Date";
                                        GLEntry."Document Type" := DeferralGLEntries."Document Type";
                                        GLEntry."Document No." := DeferralGLEntries."Document No.";
                                        GLEntry."External Document No." := DeferralGLEntries."External Document No.";
                                        GLEntry.Description := DeferralGLEntries.Description;
                                        GLEntry."Business Unit Code" := DeferralGLEntries."Business Unit Code";
                                        //v       GLEntry."Tax Type" := DeferralGLEntries."Tax Type";
                                        GLEntry.Amount := DeferralGLEntries.Amount;
                                        GLEntry."Debit Amount" := DeferralGLEntries."Debit Amount";
                                        GLEntry."Credit Amount" := DeferralGLEntries."Credit Amount";
                                        GLEntry."Global Dimension 1 Code" := DeferralGLEntries."Global Dimension 1 Code";
                                        GLEntry."Global Dimension 2 Code" := DeferralGLEntries."Global Dimension 2 Code";
                                        GLEntry."Dimension Set ID" := DeferralGLEntries."Dimension Set ID";
                                        GLEntry."Source Code" := DeferralGLEntries."Source Code";
                                        GLEntry."Source Type" := DeferralGLEntries."Source Type";
                                        GLEntry."Source No." := DeferralGLEntries."Source No.";
                                        GLEntry."Job No." := DeferralGLEntries."Job No.";
                                        GLEntry.Quantity := DeferralGLEntries.Quantity;
                                        GLEntry."Journal Batch Name" := DeferralGLEntries."Journal Batch Name";
                                        GLEntry."Reason Code" := DeferralGLEntries."Reason Code";
                                        GLEntry."User ID" := UserId;
                                        GLEntry."No. Series" := DeferralGLEntries."No. Series";
                                        GLEntry."IC Partner Code" := DeferralGLEntries."IC Partner Code";
                                        //v        GLEntry."Location Code" := DeferralGLEntries."Location Code";

                                        GLEntry.Insert(true);
                                    until DeferralGLEntries.Next = 0;
                            end;
                        until Rec.Next = 0;

                    DeferralGLEntries.Reset();
                    //DeferralGLEntries.SETRANGE("Document No.","Document No.");
                    DeferralGLEntries.SetRange("Document No.", uniqDeffEntryRec."Document No.");
                    DeferralGLEntries.SetRange("Transaction No.", uniqDeffEntryRec."Transaction No.");
                    DeferralGLEntries.SetFilter("Posting Date", '<=%1', AllowPostingTo);
                    if DeferralGLEntries.FindSet then //REPEAT
                      begin
                        DeferralGLEntries.DeleteAll(true);
                        Message(Text002);
                    end;  //UNTIL DeferralGLEntries.NEXT=0;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        IncomingDocument: Record "Incoming Document";
    begin
        HasIncomingDocument := IncomingDocument.PostedDocExists(rec."Document No.", rec."Posting Date");
        // CurrPage.IncomingDocAttachFactBox.Page.LoadDataFromRecord(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        /*
        SetControlVisibility; //CCIT
        //CCIT Vikas 06022020
        SourceName := '';
        IF "Source Type" = "Source Type"::Customer THEN BEGIN
          IF Customer.GET("Source No.") THEN
            SourceName := Customer.Name;
          END ELSE
          IF "Source Type" = "Source Type"::Vendor THEN BEGIN
            IF Vendor.GET("Source No.") THEN
              SourceName := Vendor.Name;
          END ELSE
          IF "Source Type" = "Source Type"::"Bank Account" THEN BEGIN
            IF BankAccount.GET("Source No.") THEN
              SourceName := BankAccount.Name;
              END ELSE
          IF "Source Type" = "Source Type"::"Fixed Asset" THEN BEGIN
            IF FA.GET("Source No.") THEN
              SourceName := FA.Description;
            END;
        
        GSTReverseCharge:= FALSE;
        GSTGroupCode:='';
        DGSTLedger.RESET();
        DGSTLedger.SETRANGE("Document No.","Document No.");
        IF DGSTLedger.FIND('-') THEN BEGIN
           GSTGroupCode:= DGSTLedger."GST Group Code";
           GSTReverseCharge:=DGSTLedger."Reverse Charge";
        END;
        
        
        
        
        ApproverID := '';
        PostedApprovedEntry.RESET();
        PostedApprovedEntry.SETRANGE(Status,PostedApprovedEntry.Status::Approved);
        PostedApprovedEntry.SETRANGE("Document No.","Document No.");
        PostedApprovedEntry.SETFILTER("Approver ID",'<>%1',"User ID");
        IF PostedApprovedEntry.FINDLAST THEN BEGIN
           // users1.RESET();
           // users1.SETRANGE("User Name", PostedApprovedEntry."Approver ID");
           // IF users1.FIND('-') THEN
               ApproverID := PostedApprovedEntry."Approver ID";
        
        END;
        IF ApproverID = '' THEN BEGIN
         // IF Reversed = TRUE THEN BEGIN
           IF ApproverID = '' THEN BEGIN
            IF  AppravalSetup.GET("User ID") THEN BEGIN
              //  users1.RESET();
              //  users1.SETRANGE("User Name",AppravalSetup."Approver ID");
              //  IF users1.FIND('-') THEN
                  ApproverID :=AppravalSetup."Approver ID";
           //     END;
          END;
          END ELSE BEGIN
           // users1.RESET();
            //users1.SETRANGE("User Name","Approver ID");
           // IF users1.FIND('-') THEN
            IF (ApproverID='') AND ("Approver ID"<>'') THEN
                 ApproverID := "Approver ID";
          END;
        END;
        
        //CCIT Vikas 06022020
        */

    end;

    var
        Text001: label 'Do you want to post the Defferal entries lines?';
        Text002: label 'The Defferal entries were successfully posted.';
        Text045: label 'is not within your range of allowed posting dates.';
        uniqDeffEntryRec: Record "Deferral G/L Entries" temporary;
        GLAcc: Record "G/L Account";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        HasIncomingDocument: Boolean;
        UserSetup: Record "User Setup";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        GLEntry: Record "G/L Entry";
        NextEntryNo: Integer;
        NextTransactionNo: Integer;
        SourceName: Text[100];

    local procedure GetCaption(): Text[250]
    begin
        if GLAcc."No." <> Rec."G/L Account No." then
            if not GLAcc.Get(Rec."G/L Account No.") then
                if Rec.GetFilter(Rec."G/L Account No.") <> '' then
                    if GLAcc.Get(Rec.GetRangeMin("G/L Account No.")) then;
        exit(StrSubstNo('%1 %2', GLAcc."No.", GLAcc.Name))
    end;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        //MESSAGE('%1',OpenApprovalEntriesExist);
    end;
}

