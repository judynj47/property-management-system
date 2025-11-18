page 50173 "Draft Leases"
{
    Caption = 'All leases';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Lease;
    CardPageId = "Lease Agreement Card";
    //SourceTableView = where("Lease Status" = filter(Draft));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the Lease No. field.', Comment = '%';
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ToolTip = 'Specifies the value of the Unit No. field.', Comment = '%';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                }
                field("Lease Status"; Rec."Lease Status")
                {
                    ToolTip = 'Specifies the value of the Lease Status field.', Comment = '%';
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