page 50128 "Unit List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Unit;
    CardPageId = "Unit Card";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the Unit No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Unit Size"; Rec."Unit Size")
                {
                    ToolTip = 'Specifies the value of the Unit Size (sq. m) field.', Comment = '%';
                }
                field("Unit Status"; Rec."Unit Status")
                {
                    ToolTip = 'Specifies the value of the Unit Status field.', Comment = '%';
                }
                field("Date Available"; Rec."Date Available")
                {
                    ToolTip = 'Specifies the value of the Date Available field.', Comment = '%';
                }
                field("Rent Amount"; Rec."Rent Amount")
                {
                    ToolTip = 'Specifies the value of the Rent Amount field.', Comment = '%';
                }

            }
        }
        // area(Factboxes)
        // {

        // }
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