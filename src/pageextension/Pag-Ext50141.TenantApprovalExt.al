// pageextension 50141 "Tenant Application Card Ext" extends "Tenant Application Card"
// {
//     actions
//     {
//         addlast(Processing)
//         {
//             action("RequestApproval")
//             {
//                 Caption = 'Send Approval Request';
//                 ApplicationArea = All;
//                 Image = SendApprovalRequest;
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 var
//                     TenantWorkflow: Codeunit "Tenant App Workflow Mgmt";
//                     RecRef: RecordRef;
//                     ApprovalEntry: Record "Approval Entry";
//                     UserSetup: Record "User Setup";
//                     //EmailCU: Codeunit "Email codeunit";
//                     ApproverEmail: Text;
//                 begin
//                     RecRef.GetTable(Rec);
//                     if TenantWorkflow.CheckApprovalsWorkflowEnabled(RecRef) then begin
//                         TenantWorkflow.OnSendWorkflowForApproval(RecRef);

//                         ApprovalEntry.SetRange("Record ID to Approve", Rec.RecordId);
//                         if ApprovalEntry.FindFirst() then
//                             if UserSetup.Get(ApprovalEntry."Approver ID") then
//                                 ApproverEmail := UserSetup."E-Mail";

//                         // if ApproverEmail <> '' then
//                         //     EmailCU.SendAnEmail(ApproverEmail)
//                         // else
//                         //     Message('No approver email found for user %1', ApprovalEntry."Approver ID");
//                     end;
//                 end;
//             }

//             action("Cancel ApprovalRequest")
//             {
//                 Caption = 'Cancel Approval Request';
//                 ApplicationArea = All;
//                 Image = CancelApprovalRequest;
//                 Promoted = true;
//                 PromotedCategory = Process;

//                 trigger OnAction()
//                 var
//                     TenantWorkflow: Codeunit "Tenant App Workflow Mgmt";
//                     RecRef: RecordRef;
//                 begin
//                     RecRef.GetTable(Rec);
//                     TenantWorkflow.OnCancelWorkflowForApproval(RecRef);
//                 end;
//             }
//         }
//     }
// }
