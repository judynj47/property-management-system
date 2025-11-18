page 50126 "Unit Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Unit;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {

                    ToolTip = 'Specifies the value of the Unit No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Date Available"; Rec."Date Available")
                {
                    ToolTip = 'Specifies the value of the Date Available field.', Comment = '%';
                }
                field("Unit Size"; Rec."Unit Size")
                {
                    ToolTip = 'Specifies the value of the Unit Size (sq. m) field.', Comment = '%';
                }
                field("Unit Status"; Rec."Unit Status")
                {
                    ToolTip = 'Specifies the value of the Unit Status field.', Comment = '%';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
                field("Lease No."; Rec."Lease No.")
                {
                    ToolTip = 'Specifies the value of the Lease No. field.', Comment = '%';
                }
                field("Property No."; Rec."Property No.")
                {
                    ToolTip = 'Specifies the value of the Property No. field.', Comment = '%';
                }
                field("Rent Amount"; Rec."Rent Amount")
                {
                    ToolTip = 'Specifies the value of the Rent Amount field.', Comment = '%';
                }
                field("Penalty Charge"; Rec."Penalty Charge")
                {
                    ToolTip = 'Specifies the value of the Penalty Charge field.', Comment = '%';
                }
            }

            // part(TenantUnit; "Tenant Subform")
            // {
            //     SubPageLink = "Unit No." = field("No.");


            // }
            part(TenantUnits; "Tenant Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Unit No." = FIELD("No.");
            }



        }

        area(factboxes)
        {

            part("Attached Documents List"; "Doc. Attachment List Factbox")
            {

                Visible = true;
                ApplicationArea = All;
                Caption = 'Documents';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::Unit),
                              "No." = field("No.");



            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(CreateMaintenanceRequest)
            {
                Caption = 'Create Maintenance Request';
                ApplicationArea = All;
                Image = MaintenanceRegistrations;

                trigger OnAction()
                var
                    MaintenanceRequest: Record "Maintenance Request";
                    MaintenanceCard: Page "Maintenance Request Card";
                begin
                    MaintenanceRequest.Init();
                    MaintenanceRequest."Unit No." := Rec."No.";
                    MaintenanceRequest.Insert(true);

                    MaintenanceCard.SetRecord(MaintenanceRequest);
                    MaintenanceCard.Run();
                end;
            }
        }
    }





}