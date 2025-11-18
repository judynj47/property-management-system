codeunit 50134 "Tenant Workflow Mgmt"
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

    procedure OnAfterGetStatusStyleText(SalesHeader: Record "Sales Header"; var StatusStyleText: Text)
    begin
    end;




    [IntegrationEvent(false, false)]
    procedure OnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelWorkflowForApproval(var RecRef: RecordRef)
    begin
    end;//4, card for send/cancel approval request triggers

    // Add events to the library

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        RecRef.Open(Database::"Tenant Application");
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), Database::"Tenant Application",
          GetWorkflowEventDesc(WorkflowSendForApprovalEventDescTxt, RecRef), 0, false);
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), DATABASE::"Tenant Application",
          GetWorkflowEventDesc(WorkflowCancelForApprovalEventDescTxt, RecRef), 0, false);
    end;
    // subscribe
    //listens for a specific event that is raised by an event publisher and executes when it is raised

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Tenant Workflow Mgmt", 'OnSendWorkflowForApproval', '', false, false)]
    local procedure RunWorkflowOnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowMgt.HandleEvent(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Tenant Workflow Mgmt", 'OnCancelWorkflowForApproval', '', false, false)]
    local procedure RunWorkflowOnCancelWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowMgt.HandleEvent(GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), RecRef);
    end;

    procedure GetWorkflowEventDesc(WorkflowEventDesc: Text; RecRef: RecordRef): Text
    begin
        exit(StrSubstNo(WorkflowEventDesc, RecRef.Name));
    end;

    // handle the document;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        CustomWorkflowHdr: Record "Tenant Application";
    begin
        case RecRef.Number of
            Database::"Tenant Application":
                begin
                    RecRef.SetTable(CustomWorkflowHdr);//casts back recref: RecordRef to correct table
                    CustomWorkflowHdr.Validate("Tenant Application Status", CustomWorkflowHdr."Tenant Application Status"::Open);
                    CustomWorkflowHdr.Modify(true);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        CustomWorkflowHdr: Record "Tenant Application";
    begin
        case RecRef.Number of
            Database::"Tenant Application":
                begin
                    RecRef.SetTable(CustomWorkflowHdr);
                    CustomWorkflowHdr.Validate("Tenant Application Status", CustomWorkflowHdr."Tenant Application Status"::PendingApproval);
                    CustomWorkflowHdr.Modify(true);
                    Variant := CustomWorkflowHdr;
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, true)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        TenantApplication: Record "Tenant Application";
        CustomerRec: Record Customer;
    //EmailMgmt: Codeunit "Email Management";
    begin
        if ApprovalEntry."Table ID" = Database::"Tenant Application" then begin
            if TenantApplication.Get(ApprovalEntry."Document No.") then begin

                //Create Customer:
                CreateTenantCustumer(TenantApplication."Application ID");
                TenantApplication.Validate("Tenant Application Status", TenantApplication."Tenant Application Status"::Approved);
                TenantApplication."Customer Created" := true;
                TenantApplication.Modify(true);
                //EmailMgmt.SendApplicationStatusEmail(TenantApplication, true); // true = approved

                //Message('"Tenant Application %1 has been approved. Notification email sent.', TenantApplication."A");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnCancelApprovalRequestsForRecordOnAfterCreateApprovalEntryNotification, '', true, true)]
    local procedure OnCancelApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        TenantApplication: Record "Tenant Application";
        CustomerRec: Record Customer;
    begin
        if ApprovalEntry."Table ID" = Database::"Tenant Application" then begin
            if TenantApplication.Get(ApprovalEntry."Document No.") then begin

                TenantApplication.Validate("Tenant Application Status", TenantApplication."Tenant Application Status"::Open);
                TenantApplication.Modify(true);
                //EmailMgmt.SendApplicationStatusEmail(TenantApplication, true); // true = approved

                //Message('"Tenant Application %1 has been approved. Notification email sent.', TenantApplication."A");
            end;
        end;


    end;








    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        CustomWorkflowHdr: Record "Tenant Application";
    begin
        case RecRef.Number of
            Database::"Tenant Application":
                begin
                    RecRef.SetTable(CustomWorkflowHdr);
                    ApprovalEntryArgument."Document No." := CustomWorkflowHdr."Application ID";
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        CustomWorkflowHdr: Record "Tenant Application";
    begin
        case RecRef.Number of
            Database::"Tenant Application":
                begin
                    RecRef.SetTable(CustomWorkflowHdr);
                    CustomWorkflowHdr.Validate("Tenant Application Status", CustomWorkflowHdr."Tenant Application Status"::Approved);
                    CustomWorkflowHdr.Modify(true);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        RecRef: RecordRef;
        CustomWorkflowHdr: Record "Tenant Application";

    begin
        case ApprovalEntry."Table ID" of
            Database::"Tenant Application":
                begin
                    if CustomWorkflowHdr.Get(ApprovalEntry."Document No.") then begin
                        CustomWorkflowHdr.Validate("Tenant Application Status", CustomWorkflowHdr."Tenant Application Status"::Rejected);
                        CustomWorkflowHdr.Modify(true);
                    end;
                end;
        end;
    end;


    //Automatic Creation of Customers from Tenants: 31.11.25:
    local procedure CreateTenantCustumer(TenantID: Code[20])
    var
        CustomerRec: Record Customer;
        TenantApplication: Record "Tenant Application";
        PropertySetup: Record "Property Setup";
        NoseriesMgt: Codeunit "No. Series";
    begin
        if TenantApplication.Get(TenantID) then begin
            PropertySetup.Get();
            PropertySetup.TestField("Customer Nos");
            CustomerRec.Init();
            //CustomerRec."No." := TenantApplication."Application ID";
            CustomerRec."No." := NoseriesMgt.GetNextNo(PropertySetup."Customer Nos");
            CustomerRec.Name := TenantApplication."Tenant Name";
            CustomerRec."Unit No." := TenantApplication."Unit No.";
            CustomerRec."Current Property No." := TenantApplication."Property Linked";
            CustomerRec."National ID/Passport" := TenantApplication."National ID/Passport";
            CustomerRec."Tenant Type" := TenantApplication."Tenant Type";
            CustomerRec."Tenant Category" := TenantApplication."Tenant Category";
            CustomerRec."Tenant Status" := CustomerRec."Tenant Status"::Active;
            CustomerRec."Date of Birth" := TenantApplication."Date of Birth";
            CustomerRec."Company Registration No." := TenantApplication."Company Registration No.";
            CustomerRec."Gen. Bus. Posting Group" := 'TENANT';
            CustomerRec."VAT Bus. Posting Group" := 'TENANT';
            CustomerRec."Customer Posting Group" := 'TENANT';

            CustomerRec.Insert(true);
            Message('Customer No %1 created successfully!', CustomerRec."No.");
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
