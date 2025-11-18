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
            TableRelation = Customer."No." where("Tenant Category" = filter('Residential|Commercial'));

            trigger OnValidate()
            var
                CustRec: Record Customer;
                TenantUnitRec: Record "Tenant Unit Link";
                UnitRec: Record Unit;
                PropertyRec: Record Property;
            begin
                // Fetch tenant details from Customer table extension
                if CustRec.Get("Tenant No.") then begin
                    "Tenant Name" := CustRec.Name;
                    "Unit No." := CustRec."Unit No.";
                    "Property No." := CustRec."Current Property No.";
                    "Rent Amount" := CustRec."Rent Amount";

                    // Get Property Name and Owner details from Property table
                    if "Property No." <> '' then begin
                        if PropertyRec.Get("Property No.") then begin
                            "Property Name" := PropertyRec."Property Name";
                            "Owner No." := PropertyRec."Owner No.";

                            // Get Owner Name from Vendor table
                            UpdateOwnerName();


                        end;
                    end else begin
                        Clear("Property Name");
                        Clear("Owner No.");
                        Clear("Owner Name");
                        Clear("Utility Charge");
                        Clear("Service Charge");
                    end;

                    // Update rent amount from unit if not set in customer
                    if "Rent Amount" = 0 then
                        UpdateRentAmountFromUnit();

                end else begin
                    // Clear all fields if tenant not found
                    Clear("Tenant Name");
                    Clear("Unit No.");
                    Clear("Property No.");
                    Clear("Property Name");
                    Clear("Owner No.");
                    Clear("Owner Name");
                    Clear("Rent Amount");
                    Clear("Utility Charge");
                    Clear("Service Charge");
                end;

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
                    TenantUnitRec."Move-in Date" := "Start Date";
                    TenantUnitRec."Move-out Date" := "End Date";
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
            begin
                if PropertyRec.Get("Property No.") then begin
                    "Property Name" := PropertyRec."Property Name";
                    "Owner No." := PropertyRec."Owner No.";
                    UpdateOwnerName();

                    // Auto-calculate utility and service charges when property changes
                    //CalculateUtilityAndServiceCharges();
                end else begin
                    Clear("Property Name");
                    Clear("Owner No.");
                    Clear("Owner Name");
                    Clear("Utility Charge");
                    Clear("Service Charge");
                end;
            end;
        }
        field(4; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            DataClassification = CustomerContent;
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
        field(13; "Utility Charge"; Decimal)
        {
            Caption = 'Utility Charge';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Editable = false;

            trigger OnValidate()
            var
                PropertyChargeRec: Record "Property Charge";
                TotalUtilityCharge: Decimal;
            begin
                // Calculate total utility charges for this property
                TotalUtilityCharge := 0;
                PropertyChargeRec.Reset();
                PropertyChargeRec.SetRange("Property No.", "Property No.");
                PropertyChargeRec.SetRange("Charge Type", PropertyChargeRec."Charge Type"::Utility);
                if PropertyChargeRec.FindSet() then begin
                    repeat
                        TotalUtilityCharge += PropertyChargeRec.Amount;
                    until PropertyChargeRec.Next() = 0;
                    "Utility Charge" := TotalUtilityCharge;
                end else begin
                    Clear("Utility Charge");
                end;
            end;
        }
        field(27; "Service Charge"; Decimal)
        {
            Caption = 'Service Charge';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Editable = false;

            trigger OnValidate()
            var
                PropertyChargeRec: Record "Property Charge";
                TotalServiceCharge: Decimal;
            begin
                // Calculate total service charges for this property
                TotalServiceCharge := 0;
                PropertyChargeRec.Reset();
                PropertyChargeRec.SetRange("Property No.", "Property No.");
                PropertyChargeRec.SetRange("Charge Type", PropertyChargeRec."Charge Type"::Service);
                if PropertyChargeRec.FindSet() then begin
                    repeat
                        TotalServiceCharge += PropertyChargeRec.Amount;
                    until PropertyChargeRec.Next() = 0;
                    "Service Charge" := TotalServiceCharge;
                end else begin
                    Clear("Service Charge");
                end;
            end;
        }
        // field(28; "Total Additional Charges"; Decimal)
        // {
        //     Caption = 'Total Additional Charges';
        //     DataClassification = CustomerContent;
        //     AutoFormatType = 1;
        //     Editable = false;
        // }
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
        }
        field(26; "Property Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit "No. Series";
        PropertySetup: Record "Property Setup";
        UnitRec: Record Unit;
        CustomerRec: Record Customer;
    begin
        // Assign Lease No if empty
        if "No." = '' then begin
            PropertySetup.Get();
            PropertySetup.TestField("Lease No.");
            "No." := NoSeriesMgt.GetNextNo(PropertySetup."Lease No.", 0D, true);
        end;

        // Update the Unit with the Lease No.
        if "Unit No." <> '' then begin
            if UnitRec.Get("Unit No.") then begin
                UnitRec."Lease No." := "No.";
                UnitRec.Modify(false);
            end;
        end;

        // Update Customer with current lease information
        if "Tenant No." <> '' then begin
            if CustomerRec.Get("Tenant No.") then begin
                CustomerRec."Current Lease No." := "No.";
                CustomerRec."Current Unit No." := "Unit No.";
                CustomerRec."Current Property No." := "Property No.";
                CustomerRec."Move-in Date" := "Start Date";
                CustomerRec."Rent Amount" := "Rent Amount";
                CustomerRec."Security Deposit Amount" := "Security Deposit";
                CustomerRec.Modify(false);
            end;
        end;
        CalculateChargesFromProperty();

    end;

    trigger OnModify()
    var
        UnitRec: Record Unit;
        CustomerRec: Record Customer;
    begin
        // Update Unit Status based on Lease Status
        if "Unit No." <> '' then begin
            if UnitRec.Get("Unit No.") then begin
                case "Lease Status" of
                    "Lease Status"::Active, "Lease Status"::Renewed:
                        begin
                            UnitRec.Validate("Unit Status", UnitRec."Unit Status"::Occupied);
                            UnitRec.Modify(false);
                        end;
                    "Lease Status"::Expired, "Lease Status"::Terminated:
                        begin
                            UnitRec.Validate("Unit Status", UnitRec."Unit Status"::Vacant);
                            UnitRec.Modify(false);
                        end;
                end;
            end;
        end;

        // Update Customer information when lease changes
        if "Tenant No." <> '' then begin
            if CustomerRec.Get("Tenant No.") then begin
                CustomerRec."Current Lease No." := "No.";
                CustomerRec."Current Unit No." := "Unit No.";
                CustomerRec."Current Property No." := "Property No.";
                CustomerRec."Rent Amount" := "Rent Amount";

                // Update tenant status based on lease status
                case "Lease Status" of
                    "Lease Status"::Active, "Lease Status"::Renewed:
                        CustomerRec."Tenant Status" := CustomerRec."Tenant Status"::Active;
                    "Lease Status"::Expired, "Lease Status"::Terminated:
                        CustomerRec."Tenant Status" := CustomerRec."Tenant Status"::Past;
                end;

                CustomerRec.Modify(false);
            end;
        end;

        UpdateDuration();
        begin
            if (xRec."Property No." <> "Property No.") then
                CalculateChargesFromProperty();
        end;
    end;

    trigger OnDelete()
    var
        UnitRec: Record Unit;
        CustomerRec: Record Customer;
    begin
        // Clear Lease link from Unit
        if "Unit No." <> '' then begin
            if UnitRec.Get("Unit No.") then begin
                UnitRec.Validate("Lease No.", '');
                UnitRec.Validate("Unit Status", UnitRec."Unit Status"::Vacant);
                UnitRec.Modify(false);
            end;
        end;

        // Clear current lease info from Customer
        if "Tenant No." <> '' then begin
            if CustomerRec.Get("Tenant No.") then begin
                if CustomerRec."Current Lease No." = "No." then begin
                    CustomerRec."Current Lease No." := '';
                    CustomerRec."Current Unit No." := '';
                    CustomerRec."Current Property No." := '';
                    CustomerRec."Tenant Status" := CustomerRec."Tenant Status"::Past;
                    CustomerRec.Modify(false);
                end;
            end;
        end;
    end;

    local procedure UpdateDuration()
    begin
        if ("Start Date" <> 0D) and ("End Date" <> 0D) then
            Duration := ("End Date" - "Start Date") div 30;
    end;

    local procedure UpdateRentAmountFromUnit()
    var
        UnitRec: Record Unit;
    begin
        if "Unit No." <> '' then
            if UnitRec.Get("Unit No.") then
                "Rent Amount" := UnitRec."Rent Amount";
    end;

    local procedure UpdateOwnerName()
    var
        VendorRec: Record Vendor;
    begin
        if "Owner No." <> '' then begin
            if VendorRec.Get("Owner No.") then
                "Owner Name" := VendorRec.Name
            else
                Clear("Owner Name");
        end else begin
            Clear("Owner Name");
        end;
    end;




    local procedure CalculateChargesFromProperty()
    begin
        // This will trigger the OnValidate triggers which calculate the charges
        Validate("Utility Charge");
        Validate("Service Charge");
    end;

}