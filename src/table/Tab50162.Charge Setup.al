table 50162 "Charge Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Charge ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Charge Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Property No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Property;
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
        field(7; "Default Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Default Amount';
        }
    }

    keys
    {
        key(Key1; "Charge ID")
        {
            Clustered = true;
        }
        key(Key2; "Property No.", "Charge Type")
        {
        }
    }
}