table 50145 "Property Unit"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Property No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Property;
        }
        field(2; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            DataClassification = CustomerContent;
            TableRelation = Unit where("Property No." = field("Property No."));

            trigger OnValidate()
            var
                PropertyUnit: Record "Property Unit";
            begin
                // Check if this Unit No. already exists for any property
                PropertyUnit.Reset();
                PropertyUnit.SetRange("Unit No.", Rec."Unit No.");
                PropertyUnit.SetFilter("Property No.", '<>%1', Rec."Property No.");
                if not PropertyUnit.IsEmpty then
                    Error('The unit no %1 has already been used for another property. Kindly select another unit to continue!', Rec."Unit No.");
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
        }
        field(6; "Rent Amount"; Decimal)
        {
            Caption = 'Rent Amount';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(7; "Date Available"; Date)
        {
            Caption = 'Date Available';
            DataClassification = CustomerContent;
        }
        field(8; "Penalty Charge"; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Property No.", "Unit No.")
        {
            Clustered = true;
        }
    }

    // Simplified ValidateUnitNo procedure
    procedure ValidateUnitNo(PropertyNo: Code[20])
    var
        PropertyUnit: Record "Property Unit";
        UnitCount: Integer;
    begin
        PropertyUnit.Reset();
        PropertyUnit.SetRange("Property No.", PropertyNo);
        if PropertyUnit.FindSet() then begin
            repeat
                UnitCount := 0;
                PropertyUnit.Reset();
                PropertyUnit.SetRange("Unit No.", PropertyUnit."Unit No.");
                UnitCount := PropertyUnit.Count;
                if UnitCount > 1 then begin
                    Error('The Unit No %1 is used %2 times across all properties',
                          PropertyUnit."Unit No.", Format(UnitCount));
                end;
            until PropertyUnit.Next() = 0;
        end;
    end;
}
// table 50145 "Property Unit"
// {
//     DataClassification = CustomerContent;

//     fields
//     {
//         field(1; "Property No."; Code[20])
//         {
//             DataClassification = ToBeClassified;
//             TableRelation = Property;

//         }
//         field(2; "Unit No."; Code[20])
//         {
//             Caption = 'Unit No.';
//             DataClassification = CustomerContent;
//             TableRelation = Unit where("Property No." = field("Property No."));

//             trigger OnValidate()
//             var
//                 PropertyUnit: Record "Property Unit";
//                 Num: Integer;
//             begin
//                 Num := 0;
//                 PropertyUnit.Reset();
//                 PropertyUnit.SetFilter("Property No.", '<>%1', '');
//                 PropertyUnit.SetRange("Unit No.", Rec."Unit No.");
//                 Num := PropertyUnit.Count;
//                 if Num > 1 then begin
//                     Error('The unit no has already used %1, kindly select another unit to continue!', Format(Num));
//                 end;
//             end;
//         }
//         field(3; Description; Text[100])
//         {
//             Caption = 'Description';
//             DataClassification = CustomerContent;
//         }
//         field(4; "Unit Size"; Decimal)
//         {
//             Caption = 'Unit Size (sq. m)';
//             DataClassification = CustomerContent;
//             DecimalPlaces = 2 : 2;
//         }
//         field(5; "Unit Status"; Enum "Unit Status")
//         {
//             Caption = 'Unit Status';
//             DataClassification = CustomerContent;
//         }
//         field(6; "Rent Amount"; Decimal)
//         {
//             Caption = 'Rent Amount';
//             DataClassification = CustomerContent;
//             AutoFormatType = 1;
//         }
//         field(7; "Date Available"; Date)
//         {
//             Caption = 'Date Available';
//             DataClassification = CustomerContent;
//         }


//     }

//     keys
//     {
//         key(PK; "Property No.", "Unit No.")
//         {
//             Clustered = true;
//         }
//     }

//     fieldgroups
//     {
//         // Add changes to field groups here
//     }

//     var
//         myInt: Integer;

//     trigger OnInsert()
//     begin

//     end;

//     trigger OnModify()
//     begin

//     end;

//     trigger OnDelete()
//     begin

//     end;

//     trigger OnRename()
//     begin

//     end;

//     //check dictionaries for avoiding duplicates
//     procedure ValidateUnitNo(PropertyNo: Code[20])
//     var
//         PropertyUnit: Record "Property Unit";
//         UnitList: Record "Property Unit";
//         Num: Integer;
//     begin
//         PropertyUnit.Reset();
//         PropertyUnit.SetRange("Property No.", PropertyNo);
//         if PropertyUnit.FindSet() then begin
//             repeat
//                 Num := 0;
//                 UnitList.Reset();
//                 // UnitList.SetRange("Property No.", PropertyUnit."Property No.");
//                 UnitList.SetRange("Unit No.", PropertyUnit."Unit No.");
//                 if UnitList.FindSet() then begin
//                     repeat
//                         Num := Num + 1;
//                     until UnitList.Next() = 0;
//                 end;
//                 if Num > 1 then begin
//                     Error('The Unit No %1 has already used %2 times', UnitList."Unit No.", Format(Num));
//                 end;
//             until PropertyUnit.Next() = 0;
//         end;
//     end;

// }