table 50116 "Lease"
{
    DataClassification = CustomerContent;
    Caption = 'Lease';
    DrillDownPageId = "Lease List";
    LookupPageId = "Lease List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Lease No.';
            DataClassification = CustomerContent;
        }
        field(2; "Tenant No."; Code[20])
        {
            Caption = 'Tenant No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;

            trigger OnValidate()
            var
                CustRec: Record Customer;
                TenantUnitRec: Record "Tenant Unit Link";
            begin
                // Fetch tenant name automatically
                if CustRec.Get("Tenant No.") then
                    "Tenant Name" := CustRec.Name
                else
                    Clear("Tenant Name");

                // Maintain Tenant-Unit relationship
                if xRec."Unit No." <> '' then begin
                    TenantUnitRec.Reset();
                    TenantUnitRec.SetRange("Tenant No.", xRec."Tenant No.");
                    TenantUnitRec.DeleteAll();
                end;

                if "Unit No." <> '' then begin
                    TenantUnitRec.Init();
                    TenantUnitRec."Tenant No." := "Tenant No.";
                    TenantUnitRec."Tenant Name" := "Tenant Name";
                    TenantUnitRec."Unit No." := "Unit No.";
                    TenantUnitRec."Start Date" := "Start Date";
                    TenantUnitRec."End Date" := "End Date";
                    TenantUnitRec."Rent Amount" := "Rent Amount";
                    TenantUnitRec.Insert(true);
                end;
            end;
        }


        field(3; "Property No."; Code[20])
        {
            Caption = 'Property No.';
            DataClassification = CustomerContent;
            TableRelation = Property;

            trigger OnValidate()
            var
                PropertyRec: Record Property;
                OwnerRec: Record Vendor;
            begin
                if PropertyRec.Get("Property No.") then begin
                    "Owner No." := PropertyRec."Owner No.";
                    if OwnerRec.Get(PropertyRec."Owner No.") then
                        "Owner Name" := OwnerRec.Name;
                end;

            end;
        }

        field(4; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            DataClassification = CustomerContent;
            //TableRelation = Unit;
            TableRelation = Unit where("Property No." = field("Property No."));


        }
        field(5; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = CustomerContent;
        }
        field(6; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
        }
        field(7; Duration; Integer)
        {
            Caption = 'Duration (Months)';
            DataClassification = CustomerContent;
        }
        field(8; "Rent Amount"; Decimal)
        {
            Caption = 'Rent Amount';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            //TableRelation = Unit."Rent Amount";
        }
        field(9; "Security Deposit"; Decimal)
        {
            Caption = 'Security Deposit';
            DataClassification = CustomerContent;

        }
        field(10; "Payment Frequency"; Enum "Payment Frequency")
        {
            Caption = 'Payment Frequency';
            DataClassification = CustomerContent;
        }
        field(11; "Escalation %"; Decimal)
        {
            Caption = 'Escalation %';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(12; "Renewal Option"; Enum "Renewal Option")
        {
            Caption = 'Renewal Option';
            DataClassification = CustomerContent;
        }
        field(13; "Utilities & Service Charges"; Decimal)
        {
            Caption = 'Utilities & Service Charges';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(14; "Lease Status"; Enum "Lease Status")
        {
            Caption = 'Lease Status';
            DataClassification = CustomerContent;
        }
        field(15; "Signed Date"; Date)
        {
            Caption = 'Signed Date';
            DataClassification = CustomerContent;
        }
        field(16; "Renewal Notice Period"; Integer)
        {
            Caption = 'Notice Period (Days)';
            DataClassification = CustomerContent;
        }
        field(17; "Auto Renew"; Boolean)
        {
            Caption = 'Auto Renew';
            DataClassification = CustomerContent;
        }
        field(18; "Renewal Count"; Integer)
        {
            Caption = 'Renewal Count';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(19; "Previous Lease No."; Code[20])
        {
            Caption = 'Previous Lease No.';
            DataClassification = CustomerContent;
            TableRelation = Lease;
        }
        field(20; "Created Date"; DateTime)
        {
            Caption = 'Created Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(21; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(22; "Owner No."; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
            //TableRelation = Vendor where("No." = field("Property No."));
        }
        field(23; "Renewal Notice Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(24; "Tenant Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(25; "Owner Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        // key(Tenant; "Tenant No.") { }
        // key(Unit; "Unit No.") { }
        // key(Status; "Lease Status") { }
        // key(Dates; "Start Date", "End Date") { }
    }

    // trigger OnInsert()
    // var
    //     NoSeriesMgt: Codeunit "No. Series";
    //     PropertySetup: Record "Property Setup";
    // begin

    //     if "No." = '' then
    //         PropertySetup.Get();
    //     PropertySetup.TestField("Lease No.");

    //     Rec."No." := NoSeriesMgt.GetNextNo(PropertySetup."Lease No.", 0D, true)

    // end;
    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit "No. Series";
        PropertySetup: Record "Property Setup";
        TenantUnitLink: Record "Tenant Unit Link";
        UnitRec: Record Unit;
    begin
        if "No." = '' then begin
            PropertySetup.Get();
            PropertySetup.TestField("Lease No.");
            "No." := NoSeriesMgt.GetNextNo(PropertySetup."Lease No.", 0D, true);
        end;

        if ("Tenant No." <> '') and ("Unit No." <> '') then begin
            TenantUnitLink.Init();
            TenantUnitLink."Tenant No." := "Tenant No.";
            TenantUnitLink."Unit No." := "Unit No.";
            TenantUnitLink."Start Date" := "Start Date";
            TenantUnitLink."End Date" := "End Date";
            TenantUnitLink."Rent Amount" := "Rent Amount";
            TenantUnitLink.Insert(true);
        end;

        // Update Unit Lease No.
        if "Unit No." <> '' then begin
            if UnitRec.Get("Unit No.") then begin
                UnitRec.Validate("Lease No.", "No.");
                UnitRec.Modify(true);
            end;
        end;
    end;




    // trigger OnModify()
    // begin
    //     UpdateDuration();
    // end;

    trigger OnModify()
    var
        UnitRec: Record Unit;
    begin
        if "Lease Status" = "Lease Status"::Active then begin
            if UnitRec.Get("Unit No.") then begin
                UnitRec.Validate("Unit Status", UnitRec."Unit Status"::Occupied);
                UnitRec.Modify();
            end;
        end else
            if "Lease Status" = "Lease Status"::Expired then begin
                if UnitRec.Get() then begin
                    UnitRec.Validate("Unit Status", UnitRec."Unit Status"::Vacant);
                    UnitRec.Modify();

                end;
            end;
        begin
            UpdateDuration();

        end;

    end;

    local procedure UpdateDuration()
    begin
        if ("Start Date" <> 0D) and ("End Date" <> 0D) then
            Duration := ("End Date" - "Start Date") div 30;
    end;


}