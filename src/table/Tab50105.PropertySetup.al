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
        field(7; "Customer Nos"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(8; "Termination ID"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(9; "Maintenance Request Nos."; Code[20])
        {
            Caption = 'Maintenance Request Nos.';
            TableRelation = "No. Series";
        }
        field(10; "Rent Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(11; "Rent G/L account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(12; "Revenue G/L Account"; Code[20])
        {
            Caption = 'Revenue G/L Account';
            TableRelation = "G/L Account";
        }
        field(13; "Receivables G/L Account"; Code[20])
        {
            Caption = 'Receivables G/L Account';
            TableRelation = "G/L Account";
        }
        field(14; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(15; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(16; "Service Charge G/L Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'Service Charge G/L Account';
        }
        field(17; "Utility G/L Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'Utility G/L Account';
        }
        field(18; "Penalty G/L Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'Penalty G/L Account';
        }
        field(19; "Tax G/L Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'Tax G/L Account';
        }
        field(20; "Receipt Bank Account"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Bank Account";
            Caption = 'Default Receipt Bank Account';
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