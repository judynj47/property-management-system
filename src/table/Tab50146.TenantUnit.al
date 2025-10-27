table 50146 "Tenant Unit Link"
{
    Caption = 'Tenant Unit Link';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Tenant No."; Code[20])
        {
            Caption = 'Tenant No.';
            TableRelation = Customer;
        }

        field(2; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            TableRelation = Unit;
        }

        field(3; "Start Date"; Date)
        {
            Caption = 'Lease Start Date';
        }

        field(4; "End Date"; Date)
        {
            Caption = 'Lease End Date';
        }
    }

    keys
    {
        key(PK; "Tenant No.", "Unit No.")
        {
            Clustered = true;
        }
    }
}
