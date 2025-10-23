table 50133 "Tenant Application"
{
    LookupPageId = "Tenant Application List";
    DrillDownPageId = "Tenant Application List";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Application ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Tenant Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(3; "Tenant Type"; Enum "Tenant Type")
        {
            Caption = 'Tenant Type';
            DataClassification = CustomerContent;
        }
        field(4; "National ID/Passport"; Text[30])
        {
            Caption = 'National ID/Passport';
            DataClassification = CustomerContent;
        }
        field(5; "Company Registration No."; Text[30])
        {
            Caption = 'Company Registration No.';
            DataClassification = CustomerContent;
        }
        field(6; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
            DataClassification = CustomerContent;
        }
        field(7; "Tenant Category"; Enum "Tenant Category")
        {
            Caption = 'Tenant Category';
            DataClassification = CustomerContent;
        }
        field(8; "Tenant Status"; Enum "Tenant Status")
        {
            Caption = 'Tenant Status';
            DataClassification = CustomerContent;
        }
        field(9; "Tenant Application Status"; Enum "Tenant Application Status")
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Unit No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Unit;
        }

    }

    keys
    {
        key(PK; "Application ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }




    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
        PropertySetup: Record "Property Setup";
    begin
        if "Application ID" = '' then
            PropertySetup.Get();
        PropertySetup.TestField("Application ID");
        Rec."Application ID" := NoSeries.GetNextNo(PropertySetup."Application ID", 0D, true)



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