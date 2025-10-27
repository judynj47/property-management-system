page 50131 "Amenity List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Amenity;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Amenity ID"; Rec."Amenity ID")
                {
                    ToolTip = 'Specifies the value of the Amenity ID field.', Comment = '%';
                }
                field(Amenity; Rec.Amenity)
                {
                    ToolTip = 'Specifies the value of the Amenity field.', Comment = '%';
                }
            }
        }

    }


}