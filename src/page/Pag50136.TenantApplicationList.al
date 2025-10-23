page 50136 "Tenant Application List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Tenant Application";
    CardPageId = "Tenant Application Card";



    layout
    {
        area(Content)
        {
            repeater("Applicators list")
            {
                field("Application ID"; Rec."Application ID")
                {
                    ToolTip = 'Specifies the value of the Application ID field.', Comment = '%';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ToolTip = 'Specifies the value of the Tenant Name field.', Comment = '%';
                }
                
                field("National ID/Passport"; Rec."National ID/Passport")
                {
                    ToolTip = 'Specifies the value of the National ID/Passport field.', Comment = '%';
                }
                field("Company Registration No."; Rec."Company Registration No.")
                {
                    ToolTip = 'Specifies the value of the Company Registration No. field.', Comment = '%';
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ToolTip = 'Specifies the value of the Date of Birth field.', Comment = '%';
                }
                field("Tenant Application Status"; Rec."Tenant Application Status")
                {
                    ToolTip = 'Specifies the value of the Tenant Application Status field.', Comment = '%';
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