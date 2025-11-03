table 50152 "Property Owner"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Owner No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;

        }
        field(2; "Property No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Property;

        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            TableRelation = Property."Property Name" where("Property ID" = field("Property No."));
        }

    }

    keys
    {
        key(PK; "Owner No.", "Property No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}