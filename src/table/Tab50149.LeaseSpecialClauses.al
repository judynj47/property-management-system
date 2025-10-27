table 50149 "Lease Special Clauses"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Lease No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Lease."No.";
        }
        field(2; "Clause ID"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Special Clauses"."Clause ID";

            trigger OnValidate()
            var
                ClauseRec: Record "Special Clauses";
            begin
                if ClauseRec.Get("Clause ID") then
                    Rec."Clause Description" := ClauseRec."Clause Description";
            end;


        }

        field(3; "Clause Description"; Text[200])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Lease No.", "Clause ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Clause ID", "Clause Description")
        {
        }
        // Add changes to field groups here
    }




}