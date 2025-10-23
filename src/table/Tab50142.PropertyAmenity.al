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
                aty: Record Amenity;
            begin
                if aty.Get("Amenity ID") then
                    Rec.Description := aty.Amenity;
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

    // trigger OnInsert()
    // var
    //     PropertyRec: Record Property;
    //     AmenityRec: Record Amenity;
    // begin
    //     if not PropertyRec.Get("Property No.") then
    //         Error('Property %1 does not exist.', "Property No.");

    //     if not AmenityRec.Get("Amenity ID") then
    //         Error('Amenity %1 does not exist.', "Amenity ID");

    //     if "Date Added" = 0D then
    //         "Date Added" := Today;
    // end;
}
