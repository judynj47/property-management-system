table 50160 "Maintenance Request"
{
    DataClassification = CustomerContent;
    Caption = 'Maintenance Request';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            DataClassification = CustomerContent;
            TableRelation = Unit;

            trigger OnValidate()
            var
                UnitRec: Record Unit;
            begin
                if "Unit No." <> '' then begin
                    if UnitRec.Get("Unit No.") then begin
                        "Property No." := UnitRec."Property No.";
                        Description := UnitRec.Description;
                    end;
                end else begin
                    Clear("Property No.");
                    Clear(Description);
                end;
            end;
        }
        field(3; "Property No."; Code[20])
        {
            Caption = 'Property No.';
            DataClassification = CustomerContent;
            TableRelation = Property;
            Editable = false;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; "Maintenance Type"; Enum "Maintenance Type")
        {
            Caption = 'Maintenance Type';
            DataClassification = CustomerContent;
        }
        field(6; Status; Enum "Maintenance Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(7; "Request Date"; Date)
        {
            Caption = 'Request Date';
            DataClassification = CustomerContent;
        }
        field(8; "Completed Date"; Date)
        {
            Caption = 'Completed Date';
            DataClassification = CustomerContent;
        }
        field(9; Priority; Enum "Maintenance Priority")
        {
            Caption = 'Priority';
            DataClassification = CustomerContent;
        }
        field(10; "Request Details"; Text[500])
        {
            Caption = 'Request Details';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Unit; "Unit No.") { }
        key(Status; Status) { }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit "No. Series";
        PropertySetup: Record "Property Setup";
    begin
        if "No." = '' then begin
            PropertySetup.Get();
            PropertySetup.TestField("Maintenance Request Nos.");
            "No." := NoSeriesMgt.GetNextNo(PropertySetup."Maintenance Request Nos.", 0D, true);
        end;

        if "Request Date" = 0D then
            "Request Date" := Today;

        if Status = Status::" " then
            Status := Status::Open;
    end;

    trigger OnModify()
    begin
        UpdateUnitStatus();
    end;

    local procedure UpdateUnitStatus()
    var
        UnitRec: Record Unit;
    begin
        if "Unit No." = '' then
            exit;

        if not UnitRec.Get("Unit No.") then
            exit;

        case Status of
            Status::Open, Status::"In Progress":
                begin
                    if UnitRec."Unit Status" <> UnitRec."Unit Status"::"Under Maintenance" then begin
                        UnitRec."Unit Status" := UnitRec."Unit Status"::"Under Maintenance";
                        UnitRec.Modify(true);
                    end;
                end;
            Status::Completed, Status::Cancelled:
                begin
                    if UnitRec."Unit Status" = UnitRec."Unit Status"::"Under Maintenance" then begin
                        // Return to previous status or default to Available
                        UnitRec."Unit Status" := UnitRec."Unit Status"::Available;
                        UnitRec.Modify(true);
                    end;
                end;
        end;
    end;
}