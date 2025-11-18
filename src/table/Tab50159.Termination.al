table 50159 Termination
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Termination ID"; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(2; "Termination Reason"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Tenant No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            trigger OnValidate()
            var
                TenantRec: Record Customer;
            begin
                if TenantRec.Get("Tenant No.") then begin
                    "Tenant No." := TenantRec."No.";
                    "Tenant Name" := TenantRec.Name;
                end;

            end;
        }
        field(4; "Tenant Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Owner No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
            trigger OnValidate()
            var
                OwnerRec: Record Customer;
            begin
                if OwnerRec.Get("Owner No.") then begin
                    "Owner No." := OwnerRec."No.";
                    "Owner Name" := OwnerRec.Name;
                end;

            end;
        }
        field(6; "Owner Name"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Unit No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Unit;
        }

        field(8; "Deposit Refund Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Termination Date"; Date)
        {
            Caption = 'Termination Date';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "Termination ID")
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
    var
        NoSeriesMgt: Codeunit "No. Series";
        PropertySetup: Record "Property Setup";
    begin

        if "Termination ID" = '' then begin
            PropertySetup.Get();
            PropertySetup.TestField("Termination ID");
            "Termination ID" := NoSeriesMgt.GetNextNo(PropertySetup."Termination ID", 0D, true);
        end;
    end;


    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}