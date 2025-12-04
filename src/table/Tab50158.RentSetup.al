table 50158 "Rent Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Rent Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(3; "Cash Receipts G/L Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(4; "Mpesa Receipts G/L Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }
        field(5; "Automatic Processing Enabled"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Processing Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(19; "General Bus. Posting Group"; Code[20])
        {
            TableRelation = "Gen. Business Posting Group";
        }
        field(20; "VAT Bus. Posting Group"; Code[20])
        {
            TableRelation = "VAT Business Posting Group";
        }
        field(24; "Bank Transfer Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(34; "Bank Transfer Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        Field(77; "Due From"; Code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = const(true));
        }
        Field(78; "Due To"; Code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = const(true));
        }
        field(83; "Invoicing Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(84; "Receipt Template"; Code[20])
        {
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}