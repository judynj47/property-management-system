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
    //EmailMgmt: Codeunit "Email Management";
    begin
        if ApprovalEntry."Table ID" = Database::"Tenant Application" then begin
            if TenantApplication.Get(ApprovalEntry."Document No.") then begin

                TenantApplication.Validate("Tenant Application Status", TenantApplication."Tenant Application Status"::Approved);
                TenantApplication.Modify(true);



                //EmailMgmt.SendApplicationStatusEmail(TenantApplication, true); // true = approved

                //Message('"Tenant Application %1 has been approved. Notification email sent.', TenantApplication."A");
            end;
        end;
    end;

    //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, true)]
    // local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    // var
    //     TenantApplication: Record "Tenant Application";
    //     ApprovedTenant: Record "Approved Tenant";
    //     Customer: Record Customer;
    //     NoSeries: Codeunit "No. Series";
    //     PropertySetup: Record "Property Setup";
    //     CustNo: Code[20];
    // begin
    //     if ApprovalEntry."Table ID" = Database::"Tenant Application" then begin
    //         if TenantApplication.Get(ApprovalEntry."Document No.") then begin

    //             // Update status
    //             TenantApplication.Validate("Tenant Application Status", TenantApplication."Tenant Application Status"::Approved);
    //             TenantApplication.Modify(true);

    //             // Create Approved Tenant log entry (for reporting)
    //             if not ApprovedTenant.Get(TenantApplication."Application ID") then begin
    //                 ApprovedTenant.Init();
    //                 ApprovedTenant."Application ID" := TenantApplication."Application ID";
    //                 ApprovedTenant."Tenant Name" := TenantApplication."Tenant Name";
    //                 ApprovedTenant."Tenant Type" := TenantApplication."Tenant Type";
    //                 ApprovedTenant."National ID/Passport" := TenantApplication."National ID/Passport";
    //                 ApprovedTenant."Tenant Category" := TenantApplication."Tenant Category";
    //                 ApprovedTenant."Approval Date" := Today();
    //                 ApprovedTenant.Insert(true);
    //             end;

    //             // Create customer (extended table)
    //             if not PropertySetup.Get() then
    //                 Error('Property Setup record is missing.');
    //             PropertySetup.TestField("Customer Nos.");
    //             CustNo := NoSeries.GetNextNo(PropertySetup."Customer Nos.", WorkDate(), true);

    //             if not Customer.Get(CustNo) then begin
    //                 Customer.Init();
    //                 Customer."No." := CustNo;
    //                 Customer.Name := TenantApplication."Tenant Name";
    //                 Customer.Insert(true);
    //             end;

    //             // Populate extended tenant fields
    //             Customer.Validate("Tenant Type", TenantApplication."Tenant Type");
    //             Customer.Validate("National ID/Passport", TenantApplication."National ID/Passport");
    //             Customer.Validate("Tenant Category", TenantApplication."Tenant Category");
    //             Customer.Validate("Unit No.", TenantApplication."Unit No.");
    //             Customer.Validate("Tenant Application ID", TenantApplication."Application ID");
    //             Customer.Validate("Tenant Status", Customer."Tenant Status"::Active);
    //             Customer.Modify(true);

    //             // Link customer to approved tenant (optional)
    //             ApprovedTenant."Linked Customer No." := Customer."No.";
    //             ApprovedTenant.Modify(true);

    //             Message(
    //               'Tenant %1 has been approved and created as customer %2.',
    //               TenantApplication."Tenant Name", Customer."No.");
    //         end;
    //     end;
    // end;






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
        v: Codeunit "Record Restriction Mgt.";
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

    //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    // local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    // var
    //     TenantApp: Record "Tenant Application";
    //     ApprovedTenant: Record "Approved Tenant";
    // begin
    //     if ApprovalEntry."Table ID" = Database::"Tenant Application" then begin
    //         if TenantApp.Get(ApprovalEntry."Document No.") then begin
    //             TenantApp.Validate("Tenant Application Status", TenantApp."Tenant Application Status"::Rejected);
    //             TenantApp.Modify(true);

    //             if ApprovedTenant.Get(TenantApp."Application ID") then
    //                 ApprovedTenant.Delete();

    //             Message('Tenant application %1 has been rejected and removed from Approved Tenants.', TenantApp."Application ID");
    //         end;
    //     end;
    // end;



    var

        WorkflowMgt: Codeunit "Workflow Management";

        RUNWORKFLOWONSENDFORAPPROVALCODE: Label 'RUNWORKFLOWONSEND%1FORAPPROVAL';
        RUNWORKFLOWONCANCELFORAPPROVALCODE: Label 'RUNWORKFLOWONCANCEL%1FORAPPROVAL';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        WorkflowSendForApprovalEventDescTxt: Label 'Approval of %1 is requested.';
        WorkflowCancelForApprovalEventDescTxt: Label 'Approval of %1 is canceled.';
        // vendor: Page "Sales Invoice";
        // sales: Record "Sales Header";
        // vendor: Page "Vendor Card";
        // ven: Record Vendor;
        customer: Page "Customer Card";
        // cus: Record Customer;
        // rep: Report "Customer Statement";
        // v: Page "Sales Order";
        // S: Record "Sales Header";
        C: Record Customer;
        P: Page "Customer Details FactBox";
        s: Page "Sales & Receivables Setup";
        invoice: Record "Sales Invoice Header";
        si: Page "Sales Invoice Subform";
        st: Page "Sales & Receivables Setup";




}
