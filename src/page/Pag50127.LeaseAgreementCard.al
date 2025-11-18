page 50127 "Lease Agreement Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Lease;

    layout
    {
        area(Content)
        {
            group("Parties and Properties")
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the Lease No. field.', Comment = '%';
                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    ToolTip = 'Specifies the value of the Tenant No. field.', Comment = '%';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ToolTip = 'Specifies the value of the Tenant Name field.', Comment = '%';
                }
                field("Owner No."; Rec."Owner No.")
                {
                    ToolTip = 'Specifies the value of the Owner No. field.', Comment = '%';
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ToolTip = 'Specifies the value of the Owner Name field.', Comment = '%';
                }
                field("Property No."; Rec."Property No.")
                {
                    ToolTip = 'Specifies the value of the Property No. field.', Comment = '%';
                }
                field("Property Name"; Rec."Property Name")
                {
                    ToolTip = 'Specifies the value of the Property Name field.', Comment = '%';
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ToolTip = 'Specifies the value of the Unit No. field.', Comment = '%';
                }

                group(Fees)
                {
                    field("Security Deposit"; Rec."Security Deposit")
                    {
                        ToolTip = 'Specifies the value of the Security Deposit field.', Comment = '%';
                    }
                    field("Rent Amount"; Rec."Rent Amount")
                    {
                        ToolTip = 'Specifies the value of the Rent Amount field.', Comment = '%';
                    }
                    field("Utility Charge"; Rec."Utility Charge")
                    {
                        ToolTip = 'Specifies the value of the Utility Charge field.', Comment = '%';
                        //Style = Strong;
                    }
                    field("Service Charge"; Rec."Service Charge")
                    {
                        ToolTip = 'Specifies the value of the Service Charge field.', Comment = '%';

                    }
                    // field("Total Additional Charges"; Rec."Total Additional Charges")
                    // {
                    //     ToolTip = 'Specifies the value of the Total Additional Charges field.', Comment = '%';
                    //     Style = StrongAccent;
                    // }
                    field("Payment Frequency"; Rec."Payment Frequency")
                    {
                        ToolTip = 'Specifies the value of the Payment Frequency field.', Comment = '%';
                    }
                }

                group("Lease term")
                {
                    field("Start Date"; Rec."Start Date")
                    {
                        ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
                    }
                    field("End Date"; Rec."End Date")
                    {
                        ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                    }
                    field("Signed Date"; Rec."Signed Date")
                    {
                        ToolTip = 'Specifies the value of the Signed Date field.', Comment = '%';
                    }
                    field("Lease Status"; Rec."Lease Status")
                    {
                        ToolTip = 'Specifies the value of the Lease Status field.', Comment = '%';
                    }
                    field("Renewal Notice Period"; Rec."Renewal Notice Period")
                    {
                        ToolTip = 'Specifies the value of the Notice Period (Days) field.', Comment = '%';
                    }
                    field("Renewal Notice Date"; Rec."Renewal Notice Date")
                    {
                        ToolTip = 'Specifies the value of the Renewal Notice Date field.', Comment = '%';
                    }
                }
            }

            part(PropertyCharges; "Property Charges Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Property No." = FIELD("Property No.");
                Caption = 'Property Charges Setup';
                Editable = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PrintLeaseAgreement)
            {
                Caption = 'Sign Lease Agreement';
                ApplicationArea = All;
                Image = Signature;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LeaseReport: Report "Lease Agreement Report";
                begin
                    Report.RunModal(Report::"Lease Agreement Report", true, true, Rec);
                end;
            }
            action(RenewLease)
            {
                Caption = 'Renew Lease';
                ApplicationArea = All;
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    NewLease: Record Lease;
                    NoSeriesMgt: Codeunit "No. Series";
                    PropertySetup: Record "Property Setup";
                    UnitRec: Record Unit;
                    TenantUnitLink: Record "Tenant Unit Link";
                begin
                    if not Confirm('Do you want to renew this lease?', false) then
                        exit;

                    // Get lease numbering setup
                    PropertySetup.Get();
                    PropertySetup.TestField("Lease No.");

                    // Generate new lease number first
                    NewLease."No." := NoSeriesMgt.GetNextNo(PropertySetup."Lease No.", WorkDate, true);

                    // Update Unit with new lease number FIRST
                    if UnitRec.Get(Rec."Unit No.") then begin
                        // Temporarily disable validation or use direct assignment
                        UnitRec."Lease No." := NewLease."No.";
                        UnitRec.Modify(false); // Use false to avoid validation triggers
                    end;

                    // Create new lease record
                    NewLease.Init();
                    NewLease.TransferFields(Rec, false); // false to exclude primary key and other critical fields

                    NewLease."No." := NewLease."No.";
                    NewLease."Previous Lease No." := Rec."No.";
                    NewLease."Renewal Count" := Rec."Renewal Count" + 1;
                    NewLease."Lease Status" := NewLease."Lease Status"::Renewed;
                    NewLease."Start Date" := Rec."End Date" + 1;
                    NewLease."End Date" := CalcDate('<12M>', NewLease."Start Date");
                    NewLease."Signed Date" := WorkDate;
                    NewLease."Created Date" := CurrentDateTime;
                    NewLease."Created By" := UserId;

                    // Insert the Lease
                    NewLease.Insert(true);

                    // Update existing Tenant Unit Link with new dates
                    if TenantUnitLink.Get(Rec."Tenant No.", Rec."Unit No.") then begin
                        TenantUnitLink."Move-in Date" := NewLease."Start Date";
                        TenantUnitLink."Move-out Date" := NewLease."End Date";
                        TenantUnitLink."Rent Amount" := NewLease."Rent Amount";
                        TenantUnitLink.Modify(true);
                    end;

                    // Update previous lease status
                    Rec."Lease Status" := Rec."Lease Status"::Expired;
                    Rec.Modify(true);

                    Message('Lease %1 renewed successfully as %2', Rec."No.", NewLease."No.");
                end;
            }

            action(TerminateLease)
            {
                Caption = 'Terminate Lease';
                ApplicationArea = All;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TermRec: Record Termination;
                    UnitRec: Record Unit;
                    TermDialog: Page "Lease Termination Dialog";
                    Reason: Text[100];
                    RefundAmt: Decimal;
                begin
                    if not Confirm('Do you want to terminate this lease?', false) then
                        exit;

                    // Open dialog for details
                    if TermDialog.RunModal() = Action::OK then begin
                        TermDialog.GetTerminationDetails(Reason, RefundAmt);

                        // Create termination record
                        TermRec.Init();
                        TermRec."Tenant No." := Rec."Tenant No.";
                        TermRec."Tenant Name" := Rec."Tenant Name";
                        TermRec."Owner No." := Rec."Owner No.";
                        TermRec."Owner Name" := Rec."Owner Name";
                        TermRec."Unit No." := Rec."Unit No.";
                        TermRec."Termination Reason" := Reason;
                        TermRec."Deposit Refund Amount" := RefundAmt;
                        TermRec."Termination Date" := WorkDate;

                        TermRec.Insert(true);

                        // Update lease
                        Rec."Lease Status" := Rec."Lease Status"::Terminated;
                        Rec."End Date" := WorkDate;
                        Rec.Modify(true);

                        // Update unit status
                        if UnitRec.Get(Rec."Unit No.") then begin
                            UnitRec.Validate("Unit Status", UnitRec."Unit Status"::Vacant);
                            UnitRec.Modify(true);
                        end;

                        Message('Lease %1 terminated successfully. Termination ID: %2', Rec."No.", TermRec."Termination ID");
                    end;
                end;
            }


        }
    }




}