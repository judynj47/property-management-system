table 50164 "Cheque Register"
{

    fields
    {
        field(1; "Cheque No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(3; "Date Generated"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Bank Payment Type"; Option)
        {
            Caption = 'Bank Payment Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Computer Check,Manual Check,Electronic Payment';
            OptionMembers = " ","Computer Check","Manual Check","Electronic Payment";
        }
        field(7; "Entry Status"; Option)
        {
            Caption = 'Entry Status';
            DataClassification = ToBeClassified;
            OptionCaption = ',Printed,Voided,Posted,Financially Voided,Test Print,Exported,Transmitted,Issued,Cancelled';
            OptionMembers = ,Printed,Voided,Posted,"Financially Voided","Test Print",Exported,Transmitted,Issued,Cancelled;
        }
        field(8; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");
            end;
        }
        field(9; "Issued By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Posted By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Issued Doc No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Issued; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(13; Voided; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Voided By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Void Date-Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(16; Cancelled; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Cancelled By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Cancelled Date-Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Cheque No.", "Bank Account No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

