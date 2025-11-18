codeunit 50141 "Transfer Fields"
{
    trigger OnRun()
    begin
        CustomerRec.Get();
        CustomerRec.SetRange("No.");
        TenantRec.Init();
        TenantRec.TransferFields(CustomerRec);
        TenantRec.Insert();

    end;

    var
        CustomerRec: Record Customer;
        TenantRec: Record "Tenant Updated Details";
}