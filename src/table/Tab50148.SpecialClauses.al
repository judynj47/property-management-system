table 50148 "Special Clauses"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Clause ID"; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                clause: Record "Special Clauses";
            begin
                if clause.Get("Clause ID") then
                    "Clause Description" := clause."Clause Description";
            end;

        }
        field(2; "Clause Description"; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Lease No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Lease;
        }
    }

    keys
    {
        key(PK; "Clause ID")
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




    // trigger OnInsert()
    // var
    //     NoSeriesMgt: Codeunit "No. Series";
    //     PropertySetup: Record "Property Setup";

    // begin
    //     if "Clause ID" = '' then begin
    //         PropertySetup.Get();
    //         PropertySetup.TestField("Clause ID");
    //         "Clause ID" := NoSeriesMgt.GetNextNo(PropertySetup."Clause ID", 0D, true);
    //     end;



    // end;



}