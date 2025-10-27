page 50151 "Special Clauses List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Special Clauses";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Clause ID"; Rec."Clause ID")
                {
                    ToolTip = 'Specifies the value of the Clause ID field.', Comment = '%';
                }
                field("Clause Description"; Rec."Clause Description")
                {
                    ToolTip = 'Specifies the value of the Clause Description field.', Comment = '%';
                }
            }
        }

    }


}