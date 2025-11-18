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
        field(4; "National ID/Passport"; Text[8])
        {
            Caption = 'National ID/Passport';
            DataClassification = CustomerContent;
            Numeric = true;

            trigger OnValidate()
            var
                i: Integer;
                ch: Text[1];
            begin
                if StrLen(Rec."National ID/Passport") <> 8 then
                    Error('National ID/Passport must be exactly 8 digits.');

                for i := 1 to StrLen(Rec."National ID/Passport") do begin
                    ch := CopyStr(Rec."National ID/Passport", i, 1);
                    if (ch < '0') or (ch > '9') then
                        Error('National ID/Passport must contain only 8 digits');
                end;
            end;
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
        field(10; "Property Linked"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Property;
            Caption = 'Property';
        }
        field(11; "Unit No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Unit where("Property No." = field("Property Linked"),
                                      "Unit Status" = const(Vacant));
            Caption = 'Unit No.';

            trigger OnValidate()
            var
                UnitRec: Record Unit;
                PropertyUnitRec: Record "Property Unit";
            begin
                if "Unit No." <> '' then begin
                    // Get unit details from Unit table
                    if UnitRec.Get("Unit No.") then begin
                        // Auto-populate Property Linked from the unit
                        "Property Linked" := UnitRec."Property No.";

                        // Also update Property Unit record if it exists
                        if PropertyUnitRec.Get("Property Linked", "Unit No.") then begin
                            // Property Unit record exists, no action needed
                        end;
                    end else begin
                        Error('Unit %1 not found in the Unit table.', "Unit No.");
                    end;
                end else begin
                    Clear("Property Linked");
                end;
            end;
        }
        field(12; "Customer Created"; Boolean)
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
    end;

    procedure ValidateId(ApplicationID: Code[20])
    var
        TenantApp: Record "Tenant Application";
    begin
        if TenantApp.Get(ApplicationID) then begin
            //TenantApp.TestField("National ID/Passport");
            TenantApp.TestField("Tenant Name");
        end;
    end;

    trigger OnModify()
    var
        UnitRec: Record Unit;
        PropertyUnitRec: Record "Property Unit";
    begin
        if ("Tenant Application Status" = "Tenant Application Status"::Approved) or
           ("Tenant Application Status" = "Tenant Application Status"::"PendingApproval") then begin
            if "Unit No." <> '' then begin
                // Update Unit table
                if UnitRec.Get("Unit No.") then begin
                    UnitRec.Validate("Unit Status", UnitRec."Unit Status"::Reserved);
                    UnitRec.Modify(true);
                end;

                // Update Property Unit table
                if PropertyUnitRec.Get("Property Linked", "Unit No.") then begin
                    PropertyUnitRec."Unit Status" := PropertyUnitRec."Unit Status"::Reserved;
                    PropertyUnitRec.Modify(true);
                end;
            end;
        end;
    end;

}
