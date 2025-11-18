codeunit 50157 "Rent Billing Scheduler"
{
    trigger OnRun()
    var
        Billing: Codeunit "Rent Billing";
    begin
        // Generate all invoices for today
        Billing.GenerateInvoices(WorkDate());

        // Process pending invoices (auto-posting if enabled in setup)
        Billing.ProcessPendingInvoices(0);

        // Apply late penalties daily
        Billing.ApplyLatePenalties(WorkDate());
    end;
}
