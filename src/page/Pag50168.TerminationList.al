page 50168 "Termination List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Termination;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Termination ID"; Rec."Termination ID")
                {
                    ToolTip = 'Specifies the value of the Termination ID field.', Comment = '%';
                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    ToolTip = 'Specifies the value of the Tenant No. field.', Comment = '%';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ToolTip = 'Specifies the value of the Tenant Name field.', Comment = '%';
                }
                field("Termination Reason"; Rec."Termination Reason")
                {
                    ToolTip = 'Specifies the value of the Termination Reason field.', Comment = '%';
                }
                field("Owner No."; Rec."Owner No.")
                {
                    ToolTip = 'Specifies the value of the Owner No. field.', Comment = '%';
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ToolTip = 'Specifies the value of the Owner Name field.', Comment = '%';
                }
                field("Deposit Refund Amount"; Rec."Deposit Refund Amount")
                {
                    ToolTip = 'Specifies the value of the Deposit Refund Amount field.', Comment = '%';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

}