table 50156 "Rent Invoice Line"
{
    DataClassification = CustomerContent;
    Caption = 'PMS Rent Invoice Line';

    fields
    {
        field(1; "Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Rent Invoice"."Rent Invoice No.";

        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Charge Type"; Enum "Charge Type")
        {
            DataClassification = CustomerContent;
        }
        field(6; "GL Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'G/L Account';
        }
        field(7; "Linked Lease No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Lease."No.";
        }
        // field(3; "Charge Type"; Enum "Charge Type")
        // {
        //     DataClassification = CustomerContent;
        // }
        // field(4; Description; Text[100])
        // {
        //     DataClassification = CustomerContent;
        // }
        // field(5; Amount; Decimal)
        // {
        //     DataClassification = CustomerContent;
        // }

        // field(7; "GL Account No."; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'G/L Account (optional)';
        // }
    }

    keys
    {
        key(PK; "Invoice No.", "Line No.")
        {
            Clustered = true;
        }
        key(InvoiceNo; "Invoice No.", "Charge Type")
        {
        }
    }
    trigger OnInsert()
    var
        ChargeSetup: Record "Charge Setup";
    begin
        if ChargeSetup.Get() then begin
            Description := ChargeSetup."Charge Description";
            "Charge Type" := ChargeSetup."Charge Type";
            "GL Account No." := ChargeSetup."GL Account No.";
            Amount := ChargeSetup.Amount;
            if Amount = 0 then
                Amount := ChargeSetup."Default Amount";

        end;
    end;
}
