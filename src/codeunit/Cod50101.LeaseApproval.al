codeunit 50101 "Lease Approval"
{
    procedure CheckApprovalsWorkflowEnabled(var RecRef: RecordRef): Boolean
    begin
        if not WorkflowMgt.CanExecuteWorkflow(RecRef, GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef)) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;//1

    procedure GetWorkflowCode(WorkflowCode: code[128]; RecRef: RecordRef): Code[128]
    begin
        exit(DelChr(StrSubstNo(WorkflowCode, RecRef.Name), '=', ' '));
    end;//3

    //     procedure OnAfterGetStatusStyleText(SalesHeader: Record "Sales Header"; var StatusStyleText: Text)
    //     begin
    //     end;




    [IntegrationEvent(false, false)]
    procedure OnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelWorkflowForApproval(var RecRef: RecordRef)
    begin
    end;//4, card for send/cancel approval request triggers

    //     // Add events to the library

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        RecRef.Open(Database::"Lease");
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), Database::"Lease",
          GetWorkflowEventDesc(WorkflowSendForApprovalEventDescTxt, RecRef), 0, false);
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), DATABASE::"Lease",
          GetWorkflowEventDesc(WorkflowCancelForApprovalEventDescTxt, RecRef), 0, false);
    end;
    //     // subscribe
    //     //listens for a specific event that is raised by an event publisher and executes when it is raised

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Lease Approval", 'OnSendWorkflowForApproval', '', false, false)]
    local procedure RunWorkflowOnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowMgt.HandleEvent(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Lease Approval", 'OnCancelWorkflowForApproval', '', false, false)]
    local procedure RunWorkflowOnCancelWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowMgt.HandleEvent(GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), RecRef);
    end;

    procedure GetWorkflowEventDesc(WorkflowEventDesc: Text; RecRef: RecordRef): Text
    begin
        exit(StrSubstNo(WorkflowEventDesc, RecRef.Name));
    end;

    //     // handle the document;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        CustomWorkflowHdr: Record "Lease";
    begin
        case RecRef.Number of
            Database::"Lease":
                begin
                    RecRef.SetTable(CustomWorkflowHdr);//casts back recref: RecordRef to correct table
                    CustomWorkflowHdr.Validate("Lease Status", CustomWorkflowHdr."Lease Status"::Draft);
                    CustomWorkflowHdr.Modify(true);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        CustomWorkflowHdr: Record "Lease";
    begin
        case RecRef.Number of
            Database::"Lease":
                begin
                    RecRef.SetTable(CustomWorkflowHdr);
                    CustomWorkflowHdr.Validate("Lease Status", CustomWorkflowHdr."Lease Status"::PendingApproval);
                    CustomWorkflowHdr.Modify(true);
                    Variant := CustomWorkflowHdr;
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, true)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        LeaseRec: Record Lease;
        RentInvoice: Record "Rent Invoice Line";
        RentInvoiceCalculation: Codeunit "Rent Invoice Calculation";
    //EmailMgmt: Codeunit "Email Management";
    begin
        if ApprovalEntry."Table ID" = Database::"Lease" then begin
            if LeaseRec.Get(ApprovalEntry."Document No.") then begin


                LeaseRec.Validate("Lease Status", LeaseRec."Lease Status"::Active);

                LeaseRec.Modify(true);


                //EmailMgmt.SendApplicationStatusEmail(TenantApplication, true); // true = approved

                //Message('"Tenant Application %1 has been approved. Notification email sent.', TenantApplication."A");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnCancelApprovalRequestsForRecordOnAfterCreateApprovalEntryNotification, '', true, true)]
    local procedure OnCancelApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        LeaseRec: Record Lease;

    begin
        if ApprovalEntry."Table ID" = Database::Lease then begin
            if LeaseRec.Get(ApprovalEntry."Document No.") then begin

                LeaseRec.Validate("Lease Status", LeaseRec."Lease Status"::Draft);
                LeaseRec.Modify(true);
                //EmailMgmt.SendApplicationStatusEmail(TenantApplication, true); // true = approved

                //Message('"Tenant Application %1 has been approved. Notification email sent.', TenantApplication."A");
            end;
        end;


    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        CustomWorkflowHdr: Record "Lease";
    begin
        case RecRef.Number of
            Database::"Lease":
                begin
                    RecRef.SetTable(CustomWorkflowHdr);
                    ApprovalEntryArgument."Document No." := CustomWorkflowHdr."No.";
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        CustomWorkflowHdr: Record "Lease";
    begin
        case RecRef.Number of
            Database::"Lease":
                begin
                    RecRef.SetTable(CustomWorkflowHdr);
                    CustomWorkflowHdr.Validate("Lease Status", CustomWorkflowHdr."Lease Status"::Active);
                    CustomWorkflowHdr.Modify(true);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        RecRef: RecordRef;
        CustomWorkflowHdr: Record Lease;

    begin
        case ApprovalEntry."Table ID" of
            Database::Lease:
                begin
                    if CustomWorkflowHdr.Get(ApprovalEntry."Document No.") then begin
                        CustomWorkflowHdr.Validate("Lease Status", CustomWorkflowHdr."Lease Status"::Cancelled);
                        CustomWorkflowHdr.Modify(true);
                    end;
                end;
        end;
    end;



    var

        WorkflowMgt: Codeunit "Workflow Management";
        //idRec: Record "Tenant Application";

        RUNWORKFLOWONSENDFORAPPROVALCODE: Label 'RUNWORKFLOWONSEND%1FORAPPROVAL';
        RUNWORKFLOWONCANCELFORAPPROVALCODE: Label 'RUNWORKFLOWONCANCEL%1FORAPPROVAL';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        WorkflowSendForApprovalEventDescTxt: Label 'Approval of %1 is requested.';
        WorkflowCancelForApprovalEventDescTxt: Label 'Approval of %1 is canceled.';
}






