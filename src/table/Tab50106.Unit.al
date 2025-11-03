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
                IsInserted: Boolean;

            begin
                // Delete old link if Property No. was changed
                if xRec."Property No." <> '' then begin
                    PropertyUnit.Reset();
                    PropertyUnit.SetRange("Unit No.", Rec."No.");
                    PropertyUnit.DeleteAll();
                end;

                // Insert new Property Unit record when Property No. is entered
                if "Property No." <> '' then begin
                    PropertyUnit.Init();
                    PropertyUnit."Property No." := "Property No.";
                    PropertyUnit."Unit No." := "No.";
                    PropertyUnit.Description := Description;
                    PropertyUnit."Unit Size" := "Unit Size";
                    PropertyUnit."Unit Status" := "Unit Status";
                    PropertyUnit."Date Available" := "Date Available";
                    PropertyUnit."Rent Amount" := "Rent Amount";
                    PropertyUnit.Insert(true);
                end;


            end;
        }

        // field(2; "Property No."; Code[20])
        // {
        //     Caption = 'Property No.';
        //     DataClassification = CustomerContent;
        //     TableRelation = Property;
        // }
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
            TableRelation = Lease;
            trigger OnValidate()
            var
                LeaseRec: Record Lease;
                IsInserted: Boolean;
            begin
                if xRec."No." <> '' then begin
                    LeaseRec.Reset();
                    LeaseRec.SetRange("No.", Rec."Lease No.");
                    LeaseRec.DeleteAll();
                end;
                if "No." <> '' then begin
                    LeaseRec.Init();
                    LeaseRec."No." := "Lease No.";
                    LeaseRec."Rent Amount" := "Rent Amount";
                    LeaseRec.Insert(true);
                end;

            end;

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
    }

    keys
    {
        key(PK; "No.")
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
        NoSeriesMgt: Codeunit "No. Series";
        PropertySetup: Record "Property Setup";

    begin

        if "No." = '' then
            PropertySetup.Get();
        PropertySetup.TestField("Unit No.");

        Rec."No." := NoSeriesMgt.GetNextNo(PropertySetup."Unit No.", 0D, true)

    end;





}