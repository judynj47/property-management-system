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
            Numeric = true;
        }
        field(5; "Company Registration No."; Text[30])
        {
            Caption = 'Company Registration No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                TenantApp: Record "Tenant Application";
            begin
                if Rec."Tenant Type" = Rec."Tenant Type"::Corporate then
                    if Rec."Company Registration No." = '' then
                        Error('Company Registration No. is required for corporate tenants.');


            end;
        }
        field(6; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
            DataClassification = CustomerContent;
            NotBlank = true;
            trigger OnValidate()
            begin
                if Rec."Date of Birth" = 0D then
                    exit;

                if Today() < CalcDate('<+18Y>', Rec."Date of Birth") then
                    Error('Applicant must be 18 years or older to apply for tenancy.');
            end;
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
            TableRelation = Unit where("Unit Status" = const("Unit Status"::Vacant));
        }
        field(11; "Customer Created"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
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
        if Rec."Application ID" = '' then begin
            PropertySetup.Get();
            PropertySetup.TestField("Application ID");
            Rec."Application ID" := NoSeries.GetNextNo(PropertySetup."Application ID", 0D, true);
        end;
        // begin
        //     ValidateId();
        // end;
    end;



    procedure ValidateId(ApplicationID: Code[20])
    var
        TenatApp: Record "Tenant Application";
    begin
        if TenatApp.Get(ApplicationID) then begin
            TenatApp.TestField("National ID/Passport");
            TenatApp.TestField("Tenant Name");
        end;
    end;

    trigger OnModify()
    var
        UnitRec: Record Unit;
    begin

        if "Tenant Application Status" = "Tenant Application Status"::Approved then begin
            if UnitRec.Get("Unit No.") then begin
                UnitRec.Validate("Unit Status", UnitRec."Unit Status"::Reserved);
                UnitRec.Modify(true);
            end;
        end;
    end;







}