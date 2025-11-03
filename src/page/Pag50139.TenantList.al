page 50139 "Tenant List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Customer;
    SourceTableView = where("Tenant Category" = filter('Commercial|Residential'));
    CardPageId = "Customer Card";

    layout
    {
        area(Content)
        {
            repeater(Tenants)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the vendor. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the vendor''s name. You can enter a maximum of 30 characters, both numbers and letters.';
                }
                // field(Address; Rec.Address)
                // {
                //     ToolTip = 'Specifies the value of the Address field.', Comment = '%';
                // }
                // field("Address 2"; Rec."Address 2")
                // {
                //     ToolTip = 'Specifies the value of the Address 2 field.', Comment = '%';
                // }
                field("National ID/Passport"; Rec."National ID/Passport")
                {
                    ToolTip = 'Specifies the value of the National ID/Passport field.', Comment = '%';
                }
                field("Company Registration No."; Rec."Company Registration No.")
                {
                    ToolTip = 'Specifies the value of the Company Registration No. field.', Comment = '%';
                }
                field("Tenant Type"; Rec."Tenant Type")
                {
                    ToolTip = 'Specifies the value of the Tenant Type field.', Comment = '%';
                }
                field("Tenant Category"; Rec."Tenant Category")
                {
                    ToolTip = 'Specifies the value of the Tenant Category field.', Comment = '%';
                }
                field("Tenant Status"; Rec."Tenant Status")
                {
                    ToolTip = 'Specifies the value of the Tenant Status field.', Comment = '%';
                }
                // field("Date of Birth"; Rec."Date of Birth")
                // {
                //     ToolTip = 'Specifies the value of the Date of Birth field.', Comment = '%';
                // }
                // field("Move-in Date"; Rec."Move-in Date")
                // {
                //     ToolTip = 'Specifies the value of the Move-in Date field.', Comment = '%';
                // }
                // field("Move-out Date"; Rec."Move-out Date")
                // {
                //     ToolTip = 'Specifies the value of the Move-out Date field.', Comment = '%';
                // }
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