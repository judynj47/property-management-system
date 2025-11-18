codeunit 50156 "Rent Billing"
{
    SingleInstance = true;

    var
        RentInvoiceRec: Record "Rent Invoice";
        RentInvoiceLineRec: Record "Rent Invoice Line";
        LeaseRec: Record Lease;
        CustomerRec: Record Customer;
        PenSetupRec: Record "PMS Penalty Setup";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PropertySetup: Record "Property Setup";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        SalesPost: Codeunit "Sales-Post";
        RentInvoiceCalculation: Codeunit "Rent Invoice Calculation";

    procedure GenerateInvoices(ForDate: Date)
    var
        LeaseRec: Record "Lease";
        InvRec: Record "Rent Invoice";
        PropertySetup: Record "Property Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if not PropertySetup.Get() then
            Error('Property Setup record not found.');

        LeaseRec.Reset();
        LeaseRec.SetRange("Lease Status", LeaseRec."Lease Status"::Active);
        LeaseRec.SetFilter("Rent Amount", '>0');
        if LeaseRec.FindSet() then
            repeat
                // Check if invoice already exists for this period
                if not InvoiceExistsForPeriod(LeaseRec."No.", ForDate) then begin
                    // Create Rent Invoice Header with lease details
                    InvRec.Init();
                    InvRec.Validate("Rent Invoice No.", NoSeriesMgt.GetNextNo(PropertySetup."Rent Invoice No.", WorkDate(), true));
                    InvRec.Validate("Tenant No.", LeaseRec."Tenant No.");
                    InvRec.Validate("Lease No.", LeaseRec."No.");
                    InvRec.Validate("Posting Date", ForDate);
                    InvRec.Validate("Date Invoiced", ForDate);
                    InvRec.Validate("Document Status", InvRec."Document Status"::Open);
                    InvRec.Insert(true);

                    // Use charge calculation to automatically create all charge lines
                    CalculateChargesForInvoice(InvRec);

                    Message('Generated invoice %1 for tenant %2 (Lease: %3)',
                        InvRec."Rent Invoice No.", InvRec."Tenant Name", InvRec."Lease No.");
                end;
            until LeaseRec.Next() = 0;
    end;

    local procedure InvoiceExistsForPeriod(LeaseNo: Code[20]; ForDate: Date): Boolean
    var
        RentInvoice: Record "Rent Invoice";
    begin
        RentInvoice.SetRange("Lease No.", LeaseNo);
        RentInvoice.SetRange("Date Invoiced", ForDate);
        exit(not RentInvoice.IsEmpty);
    end;

    procedure CalculateChargesForInvoice(var RentInvoice: Record "Rent Invoice")
    begin
        RentInvoiceCalculation.CalculateInvoiceCharges(RentInvoice);
    end;


    procedure ProcessPendingInvoices(MaxRecords: Integer)
    var
        InvRec: Record "Rent Invoice";
        Processed: Integer;
        ErrorText: Text[250];
    begin
        Processed := 0;
        InvRec.SetRange("Process Automatically", true);
        InvRec.SetRange("Document Status", InvRec."Document Status"::Open);

        if InvRec.FindSet() then
            repeat
                if PostInvoiceSafe(InvRec, ErrorText) then begin
                    Processed += 1;
                end else begin
                    InvRec."Processing Attempts" += 1;
                    InvRec."Last Processing Error" := ErrorText;
                    InvRec.Modify();
                end;

                if (MaxRecords > 0) and (Processed >= MaxRecords) then
                    exit;

            until InvRec.Next() = 0;
    end;

    procedure ApplyLatePenalties(AsOfDate: Date)
    var
        InvRec: Record "Rent Invoice";
        Penalty: Decimal;
        LineNo: Integer;
    begin
        if not PenSetupRec.Get('DEFAULT') then
            exit;

        InvRec.SetRange("Document Status", InvRec."Document Status"::Open); // Apply to open invoices only

        if InvRec.FindSet() then
            repeat
                // Check if penalty already exists for this invoice
                if not PenaltyLineExists(InvRec."Rent Invoice No.") then begin
                    Penalty := ComputePenaltyForInvoice(InvRec, PenSetupRec, AsOfDate);
                    if Penalty > 0 then begin
                        LineNo := GetNextInvoiceLineNo(InvRec."Rent Invoice No.");
                        RentInvoiceLineRec.Init();
                        RentInvoiceLineRec."Invoice No." := InvRec."Rent Invoice No.";
                        RentInvoiceLineRec."Line No." := LineNo;
                        RentInvoiceLineRec."Charge Type" := RentInvoiceLineRec."Charge Type"::Penalty;
                        RentInvoiceLineRec.Description := 'Late payment penalty';
                        RentInvoiceLineRec.Amount := Penalty;
                        RentInvoiceLineRec."GL Account No." := GetGLAccountForChargeType(RentInvoiceLineRec."Charge Type");
                        RentInvoiceLineRec.Insert();

                        // Recalculate total amount after adding penalty
                        InvRec.CalculateTotalAmount();
                        InvRec.Modify();

                        Message('Added penalty of %1 to invoice %2', Penalty, InvRec."Rent Invoice No.");
                    end;
                end;
            until InvRec.Next() = 0;
    end;

    procedure ProcessInvoice(var InvRec: Record "Rent Invoice")
    begin
        PostToGenJournal(InvRec);
    end;

    procedure ProcessInvoice_Sales(var InvRec: Record "Rent Invoice")
    begin
        PostToSalesInvoice(InvRec);
    end;

    procedure ProcessReceipt(var InvRec: Record "Rent Invoice")
    begin
        PostReceiptToGenJournal(InvRec);
    end;


    procedure PostReceipt(var InvRec: Record "Rent Invoice")
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        // Validate that invoice is posted
        if InvRec."Document Status" <> InvRec."Document Status"::Posted then
            Error('Rent receipt %1 must be posted before receiving payment.', InvRec."Rent Invoice No.");

        // Find the outstanding invoice in customer ledger
        CustLedgerEntry.SetRange("Document No.", InvRec."Rent Invoice No.");
        CustLedgerEntry.SetRange(Open, true);
        if not CustLedgerEntry.FindFirst() then
            Error('No open invoice found for receipt.');

        // Get or create cash receipt batch
        if not GenJnlTemplate.Get('CASH') then
            Error('Cash journal template not found.');

        if not GenJnlBatch.Get('CASH', 'DEFAULT') then begin
            GenJnlBatch.Init();
            GenJnlBatch."Journal Template Name" := 'CASH';
            GenJnlBatch.Name := 'DEFAULT';
            GenJnlBatch.Description := 'Rent Receipts';
            GenJnlBatch.Insert();
        end;

        // Create cash receipt journal line
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := 'CASH';
        GenJnlLine."Journal Batch Name" := 'DEFAULT';
        GenJnlLine."Line No." := 10000;
        GenJnlLine."Posting Date" := WorkDate();
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := InvRec."Rent Invoice No." + '-RCPT';
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := InvRec."Tenant No.";
        GenJnlLine.Description := 'Payment received for Rent Invoice ' + InvRec."Rent Invoice No.";
        GenJnlLine.Amount := -InvRec."Receipt Amount"; // Negative for customer payment
        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
        GenJnlLine."Applies-to Doc. No." := InvRec."Rent Invoice No.";
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        // You might want to set a default bank account in Property Setup
        GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
        GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
        GenJnlLine.Insert();

        // Post the receipt
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJnlLine);

        Message('Receipt posted for Rent Invoice %1. Amount: %2', InvRec."Rent Invoice No.", InvRec."Receipt Amount");
    end;

    local procedure PostToGenJournal(var InvRec: Record "Rent Invoice")
    var
        LineRec: Record "Rent Invoice Line";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        Customer: Record Customer;
        LineCount: Integer;
        GLAccountNo: Code[20];
        TotalAmount: Decimal;
    begin
        // Validate that invoice has lines with non-zero amounts
        LineRec.SetRange("Invoice No.", InvRec."Rent Invoice No.");
        LineRec.SetFilter(Amount, '<>0'); // Only include lines with non-zero amounts
        if not LineRec.FindSet() then
            Error('No rent invoice lines with non-zero amounts found for Rent Invoice %1.', InvRec."Rent Invoice No.");

        // Get or create journal batch
        if not GenJnlTemplate.Get('GENERAL') then
            Error('General journal template not found.');

        if not GenJnlBatch.Get('GENERAL', 'DEFAULT') then begin
            GenJnlBatch.Init();
            GenJnlBatch."Journal Template Name" := 'GENERAL';
            GenJnlBatch.Name := 'DEFAULT';
            GenJnlBatch.Description := 'Rent Invoices';
            GenJnlBatch.Insert();
        end;

        // Validate customer exists
        if not Customer.Get(InvRec."Tenant No.") then
            Error('Customer %1 not found.', InvRec."Tenant No.");

        PropertySetup.Get();

        LineCount := 0;
        TotalAmount := 0;

        // First pass: Calculate total amount and validate lines
        repeat
            if LineRec.Amount = 0 then
                Error('Line %1 has zero amount. Please remove or correct zero amount lines.', LineRec."Line No.");

            TotalAmount += LineRec.Amount;
        until LineRec.Next() = 0;

        // Second pass: Create journal lines
        LineRec.FindSet();
        repeat
            LineCount += 1;

            // Get appropriate G/L account for charge type - use line G/L account if available
            if LineRec."GL Account No." <> '' then
                GLAccountNo := LineRec."GL Account No."
            else
                GLAccountNo := GetGLAccountForChargeType(LineRec."Charge Type");

            // Create journal line for each invoice line
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name" := 'GENERAL';
            GenJnlLine."Journal Batch Name" := 'DEFAULT';
            GenJnlLine."Line No." := LineCount + 10000;
            GenJnlLine."Posting Date" := InvRec."Posting Date";
            GenJnlLine."Document Date" := InvRec."Date Invoiced";
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
            GenJnlLine."Document No." := InvRec."Rent Invoice No.";
            GenJnlLine."External Document No." := InvRec."Rent Invoice No.";

            // Debit customer
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
            GenJnlLine."Account No." := InvRec."Tenant No.";
            GenJnlLine.Description := LineRec.Description;
            GenJnlLine.Amount := LineRec.Amount;
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := GLAccountNo;
            GenJnlLine."Salespers./Purch. Code" := ''; //not necessary
            GenJnlLine."Source Code" := GenJnlTemplate."Source Code"; //not necessary
            GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";//not necessary

            // Validate the line before inserting
            GenJnlLine.TestField(Amount);

            if not GenJnlLine.Insert() then
                GenJnlLine.Modify();//the modify below instead of this repeat until linerec.next()=0
        until LineRec.Next() = 0;

        // Post the journal lines
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJnlLine);

        //modify before insert.
        // GenJnlLine.Reset;
        //         GenJnlLine.SetRange("Journal Template Name", InvestmentSetup."General Journal");
        //         GenJnlLine.SetRange("Journal Batch Name", TransferHeaderNew."No.");
        //         GenJnlLine.DeleteAll;


        // Update invoice status
        InvRec."Document Status" := InvRec."Document Status"::Posted;
        InvRec."Posted Date" := WorkDate();
        InvRec.Modify(true);

        Message('Rent Invoice %1 posted successfully via General Journal. Total Amount: %2', InvRec."Rent Invoice No.", TotalAmount);
    end;

    local procedure PostToSalesInvoice(var InvRec: Record "Rent Invoice")
    var
        LineRec: Record "Rent Invoice Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PropertySetup: Record "Property Setup";
        SalesPost: Codeunit "Sales-Post";
        SalesLineNo: Integer;
        IsHandled: Boolean;
        GLAccountNo: Code[20];
    begin
        // Validate pre-conditions
        if InvRec."Document Status" = InvRec."Document Status"::Posted then
            Error('Rent Invoice %1 is already posted.', InvRec."Rent Invoice No.");

        if not PropertySetup.Get() then
            Error('Property Setup record not found.');

        // Check for lines
        LineRec.SetRange("Invoice No.", InvRec."Rent Invoice No.");
        if not LineRec.FindSet() then
            Error('No rent invoice lines found for Rent Invoice %1.', InvRec."Rent Invoice No.");

        // Create Sales Header
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."No." := ''; // Let system assign number
        SalesHeader.Validate("Sell-to Customer No.", InvRec."Tenant No.");
        SalesHeader.Validate("Posting Date", InvRec."Posting Date");
        SalesHeader.Validate("Document Date", InvRec."Date Invoiced");
        SalesHeader."External Document No." := InvRec."Rent Invoice No.";
        SalesHeader."Due Date" := CalcDate('<30D>', InvRec."Posting Date"); // 30 days due date
        SalesHeader.Insert(true);

        // Add Sales Lines
        SalesLineNo := 10000;
        repeat
            // Use G/L account from invoice line if available, otherwise fall back to charge type mapping
            if LineRec."GL Account No." <> '' then
                GLAccountNo := LineRec."GL Account No."
            else
                GLAccountNo := GetGLAccountForChargeType(LineRec."Charge Type");

            SalesLine.Init();
            SalesLine."Document Type" := SalesHeader."Document Type";
            SalesLine."Document No." := SalesHeader."No.";
            SalesLine."Line No." := SalesLineNo;
            SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
            SalesLine.Validate("No.", GLAccountNo);
            SalesLine.Validate(Description, LineRec.Description);
            SalesLine.Validate(Quantity, 1);
            SalesLine.Validate("Unit Price", LineRec.Amount);
            SalesLine.Insert(true);
            SalesLineNo += 10000;
        until LineRec.Next() = 0;

        // Post the sales invoice
        IsHandled := false;
        OnBeforePostSalesInvoice(SalesHeader, IsHandled);

        if not IsHandled then begin
            Clear(SalesPost);
            SalesPost.SetPreviewMode(false);
            SalesPost.Run(SalesHeader);
        end;

        // Update rent invoice status
        InvRec."Document Status" := InvRec."Document Status"::Posted;
        InvRec."Posted Date" := WorkDate();
        InvRec.Modify(true);

        Message('Rent Invoice %1 posted as Sales Invoice %2. Total Amount: %3', InvRec."Rent Invoice No.", SalesHeader."No.", InvRec."Receipt Amount");
    end;

    local procedure PostInvoiceSafe(var InvRec: Record "Rent Invoice"; var ErrorText: Text[250]): Boolean
    begin
        ErrorText := '';
        // Attempt to post via GenJournal method
        if InvRec."Document Status" = InvRec."Document Status"::Open then begin
            if InvRec."Tenant No." <> '' then begin
                PostToGenJournal(InvRec);
                exit(true);
            end else begin
                ErrorText := 'Tenant No. is empty.';
                exit(false);
            end;
        end;
        exit(false);
    end;

    local procedure PostReceiptToGenJournal(var InvRec: Record "Rent Invoice")
    var
        LineRec: Record "Rent Invoice Line";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        Customer: Record Customer;
        LineCount: Integer;
        GLAccountNo: Code[20];
        TotalAmount: Decimal;
    begin
        // Validate that invoice has lines with non-zero amounts
        LineRec.SetRange("Invoice No.", InvRec."Rent Invoice No.");
        LineRec.SetFilter(Amount, '<>0'); // Only include lines with non-zero amounts
        if not LineRec.FindSet() then
            Error('No rent invoice lines with non-zero amounts found for Rent Invoice %1.', InvRec."Rent Invoice No.");

        // Get or create journal batch
        if not GenJnlTemplate.Get('GENERAL') then
            Error('General journal template not found.');

        if not GenJnlBatch.Get('GENERAL', 'DEFAULT') then begin
            GenJnlBatch.Init();
            GenJnlBatch."Journal Template Name" := 'GENERAL';
            GenJnlBatch.Name := 'DEFAULT';
            GenJnlBatch.Description := 'Rent Receipt';
            GenJnlBatch.Insert();
        end;

        // Validate customer exists
        if not Customer.Get(InvRec."Tenant No.") then
            Error('Customer %1 not found.', InvRec."Tenant No.");

        PropertySetup.Get();

        LineCount := 0;
        TotalAmount := 0;

        // First pass: Calculate total amount and validate lines
        repeat
            if LineRec.Amount = 0 then
                Error('Line %1 has zero amount. Please remove or correct zero amount lines.', LineRec."Line No.");

            TotalAmount += LineRec.Amount;
        until LineRec.Next() = 0;

        // Second pass: Create journal lines
        LineRec.FindSet();
        repeat
            LineCount += 1;

            // Get appropriate G/L account for charge type - use line G/L account if available
            if LineRec."GL Account No." <> '' then
                GLAccountNo := LineRec."GL Account No."
            else
                GLAccountNo := GetGLAccountForChargeType(LineRec."Charge Type");

            // Create journal line for each invoice line
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name" := 'GENERAL';
            GenJnlLine."Journal Batch Name" := 'DEFAULT';
            GenJnlLine."Line No." := LineCount + 10000;
            GenJnlLine."Posting Date" := InvRec."Posting Date";
            GenJnlLine."Document Date" := InvRec."Date Invoiced";
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
            GenJnlLine."Document No." := InvRec."Rent Invoice No.";
            GenJnlLine."External Document No." := InvRec."Rent Invoice No.";

            // Credit customer
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer; //check if I can create a g/l account for crediting customers
            GenJnlLine."Account No." := InvRec."Tenant No.";
            GenJnlLine.Description := LineRec.Description;
            GenJnlLine.Amount := -TotalAmount;
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := GLAccountNo;

            // Validate the line before inserting
            GenJnlLine.TestField(Amount);

            // if not GenJnlLine.Insert() then
            //     GenJnlLine.Modify();//the modify below instead of this repeat until linerec.next()=0
            //until LineRec.Next() = 0;
            if GenJnlLine.Amount <> 0 then begin
                GenJnlLine.Insert(true);
            end;
        until LineRec.Next() = 0;


        // Post the journal lines
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJnlLine);

        //modify before insert.
        // GenJnlLine.Reset;
        //         GenJnlLine.SetRange("Journal Template Name", InvestmentSetup."General Journal");
        //         GenJnlLine.SetRange("Journal Batch Name", TransferHeaderNew."No.");
        //         GenJnlLine.DeleteAll;
        repeat
            GenJnlLine.Reset();
            GenJnlLine.SetRange("Journal Template Name", 'GENERAL');
            GenJnlLine.SetRange("Journal Batch Name", 'DEFAULT');
            GenJnlLine.DeleteAll();
        until LineRec.Next() = 0;



        // Update invoice status
        InvRec."Document Status" := InvRec."Document Status"::Posted;
        InvRec."Posted Date" := WorkDate();
        InvRec.Modify(true);

        Message('Rent receipt %1 posted successfully via General Journal. Total Amount: %2', InvRec."Rent Invoice No.", TotalAmount);
    end;

    local procedure GetGLAccountForChargeType(ChargeType: Enum "Charge Type"): Code[20]
    begin
        PropertySetup.Get();
        case ChargeType of
            ChargeType::Rent:
                begin
                    PropertySetup.TestField("Revenue G/L Account");
                    exit(PropertySetup."Revenue G/L Account");
                end;
            ChargeType::Service:
                begin
                    // If you add Service Charge G/L Account to Property Setup, use it here
                    // Otherwise fall back to Revenue account
                    if PropertySetup."Service Charge G/L Account" <> '' then
                        exit(PropertySetup."Service Charge G/L Account")
                    else
                        exit(PropertySetup."Revenue G/L Account");
                end;
            ChargeType::Utility:
                begin
                    if PropertySetup."Utility G/L Account" <> '' then
                        exit(PropertySetup."Utility G/L Account")
                    else
                        exit(PropertySetup."Revenue G/L Account");
                end;
            // ChargeType::Penalty:
            //     begin
            //         if PropertySetup."Penalty G/L Account" <> '' then
            //             exit(PropertySetup."Penalty G/L Account")
            //         else
            //             exit(PropertySetup."Revenue G/L Account");
            //     end;
            // ChargeType::Tax:
            //     begin
            //         if PropertySetup."Tax G/L Account" <> '' then
            //             exit(PropertySetup."Tax G/L Account")
            //         else
            //             exit(PropertySetup."Revenue G/L Account");
            //     end;
            else begin
                PropertySetup.TestField("Revenue G/L Account");
                exit(PropertySetup."Revenue G/L Account");
            end;
        end;
    end;

    local procedure CalculateInvoiceTotal(InvoiceNo: Code[20]): Decimal
    var
        LineRec: Record "Rent Invoice Line";
        Total: Decimal;
    begin
        Total := 0;
        LineRec.SetRange("Invoice No.", InvoiceNo);
        if LineRec.FindSet() then
            repeat
                Total += LineRec.Amount;
            until LineRec.Next() = 0;
        exit(Total);
    end;

    local procedure GetNextRentInvoiceNo(): Code[20]
    var
        NoSeriesMgt: Codeunit "No. Series";
    begin
        PropertySetup.Get();
        PropertySetup.TestField("Rent Invoice No.");
        exit(NoSeriesMgt.GetNextNo(PropertySetup."Rent Invoice No.", 0D, true));
    end;

    local procedure GetCustomerNameSafe(CustNo: Code[20]): Text[100]
    begin
        if CustomerRec.Get(CustNo) then
            exit(CustomerRec.Name)
        else
            exit('');
    end;

    local procedure GetNextInvoiceLineNo(InvoiceNo: Code[20]): Integer
    var
        LineRec: Record "Rent Invoice Line";
    begin
        LineRec.SetRange("Invoice No.", InvoiceNo);
        if not LineRec.FindLast() then
            exit(10000);
        exit(LineRec."Line No." + 10000);
    end;

    local procedure ComputePenaltyForInvoice(var InvRec: Record "Rent Invoice"; var PenSetup: Record "PMS Penalty Setup"; AsOfDate: Date): Decimal
    var
        Lease: Record Lease;
        UnitRec: Record Unit;
        DaysOverdue: Integer;
        Outstanding: Decimal;
        Penalty: Decimal;
    begin
        // Get the unit to calculate penalty (10% of rent)
        if Lease.Get(InvRec."Lease No.") then
            if UnitRec.Get(Lease."Unit No.") then begin
                // Use the unit's pre-calculated penalty charge
                if UnitRec."Penalty Charge" > 0 then
                    exit(UnitRec."Penalty Charge");
            end;

        // Fallback calculation if unit penalty is not set
        Outstanding := CalculateInvoiceTotal(InvRec."Rent Invoice No.");
        DaysOverdue := AsOfDate - InvRec."Posting Date";

        if DaysOverdue <= PenSetup."Grace Days" then
            exit(0);

        if PenSetup."Penalty Type" = PenSetup."Penalty Type"::Flat then
            Penalty := PenSetup.Amount
        else
            Penalty := (Outstanding * PenSetup.Amount) / 100;

        exit(Penalty);
    end;


    local procedure PenaltyLineExists(InvoiceNo: Code[20]): Boolean
    var
        RentInvoiceLine: Record "Rent Invoice Line";
    begin
        RentInvoiceLine.SetRange("Invoice No.", InvoiceNo);
        RentInvoiceLine.SetRange("Charge Type", RentInvoiceLine."Charge Type"::Penalty);
        exit(not RentInvoiceLine.IsEmpty);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostSalesInvoice(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;
}