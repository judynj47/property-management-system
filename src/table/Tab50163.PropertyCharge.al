table 50163 "Property Charge"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Property No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Property;
        }
        field(2; "Charge ID"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Charge Setup"."Charge ID";
        }
        field(3; "Charge Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Charge Type"; Enum "Charge Type")
        {
            DataClassification = CustomerContent;
        }
        field(6; "GL Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'G/L Account';
        }
    }

    keys
    {
        key(Key1; "Property No.", "Charge ID")
        {
            Clustered = true;
        }
        key(Key2; "Property No.", "Charge Type")
        {
        }
    }

    trigger OnInsert()
    var
        ChargeSetup: Record "Charge Setup";
    begin
        if ChargeSetup.Get("Charge ID") then begin
            "Charge Description" := ChargeSetup."Charge Description";
            "Charge Type" := ChargeSetup."Charge Type";
            "GL Account No." := ChargeSetup."GL Account No.";

            // if Amount = 0 then
            //     Amount := ChargeSetup."Default Amount";
        end;
    end;
}