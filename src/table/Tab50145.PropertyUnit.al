table 50145 "Property Unit"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Property No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Property;

        }
        field(2; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            DataClassification = CustomerContent;
            TableRelation = Unit;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(4; "Unit Size"; Decimal)
        {
            Caption = 'Unit Size (sq. m)';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(5; "Unit Status"; Enum "Unit Status")
        {
            Caption = 'Unit Status';
            DataClassification = CustomerContent;
        }
        field(6; "Rent Amount"; Decimal)
        {
            Caption = 'Rent Amount';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(7; "Date Available"; Date)
        {
            Caption = 'Date Available';
            DataClassification = CustomerContent;
        }


    }

    keys
    {
        key(PK; "Property No.", "Unit No.")
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