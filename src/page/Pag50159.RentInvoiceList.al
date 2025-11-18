page 50159 "Rent Invoice List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Rent Invoice";
    CardPageId = "Rent Invoice Card";
    SourceTableView = where("Document Type" = const(Invoice));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."Rent Invoice No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Lease No."; Rec."Lease No.")
                {
                    ToolTip = 'Specifies the value of the Lease No. field.', Comment = '%';
                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    ToolTip = 'Specifies the value of the Tenant No. field.', Comment = '%';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ToolTip = 'Specifies the value of the Tenant Name field.', Comment = '%';
                }
                field("Invoice Amount"; Rec."Receipt Amount")
                {
                    ToolTip = 'Specifies the value of the Receipt Amount field.', Comment = '%';
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }
}