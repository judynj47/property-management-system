page 50157 "Tenant Receipt Subform"
{
    PageType = ListPart;
    SourceTable = "Tenant Receipt Line";
    Caption = 'Receipt Lines';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }
                field("Lease No."; Rec."Lease No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lease No. field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
            }
        }
    }
}
