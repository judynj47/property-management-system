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
                    Editable = IsEditable;
                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    Editable = IsEditable;
                    ToolTip = 'Specifies the value of the Tenant No. field.', Comment = '%';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    Editable = IsEditable;
                    ToolTip = 'Specifies the value of the Tenant Name field.', Comment = '%';
                }
                field("Owner No."; Rec."Owner No.")
                {
                    Editable = IsEditable;
                    ToolTip = 'Specifies the value of the Owner No. field.', Comment = '%';
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    Editable = IsEditable;
                    ToolTip = 'Specifies the value of the Owner Name field.', Comment = '%';
                }
                field("Property No."; Rec."Property No.")
                {
                    Editable = IsEditable;
                    ToolTip = 'Specifies the value of the Property No. field.', Comment = '%';
                }
                field("Property Name"; Rec."Property Name")
                {
                    Editable = IsEditable;
                    ToolTip = 'Specifies the value of the Property Name field.', Comment = '%';
                }
                field("Unit No."; Rec."Unit No.")
                {
                    Editable = IsEditable;
                    ToolTip = 'Specifies the value of the Unit No. field.', Comment = '%';
                }

                group(Fees)
                {
                    field("Security Deposit"; Rec."Security Deposit")
                    {
                        Editable = IsEditable;
                        ToolTip = 'Specifies the value of the Security Deposit field.', Comment = '%';
                    }
                    field("Rent Amount"; Rec."Rent Amount")
                    {
                        Editable = IsEditable;
                        ToolTip = 'Specifies the value of the Rent Amount field.', Comment = '%';
                    }
                    field("Utility Charge"; Rec."Utility Charge")
                    {
                        Editable = IsEditable;
                        ToolTip = 'Specifies the value of the Utility Charge field.', Comment = '%';
                        //Style = Strong;
                    }
                    field("Service Charge"; Rec."Service Charge")
                    {
                        Editable = IsEditable;
                        ToolTip = 'Specifies the value of the Service Charge field.', Comment = '%';

                    }
                    // field("Total Additional Charges"; Rec."Total Additional Charges")
                    // {
                    //     ToolTip = 'Specifies the value of the Total Additional Charges field.', Comment = '%';
                    //     Style = StrongAccent;
                    // }
                    field("Payment Frequency"; Rec."Payment Frequency")
                    {
                        Editable = IsEditable;
                        ToolTip = 'Specifies the value of the Payment Frequency field.', Comment = '%';
                    }
                }

                group("Lease term")
                {
                    field("Start Date"; Rec."Start Date")
                    {
                        Editable = IsEditable;
                        ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
                    }
                    field("End Date"; Rec."End Date")
                    {
                        Editable = IsEditable;
                        ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                    }
                    field("Signed Date"; Rec."Signed Date")
                    {
                        Editable = IsEditable;
                        ToolTip = 'Specifies the value of the Signed Date field.', Comment = '%';
                    }
                    field("Lease Status"; Rec."Lease Status")
                    {
                        StyleExpr = StatusStyleTxt;
                        ToolTip = 'Specifies the value of the Lease Status field.', Comment = '%';
                        Editable = false;
                    }
                    field("Renewal Notice Period"; Rec."Renewal Notice Period")
                    {
                        Editable = IsEditable;
                        ToolTip = 'Specifies the value of the Notice Period (Days) field.', Comment = '%';
                    }
                    field("Renewal Notice Date"; Rec."Renewal Notice Date")
                    {
                        Editable = IsEditable;
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
        area(factboxes)
        {
            part("Attached Documents List"; "Doc. Attachment List Factbox")
            {
                Visible = true;
                ApplicationArea = All;
                Caption = 'Documents';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::Lease),
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
            action("Request Approval")
            {
                Caption = 'Send Approval Request';
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedCategory = Process;
                Visible = ShowSendApproval;

                trigger OnAction()
                var
                    CustomWorkflowMgmt: Codeunit "Lease Approval";
                    RecRef: RecordRef;
                begin
                    // Validate required fields before sending for approval

                    RecRef.GetTable(Rec);
                    if CustomWorkflowMgmt.CheckApprovalsWorkflowEnabled(RecRef) then
                        CustomWorkflowMgmt.OnSendWorkflowForApproval(RecRef);
                end;
            }

            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Request';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                Visible = ShowCancelApproval;

                trigger OnAction()
                var
                    RecRef: RecordRef;
                    WorkflowStepInstance: Record "Workflow Step Instance";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    RecRef.GetTable(Rec);
                    ApprovalsMgmt.CancelApprovalRequestsForRecord(RecRef, WorkflowStepInstance);

                    //Set status to Open
                    Rec.Validate("Lease Status", Rec."Lease Status"::Draft);
                    Rec.Modify(true);

                    Message('Approval request for Lease %1 has been cancelled.', Rec."No.");
                end;
            }



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
                Visible = ShowRenew;

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
                Visible = ShowTerminate;

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
        area(Creation)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = New;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                        CurrPage.Update();
                        Message('Lease %1 has been approved.', Rec."No.");
                    end;
                }

                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = New;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                        CurrPage.Update();
                        Message('Lease %1 has been rejected.', Rec."No.");
                    end;
                }

                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = New;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                        CurrPage.Update();
                        Message('Approval request for Lease %1 has been delegated.', Rec."No.");
                    end;
                }

                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = New;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }

                action(Approvals)
                {
                    ApplicationArea = All;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = New;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin

        //if there are open approvals for current user
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);

        //Default visibility for approval actions
        ShowSendApproval := false;
        ShowCancelApproval := false;
        ShowRenew := false;
        ShowTerminate := false;

        case Rec."Lease Status" of
            Rec."Lease Status"::Active:
                begin
                    IsEditable := false;
                    StatusStyleTxt := 'Favorable';
                    ShowTerminate := true;
                end;

            Rec."Lease Status"::Cancelled:
                begin
                    IsEditable := false;
                    StatusStyleTxt := 'Unfavorable';
                    ShowTerminate := true;
                end;

            Rec."Lease Status"::"PendingApproval":
                begin
                    IsEditable := false;
                    StatusStyleTxt := 'Strong';
                    ShowCancelApproval := true;
                end;

            else begin
                IsEditable := true;
                StatusStyleTxt := 'Standard';
                ShowSendApproval := true;
            end;
        end;
    end;

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExistCurrUser: Boolean;
        StatusStyleTxt: Text;
        IsEditable: Boolean;
        ShowSendApproval: Boolean;
        ShowCancelApproval: Boolean;
        ShowRenew: Boolean;
        ShowTerminate: Boolean;




}