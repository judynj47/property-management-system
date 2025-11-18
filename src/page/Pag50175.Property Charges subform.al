page 50176 "Property Charges Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Property Charge";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Charge ID"; Rec."Charge ID")
                {
                    ToolTip = 'Specifies the value of the Charge ID field.', Comment = '%';
                }
                field("Charge Description"; Rec."Charge Description")
                {
                    ToolTip = 'Specifies the value of the Charge Description field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    ToolTip = 'Specifies the value of the Charge Type field.', Comment = '%';
                    Editable = false;
                }
                field("GL Account No."; Rec."GL Account No.")
                {
                    ToolTip = 'Specifies the value of the G/L Account field.', Comment = '%';
                }
            }
        }

    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Charge ID" := Rec."Charge ID"; // ensures linking to parent record
    end;


}