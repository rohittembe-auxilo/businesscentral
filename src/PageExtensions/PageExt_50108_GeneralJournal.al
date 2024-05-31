pageextension 50108 GeneralJournal extends "General Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter("Posting Date")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
            }


        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
                UserSetup: Record "User Setup";
                Location: Record Location;
            begin
                UserSetup.RESET();
                UserSetup.SETRANGE("User ID", USERID);
                UserSetup.SETRANGE(Blocked, TRUE);
                IF UserSetup.FINDFIRST THEN
                    ERROR('This User Is Blocked, Can not Post This Invoice ');


                if Location.Get(rec."Location Code") then begin
                    if Location."Blocked Location" = true then
                        Error('Location is blocked');
                end;
            End;
        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        //Vikas 21072020
        "Account Name" := '';
        CASE rec."Account Type" OF
            rec."Account Type"::"G/L Account":
                BEGIN
                    GLAcc.RESET();
                    GLAcc.SETRANGE("No.", rec."Account No.");
                    IF GLAcc.FIND('-') THEN
                        "Account Name" := GLAcc.Name;
                END;
            rec."Account Type"::Customer:
                BEGIN
                    Cust.RESET();
                    Cust.SETRANGE("No.", rec."Account No.");
                    IF Cust.FIND('-') THEN
                        "Account Name" := Cust.Name;
                END;
            rec."Account Type"::Vendor:
                BEGIN
                    Vend.RESET();
                    Vend.SETRANGE("No.", rec."Account No.");
                    IF Vend.FIND('-') THEN
                        "Account Name" := Vend.Name;
                END;
            rec."Account Type"::"Bank Account":
                BEGIN
                    BankAcc.RESET();
                    BankAcc.SETRANGE("No.", rec."Account No.");
                    IF BankAcc.FIND('-') THEN
                        "Account Name" := BankAcc.Name;
                END;
            rec."Account Type"::"Fixed Asset":
                BEGIN
                    FA.RESET();
                    FA.SETRANGE("No.", rec."Account No.");
                    IF FA.FIND('-') THEN
                        "Account Name" := FA.Description;
                END;
            rec."Account Type"::"IC Partner":
                BEGIN

                    ICPartner.RESET();
                    ICPartner.SETRANGE(Code, rec."Account No.");
                    IF ICPartner.FIND('-') THEN
                        "Account Name" := ICPartner.Name;
                END;
        END;
    END;



    var
        UserDept: Text[1024];
        RecUserDep: Record 5209;
        GenJournalBatch: Record 232;
        ApprovalsMgmt: Codeunit 1535;
        ApprovalEntry: Record 454;
        "Account Name": Text;
        GLAcc: Record 15;
        Cust: Record 18;
        Vend: Record 23;
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        ICPartner: Record 413;
}