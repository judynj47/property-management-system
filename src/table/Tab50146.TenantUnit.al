table 50146 "Tenant Unit Link"
{
    Caption = 'Tenant Unit Link';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Tenant No."; Code[20])
        {
            Caption = 'Tenant No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                CustRec: Record Customer;
            begin
                if CustRec.Get("Tenant No.") then
                    Rec."Tenant Name" := CustRec.Name
                else
                    Clear("Tenant Name");
            end;
        }

        field(2; "Tenant Name"; Text[100])
        {
            DataClassification = CustomerContent;
            //TableRelation = Customer."Name" where("Name" = field("Tenant Name"));

        }

        field(3; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            TableRelation = Unit;
        }

        field(4; "Start Date"; Date)
        {
            Caption = 'Lease Start Date';
            TableRelation = Lease."Start Date" where("Start Date" = field("Start Date"));
        }

        field(5; "End Date"; Date)
        {
            Caption = 'Lease End Date';
            TableRelation = Lease."End Date" where("End Date" = field("End Date"));
        }
        field(6; "Rent Amount"; Decimal)
        {
            TableRelation = Lease."Rent Amount" where("Rent Amount" = field("Rent Amount"));
        }
    }

    keys
    {
        key(PK; "Unit No.", "Tenant No.")
        {
            Clustered = true;
        }
    }
}
