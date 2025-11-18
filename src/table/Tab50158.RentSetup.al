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
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}