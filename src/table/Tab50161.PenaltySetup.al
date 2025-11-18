table 50157 "PMS Penalty Setup"
{
    DataClassification = ToBeClassified;
    Caption = 'PMS Penalty Setup';

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code';
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Penalty Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = None,Flat,Percent;
        }
        field(4; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount (flat or percentage)';
        }
        field(5; "Grace Days"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Grace Days';
        }
        field(6; Active; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Active';
        }
    }

    keys
    {
        key(PK; Code) { Clustered = true; }
    }
}
