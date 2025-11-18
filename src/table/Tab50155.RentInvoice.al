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
                InvRec: Record "Rent Invoice";
            begin
                if xRec."Rent Invoice No." <> '' then begin
                    InvRec.Reset();
                    InvRec.SetRange("Invoiced Tenant No.", xRec."Tenant No.");
                    InvRec.DeleteAll();
                    InvRec.Insert();

                    InvRec.Paid := false;
                end;
            end;
        }
        field(24; "Paid"; Boolean)
        {
            DataClassification = CustomerContent;
        }
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

    // Add a procedure to get detailed charge breakdown
    procedure GetChargeBreakdown(var RentAmount: Decimal; var UtilityAmount: Decimal; var ServiceAmount: Decimal)
    var
        RentInvoiceLine: Record "Rent Invoice Line";
    begin
        RentAmount := 0;
        UtilityAmount := 0;
        ServiceAmount := 0;

        RentInvoiceLine.SetRange("Invoice No.", "Rent Invoice No.");
        if RentInvoiceLine.FindSet() then
            repeat
                case RentInvoiceLine."Charge Type" of
                    RentInvoiceLine."Charge Type"::Rent:
                        RentAmount += RentInvoiceLine.Amount;
                    RentInvoiceLine."Charge Type"::Utility:
                        UtilityAmount += RentInvoiceLine.Amount;
                    RentInvoiceLine."Charge Type"::Service:
                        ServiceAmount += RentInvoiceLine.Amount;
                end;
            until RentInvoiceLine.Next() = 0;
    end;
}