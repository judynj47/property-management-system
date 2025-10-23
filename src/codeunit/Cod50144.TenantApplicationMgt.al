codeunit 50135 "Tenant Application Mgt"
{
    Subtype = Normal;

    procedure CreateCustomerFromTenantApp(var TenantApp: Record "Tenant Application")
    var
        Customer: Record Customer;
        PropertySetup: Record "Property Setup";
        NoSeries: Codeunit "No. Series";
        CustNo: Code[20];

    begin
        // Only process approved applications
        if TenantApp."Tenant Application Status" <> TenantApp."Tenant Application Status"::Approved then
            exit;

        // Generate a new customer number from setup
        if not PropertySetup.Get() then
            Error('Property Setup record is missing.');

        PropertySetup.TestField("Customer Nos.");
        CustNo := NoSeries.GetNextNo(PropertySetup."Customer Nos.", WorkDate(), true);

        // Check if a customer already exists for this tenant
        if Customer.Get(CustNo) then
            exit;

        //  Initialize and create a new customer record
        Customer.Init();
        Customer."No." := CustNo;
        Customer.Name := TenantApp."Tenant Name";



        Customer.Insert(true);

        // Fill in tenant-specific extended fields
        Customer.Validate("Tenant Type", TenantApp."Tenant Type");
        Customer.Validate("National ID/Passport", TenantApp."National ID/Passport");
        Customer.Validate("Company Registration No.", TenantApp."Company Registration No.");
        Customer.Validate("Date of Birth", TenantApp."Date of Birth");
        Customer.Validate("Tenant Category", TenantApp."Tenant Category");
        Customer.Validate("Tenant Status", TenantApp."Tenant Status");
        Customer.Validate("Unit No.", TenantApp."Unit No.");
        Customer.Modify(true);

        Message(
            'Customer %1 (%2) has been created for tenant application %3.',
            Customer."No.", Customer.Name, TenantApp."Application ID");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Tenant Application", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnTenantApplicationModified(var Rec: Record "Tenant Application"; xRec: Record "Tenant Application")
    var
        TenantAppMgt: Codeunit "Tenant Application Mgt";
    begin
        if (Rec."Tenant Application Status" = Rec."Tenant Application Status"::Approved) and
           (xRec."Tenant Application Status" <> xRec."Tenant Application Status"::Approved)
        then
            TenantAppMgt.CreateCustomerFromTenantApp(Rec);
    end;
}
