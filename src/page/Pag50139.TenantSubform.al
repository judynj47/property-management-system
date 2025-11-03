page 50140 "Tenant Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Tenant Unit Link";
    Editable = false;
    //SourceTable = Customer;
    //CardPageId = "Customer Card";

    layout
    {
        area(Content)
        {
            repeater(Tenants)
            {
                field("No."; Rec."Tenant No.")
                {

                    //TableRelation = "Tenant Application";
                    ToolTip = 'Specifies the number of the vendor. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';

                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ToolTip = 'Specifies the value of the Tenant Name field.', Comment = '%';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Lease Start Date field.', Comment = '%';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the Lease End Date field.', Comment = '%';
                }
                field("Rent Amount"; Rec."Rent Amount")
                {
                    ToolTip = 'Specifies the value of the Rent Amount field.', Comment = '%';
                }
                // field(Name; Rec.Name)
                // {
                //     ToolTip = 'Specifies the vendor''s name. You can enter a maximum of 30 characters, both numbers and letters.';
                // }

                // field("National ID/Passport"; Rec."National ID/Passport")
                // {
                //     ToolTip = 'Specifies the value of the National ID/Passport field.', Comment = '%';
                // }
                // field("Company Registration No."; Rec."Company Registration No.")
                // {
                //     ToolTip = 'Specifies the value of the Company Registration No. field.', Comment = '%';
                // }
                // field("Tenant Type"; Rec."Tenant Type")
                // {
                //     ToolTip = 'Specifies the value of the Tenant Type field.', Comment = '%';
                // }
                // field("Tenant Category"; Rec."Tenant Category")
                // {
                //     ToolTip = 'Specifies the value of the Tenant Category field.', Comment = '%';
                // }
                // field("Tenant Status"; Rec."Tenant Status")
                // {
                //     ToolTip = 'Specifies the value of the Tenant Status field.', Comment = '%';
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

    }


}