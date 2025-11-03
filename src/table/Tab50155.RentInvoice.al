table 50155 "Rent Invoice"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Rent Invoice List";
    LookupPageId = "Rent Invoice List";

    fields
    {
        field(1; "Rent Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(2; "Tenant No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }
        field(3; "Tenant Name"; Text[50])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer.Name where(Name = field("Tenant Name"));
        }
        field(4; "Lease No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Lease."No.";
        }
        field(5; "Receipt Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Payment Mode"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Cash,Mpesa;
        }
        field(7; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Date Invoiced"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Posted Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Invoice","Receipt";
        }
        field(12; "Document Status"; Enum "Document Status")
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "Rent Invoice No.")
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

        if "Rent Invoice No." = '' then begin
            PropertySetup.Get();
            PropertySetup.TestField("Rent Invoice No.");
            Rec."Rent Invoice No." := NoSeriesMgt.GetNextNo(PropertySetup."Rent Invoice No.", 0D, true);
        end;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}