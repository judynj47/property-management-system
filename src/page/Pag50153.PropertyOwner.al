page 50153 "Property Owner Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = "Property Owner";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                // field("Owner No."; Rec."Owner No.")
                // {
                //     ToolTip = 'Specifies the value of the Owner No. field.', Comment = '%';
                // }
                field("Property No."; Rec."Property No.")
                {
                    ToolTip = 'Specifies the value of the Property No. field.', Comment = '%';
                    trigger OnValidate()
                    var
                        PropertyRec: Record Property;
                    begin
                        if PropertyRec.Get(Rec."Property No.") then
                            Rec.Description := PropertyRec."Property Name";
                    end;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }

            }
        }

    }

}