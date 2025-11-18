tableextension 50111 "Customer Tenant Ext" extends Customer
{
    fields
    {
        field(50100; "Tenant Type"; Enum "Tenant Type")
        {
            Caption = 'Tenant Type';
            DataClassification = CustomerContent;
        }
        field(50101; "National ID/Passport"; Text[30])
        {
            Caption = 'National ID/Passport';
            DataClassification = CustomerContent;
        }
        field(50102; "Company Registration No."; Text[30])
        {
            Caption = 'Company Registration No.';
            DataClassification = CustomerContent;
        }
        field(50103; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
            DataClassification = CustomerContent;
        }
        field(50104; "Tenant Category"; Enum "Tenant Category")
        {
            Caption = 'Tenant Category';
            DataClassification = CustomerContent;
        }
        field(50105; "Tenant Status"; Enum "Tenant Status")
        {
            Caption = 'Tenant Status';
            DataClassification = CustomerContent;
            //Editable = false;
        }
        field(50106; "Emergency Contact Name"; Text[100])
        {
            Caption = 'Emergency Contact Name';
            DataClassification = CustomerContent;
        }
        field(50107; "Emergency Contact Phone"; Text[30])
        {
            Caption = 'Emergency Contact Phone';
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;

            trigger OnValidate()
            var
                ch: Text[1];
                i: Integer;
            begin
                for i := 1 to StrLen("Phone No.") do begin
                    ch := CopyStr("Phone No.", i, 1);
                    if ((ch >= 'A') and (ch <= 'Z')) or ((ch >= 'a') and (ch <= 'z')) then
                        FieldError("Phone No.", PhoneNoCannotContainLettersErr);
                end;

                if (Rec."Phone No." <> xRec."Phone No.") then
                    SetForceUpdateContact(true);

                UpdateEmergencyPhone(FieldNo("Phone No."));
            end;

        }
        field(50108; "Emergency Contact Relation"; Enum "Emergency Contact Relation")
        {
            Caption = 'Emergency Contact Relation';
            DataClassification = CustomerContent;


        }
        field(50109; "Move-in Date"; Date)
        {
            Caption = 'Move-in Date';
            DataClassification = CustomerContent;
        }
        field(50110; "Move-out Date"; Date)
        {
            Caption = 'Move-out Date';
            DataClassification = CustomerContent;
        }
        field(50111; "Reason for Exit"; Enum "Exit Reason")
        {
            Caption = 'Reason for Exit';
            DataClassification = CustomerContent;
        }
        field(50112; "Current Unit No."; Code[20])
        {
            Caption = 'Current Unit No.';
            DataClassification = CustomerContent;
            //TableRelation = Unit;
        }
        field(50113; "Current Property No."; Code[20])
        {
            Caption = 'Current Property No.';
            DataClassification = CustomerContent;

            //TableRelation = Property;
        }
        field(50114; "Current Lease No."; Code[20])
        {
            Caption = 'Current Lease No.';
            DataClassification = CustomerContent;
            //TableRelation = Lease;
        }
        field(50115; "Security Deposit Amount"; Decimal)
        {
            Caption = 'Security Deposit Amount';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(50116; "Deposit Refunded"; Boolean)
        {
            Caption = 'Deposit Refunded';
            DataClassification = CustomerContent;
        }
        field(50117; "Unit No."; Code[20])
        {
            DataClassification = CustomerContent;
            //TableRelation = Unit;
        }
        field(50118; Tenant; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50119; "Rent Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50120; "Total Active Tenants"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Customer where("Tenant Status" = filter('Active')));
        }


    }






    trigger OnAfterModify()
    begin
        UpdateTenantStatus();
    end;

    local procedure UpdateTenantStatus()
    var
        Lease: Record Lease;
    begin
        if "Current Lease No." <> '' then begin
            Lease.Get("Current Lease No.");
            if Lease."Lease Status" = Lease."Lease Status"::Active then
                "Tenant Status" := "Tenant Status"::Active
            else
                "Tenant Status" := "Tenant Status"::Past;
        end else
            "Tenant Status" := "Tenant Status"::Prospective;
    end;

    var
        PhoneNoCannotContainLettersErr: Label 'must not contain letters';

    local procedure UpdateEmergencyPhone(CallingFieldNo: Integer)
    var
        MyTenant: Record Customer;
    begin
        case
            CallingFieldNo of
            FieldNo("Emergency Contact Phone"):
                begin
                    MyTenant.SetRange("No.", "No.");
                    if not MyTenant.IsEmpty() then
                        MyTenant.ModifyAll("Emergency Contact Phone", "Emergency Contact Phone");

                end;
        end;
    end;


}