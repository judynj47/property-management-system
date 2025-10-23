// table 50107 "Owner"
// {
//     DataClassification = CustomerContent;
//     Caption = 'Owner';
//     DrillDownPageId = "Owner List";
//     LookupPageId = "Owner List";

//     fields
//     {
//         field(1; "No."; Code[20])
//         {
//             Caption = 'Owner No.';
//             DataClassification = CustomerContent;
//         }
//         field(2; Name; Text[100])
//         {
//             Caption = 'Name';
//             DataClassification = CustomerContent;
//         }
//         field(3; "Company Name"; Text[100])
//         {
//             Caption = 'Company Name';
//             DataClassification = CustomerContent;
//         }
//         field(4; "Owner Type"; Enum "Owner Type")
//         {
//             Caption = 'Owner Type';
//             DataClassification = CustomerContent;
//         }
//         field(5; "Ownership Type"; Enum "Ownership Type")
//         {
//             Caption = 'Ownership Type';
//             DataClassification = CustomerContent;
//         }
//         field(6; Address; Text[100])
//         {
//             Caption = 'Address';
//             DataClassification = CustomerContent;
//         }
//         field(7; "Address 2"; Text[50])
//         {
//             Caption = 'Address 2';
//             DataClassification = CustomerContent;
//         }
//         field(8; City; Text[30])
//         {
//             Caption = 'City';
//             DataClassification = CustomerContent;
//         }
//         field(9; "Post Code"; Code[20])
//         {
//             Caption = 'Post Code';
//             DataClassification = CustomerContent;
//             TableRelation = "Post Code";
//         }
//         field(10; "Country/Region Code"; Code[10])
//         {
//             Caption = 'Country/Region Code';
//             DataClassification = CustomerContent;
//             TableRelation = "Country/Region";
//         }
//         field(11; "Phone No."; Text[30])
//         {
//             Caption = 'Phone No.';
//             OptimizeForTextSearch = true;
//             ExtendedDatatype = PhoneNo;
//             ToolTip = 'Specifies the customer''s telephone number.';

//             trigger OnValidate()
//             var
//                 i: Integer;
//                 ch: Text[1];
//                 PhoneNoCannotContainLettersErr: Label 'Phone number cannot contain letters.';
//             begin
//                 for i := 1 to StrLen("Phone No.") do begin
//                     ch := CopyStr("Phone No.", i, 1);
//                     if ch in ['A' .. 'Z', 'a' .. 'z'] then
//                         FieldError("Phone No.", PhoneNoCannotContainLettersErr);
//                 end;

//                 if ("Phone No." <> xRec."Phone No.") then
//                     SetForceUpdateContact(true);

//                 UpdateMyOwner(FieldNo("Phone No."));
//             end;

//         }
//         field(12; "Email"; Text[80])
//         {
//             Caption = 'Email';
//             DataClassification = CustomerContent;
//             ExtendedDatatype = EMail;
//         }
//         field(13; "Acquisition Date"; Date)
//         {
//             Caption = 'Acquisition Date';
//             DataClassification = CustomerContent;
//         }
//         field(14; "National ID/Passport"; Text[30])
//         {
//             Caption = 'National ID/Passport';
//             DataClassification = CustomerContent;
//         }
//         field(15; "Company Registration No."; Text[30])
//         {
//             Caption = 'Company Registration No.';
//             DataClassification = CustomerContent;
//         }
//         field(16; "Tax Identification No."; Text[30])
//         {
//             Caption = 'Tax Identification No.';
//             DataClassification = CustomerContent;
//         }
//         field(17; "Bank Name"; Text[100])
//         {
//             Caption = 'Bank Name';
//             DataClassification = CustomerContent;
//         }
//         field(18; "Bank Branch"; Text[50])
//         {
//             Caption = 'Bank Branch';
//             DataClassification = CustomerContent;
//         }
//         field(19; "Bank Account No."; Text[50])
//         {
//             Caption = 'Bank Account No.';
//             DataClassification = CustomerContent;
//         }
//         field(20; "IBAN"; Code[50])
//         {
//             Caption = 'IBAN';
//             DataClassification = CustomerContent;
//         }
//         field(21; "Mobile Money Account"; Text[30])
//         {
//             Caption = 'Mobile Money Account';
//             DataClassification = CustomerContent;
//         }
//         field(22; "Paybill No."; Text[20])
//         {
//             Caption = 'Paybill No.';
//             DataClassification = CustomerContent;
//         }
//         field(23; "Till No."; Text[20])
//         {
//             Caption = 'Till No.';
//             DataClassification = CustomerContent;
//         }
//         field(24; "Preferred Payment Method"; Enum "Preferred Payment Method")
//         {
//             Caption = 'Preferred Payment Method';
//             DataClassification = CustomerContent;
//         }
//         field(25; "Total Properties"; Integer)
//         {
//             Caption = 'Total Properties';
//             //DataClassification = CustomerContent;
//             Editable = false;
//             FieldClass = FlowField;
//             CalcFormula = count(Property where("Owner No." = field("No.")));
//         }
//         // field(26; "Total Monthly Rent"; Decimal)
//         // {
//         //     Caption = 'Total Monthly Rent';
//         //     //DataClassification = CustomerContent;
//         //     Editable = false;
//         //     AutoFormatType = 1;
//         //     FieldClass = FlowField;
//         //     //CalcFormula = sum(Unit."Rent Amount" where("Current Tenant No." = filter(<> '')));
//         // }
//         field(27; Blocked; Boolean)
//         {
//             Caption = 'Blocked';
//             DataClassification = CustomerContent;
//         }
//     }

//     keys
//     {
//         key(PK; "No.")
//         {
//             Clustered = true;
//         }
//     }

//     fieldgroups
//     {
//         // Add changes to field groups here
//     }

//     trigger OnInsert()
//     var
//         NoSeriesMgt: Codeunit "No. Series";
//         PropertySetup: Record "Property Setup";
//     begin

//         if "No." = '' then
//             PropertySetup.Get();
//         PropertySetup.TestField("Owner No.");

//         Rec."No." := NoSeriesMgt.GetNextNo(PropertySetup."Owner No.", 0D, true)

//     end;


//     var
//         ForceUpdateContact: Boolean;
//         PhoneNoCannotContainLettersErr: Label 'must not contain letters';

//     procedure SetForceUpdateContact(NewForceUpdateContact: Boolean)
//     begin
//         ForceUpdateContact := NewForceUpdateContact;
//     end;

//     [InherentPermissions(PermissionObjectType::TableData, Database::"Owner", 'rm')]
//     local procedure UpdateMyOwner(CallingFieldNo: Integer)
//     var
//         MyOwner: Record "Owner";
//     begin
//         case CallingFieldNo of
//             FieldNo(Name):
//                 begin
//                     MyOwner.SetRange("No.", "No.");
//                     if not MyOwner.IsEmpty() then
//                         MyOwner.ModifyAll(Name, Name);
//                 end;
//             FieldNo("Phone No."):
//                 begin
//                     MyOwner.SetRange("No.", "No.");
//                     if not MyOwner.IsEmpty() then
//                         MyOwner.ModifyAll("Phone No.", "Phone No.");
//                 end;
//         end;
//     end;

// }