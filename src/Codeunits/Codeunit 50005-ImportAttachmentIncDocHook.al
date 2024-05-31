codeunit 50005 "ImportAttachmentIncDoc Hook"
{
    trigger OnRun()
    begin

    end;

    //   IF FindUsingVendNoFilter(IncomingDocumentAttachment,IncomingDocument,DocNo) THEN //CCIT AN
    //     EXIT;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Import Attachment - Inc. Doc.", OnBeforeCreateNewSalesPurchIncomingDoc, '', false, false)]
    local procedure OnBeforeCreateNewSalesPurchIncomingDoc(var IncomingDocumentAttachment: Record "Incoming Document Attachment"; var IncomingDocEntryNo: Integer; var IsHandled: Boolean)
    var
        IncomingDocument: Record "Incoming Document";
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        Vendor: Record Vendor;
        DocTableNo: Integer;
        DocType: Enum "Incoming Document Type";
        DocNo: Code[20];
        NotSupportedDocTableErr: Label 'Table no. %1 is not supported.', Comment = '%1 is a number (integer).';
    begin
        IsHandled := false;

        if IncomingDocumentAttachment.GetFilter(IncomingDocumentAttachment."Document Table No. Filter") <> '' then
            DocTableNo := IncomingDocumentAttachment.GetRangeMin("Document Table No. Filter");
        if IncomingDocumentAttachment.GetFilter("Document Type Filter") <> '' then
            DocType := IncomingDocumentAttachment.GetRangeMin("Document Type Filter");
        if IncomingDocumentAttachment.GetFilter("Document No. Filter") <> '' then
            DocNo := IncomingDocumentAttachment.GetRangeMin("Document No. Filter");

        case DocTableNo of
            DATABASE::"Sales Header":
                begin
                    SalesHeader.Get(DocType, DocNo);
                    CreateIncomingDocumentExtended(IncomingDocumentAttachment, IncomingDocument, 0D, '', SalesHeader.RecordId);
                    SalesHeader."Incoming Document Entry No." := IncomingDocument."Entry No.";
                    SalesHeader.Modify();
                end;
            DATABASE::"Purchase Header":
                begin
                    PurchaseHeader.Get(DocType, DocNo);
                    CreateIncomingDocumentExtended(IncomingDocumentAttachment, IncomingDocument, 0D, '', PurchaseHeader.RecordId);
                    PurchaseHeader."Incoming Document Entry No." := IncomingDocument."Entry No.";
                    PurchaseHeader.Modify();
                end;
            //CCIT AN06072023 ++
            DATABASE::Vendor:
                BEGIN
                    Vendor.GET(DocNo);
                    Vendor."Incoming Document Entry No." := IncomingDocument."Entry No.";
                    Vendor.MODIFY;
                END; //CCIT AN06072023 ++
            else
                Error(NotSupportedDocTableErr, DocTableNo);
        end;

        IncomingDocEntryNo := IncomingDocument."Entry No.";
        IsHandled := true;
    end;


    local procedure IsJournalRelated(var IncomingDocumentAttachment: Record "Incoming Document Attachment"): Boolean
    var
        Result: Boolean;
    begin
        Result :=
          (IncomingDocumentAttachment.GetFilter("Journal Template Name Filter") <> '') and
          (IncomingDocumentAttachment.GetFilter("Journal Batch Name Filter") <> '') and
          (IncomingDocumentAttachment.GetFilter("Journal Line No. Filter") <> '');
        exit(Result);
    end;

    local procedure IsSalesPurhaseRelated(var IncomingDocumentAttachment: Record "Incoming Document Attachment"): Boolean
    var
        Result: Boolean;
    begin
        Result :=
          (IncomingDocumentAttachment.GetFilter("Document Table No. Filter") <> '') and
          (IncomingDocumentAttachment.GetFilter("Document Type Filter") <> '');
        exit(Result);
    end;

    local procedure GetDocType(var IncomingDocumentAttachment: Record "Incoming Document Attachment"; var IncomingDocument: Record "Incoming Document"; PostingDate: Date; DocNo: Code[20]; var Posted: Boolean): Enum "Incoming Related Document Type"
    begin
        if (PostingDate <> 0D) and (DocNo <> '') then begin
            IncomingDocument.SetPostedDocFields(PostingDate, DocNo);
            exit(IncomingDocument.GetRelatedDocType(PostingDate, DocNo, Posted));
        end;
        Posted := false;
        exit(GetUnpostedDocType(IncomingDocumentAttachment, IncomingDocument));
    end;

    local procedure GetUnpostedDocType(var IncomingDocumentAttachment: Record "Incoming Document Attachment"; var IncomingDocument: Record "Incoming Document"): Enum "Incoming Related Document Type"
    begin
        if IsJournalRelated(IncomingDocumentAttachment) then
            exit(IncomingDocument."Document Type"::Journal);

        if IsSalesPurhaseRelated(IncomingDocumentAttachment) then
            exit(GetUnpostedSalesPurchaseDocType(IncomingDocumentAttachment, IncomingDocument));

        exit(IncomingDocument."Document Type"::" ");
    end;

    local procedure GetUnpostedSalesPurchaseDocType(var IncomingDocumentAttachment: Record "Incoming Document Attachment"; var IncomingDocument: Record "Incoming Document"): Enum "Incoming Related Document Type"
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
    begin
        case IncomingDocumentAttachment.GetRangeMin("Document Table No. Filter") of
            DATABASE::"Sales Header":
                begin
                    if IncomingDocumentAttachment.GetRangeMin("Document Type Filter") = SalesHeader."Document Type"::"Credit Memo" then
                        exit(IncomingDocument."Document Type"::"Sales Credit Memo");
                    exit(IncomingDocument."Document Type"::"Sales Invoice");
                end;
            DATABASE::"Purchase Header":
                begin
                    if IncomingDocumentAttachment.GetRangeMin("Document Type Filter") = PurchaseHeader."Document Type"::"Credit Memo" then
                        exit(IncomingDocument."Document Type"::"Purchase Credit Memo");
                    exit(IncomingDocument."Document Type"::"Purchase Invoice");
                end;
        end;
    end;

    local procedure CreateIncomingDocumentExtended(var IncomingDocumentAttachment: Record "Incoming Document Attachment"; var IncomingDocument: Record "Incoming Document"; PostingDate: Date; DocNo: Code[20]; RelatedRecordID: RecordID)
    var
        DataTypeManagement: Codeunit "Data Type Management";
        RelatedRecordRef: RecordRef;
        RelatedRecord: Variant;
    begin
        IncomingDocument.CreateIncomingDocument('', '');
        IncomingDocument."Document Type" :=
          GetDocType(IncomingDocumentAttachment, IncomingDocument, PostingDate, DocNo, IncomingDocument.Posted);
        if RelatedRecordID.TableNo = 0 then
            if IncomingDocument.GetRecord(RelatedRecord) then
                if DataTypeManagement.GetRecordRef(RelatedRecord, RelatedRecordRef) then
                    RelatedRecordID := RelatedRecordRef.RecordId;
        IncomingDocument."Related Record ID" := RelatedRecordID;
        if IncomingDocument."Document Type" <> IncomingDocument."Document Type"::" " then begin
            if IncomingDocument.Posted then
                IncomingDocument.Status := IncomingDocument.Status::Posted
            else
                IncomingDocument.Status := IncomingDocument.Status::Created;
            IncomingDocument.Released := true;
            IncomingDocument."Released Date-Time" := CurrentDateTime;
            IncomingDocument."Released By User ID" := UserSecurityId();
        end;
        IncomingDocument.Modify();
    end;

    local procedure FindUsingVendNoFilter(VAR IncomingDocumentAttachment: Record 133; VAR IncomingDocument: Record 130; VAR VendNo: Code[20]): Boolean;
    VAR
        FilterGroupID: Integer;
    BEGIN
        FOR FilterGroupID := 0 TO 2 DO BEGIN
            IncomingDocumentAttachment.FILTERGROUP(FilterGroupID * 2);
            IF (IncomingDocumentAttachment.GETFILTER("Document No.") <> '') THEN BEGIN
                VendNo := IncomingDocumentAttachment.GETRANGEMIN("Document No.");
                //PostingDate := GETRANGEMIN("Posting Date");
            END;
            IF VendNo <> '' THEN
                BREAK;
        END;
        IncomingDocumentAttachment.FILTERGROUP(0);

        IF VendNo = '' THEN
            EXIT(FALSE);

        IncomingDocument.SETRANGE("Document No.", VendNo);
        EXIT(IncomingDocument.FINDFIRST);
    END;
}