table 50105 "Property Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Property No."; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'Property No.';
        }
        field(3; "Unit No."; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'Unit No';
        }
        field(4; "Lease No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(5; "Owner No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(6; "Application ID"; Code[50])
        {
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(7; "Customer Nos."; Code[20])
        {
            Caption = 'Customer Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        // field(8; "Clause ID"; Code[20])
        // {
        //     DataClassification = CustomerContent;
        //     TableRelation = "No. Series";

        // }

    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }


}