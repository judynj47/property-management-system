page 50158 "Rent Invoice Card"
{
    PageType = Document;
    SourceTable = "Rent Invoice";
    Editable = true;

    layout
    {
        area(Content)
        {
            group("Receipt Details")
            {
                field("No."; Rec."Rent Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Lease No."; Rec."Lease No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lease No. field.', Comment = '%';
                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tenant No. field.', Comment = '%';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tenant Name field.', Comment = '%';
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Mode field.', Comment = '%';
                }
                field("Receipt Amount"; Rec."Receipt Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Receipt Amount field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Date Invoiced"; Rec."Date Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date Invoiced field.', Comment = '%';
                }
                field("Posted Date"; Rec."Posted Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Date field.', Comment = '%';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Status field.', Comment = '%';
                }
            }

            part(Lines; "Tenant Receipt Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("Rent Invoice No.");
            }
        }
    }


}
