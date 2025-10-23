tableextension 50137 "Owner Ext" extends Vendor
{
    fields
    {
        field(50100; "Owner Type"; Option)
        {
            OptionMembers = Individual,Corporate,Joint;
        }
        field(50101; "Ownership Share"; Decimal)
        {
            Caption = 'Ownership Share (%)';
        }
        field(50102; "Property Linked"; Code[20])
        {
            TableRelation = Property;
        }
        field(50103; "Ownership Type"; Enum "Ownership Type")
        {
            Caption = 'Ownership Type';
            DataClassification = CustomerContent;
        }
        field(50104; "Preferred Payment Method"; Enum "Preferred Payment Method")
        {
            Caption = 'Preferred Payment Method';
            DataClassification = CustomerContent;
        }
        field(50105; "Mobile Money Account"; Text[30])
        {
            Caption = 'Mobile Money Account';
            DataClassification = CustomerContent;
        }
        field(50106; "Paybill No."; Text[20])
        {
            Caption = 'Paybill No.';
            DataClassification = CustomerContent;
        }
        field(50107; "Till No."; Text[20])
        {
            Caption = 'Till No.';
            DataClassification = CustomerContent;
        }
        field(50108; "Bank Account No."; Text[50])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;
        }
        field(50109; "Property Owner"; Boolean)
        {
            DataClassification = CustomerContent;
        }

    }
}
