table 50142 "Property Amenity"
{
    Caption = 'Property Amenity Link';
    DataClassification = CustomerContent;


    fields
    {
        field(1; "Property No."; Code[20])
        {
            Caption = 'Property ID';
            TableRelation = Property."Property ID";
            DataClassification = CustomerContent;

        }

        field(2; "Amenity ID"; Code[20])
        {
            Caption = 'Amenity ID';
            TableRelation = Amenity."Amenity ID";
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                AmenityRec: Record Amenity;
            begin
                if AmenityRec.Get("Amenity ID") then
                    Rec.Description := AmenityRec.Amenity;
            end;
        }

        field(3; Description; Enum Amenity)
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(4; "Date Added"; Date)
        {
            Caption = 'Date Added';
            DataClassification = CustomerContent;
        }

        field(5; "Active"; Boolean)
        {
            Caption = 'Active';
            DataClassification = CustomerContent;
            InitValue = true;
        }

    }

    keys
    {
        key(PK; "Property No.", "Amenity ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Amenity ID", Description)
        {
        }
    }

}
