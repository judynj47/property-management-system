table 50132 "Tenant Updated Details"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[100])
        {
        }
        field(5; Address; Text[100])
        {
            Caption = 'Address';

        }
        field(6; "Address 2"; Text[50])
        {
        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(21; "Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
        }
        field(27; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
        }
        field(45; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
        }
        field(58; Balance; Decimal)
        {
        }
        field(59; "Balance (LCY)"; Decimal)
        {
        }
        field(66; "Balance Due"; Decimal)
        {
        }
        field(67; "Balance Due (LCY)"; Decimal)
        {
        }
        field(88; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        field(102; "E-Mail"; Text[80])
        {
            Caption = 'Email';
        }
        field(110; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
        }
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

        }
        field(50111; "Reason for Exit"; Enum "Exit Reason")
        {
            Caption = 'Reason for Exit';

        }
        field(50112; "Current Unit No."; Code[20])
        {
            Caption = 'Current Unit No.';

        }
        field(50113; "Current Property No."; Code[20])
        {
            Caption = 'Current Property No.';
            DataClassification = CustomerContent;

        }
        field(50114; "Current Lease No."; Code[20])
        {
            Caption = 'Current Lease No.';
        }
        field(50115; "Security Deposit Amount"; Decimal)
        {
            Caption = 'Security Deposit Amount';

        }
        field(50116; "Deposit Refunded"; Boolean)
        {
            Caption = 'Deposit Refunded';
            DataClassification = CustomerContent;
        }
        field(50117; "Unit No."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50118; Tenant; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50119; "Rent Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }


    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }





}