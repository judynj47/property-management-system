page 50134 "Tenant Application Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Tenant Application";

    layout
    {
        area(Content)
        {
            group("Applicant Details")
            {
                field("Application ID"; Rec."Application ID")
                {
                    Editable = IsEditable;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application ID field.';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    Editable = IsEditable;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tenant Name field.';
                }
                field("Tenant Type"; Rec."Tenant Type")
                {
                    Editable = IsEditable;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tenant Type field.';

                    trigger OnValidate()
                    begin
                        // Clear Company Registration No. when switching away from Corporate
                        if (xRec."Tenant Type" = xRec."Tenant Type"::Corporate) and
                           (Rec."Tenant Type" <> Rec."Tenant Type"::Corporate) then
                            Rec."Company Registration No." := '';

                        if (xRec."Tenant Type" = xRec."Tenant Type"::Individual) and
                           (Rec."Tenant Type" <> Rec."Tenant Type"::Individual) then
                            Rec."National ID/Passport" := '';



                    end;
                }


                field("Tenant Category"; Rec."Tenant Category")
                {
                    Editable = IsEditable;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tenant Category field.';
                }



                group("Company Details")
                {
                    //ApplicationArea = All;
                    Editable = IsEditable;
                    Visible = (Rec."Tenant Type" = Rec."Tenant Type"::Corporate);

                    field("Company Registration No."; Rec."Company Registration No.")
                    {
                        ShowMandatory = (Rec."Tenant Type" = Rec."Tenant Type"::Corporate);
                        ToolTip = 'Specifies the value of the Company Registration No. field.';
                        Editable = IsEditable;
                    }
                }

                group("Individual Details")
                {
                    Editable = IsEditable;
                    Visible = (Rec."Tenant Type" = Rec."Tenant Type"::Individual);
                    field("Date of Birth"; Rec."Date of Birth")
                    {
                        Editable = IsEditable;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Date of Birth field.';

                    }
                    field("National ID/Passport"; Rec."National ID/Passport")
                    {
                        ShowMandatory = true;
                        Editable = IsEditable;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the National ID/Passport field.';
                    }
                }
                field("Property Linked"; Rec."Property Linked")
                {
                    ToolTip = 'Specifies the value of the Property Linked field.', Comment = '%';
                    Editable = IsEditable;

                }

                field("Unit No."; Rec."Unit No.")
                {
                    ToolTip = 'Specifies the value of the Unit No. field.';
                    Caption = 'Unit applying for';
                    Editable = IsEditable;
                }


                field("Tenant Application Status"; Rec."Tenant Application Status")
                {
                    StyleExpr = StatusStyleTxt;
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Tenant Application Status field.';
                }
                field("Customer Created"; Rec."Customer Created")
                {
                    StyleExpr = StatusStyleTxt;
                    ApplicationArea = All;
                }
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
                SubPageLink = "Table ID" = const(Database::"Tenant Application"),
                              "No." = field("Application ID");



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
                    CustomWorkflowMgmt: Codeunit "Tenant Workflow Mgmt";
                    RecRef: RecordRef;
                begin
                    // Validate required fields before sending for approval
                    Rec.ValidateId(Rec."Application ID");

                    // Check if Company Registration No. is required and filled
                    if Rec."Tenant Type" = Rec."Tenant Type"::Corporate then
                        Rec.TestField("Company Registration No.");

                    if Rec."Tenant Type" = Rec."Tenant Type"::Individual then
                        Rec.TestField("National ID/Passport");
                    Rec.TestField("Date of Birth");
                    CurrPage.Update();

                    Rec.TestField("Tenant Name");
                    Rec.TestField("Property Linked");
                    rec.TestField("Unit No.");

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
                    Rec.Validate("Tenant Application Status", Rec."Tenant Application Status"::Open);
                    Rec.Modify(true);

                    Message('Approval request for Tenant Application %1 has been canceled.', Rec."Application ID");
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
                        Message('Tenant Application %1 has been approved.', Rec."Application ID");
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
                        Message('Tenant Application %1 has been rejected.', Rec."Application ID");
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
                        Message('Approval request for Tenant Application %1 has been delegated.', Rec."Application ID");
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

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExistCurrUser: Boolean;
        StatusStyleTxt: Text;
        IsEditable: Boolean;
        ShowSendApproval: Boolean;
        ShowCancelApproval: Boolean;
        ShowCompanyNumber: Boolean;
        ShowIndividualDetails: Boolean;

    trigger OnOpenPage()
    begin
        ShowCompanyNumber := (Rec."Tenant Type" = Rec."Tenant Type"::Corporate);
        ShowIndividualDetails := (Rec."Tenant Type" = Rec."Tenant Type"::Individual);
    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ShowCompanyNumber := (Rec."Tenant Type" = Rec."Tenant Type"::Corporate);
        ShowIndividualDetails := (Rec."Tenant Type" = Rec."Tenant Type"::Individual);

    end;

    trigger OnAfterGetCurrRecord()
    begin

        //if there are open approvals for current user
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);

        //Default visibility for approval actions
        ShowSendApproval := false;
        ShowCancelApproval := false;

        case Rec."Tenant Application Status" of
            Rec."Tenant Application Status"::Approved:
                begin
                    IsEditable := false;
                    StatusStyleTxt := 'Favorable';
                end;

            Rec."Tenant Application Status"::Rejected:
                begin
                    IsEditable := false;
                    StatusStyleTxt := 'Unfavorable';
                end;

            Rec."Tenant Application Status"::"PendingApproval":
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

}