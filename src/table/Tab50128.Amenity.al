table 50128 Amenity
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Amenity ID"; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                aty: Record Amenity;
            begin
                if aty.Get("Amenity ID") then
                    Amenity := aty.Amenity;
            end;


        }
        field(2; "Amenity"; Enum Amenity)
        {

            DataClassification = CustomerContent;
        }
        field(3; "Property No."; Code[20])
        {
            Caption = 'Property No.';
            DataClassification = CustomerContent;
            TableRelation = Property;
        }

    }

    keys
    {
        key(PK; "Amenity ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Amenity ID", "Amenity")
        {
        }

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