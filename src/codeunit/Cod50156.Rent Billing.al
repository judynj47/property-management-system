codeunit 50156 "Rent Billing"
{
    var
        Batch: Record "Gen. Journal Batch";
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
        Text017: Label 'Are you sure you want to post receipt no. %1 ?';
        Text018: Label 'The receipt is already posted/paid';

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
                if not InvoiceExistsForPeriod(LeaseRec."No.", ForDate) then begin
                    InvRec.Init();
                    InvRec.Validate("Rent Invoice No.", NoSeriesMgt.GetNextNo(PropertySetup."Rent Invoice No.", WorkDate(), true));
                    InvRec.Validate("Tenant No.", LeaseRec."Tenant No.");
                    InvRec.Validate("Lease No.", LeaseRec."No.");
                    InvRec.Validate("Posting Date", ForDate);
                    InvRec.Validate("Date Invoiced", ForDate);
                    InvRec.Validate("Document Status", InvRec."Document Status"::Open);
                    InvRec.Insert(true);

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
        InvRec.SetRange("Document Type", InvRec."Document Type"::Invoice);

        if InvRec.FindSet() then
            repeat
                if PostInvoiceSafe(InvRec, ErrorText) then
                    Processed += 1
                else begin
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

        InvRec.SetRange("Document Status", InvRec."Document Status"::Open);
        InvRec.SetRange("Document Type", InvRec."Document Type"::Invoice);

        if InvRec.FindSet() then
            repeat
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

    // procedure ProcessReceipt(var InvRec: Record "Rent Invoice")
    // begin
    //     PostReceiptToGenJournal(InvRec);
    // end;




    procedure MarkInvoicePaid(var RentInvoice: Record "Rent Invoice")
    begin
        RentInvoice.Paid := true;
        RentInvoice.Modify();
    end;



    local procedure PostToGenJournal(var InvRec: Record "Rent Invoice")
    var
        LineRec: Record "Rent Invoice Line";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        Customer: Record Customer;
        LineNo: Integer;
        GLAccountNo: Code[20];
        TotalAmount: Decimal;
    begin
        LineRec.SetRange("Invoice No.", InvRec."Rent Invoice No.");
        LineRec.SetFilter(Amount, '<>0');
        if not LineRec.FindSet() then
            Error('No rent invoice lines with non-zero amounts found for Rent Invoice %1.', InvRec."Rent Invoice No.");

        if not GenJnlTemplate.Get('GENERAL') then
            Error('General journal template not found.');

        if not GenJnlBatch.Get('GENERAL', 'DEFAULT') then begin
            GenJnlBatch.Init();
            GenJnlBatch."Journal Template Name" := 'GENERAL';
            GenJnlBatch.Name := 'DEFAULT';
            GenJnlBatch.Description := 'Rent Invoices';
            GenJnlBatch.Insert();
        end;

        if not Customer.Get(InvRec."Tenant No.") then
            Error('Customer %1 not found.', InvRec."Tenant No.");

        PropertySetup.Get();

        // Get starting line number
        GenJnlLine.SetRange("Journal Template Name", 'GENERAL');
        GenJnlLine.SetRange("Journal Batch Name", 'DEFAULT');
        if GenJnlLine.FindLast() then
            LineNo := GenJnlLine."Line No." + 10000
        else
            LineNo := 10000;

        TotalAmount := 0;

        LineRec.FindSet();
        repeat
            if LineRec.Amount = 0 then
                Error('Line %1 has zero amount. Please remove or correct zero amount lines.', LineRec."Line No.");

            if LineRec."GL Account No." <> '' then
                GLAccountNo := LineRec."GL Account No."
            else
                GLAccountNo := GetGLAccountForChargeType(LineRec."Charge Type");

            GenJnlLine.Init();
            GenJnlLine."Journal Template Name" := 'GENERAL';
            GenJnlLine."Journal Batch Name" := 'DEFAULT';
            GenJnlLine."Line No." := LineNo;
            GenJnlLine."Posting Date" := InvRec."Posting Date";
            GenJnlLine."Document Date" := InvRec."Date Invoiced";
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
            GenJnlLine."Document No." := InvRec."Rent Invoice No.";
            GenJnlLine."External Document No." := InvRec."Rent Invoice No.";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
            GenJnlLine."Account No." := InvRec."Tenant No.";
            GenJnlLine.Description := GetInvoiceLineDescription(LineRec."Charge Type");
            GenJnlLine.Amount := LineRec.Amount;
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := GLAccountNo;
            GenJnlLine."Salespers./Purch. Code" := '';
            GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
            GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
            GenJnlLine.TestField(Amount);
            GenJnlLine.Insert();

            TotalAmount += LineRec.Amount;
            LineNo += 10000;
        until LineRec.Next() = 0;

        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJnlLine);

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
        SalesHeader."No." := '';
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

    procedure ProcessReceipt(var ReceiptRec: Record "Rent Invoice")
    var
        SourceInv: Record "Rent Invoice";
        RentInvCU: Codeunit "Rent Invoice Calculation";
    begin
        // Ensure receipt is saved
        ReceiptRec.Modify(true);

        if ReceiptRec."Document Type" <> ReceiptRec."Document Type"::Receipt then
            Error('This is not a receipt.');

        // Validate that source invoice exists
        if ReceiptRec."Source Invoice No." = '' then
            Error('Select a source invoice before posting.');

        if not SourceInv.Get(ReceiptRec."Source Invoice No.") then
            Error('Source invoice %1 not found.', ReceiptRec."Source Invoice No.");

        // Copy lines from source invoice → receipt
        RentInvCU.CopyInvoiceLinesToReceipt(SourceInv."Rent Invoice No.", ReceiptRec."Rent Invoice No.");

        // Post the receipt safely
        PostReceiptToGenJournal(ReceiptRec);

        // Mark source invoice as paid
        SourceInv."Paid" := true;
        SourceInv.Modify(true);
    end;


    procedure PostReceiptToGenJournal(var InvRec: Record "Rent Invoice")
    var
        ReceiptLine: Record "Rent Invoice Line";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        CustLedgEntry: Record "Cust. Ledger Entry";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        TotalAmount: Decimal;
        BankAccountNo: Code[20];
        LineNo: Integer;
        SourceDocumentNo: Code[20];
    begin
        // Validate source invoice
        if InvRec."Source Invoice No." = '' then
            Error('Receipt %1 does not have a source invoice.', InvRec."Rent Invoice No.");

        // Get receipt lines
        ReceiptLine.SetRange("Invoice No.", InvRec."Rent Invoice No.");
        ReceiptLine.SetRange("IsReceiptLine", true);
        if not ReceiptLine.FindSet() then
            Error('No receipt lines found for receipt %1.', InvRec."Rent Invoice No.");

        // Calculate total receipt amount
        TotalAmount := 0;
        repeat
            TotalAmount += ReceiptLine.Amount;
        until ReceiptLine.Next() = 0;

        // Find the correct customer ledger entry to apply to
        SourceDocumentNo := FindCustomerLedgerEntry(InvRec."Source Invoice No.", InvRec."Invoiced Tenant No.");
        if SourceDocumentNo = '' then
            Error('No open invoice found for Customer %1. Please check if the source invoice was posted correctly.',
                InvRec."Invoiced Tenant No.");

        // Ensure General Journal template exists
        if not GenJnlTemplate.Get('GENERAL') then
            Error('General journal template GENERAL not found.');

        // Ensure batch exists or create it
        if not GenJnlBatch.Get('GENERAL', 'RENTRCPT') then begin
            GenJnlBatch.Init();
            GenJnlBatch."Journal Template Name" := 'GENERAL';
            GenJnlBatch.Name := 'RENTRCPT';
            GenJnlBatch.Description := 'Rent Receipts';
            GenJnlBatch.Insert();
        end;

        // Determine bank account
        BankAccountNo := GetBankAccountForPaymentMode(InvRec);

        // Get next line number
        GenJnlLine.SetRange("Journal Template Name", 'GENERAL');
        GenJnlLine.SetRange("Journal Batch Name", 'RENTRCPT');
        if GenJnlLine.FindLast() then
            LineNo := GenJnlLine."Line No." + 10000
        else
            LineNo := 10000;

        // Prepare Gen. Journal line
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := 'GENERAL';
        GenJnlLine."Journal Batch Name" := 'RENTRCPT';
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Posting Date" := InvRec."Posting Date";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := InvRec."Rent Invoice No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := InvRec."Invoiced Tenant No.";
        GenJnlLine.Description := 'Rent Receipt ' + InvRec."Rent Invoice No.";
        GenJnlLine.Amount := -TotalAmount; // Credit to customer
        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
        GenJnlLine."Applies-to Doc. No." := SourceDocumentNo; // Use the actual document number from ledger
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
        GenJnlLine."Bal. Account No." := BankAccountNo;
        GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
        GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
        GenJnlLine.Insert();

        // Post the journal line
        Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJnlLine);

        // Update receipt status
        InvRec."Document Status" := InvRec."Document Status"::Posted;
        InvRec."Receipt Amount" := TotalAmount;
        InvRec."Posted Date" := WorkDate();
        InvRec.Modify(true);

        // Mark source invoice as paid
        MarkInvoiceAsPaid(InvRec."Source Invoice No.");

        Message('Receipt %1 posted successfully. Amount: %2 applied to document %3',
            InvRec."Rent Invoice No.", TotalAmount, SourceDocumentNo);
    end;


    procedure PostReceipt(var RentInvRec: Record "Rent Invoice")
    var
        RcptLines: Record "Rent Invoice Line";
        GenJnLine: Record "Gen. Journal Line";
        LineNo: Integer;
        VATSetup: Record "VAT Posting Setup";
        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        GLEntry: Record "G/L Entry";
        RentSetupRec: Record "Rent Setup";
    begin
        if Confirm(Text017, false, RentInvRec."Rent Invoice No.") = true then begin
            if RentInvRec.Paid then
                Error(Text018, RentInvRec."Rent Invoice No.");

            RentInvRec.TestField("Invoiced Tenant No.");
            //RentInvRec.TestField(Date);
            RentInvRec.TestField("Payment Mode");
            if RentInvRec."Posted Date" = 0D then
                Error('Please input posting date');

        end;
        RcptLines.Amount := RentInvRec."Receipt Amount";
        // Delete Lines Present on the General Journal Line
        GenJnLine.Reset;
        //GenJnLine.SetRange(GenJnLine."Journal Template Name", RentSetupRec."Receipt Template");
        GenJnLine.SetRange(GenJnLine."Journal Batch Name", RentInvRec."Rent Invoice No.");
        GenJnLine.DeleteAll;
        Batch.Init;
        if RentSetupRec.Get() then
            Batch."Journal Template Name" := RentSetupRec."Receipt Template";
        Batch.Name := RentInvRec."Rent Invoice No.";
        if not Batch.Get(Batch."Journal Template Name", RentInvRec."Rent Invoice No.") then
            Batch.Insert;
        //Bank Entries
        LineNo := LineNo + 10000;
        RcptLines.Reset;
        //RcptLines.SETRANGE("Payment Type",ReceiptRec."Payment Type");
        RcptLines.SetRange("Invoice No.", RentInvRec."Rent Invoice No.");
        RcptLines.Validate(Amount);
        RcptLines.CalcSums(Amount);
        GenJnLine.Init;
        if RentSetupRec.Get then
            GenJnLine."Journal Template Name" := RentSetupRec."Receipt Template";
        GenJnLine."Journal Batch Name" := RentInvRec."Rent Invoice No.";
        GenJnLine."Line No." := LineNo;
        GenJnLine."Account Type" := GenJnLine."Account Type"::"Bank Account";
        GenJnLine."Account No." := RentInvRec."Paying Bank Account";
        GenJnLine.Validate(GenJnLine."Account No.");
        if RentInvRec.Date = 0D then
            Error('You must specify the Receipt date');
        GenJnLine."Posting Date" := RentInvRec."Payment Release Date";
        GenJnLine."Document No." := RentInvRec."Rent Invoice No.";
        GenJnLine."External Document No." := RentInvRec."Cheque No";
        GenJnLine."Payment Method Code" := RentInvRec."Pay Mode";
        GenJnLine.Description := RentInvRec."Received From";
        GenJnLine.Amount := RentInvRec."Receipt Amount";
        GenJnLine."Currency Code" := RentInvRec.Currency;
        GenJnLine.Validate("Currency Code");
        GenJnLine.Validate(GenJnLine.Amount);
        GenJnLine."Shortcut Dimension 1 Code" := RentInvRec."Shortcut Dimension 1 Code";
        GenJnLine.Validate(GenJnLine."Shortcut Dimension 1 Code");
        GenJnLine."Shortcut Dimension 2 Code" := RentInvRec."Shortcut Dimension 2 Code";
        GenJnLine.Validate(GenJnLine."Shortcut Dimension 2 Code");
        if GenJnLine.Amount <> 0 then
            GenJnLine.Insert;
        //Receipt Lines Entries
        RcptLines.Reset;
        //RcptLines.SETRANGE("Payment Type",ReceiptRec."Payment Type");
        RcptLines.SetRange("Invoice No.", RentInvRec."Rent Invoice No.");

    end;



    local procedure FindCustomerLedgerEntry(SourceInvoiceNo: Code[20]; CustomerNo: Code[20]): Code[20]
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        RentInvoice: Record "Rent Invoice";
    begin
        // First try: Find by External Document No (if posted via General Journal)
        CustLedgEntry.SetRange("Customer No.", CustomerNo);
        CustLedgEntry.SetRange("External Document No.", SourceInvoiceNo);
        CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
        CustLedgEntry.SetRange(Open, true);
        if CustLedgEntry.FindFirst() then
            exit(CustLedgEntry."Document No.");

        // Second try: Find by Document No directly (if posted via Sales Invoice)
        CustLedgEntry.SetRange("External Document No.");
        CustLedgEntry.SetRange("Document No.", SourceInvoiceNo);
        CustLedgEntry.SetRange(Open, true);
        if CustLedgEntry.FindFirst() then
            exit(CustLedgEntry."Document No.");

        // Third try: Look for Sales Invoice with matching External Document No
        SalesInvoiceHeader.SetRange("Sell-to Customer No.", CustomerNo);
        SalesInvoiceHeader.SetRange("External Document No.", SourceInvoiceNo);
        if SalesInvoiceHeader.FindFirst() then begin
            CustLedgEntry.SetRange("Document No.", SalesInvoiceHeader."No.");
            CustLedgEntry.SetRange(Open, true);
            if CustLedgEntry.FindFirst() then
                exit(CustLedgEntry."Document No.");
        end;

        // Fourth try: Any open invoice for this customer
        CustLedgEntry.SetRange("Document No.");
        CustLedgEntry.SetRange("Customer No.", CustomerNo);
        CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
        CustLedgEntry.SetRange(Open, true);
        CustLedgEntry.SetFilter("Remaining Amount", '>0');
        if CustLedgEntry.FindFirst() then
            exit(CustLedgEntry."Document No.");

        exit('');
    end;

    local procedure PostInvoiceSafe(var InvRec: Record "Rent Invoice"; var ErrorText: Text[250]): Boolean
    begin
        ErrorText := '';
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
            ChargeType::Penalty:
                begin
                    if PropertySetup."Penalty G/L Account" <> '' then
                        exit(PropertySetup."Penalty G/L Account")
                    else
                        exit(PropertySetup."Revenue G/L Account");
                end;
            else begin
                PropertySetup.TestField("Revenue G/L Account");
                exit(PropertySetup."Revenue G/L Account");
            end;
        end;
    end;

    local procedure GetBankAccountForPaymentMode(InvRec: Record "Rent Invoice"): Code[20]
    begin
        PropertySetup.Get();

        case InvRec."Payment Mode" of
            InvRec."Payment Mode"::Cash:
                begin
                    if PropertySetup."Receipt Bank Account" <> '' then
                        exit(PropertySetup."Receipt Bank Account")
                    else
                        Error('Receipt Bank Account is not set in Property Setup.');
                end;
            InvRec."Payment Mode"::Mpesa:
                begin
                    if PropertySetup."Receipt Bank Account" <> '' then
                        exit(PropertySetup."Receipt Bank Account")
                    else
                        Error('Receipt Bank Account is not set in Property Setup.');
                end;
            // InvRec."Payment Mode"::BankTransfer:
            //     begin
            //         if InvRec."Bank Account No." <> '' then
            //             exit(InvRec."Bank Account No.")
            //         else
            //             Error('Bank Account is not specified for bank transfer.');
            //     end;
            else
                Error('Invalid payment mode selected.');
        end;
    end;

    local procedure GetReceiptDescription(InvRec: Record "Rent Invoice"): Text[100]
    var
        ReceiptLine: Record "Rent Invoice Line";
        Description: Text[100];
        ChargeTypes: Text;
    begin
        Description := 'Rent Receipt ' + InvRec."Rent Invoice No.";

        if InvRec."Source Invoice No." <> '' then
            Description += ' for Inv. ' + InvRec."Source Invoice No.";

        // Build charge types string
        ReceiptLine.SetRange("Invoice No.", InvRec."Rent Invoice No.");
        ReceiptLine.SetRange("IsReceiptLine", true);
        if ReceiptLine.FindSet() then begin
            ChargeTypes := '';
            repeat
                if ChargeTypes <> '' then
                    ChargeTypes += ', ';

                case ReceiptLine."Charge Type" of
                    ReceiptLine."Charge Type"::Rent:
                        ChargeTypes += 'Rent';
                    ReceiptLine."Charge Type"::Service:
                        ChargeTypes += 'Service';
                    ReceiptLine."Charge Type"::Utility:
                        ChargeTypes += 'Utility';
                    ReceiptLine."Charge Type"::Penalty:
                        ChargeTypes += 'Penalty';
                    else
                        ChargeTypes += 'Other';
                end;
            until ReceiptLine.Next() = 0;

            if ChargeTypes <> '' then
                Description += ' (' + ChargeTypes + ')';
        end;

        exit(CopyStr(Description, 1, 100));
    end;

    local procedure GetInvoiceLineDescription(ChargeType: Enum "Charge Type"): Text[100]
    begin
        case ChargeType of
            ChargeType::Rent:
                exit('Monthly Rent Charges');
            ChargeType::Service:
                exit('Service Charges');
            ChargeType::Utility:
                exit('Utility Charges');
            ChargeType::Penalty:
                exit('Penalty Charges');
            else
                exit('Rent Invoice Charges');
        end;
    end;

    local procedure MarkInvoiceAsPaid(InvoiceNo: Code[20])
    var
        OriginalInvoice: Record "Rent Invoice";
    begin
        if OriginalInvoice.Get(InvoiceNo) then begin
            OriginalInvoice."Paid" := true;
            OriginalInvoice.Modify();
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
        if Lease.Get(InvRec."Lease No.") then
            if UnitRec.Get(Lease."Unit No.") then
                if UnitRec."Penalty Charge" > 0 then
                    exit(UnitRec."Penalty Charge");

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