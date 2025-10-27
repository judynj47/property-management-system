page 50150 "Special Clauses Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Lease Special Clauses";
    DelayedInsert = true;
    

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Clause ID"; Rec."Clause ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clause ID field.', Comment = '%';
                }
                field("Clause Description"; Rec."Clause Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clause Description field.', Comment = '%';
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Lease No." := Rec."Lease No."; // ensures linking to parent record
    end;
}