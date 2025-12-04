codeunit 50170 "Rent Invoice Calculation"
{

    procedure CalculateInvoiceCharges(var RentInvoice: Record "Rent Invoice")
    var
        LeaseRec: Record Lease;
        UnitRec: Record Unit;
        PropertyCharge: Record "Property Charge";
        RentInvoiceLine: Record "Rent Invoice Line";
        PropertySetupRec: Record "Property Setup";
        LineNo: Integer;
        TotalUtilityCharge: Decimal;
        TotalServiceCharge: Decimal;
        TotalRentAmount: Decimal;
        TotalPenaltyAmount: Decimal;
    begin
        if not LeaseRec.Get(RentInvoice."Lease No.") then
            Error('Lease %1 not found.', RentInvoice."Lease No.");

        if not UnitRec.Get(LeaseRec."Unit No.") then
            Error('Unit %1 not found.', LeaseRec."Unit No.");

        // Ensure Property Setup exists
        if not PropertySetupRec.Get() then
            Error('Property Setup record not found.');

        // Clear existing penalty lines
        RentInvoiceLine.SetRange("Invoice No.", RentInvoice."Rent Invoice No.");
        RentInvoiceLine.SetFilter("Charge Type", '<>%1', RentInvoiceLine."Charge Type"::Penalty);
        RentInvoiceLine.DeleteAll();

        LineNo := 10000;
        TotalUtilityCharge := 0;
        TotalServiceCharge := 0;
        TotalRentAmount := 0;
        TotalPenaltyAmount := 0;

        TotalRentAmount := LeaseRec."Rent Amount";
        if TotalRentAmount = 0 then
            TotalRentAmount := UnitRec."Rent Amount";

        if TotalRentAmount > 0 then
            InsertInvoiceLine(RentInvoice."Rent Invoice No.", LineNo, 'Monthly Rent', TotalRentAmount, RentInvoiceLine."Charge Type"::Rent, GetGLAccountForCharge(RentInvoiceLine."Charge Type"::Rent, LeaseRec."Property No."));

        LineNo += 10000;

        // if LeaseRec."Service Charge" > 0 then begin
        //     TotalServiceCharge := LeaseRec."Service Charge";
        //     InsertInvoiceLine(RentInvoice."Rent Invoice No.", LineNo, 'Service Charge', TotalServiceCharge, RentInvoiceLine."Charge Type"::Service, GetGLAccountForCharge(RentInvoiceLine."Charge Type"::Service, LeaseRec."Property No."));
        //     LineNo += 10000;
        // end else 
        begin
            // try property-level charges
            PropertyCharge.SetRange("Property No.", LeaseRec."Property No.");
            PropertyCharge.SetRange("Charge Type", PropertyCharge."Charge Type"::Service);
            if PropertyCharge.FindSet() then begin
                repeat
                    TotalServiceCharge += PropertyCharge.Amount;
                    InsertInvoiceLine(RentInvoice."Rent Invoice No.", LineNo, PropertyCharge."Charge Description", PropertyCharge.Amount, RentInvoiceLine."Charge Type"::Service, PropertyCharge."GL Account No.");
                    LineNo += 10000;
                until PropertyCharge.Next() = 0;
            end;
        end;

        // 3. Utility charges - prefer Lease, otherwise property-level
        // if LeaseRec."Utility Charge" > 0 then begin
        //     TotalUtilityCharge := LeaseRec."Utility Charge";
        //     InsertInvoiceLine(RentInvoice."Rent Invoice No.", LineNo, 'Utility Charge', TotalUtilityCharge, RentInvoiceLine."Charge Type"::Utility, GetGLAccountForCharge(RentInvoiceLine."Charge Type"::Utility, LeaseRec."Property No."));
        //     LineNo += 10000;
        // end else 
        begin
            PropertyCharge.SetRange("Property No.", LeaseRec."Property No.");
            PropertyCharge.SetRange("Charge Type", PropertyCharge."Charge Type"::Utility);
            if PropertyCharge.FindSet() then begin
                repeat
                    TotalUtilityCharge += PropertyCharge.Amount;
                    InsertInvoiceLine(RentInvoice."Rent Invoice No.", LineNo, PropertyCharge."Charge Description", PropertyCharge.Amount, RentInvoiceLine."Charge Type"::Utility, PropertyCharge."GL Account No.");
                    LineNo += 10000;
                until PropertyCharge.Next() = 0;
            end;
        end;

        // 4. Penalty or leave to ApplyLatePenalties
        TotalPenaltyAmount := UnitRec."Penalty Charge";
        if TotalPenaltyAmount > 0 then begin
            InsertInvoiceLine(RentInvoice."Rent Invoice No.", LineNo, 'Late Payment Penalty (10%)', TotalPenaltyAmount, RentInvoiceLine."Charge Type"::Penalty, GetGLAccountForCharge(RentInvoiceLine."Charge Type"::Penalty, LeaseRec."Property No."));
        end;

        // Update header fields
        UpdateRentInvoiceCharges(RentInvoice, TotalRentAmount, TotalUtilityCharge, TotalServiceCharge, TotalPenaltyAmount);
    end;

    local procedure InsertInvoiceLine(InvoiceNo: Code[20]; var LineNo: Integer; Description: Text[100]; Amount: Decimal; ChargeType: Enum "Charge Type"; GLAccountNo: Code[20])
    var
        LineRec: Record "Rent Invoice Line";
    begin
        if Amount = 0 then
            exit;

        LineRec.Init();
        LineRec."Invoice No." := InvoiceNo;
        LineRec."Line No." := LineNo;
        LineRec."Charge Type" := ChargeType;
        LineRec.Description := Description;
        LineRec.Amount := Amount;
        LineRec."GL Account No." := GLAccountNo;
        LineRec."Linked Lease No." := '';
        LineRec.Insert();

        LineNo += 10000;
    end;

    local procedure UpdateRentInvoiceCharges(var RentInvoice: Record "Rent Invoice"; RentAmount: Decimal; UtilityCharge: Decimal; ServiceCharge: Decimal; PenaltyAmount: Decimal)
    begin
        RentInvoice."Rent Amount" := RentAmount;
        RentInvoice."Utility Charge" := UtilityCharge;
        RentInvoice."Service Charge" := ServiceCharge;
        // Penalty stored on lines; keep header for display if you want
        RentInvoice.Modify();
    end;

    local procedure GetGLAccountForCharge(ChargeType: Enum "Charge Type"; PropertyNo: Code[20]): Code[20]
    var
        PropertyCharge: Record "Property Charge";
        PropertySetup: Record "Property Setup";
    begin
        // Try property charge entry first
        PropertyCharge.SetRange("Property No.", PropertyNo);
        PropertyCharge.SetRange("Charge Type", ChargeType);
        if PropertyCharge.FindFirst() and (PropertyCharge."GL Account No." <> '') then
            exit(PropertyCharge."GL Account No.");

        // Fallback to property setup
        PropertySetup.Get();
        case ChargeType of
            ChargeType::Rent:
                if PropertySetup."Revenue G/L Account" <> '' then
                    exit(PropertySetup."Revenue G/L Account");
            ChargeType::Penalty:
                if PropertySetup."Penalty G/L Account" <> '' then
                    exit(PropertySetup."Penalty G/L Account");
            ChargeType::Service:
                if PropertySetup."Service Charge G/L Account" <> '' then
                    exit(PropertySetup."Service Charge G/L Account");
            ChargeType::Utility:
                if PropertySetup."Utility G/L Account" <> '' then
                    exit(PropertySetup."Utility G/L Account");
        end;

        PropertySetup.TestField("Revenue G/L Account");
        exit(PropertySetup."Revenue G/L Account");
    end;

    procedure CopyInvoiceLinesToReceipt(SourceInvoiceNo: Code[20]; ReceiptNo: Code[20])
    var
        Src: Record "Rent Invoice Line";
        Tgt: Record "Rent Invoice Line";
        NextLineNo: Integer;
    begin
        // Do not duplicate
        Tgt.Reset();
        Tgt.SetRange("Invoice No.", ReceiptNo);
        if Tgt.FindFirst() then
            exit;

        // Get source lines
        Src.Reset();
        Src.SetRange("Invoice No.", SourceInvoiceNo);
        if not Src.FindSet() then
            Error('No invoice lines found for %1.', SourceInvoiceNo);

        // Determine next line no
        if Tgt.FindLast() then
            NextLineNo := Tgt."Line No." + 10000
        else
            NextLineNo := 10000;

        repeat
            Tgt.Init();
            Tgt."Invoice No." := ReceiptNo; 
            Tgt."Line No." := NextLineNo;

            Tgt.Description := Src.Description;
            Tgt.Amount := Src.Amount;
            Tgt."Charge Type" := Src."Charge Type";
            Tgt."GL Account No." := Src."GL Account No.";
            Tgt."Linked Lease No." := Src."Linked Lease No.";

            Tgt."IsReceiptLine" := true;
            Tgt."Source Invoice Line No." := Src."Line No.";

            Tgt.Insert(true);

            NextLineNo += 10000;
        until Src.Next() = 0;
    end;



}
