pageextension 50132 "Customer Card Tenant Ext" extends "Customer Card"
{
    layout
    {
        modify("Salesperson Code")
        {
            Visible = false;

        }
        modify("IC Partner Code")
        {
            Visible = false;

        }
        modify("Responsibility Center")
        {
            Visible = false;

        }
        modify("Service Zone Code")
        {
            Visible = false;

        }
        modify("Document Sending Profile")
        {
            Visible = false;

        }
        modify(TotalSales2)
        {
            Visible = false;

        }
        modify(AdjCustProfit)
        {
            Visible = false;

        }
        modify(AdjProfitPct)
        {
            Visible = false;

        }

        addlast(General)
        {

            field("Tenant Type"; Rec."Tenant Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the tenant type.';
            }
            field("Tenant Category"; Rec."Tenant Category")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the tenant category.';
            }
            field("Tenant Status"; Rec."Tenant Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the tenant status.';
            }
            field("National ID/Passport"; Rec."National ID/Passport")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the national ID or passport.';
            }
            field("Company Registration No."; Rec."Company Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the company registration number.';
            }
            field("Date of Birth"; Rec."Date of Birth")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date of birth.';
            }

            field("Rent Amount"; Rec."Rent Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Rent Amount field.', Comment = '%';
            }

            field(Tenant; Rec.Tenant)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tenant field.', Comment = '%';
                Caption = 'Unit Tenant';
            }


        }

        addlast("Address & Contact")
        {
            group(EmergencyContact)
            {
                Caption = 'Emergency Contact';
                Visible = ShowTenantDetails;

                field("Emergency Contact Name"; Rec."Emergency Contact Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the emergency contact name.';
                }
                field("Emergency Contact Phone"; Rec."Emergency Contact Phone")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the emergency contact phone.';
                }
                field("Emergency Contact Relation"; Rec."Emergency Contact Relation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the emergency contact relation.';
                }
            }
        }
        modify(PostingDetails)
        {
            Visible = true;
        }
        modify(PricesandDiscounts)
        {
            Visible = false;
        }
        modify(Shipping)
        {
            Visible = false;
        }
        modify(Interactions)
        {
            Visible = false;
        }


        addlast(Invoicing)
        {
            group(TenantOccupancy)
            {
                Caption = 'Occupancy Details';
                Visible = ShowTenantDetails;

                field("Current Property No."; Rec."Current Property No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current property.';
                    //Editable = false;
                }
                field("Current Unit No."; Rec."Current Unit No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current unit.';
                    //Editable = false;
                }
                field("Current Lease No."; Rec."Current Lease No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current lease.';
                    //Editable = false;
                }
                field("Move-in Date"; Rec."Move-in Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the move-in date.';
                    //Editable = false;
                }
                field("Move-out Date"; Rec."Move-out Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the move-out date.';
                }
                field("Reason for Exit"; Rec."Reason for Exit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reason for exit.';
                }
                field("Security Deposit Amount"; Rec."Security Deposit Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the security deposit amount.';
                    //Editable = false;
                }
                field("Deposit Refunded"; Rec."Deposit Refunded")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the deposit has been refunded.';
                    //Editable = false;
                }
            }
        }
    }

    actions
    {
        addlast(navigation)
        {
            action(TenantLeases)
            {
                ApplicationArea = All;
                Caption = 'Leases';
                Image = Agreement;
                ToolTip = 'View all leases for this tenant.';
                RunObject = Page "Lease List";
                RunPageLink = "Tenant No." = field("No.");
            }
            action(TenantInvoices)
            {
                ApplicationArea = All;
                Caption = 'Rent Invoices';
                Image = ListPage;
                ToolTip = 'View all rent invoices for this tenant.';
                RunObject = Page "Sales Invoice List";
                RunPageLink = "Sell-to Customer No." = field("No.");
                //RunPageView = where("Rent Invoice" = const(true));
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ShowTenantDetails := (Rec."Tenant Type" <> Rec."Tenant Type"::" ") or
                            (Rec."Tenant Category" <> Rec."Tenant Category"::" ") or
                            (Rec."Tenant Status" <> Rec."Tenant Status"::Prospective);
    end;

    var
        ShowTenantDetails: Boolean;
}