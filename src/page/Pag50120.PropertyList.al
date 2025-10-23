page 50120 "Property List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Property;
    CardPageId = "Property Card";
    Caption = 'Properties';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the property.';
                }
                field(Name; Rec."Property Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the property.';
                }
                field(Type; Rec."Property Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of property.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category of the property.';
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city of the property.';
                }
                field("Owner No."; Rec."Owner No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the owner of the property.';
                }
                field("Total Units"; Rec."Total Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of units in the property.';
                }
                field("Occupied Units"; Rec."Occupied Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of occupied units.';
                }
                field("Vacancy Rate"; Rec."Vacancy Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vacancy rate percentage.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Property Card")
            {
                ApplicationArea = All;
                Caption = 'Property Card';
                Image = Edit;
                RunObject = Page "Property Card";
                RunPageLink = "Property ID" = field("Property ID");
            }
        }
    }
}