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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Application ID field.', Comment = '%';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tenant Name field.', Comment = '%';
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date of Birth field.', Comment = '%';
                }
                field("National ID/Passport"; Rec."National ID/Passport")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the National ID/Passport field.', Comment = '%';
                }
                field("Company Registration No."; Rec."Company Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Company Registration No. field.', Comment = '%';
                }
                field("Tenant Category"; Rec."Tenant Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tenant Category field.', Comment = '%';
                }
                field("Tenant Type"; Rec."Tenant Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tenant Type field.', Comment = '%';
                }
                // field("Tenant Status"; Rec."Tenant Status")
                // {
                //     ToolTip = 'Specifies the value of the Tenant Status field.', Comment = '%';
                // }
                field("Tenant Application Status"; Rec."Tenant Application Status")
                {
                    StyleExpr = StatusStyleTxt;
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Tenant Application Status field.', Comment = '%';
                }
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


                trigger OnAction()
                var
                    CustomWorkflowMgmt: Codeunit "Tenant Workflow Mgmt";
                    RecRef: RecordRef;
                    //EmailCU: Codeunit Email;
                    ApprovalEntry: Record "Approval Entry";
                    UserSetup: Record "User Setup";
                    ApproverEmail: Text;
                begin
                    RecRef.GetTable(Rec);
                    if CustomWorkflowMgmt.CheckApprovalsWorkflowEnabled(RecRef) then begin
                        CustomWorkflowMgmt.OnSendWorkflowForApproval(RecRef);

                        // Find approver for this record
                        ApprovalEntry.SetRange("Record ID to Approve", Rec.RecordId);
                        if ApprovalEntry.FindFirst() then begin
                            if UserSetup.Get(ApprovalEntry."Approver ID") then
                                ApproverEmail := UserSetup."E-Mail"; // use email field from User Setup
                        end;


                        // // Send email to approver
                        // if ApproverEmail <> '' then
                        //     EmailCU.SendAnEmail(ApproverEmail)
                        // else
                        //     Message('No approver email found for user %1', ApprovalEntry."Approver ID");

                    end;
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Request';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CustomWorkflowMgmt: Codeunit "Tenant Workflow Mgmt";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    CustomWorkflowMgmt.OnCancelWorkflowForApproval(RecRef);
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
                        // Approve the current record
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);

                        // Re-read the record from database to get latest status
                        if Rec.Get(Rec.RecordId) then begin
                            CurrPage.Update();
                            Message('Tenant Application %1 has been approved.', Rec."Application ID");
                        end else
                            CurrPage.Update(); // still refresh if record not found
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
                        // Reject the current record
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);

                        // Re-read the record from database to reflect new status
                        if Rec.Get(Rec.RecordId) then begin
                            CurrPage.Update();
                            Message('Tenant Application %1 has been rejected.', Rec."Application ID");
                        end else
                            CurrPage.Update();
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
                        // Delegate the current record
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);

                        // Re-read and refresh UI after delegation
                        if Rec.Get(Rec.RecordId) then begin
                            CurrPage.Update();
                            Message('Approval request for Tenant Application %1 has been delegated.', Rec."Application ID");
                        end else
                            CurrPage.Update();
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

    trigger OnAfterGetCurrRecord()
    begin
        // Update visibility flag based on current user’s approval entries
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);

        // Set style based on Status
        case Rec."Tenant Application Status" of
            Rec."Tenant Application Status"::Approved:
                StatusStyleTxt := 'Favorable'; // green
            Rec."Tenant Application Status"::Rejected:
                StatusStyleTxt := 'Unfavorable'; // red
            Rec."Tenant Application Status"::"PendingApproval":
                StatusStyleTxt := 'Strong'; // bold black
            else
                StatusStyleTxt := 'Standard'; // default style
        end;
    end;

    local procedure RefreshTenantApplication()
    begin
        if Rec.Get(Rec.RecordId) then;
        CurrPage.Update();
    end;



}
