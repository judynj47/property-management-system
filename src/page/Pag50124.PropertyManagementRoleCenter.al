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
        }
    }

    actions
    {
        area(Sections)
        {
            group(Setup)
            {
                Caption = 'Setups';

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


                action("Property Setup")
                {
                    ApplicationArea = All;
                    RunObject = page "Property SetUp";
                }

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

                    action("Approved Tenants")
                    {
                        ApplicationArea = All;
                        Caption = 'Approved Tenants';
                        RunObject = page "Approved Tenants List";
                    }

                    action("Pending Tenants")
                    {
                        ApplicationArea = All;
                        Caption = 'Pending Tenants';
                        RunObject = page "Pending Tenants List";
                    }
                }

                action("&LeaseAgreement")
                {
                    Caption = 'Lease Agreement';
                    ApplicationArea = All;

                    RunObject = page "Lease list";
                }

            }



            group("Tenants & Leases")
            {

                action(Tenants)
                {
                    ApplicationArea = All;
                    Caption = 'Tenants';
                    RunObject = page "Tenant List";
                }
                action(Leases)
                {
                    ApplicationArea = All;
                    Caption = 'Leases';
                    RunObject = page "Lease List";
                }

            }
        }


        area(Creation)
        {
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
