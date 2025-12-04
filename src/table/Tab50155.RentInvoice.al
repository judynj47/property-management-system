table 50155 "Rent Invoice"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Rent Invoice List";
    LookupPageId = "Rent Invoice List";

    fields
    {
        field(1; "Rent Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Tenant No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer."No." where("Tenant Category" = filter('Residential|Commercial'));
            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if Customer.Get("Tenant No.") then begin
                    "Tenant Name" := Customer.Name;
                    "Invoiced Tenant No." := Customer."No.";
                    UpdateLeaseDetailsFromTenant();
                end else begin
                    Clear("Tenant Name");
                    ClearLeaseDetails();
                end;
            end;
        }
        field(3; "Tenant Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; "Lease No."; Code[20])
        {
            DataClassification = CustomerContent;

            TableRelation = Lease."No." where("Tenant No." = field("Tenant No."));
            trigger OnValidate()
            begin
                UpdateLeaseDetails();
            end;
        }
        field(5; "Receipt Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; "Payment Mode"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Cash,Mpesa;
        }
        field(7; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Date Invoiced"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Posted Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Invoice","Receipt";
        }
        field(12; "Document Status"; Enum "Document Status")
        {
            DataClassification = CustomerContent;
        }
        field(13; "Process Automatically"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Last Processing Error"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Processing Attempts"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(16; "Next Processing DateTime"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(17; "Property No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Property;
            Editable = false;
        }
        field(18; "Unit No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Unit;
            Editable = false;
        }
        field(19; "Rent Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "Utility Charge"; Decimal)
        {
            Caption = 'Utility Charge';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(21; "Service Charge"; Decimal)
        {
            Caption = 'Service Charge';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(22; "Total Charges"; Decimal)
        {
            Caption = 'Total Charges';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(23; "Invoiced Tenant No."; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer."No." where(Tenant = const(true));
            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                if Cust.Get("Tenant No.") then begin
                    "Tenant Name" := Cust.Name;
                    UpdateLeaseDetailsFromTenant();
                end else begin
                    Clear("Tenant Name");
                    ClearLeaseDetails();
                end;


                // if xRec."Rent Invoice No." <> '' then begin
                //     InvRec.Reset();
                //     InvRec.SetRange("Invoiced Tenant No.", xRec."Tenant No.");
                //     InvRec.DeleteAll();
                //     InvRec.Insert();

                //     InvRec.Paid := false;
                // end;
            end;
        }
        field(119; "Received From"; Text[100])
        {

            trigger OnValidate()
            begin
                "On behalf of" := "Received From";
            end;
        }
        field(120; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(121; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(68; "Payment Release Date"; Date)
        {
        }
        field(24; "Paid"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;

        }
        field(25; "Source Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Rent Invoice"."Rent Invoice No." where(
                "Document Type" = const(Invoice),
                "Document Status" = const(Posted),
                "Paid" = const(false)
            );
            Caption = 'Source Invoice No.';

            trigger OnValidate()
            var
                SourceInvoice: Record "Rent Invoice";
            begin
                if "Source Invoice No." <> '' then begin
                    // Verify the source invoice exists and get tenant details
                    if SourceInvoice.Get("Source Invoice No.") then begin
                        // Validate that the source invoice is appropriate
                        if SourceInvoice."Document Type" <> SourceInvoice."Document Type"::Invoice then
                            Error('Selected document is not an invoice.');

                        if SourceInvoice."Document Status" <> SourceInvoice."Document Status"::Posted then
                            Error('Selected invoice is not posted.');

                        if SourceInvoice.Paid then
                            Error('Selected invoice is already paid.');

                        // Auto-populate tenant information from source invoice
                        "Invoiced Tenant No." := SourceInvoice."Tenant No.";
                        "Tenant Name" := SourceInvoice."Tenant Name";
                        "Lease No." := SourceInvoice."Lease No.";
                        "Property No." := SourceInvoice."Property No.";
                        "Unit No." := SourceInvoice."Unit No.";

                        // Auto-populate receipt lines
                        AutoPopulateReceiptLines();
                    end else begin
                        Error('Source invoice %1 not found.', "Source Invoice No.");
                    end;
                end else begin
                    // Clear related fields if source invoice is cleared
                    Clear("Invoiced Tenant No.");
                    Clear("Tenant Name");
                    Clear("Lease No.");
                    Clear("Property No.");
                    Clear("Unit No.");

                    // Clear receipt lines
                    ClearReceiptLines();
                end;
            end;
        }
        field(26; "Document No."; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(27; "Paying Bank Account"; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Bank.Get("Paying Bank Account") then begin
                    //    Bank.TESTFIELD(Name);
                    //    Bank.TESTFIELD("Currency Code");
                    //    Bank.TESTFIELD("Bank Type");
                    "Bank Name" := Bank.Name;
                    Currency := Bank."Currency Code";
                end;
            end;
        }
        field(28; Currency; Code[20])
        {
            TableRelation = Currency;
            trigger OnValidate()
            begin
                // if "Receiving Bank Amount" <> 0 then
                Validate("Receiving Bank Amount");
            end;
        }
        field(50001; "Bank Name"; Text[100])
        {
            CalcFormula = Lookup("Bank Account".Name WHERE("No." = FIELD("Paying Bank Account")));
            Caption = 'Bank Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50037; "Receiving Bank Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CurrencyRec.InitRoundingPrecision;

                if Currency = '' then
                    "Receiving Amount LCY" := Round("Receiving Bank Amount", CurrencyRec."Amount Rounding Precision")
                else
                    "Receiving Amount LCY" := Round(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          Date, Currency,
                          "Receiving Bank Amount", CurrExchRate.ExchangeRate(Date, Currency)),
                          CurrencyRec."Amount Rounding Precision");
            end;
        }
        field(50041; "Receiving Amount LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(50038; "Source Bank"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
                if Bank.Get("Source Bank") then begin
                    "Source Currency" := Bank."Currency Code";
                    Validate("Source Currency");
                end;
            end;
        }
        field(50039; "Source Currency"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency.Code;

            trigger OnValidate()
            begin
                if "Source Bank Amount" <> 0 then
                    Validate("Source Bank Amount");
            end;
        }
        field(50042; "Source Amount LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50040; "Source Bank Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CurrencyRec.InitRoundingPrecision;

                if "Source Currency" = '' then
                    "Source Amount LCY" := Round("Source Bank Amount", CurrencyRec."Amount Rounding Precision")
                else
                    "Source Amount LCY" := Round(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          Date, "Source Currency",
                          "Source Bank Amount", CurrExchRate.ExchangeRate(Date, "Source Currency")),
                          CurrencyRec."Amount Rounding Precision");
            end;
        }
        field(50; Date; Date)
        {
        }
        field(51; "Pay Mode"; Code[20])
        {
            TableRelation = "Payment Method";
        }
        field(52; "Cheque No"; Code[20])
        {
            TableRelation = IF ("Cheque Type" = FILTER("Computer Check")) "Cheque Register"."Cheque No." WHERE("Bank Account No." = FIELD("Paying Bank Account"),
                                                                                                              Issued = CONST(false),
                                                                                                              Voided = CONST(false),
                                                                                                              Cancelled = CONST(false));

            trigger OnValidate()
            begin
                /*
                IF "Cheque No"<>'' THEN BEGIN
                PV.RESET;
                PV.SETRANGE(PV."Cheque No","Cheque No");
                IF PV.FIND('-') THEN BEGIN
                IF PV."No." <> "No." THEN
                   ERROR(Text002);
                END;
                END;
                */
                if "Cheque No" <> '' then begin
                    if "Cheque Type" = "Cheque Type"::"Computer Check" then begin
                        if Confirm('Are you sure you want to issue Cheque No. %1', false, "Cheque No") then begin
                            ChequeRegister.Reset;
                            ChequeRegister.SetRange(ChequeRegister."Cheque No.", "Cheque No");
                            if ChequeRegister.FindFirst then begin
                                ChequeRegister."Entry Status" := ChequeRegister."Entry Status"::Issued;
                                ChequeRegister."Issued By" := UserId;
                                ChequeRegister."Issued Doc No." := "Rent Invoice No.";
                                ChequeRegister."Cheque Date" := "Cheque Date";
                                ChequeRegister.Issued := true;
                                ChequeRegister.Modify;
                            end;
                        end else
                            "Cheque No" := '';
                    end;
                end;

            end;
        }
        field(86; "Cheque Type"; Option)
        {
            OptionCaption = ' ,Computer Check,Manual Check';
            OptionMembers = " ","Computer Check","Manual Check";
        }
        field(61; "Cheque Date"; Date)
        {
        }
        field(81; Payee; Text[100])
        {
        }
        field(91; "On behalf of"; Text[250])
        {
        }
        // field(25; "Source Invoice No."; Code[20])
        // {
        //     DataClassification = CustomerContent;
        //     TableRelation = "Rent Invoice"."Rent Invoice No." where(
        //         "Document Type" = const(Invoice),
        //         "Document Status" = const(Posted),
        //         "Paid" = const(false)
        //     //,"Tenant No." = field("Invoiced Tenant No.")
        //     );
        //     Caption = 'Source Invoice No.';

        //     trigger OnValidate()
        //     begin
        //         if "Source Invoice No." <> '' then
        //             AutoPopulateReceiptLines();
        //     end;
        // }
    }

    keys
    {
        key(PK; "Rent Invoice No.")
        {
            Clustered = true;
        }
        key(Processing; "Process Automatically", "Document Status", "Next Processing DateTime")
        {
        }
        key(DocumentType; "Document Type")
        {
        }
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit "No. Series";
        PropertySetup: Record "Property Setup";
        Customer: Record Customer;
        Receipt: Page "Receipt Card";
    begin
        if "Rent Invoice No." = '' then begin
            PropertySetup.Get();
            PropertySetup.TestField("Rent Invoice No.");
            Rec."Rent Invoice No." := NoSeriesMgt.GetNextNo(PropertySetup."Rent Invoice No.", 0D, true);

        end;

        // Auto-populate tenant name
        if "Tenant No." <> '' then begin
            if Customer.Get("Tenant No.") then
                "Tenant Name" := Customer.Name;
        end;

        // Set default dates
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();
        if "Date Invoiced" = 0D then
            "Date Invoiced" := WorkDate();
    end;

    // Single CalculateTotalAmount procedure
    procedure CalculateTotalAmount() Total: Decimal
    var
        LineRec: Record "Rent Invoice Line";
    begin
        Total := 0;
        LineRec.SetRange("Invoice No.", "Rent Invoice No.");
        if LineRec.FindSet() then
            repeat
                Total += LineRec.Amount;
            until LineRec.Next() = 0;

        // Update the total charges field
        "Total Charges" := Total;
        "Receipt Amount" := Total;
    end;

    trigger OnModify()
    begin

        // Auto-update receipt amount when lines are modified
        "Receipt Amount" := CalculateTotalAmount();
    end;

    local procedure UpdateLeaseDetails()
    var
        Lease: Record Lease;
    begin
        if "Lease No." <> '' then begin
            if Lease.Get("Lease No.") then begin
                "Tenant No." := Lease."Tenant No.";
                "Tenant Name" := Lease."Tenant Name";
                "Property No." := Lease."Property No.";
                "Unit No." := Lease."Unit No.";
                "Rent Amount" := Lease."Rent Amount";
            end;
        end else begin
            ClearLeaseDetails();
        end;
    end;

    local procedure UpdateLeaseDetailsFromTenant()
    var
        Lease: Record Lease;
    begin
        if "Tenant No." <> '' then begin
            Lease.SetRange("Tenant No.", "Tenant No.");
            Lease.SetRange("Lease Status", Lease."Lease Status"::Active);
            if Lease.FindFirst() then begin
                "Lease No." := Lease."No.";
                UpdateLeaseDetails();
            end else begin
                ClearLeaseDetails();
            end;
        end else begin
            ClearLeaseDetails();
        end;
    end;

    local procedure ClearLeaseDetails()
    begin
        Clear("Property No.");
        Clear("Unit No.");
        Clear("Rent Amount");
    end;

    procedure AutoPopulateReceiptLines()
    var
        SourceInvoice: Record "Rent Invoice";
        SourceInvoiceLine: Record "Rent Invoice Line";
        ReceiptLine: Record "Rent Invoice Line";
        LineNo: Integer;
    begin
        if "Document Type" <> "Document Type"::"Receipt" then
            exit;

        if "Source Invoice No." = '' then
            exit;

        // Verify the source invoice exists and is posted
        if not SourceInvoice.Get("Source Invoice No.") then
            Error('Source invoice %1 not found.', "Source Invoice No.");

        if SourceInvoice."Document Status" <> SourceInvoice."Document Status"::Posted then
            Error('Source invoice %1 is not posted.', "Source Invoice No.");

        if SourceInvoice.Paid then
            Error('Source invoice %1 is already fully paid.', "Source Invoice No.");

        // Clear existing receipt lines
        ReceiptLine.SetRange("Invoice No.", "Rent Invoice No.");
        ReceiptLine.DeleteAll();

        // Add lines from source invoice
        SourceInvoiceLine.SetRange("Invoice No.", "Source Invoice No.");
        if SourceInvoiceLine.FindSet() then begin
            LineNo := 10000;
            repeat
                ReceiptLine.Init();
                ReceiptLine."Invoice No." := "Rent Invoice No.";
                ReceiptLine."Line No." := LineNo;
                ReceiptLine."Charge Type" := SourceInvoiceLine."Charge Type";
                ReceiptLine.Description := SourceInvoiceLine.Description;
                ReceiptLine.Amount := SourceInvoiceLine.Amount;
                ReceiptLine."GL Account No." := SourceInvoiceLine."GL Account No.";
                ReceiptLine."IsReceiptLine" := true;
                ReceiptLine."Source Invoice Line No." := SourceInvoiceLine."Line No.";
                ReceiptLine.Insert();

                LineNo += 10000;
            until SourceInvoiceLine.Next() = 0;
        end;

        // Update receipt amount
        CalculateTotalAmount();

        // Auto-fill tenant details
        "Invoiced Tenant No." := SourceInvoice."Tenant No.";
        "Tenant Name" := SourceInvoice."Tenant Name";
        "Lease No." := SourceInvoice."Lease No.";
        "Property No." := SourceInvoice."Property No.";
        "Unit No." := SourceInvoice."Unit No.";
        Modify();
    end;




    //11.19.2025. 
    // procedure AutoPopulateReceiptLines()
    // var
    //     SourceInvoice: Record "Rent Invoice";
    //     SourceInvoiceLine: Record "Rent Invoice Line";
    //     ReceiptLine: Record "Rent Invoice Line";
    //     LineNo: Integer;
    // begin
    //     if "Document Type" <> "Document Type"::Receipt then
    //         exit;

    //     if "Source Invoice No." = '' then
    //         exit;

    //     // Clear existing receipt lines
    //     ReceiptLine.SetRange("Invoice No.", "Rent Invoice No.");
    //     //ReceiptLine.SetRange("IsReceiptLine", true);
    //     ReceiptLine.DeleteAll();

    //     // Get source invoice lines
    //     SourceInvoiceLine.SetRange("Invoice No.", "Source Invoice No.");
    //     if SourceInvoiceLine.FindSet() then begin
    //         LineNo := 10000;
    //         repeat
    //             ReceiptLine.Init();
    //             ReceiptLine."Invoice No." := "Rent Invoice No.";
    //             ReceiptLine."Line No." := LineNo;
    //             ReceiptLine."Charge Type" := SourceInvoiceLine."Charge Type";
    //             ReceiptLine.Description := SourceInvoiceLine.Description;
    //             ReceiptLine.Amount := SourceInvoiceLine.Amount;
    //             ReceiptLine."GL Account No." := SourceInvoiceLine."GL Account No.";
    //             // ReceiptLine."IsReceiptLine" := true;
    //             // ReceiptLine."Source Invoice Line No." := SourceInvoiceLine."Line No.";
    //             ReceiptLine.Insert();

    //             LineNo += 10000;
    //         until SourceInvoiceLine.Next() = 0;
    //     end;

    //     // Update receipt amount
    //     CalculateTotalAmount();

    //     // Update tenant info from source invoice
    //     if SourceInvoice.Get("Source Invoice No.") then begin
    //         "Invoiced Tenant No." := SourceInvoice."Tenant No.";
    //         "Tenant Name" := SourceInvoice."Tenant Name";
    //         "Lease No." := SourceInvoice."Lease No.";
    //         "Property No." := SourceInvoice."Property No.";
    //         "Unit No." := SourceInvoice."Unit No.";
    //         Modify();
    //     end;
    // end;

    local procedure ClearReceiptLines()
    var
        ReceiptLine: Record "Rent Invoice Line";
    begin
        if "Document Type" <> "Document Type"::Receipt then
            exit;

        ReceiptLine.SetRange("Invoice No.", "Rent Invoice No.");
        ReceiptLine.SetRange("IsReceiptLine", true);
        ReceiptLine.DeleteAll();

        "Receipt Amount" := 0;
        Modify();
    end;


    // Add a procedure to get detailed charge breakdown
    // procedure GetChargeBreakdown(var RentAmount: Decimal; var UtilityAmount: Decimal; var ServiceAmount: Decimal)
    // var
    //     RentInvoiceLine: Record "Rent Invoice Line";
    // begin
    //     RentAmount := 0;
    //     UtilityAmount := 0;
    //     ServiceAmount := 0;

    //     RentInvoiceLine.SetRange("Invoice No.", "Rent Invoice No.");
    //     if RentInvoiceLine.FindSet() then
    //         repeat
    //             case RentInvoiceLine."Charge Type" of
    //                 RentInvoiceLine."Charge Type"::Rent:
    //                     RentAmount += RentInvoiceLine.Amount;
    //                 RentInvoiceLine."Charge Type"::Utility:
    //                     UtilityAmount += RentInvoiceLine.Amount;
    //                 RentInvoiceLine."Charge Type"::Service:
    //                     ServiceAmount += RentInvoiceLine.Amount;
    //             end;
    //         until RentInvoiceLine.Next() = 0;
    // end;

    // local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    //     var
    //         OldDimSetID: Integer;
    //     begin
    //         OldDimSetID := "Dimension Set ID";
    //         DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");

    //         if OldDimSetID <> "Dimension Set ID" then begin
    //             if PaymentLinesExist then
    //                 UpdateAllLineDim("Dimension Set ID", OldDimSetID);
    //         end;
    //     end;
    var
        Bank: Record "Bank Account";
        CurrencyRec: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        ChequeRegister: Record "Cheque Register";
}
