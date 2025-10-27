page 50130 "Property Amenity Subpage"
{
    PageType = ListPart;
    SourceTable = "Property Amenity";
    Caption = 'Property Amenities';
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
