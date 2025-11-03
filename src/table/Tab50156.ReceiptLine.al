table 50156 "Tenant Receipt Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
        }
        field(3; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(5; "Lease No."; Code[20])
        {
            Caption = 'Lease No.';
            TableRelation = Lease."No.";
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
