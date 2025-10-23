page 50130 "Property Amenity Subpage"
{
    PageType = ListPart;
    SourceTable = "Property Amenity";
    Caption = 'Property Amenities';

    //AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Amenity ID"; Rec."Amenity ID")
                {
                    ApplicationArea = All;
                    // ToolTip = 'Specifies the amenity linked to this property.';
                    // trigger OnValidate()
                    // var
                    //     aty: Record "Property Amenity";
                    // begin
                    //     if aty.Get(Rec."Amenity ID") then
                    //         Rec.Description := aty.Description;
                    // end;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Date Added"; Rec."Date Added")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Active"; Rec."Active")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Property No." := Rec."Property No."; // ensures linking to parent record
    end;
}

// page 50130 "Amenity ListPart"
// {
//     PageType = ListPart;
//     ApplicationArea = All;
//     UsageCategory = Lists;
//     SourceTable = Amenity;

//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 field("Amenity ID"; Rec."Amenity ID")
//                 {
//                     TableRelation = Amenity;
//                     ToolTip = 'Specifies the value of the Amenity ID field.', Comment = '%';
//                 }
//                 field(Amenity; Rec.Amenity)
//                 {
//                     Editable = false;
//                     ToolTip = 'Specifies the value of the Amenity field.', Comment = '%';
//                 }
//             }
//         }
//         // area(Factboxes)
//         // {

//         // }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(ActionName)
//             {

//                 trigger OnAction()
//                 begin

//                 end;
//             }
//         }
//     }
// }