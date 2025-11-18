page 50124 "Property Management RoleCenter"
{
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part(Control11; "Headline RC Team Member")
            {
                ApplicationArea = Suite;
            }
            part("Emails"; "Email Activities")
            {
                ApplicationArea = Basic, Suite;
            }
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }
            part(TotalProperties; "Property Cue")
            {
                ApplicationArea = Suite;
            }
            part(TotalTenants; "Tenant Cue")
            {
                ApplicationArea = Suite;

            }
        }

    }

    actions
    {
        area(Sections)
        {
            group(Setup)
            {
                Caption = 'Setups';

                action("Units")
                {
                    ApplicationArea = All;
                    Caption = 'Units';
                    RunObject = page "Unit List";

                }


                action("Properties")
                {
                    ApplicationArea = All;
                    Caption = 'Properties';
                    RunObject = page "Property List";

                }


                action("Owners")
                {
                    ApplicationArea = All;
                    Caption = 'Owners';
                    RunObject = page "Owner List";

                }

                action("Amenity Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Amenities';
                    RunObject = page "Amenity List";

                }
                action("Special Clauses Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Special Clauses';
                    RunObject = page "Special Clauses List";

                }
                action("Property Charges Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Property Charges Setup';
                    RunObject = page "Property Charge List";

                }


                action("Property Setup")
                {
                    ApplicationArea = All;
                    RunObject = page "Property SetUp";
                }
                // action("Unit Maintenance")
                // {
                //     ApplicationArea = All;
                //     RunObject = page "Maintenance Request List";
                // }

            }

            group(Application)
            {
                Caption = 'Applications';

                group("Tenant Applications")
                {
                    Caption = 'Tenant Applications';

                    action("All Tenant Applications")
                    {
                        ApplicationArea = All;
                        Caption = 'All Tenant Applications';
                        RunObject = page "Tenant Application List";
                    }

                    action("Pending Tenants")
                    {
                        ApplicationArea = All;
                        Caption = 'Pending Tenants';
                        RunObject = page "Pending Tenants List";
                    }
                    action("Approved Tenants")
                    {
                        ApplicationArea = All;
                        Caption = 'Approved Tenants';
                        RunObject = page "Approved Tenants List";
                    }
                }

                // action("&LeaseAgreement")
                // {
                //     Caption = 'Lease Agreement';
                //     ApplicationArea = All;

                //     RunObject = page "Lease list";
                // }

            }



            group("Tenant Management")
            {
                action(Tenants)
                {
                    ApplicationArea = All;
                    Caption = 'All Tenants';
                    RunObject = page "Tenant List";
                }
                action(ActiveTenants)
                {
                    ApplicationArea = All;
                    Caption = 'Active Tenants';
                    RunObject = page "Active Tenant List";
                }
                action(PastTenants)
                {
                    ApplicationArea = All;
                    Caption = 'Past Tenants';
                    RunObject = page "Past Tenant List";
                }



            }
            group("Lease Management")
            {
                // action(Leases)
                // {
                //     ApplicationArea = All;
                //     Caption = 'Leases';
                //     RunObject = page "Lease List";
                // }
                action(DraftLeases)
                {
                    ApplicationArea = All;
                    Caption = 'Draft Leases';
                    RunObject = page "Draft Leases";
                }
                action(ActiveLeases)
                {
                    ApplicationArea = All;
                    Caption = 'Active Leases';
                    RunObject = page "Active Leases";
                }
                action(ExpiredLeases)
                {
                    ApplicationArea = All;
                    Caption = 'Expired Leases';
                    RunObject = page "Expired Leases";
                }
                action(RenewedLeases)
                {
                    ApplicationArea = All;
                    Caption = 'Renewed Leases';
                    RunObject = page "Renewed Leases";
                }
                action(TerminatedLeases)
                {
                    ApplicationArea = All;
                    Caption = 'Terminated Leases';
                    RunObject = page "Terminated Leases";
                }



            }
            group("Billing")
            {
                action(Invoicing)
                {
                    Caption = 'All rent bills';
                    ApplicationArea = All;
                    RunObject = page "Rent Invoice List";
                }
                action(Invoice)
                {
                    ApplicationArea = All;
                    RunObject = page "Invoice List";
                }
                action(Receipts)
                {
                    ApplicationArea = All;
                    RunObject = page "Receipt List";
                }

            }
            group("Terminations")
            {
                action(Termination)
                {
                    ApplicationArea = All;
                    RunObject = page "Termination List";

                }
            }
        }


        area(Creation)
        {
            action(Unit)
            {
                ApplicationArea = Basic, Suite;
                RunObject = Page "Unit Card";
                RunPageMode = Create;
            }
            action(Property)
            {
                ApplicationArea = Basic, Suite;
                RunObject = Page "Property Card";
                RunPageMode = Create;
            }
            action("Tenant Application")
            {
                ApplicationArea = Basic, Suite;
                RunObject = Page "Tenant Application Card";
                RunPageMode = Create;
            }
            action("Lease Agreement")
            {
                ApplicationArea = Basic, Suite;
                RunObject = Page "Lease Agreement Card";
                RunPageMode = Create;
            }
        }
    }
}
