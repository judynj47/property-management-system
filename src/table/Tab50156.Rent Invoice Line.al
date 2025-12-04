table 50156 "Rent Invoice Line"
{
    DataClassification = CustomerContent;
    Caption = 'PMS Rent Invoice Line';

    fields
    {
        field(1; "Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Rent Invoice"."Rent Invoice No.";

        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Charge Type"; Enum "Charge Type")
        {
            DataClassification = CustomerContent;
        }
        field(6; "GL Account No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            Caption = 'G/L Account';
        }
        field(7; "Linked Lease No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Lease."No.";
        }
        field(8; "IsReceiptLine"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Is Receipt Line';
        }
        field(9; "Source Invoice Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Source Invoice Line No.';
        }
        field(10; "Posted Invoice No."; Code[20])
        {
            Caption = 'Posted Invoice No.';
            DataClassification = CustomerContent;
            TableRelation = "Sales Invoice Header";
        }
        field(11; "Posted Invoice Line No."; Integer)
        {
            Caption = 'Posted Invoice Line No.';
            DataClassification = CustomerContent;
        }

        // field(3; "Charge Type"; Enum "Charge Type")
        // {
        //     DataClassification = CustomerContent;
        // }
        // field(4; Description; Text[100])
        // {
        //     DataClassification = CustomerContent;
        // }
        // field(5; Amount; Decimal)
        // {
        //     DataClassification = CustomerContent;
        // }

        // field(7; "GL Account No."; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'G/L Account (optional)';
        // }
    }

    keys
    {
        key(PK; "Invoice No.", "Line No.")
        {
            Clustered = true;
        }
        key(InvoiceNo; "Invoice No.", "Charge Type")
        {
        }
    }
    trigger OnInsert()
    var
        RentInvoice: Record "Rent Invoice";
        ChargeSetup: Record "Charge Setup";
    begin
        if RentInvoice.Get("Invoice No.") then begin
            if RentInvoice."Document Type" = RentInvoice."Document Type"::Receipt then
                "IsReceiptLine" := true
            else
                "IsReceiptLine" := false;
        end;

        if "IsReceiptLine" then
            exit;

        // Normal invoice line behavior
        if ChargeSetup.Get() then begin
            if Description = '' then
                Description := ChargeSetup."Charge Description";
            if "Charge Type" = "Charge Type"::" " then
                "Charge Type" := ChargeSetup."Charge Type";
            if "GL Account No." = '' then
                "GL Account No." := ChargeSetup."GL Account No.";
            if Amount = 0 then
                Amount := ChargeSetup.Amount;

            if Amount = 0 then
                Amount := ChargeSetup."Default Amount";
        end;
    end;

    // trigger OnInsert()
    // var
    //     RentInvoice: Record "Rent Invoice";
    //     ChargeSetup: Record "Charge Setup";
    // begin
    //     if RentInvoice.Get("Invoice No.") then begin
    //         if RentInvoice."Document Type" = RentInvoice."Document Type"::Receipt then
    //             "IsReceiptLine" := true
    //         else
    //             "IsReceiptLine" := false;
    //     end;

    //     // Only auto-populate for invoice lines, not receipt lines
    //     if not "IsReceiptLine" then begin
    //         if ChargeSetup.Get() then begin
    //             if Description = '' then
    //                 Description := ChargeSetup."Charge Description";
    //             if "Charge Type" = "Charge Type"::" " then
    //                 "Charge Type" := ChargeSetup."Charge Type";
    //             if "GL Account No." = '' then
    //                 "GL Account No." := ChargeSetup."GL Account No.";
    //             if Amount = 0 then
    //                 Amount := ChargeSetup.Amount;
    //             if Amount = 0 then
    //                 Amount := ChargeSetup."Default Amount";
    //         end;
    //     end;
    // end;

    //20.11.2025
    // trigger OnInsert()
    // var
    //     ChargeSetup: Record "Charge Setup";
    //     RentInvoice: Record "Rent Invoice";
    // begin
    //     if not RentInvoice.Get("Invoice No.") then
    //         exit;

    //     if RentInvoice."Document Type" = RentInvoice."Document Type"::Receipt then
    //         "IsReceiptLine" := true
    //     else
    //         "IsReceiptLine" := false;

    //     if ChargeSetup.Get() and (not "IsReceiptLine") then begin
    //         Description := ChargeSetup."Charge Description";
    //         "Charge Type" := ChargeSetup."Charge Type";
    //         "GL Account No." := ChargeSetup."GL Account No.";
    //         Amount := ChargeSetup.Amount;
    //         if Amount = 0 then
    //             Amount := ChargeSetup."Default Amount";
    //     end;
    // end;
}
// trigger OnInsert()
// var
//     ChargeSetup: Record "Charge Setup";
// begin
//     if ChargeSetup.Get() then begin
//         Description := ChargeSetup."Charge Description";
//         "Charge Type" := ChargeSetup."Charge Type";
//         "GL Account No." := ChargeSetup."GL Account No.";
//         Amount := ChargeSetup.Amount;
//         if Amount = 0 then
//             Amount := ChargeSetup."Default Amount";

//     end;
// end;

