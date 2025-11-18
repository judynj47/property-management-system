table 50106 Unit
{
    DataClassification = CustomerContent;
    Caption = 'Unit';
    DrillDownPageId = "Unit List";
    LookupPageId = "Unit List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Unit No.';
            DataClassification = CustomerContent;
        }
        field(2; "Property No."; Code[20])
        {
            Caption = 'Property No.';
            DataClassification = CustomerContent;
            TableRelation = Property;

            trigger OnValidate()
            var
                PropertyUnit: Record "Property Unit";
            begin
                // Delete old Property Unit record if Property No. was changed
                if (xRec."Property No." <> '') and (xRec."Property No." <> "Property No.") then begin
                    if PropertyUnit.Get(xRec."Property No.", "No.") then
                        PropertyUnit.Delete();
                end;

                // Create/Update Property Unit record when Property No. is entered
                if "Property No." <> '' then begin
                    if not PropertyUnit.Get("Property No.", "No.") then begin
                        PropertyUnit.Init();
                        PropertyUnit."Property No." := "Property No.";
                        PropertyUnit."Unit No." := "No.";
                    end;
                    PropertyUnit.Description := Description;
                    PropertyUnit."Unit Size" := "Unit Size";
                    PropertyUnit."Unit Status" := "Unit Status";
                    PropertyUnit."Date Available" := "Date Available";
                    PropertyUnit."Rent Amount" := "Rent Amount";

                    if not PropertyUnit.Insert() then
                        PropertyUnit.Modify();
                end;
            end;
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
            Editable = false;
        }
        field(6; "Rent Amount"; Decimal)
        {
            Caption = 'Rent Amount';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(8; "Lease No."; Code[20])
        {
            Editable = false;
            Caption = 'Lease No.';
            DataClassification = CustomerContent;
        }
        field(9; "Date Available"; Date)
        {
            Caption = 'Date Available';
            DataClassification = CustomerContent;
        }
        field(10; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(11; "Penalty Charge"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 1 : 1;
        }
        field(12; "Service Charge"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Utility Charge"; Decimal)
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
    begin
        if "No." = '' then begin
            PropertySetup.Get();
            PropertySetup.TestField("Unit No.");
            "No." := NoSeriesMgt.GetNextNo(PropertySetup."Unit No.", 0D, true);
        end;
    end;

    trigger OnModify()
    var
        PropertyUnit: Record "Property Unit";
    begin
        CalculatePenalty();

        // Sync changes to Property Unit table
        if "Property No." <> '' then begin
            if PropertyUnit.Get("Property No.", "No.") then begin
                PropertyUnit.Description := Description;
                PropertyUnit."Unit Size" := "Unit Size";
                PropertyUnit."Unit Status" := "Unit Status";
                PropertyUnit."Date Available" := "Date Available";
                PropertyUnit."Rent Amount" := "Rent Amount";
                PropertyUnit."Penalty Charge" := "Penalty Charge";
                PropertyUnit.Modify();
            end;
        end;
    end;

    local procedure CalculatePenalty()
    begin
        if "Rent Amount" > 0 then
            "Penalty Charge" := ("Rent Amount" * 0.1)
        else
            "Penalty Charge" := 0;
    end;
}
