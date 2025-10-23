// page 50102 "Tenant Card"
// {
//     ApplicationArea = All;
//     Caption = 'Tenant Card';
//     PageType = Card;
//     SourceTable = Customer;


//     layout
//     {
//         area(Content)
//         {
//             group(General)
//             {
//                 Caption = 'General';

//                 field("No."; Rec."No.")
//                 {
//                     ToolTip = 'Specifies the number of the vendor. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
//                 }
//                 field(Name; Rec.Name)
//                 {
//                     ToolTip = 'Specifies the vendor''s name. You can enter a maximum of 30 characters, both numbers and letters.';
//                 }

//                 field("National ID/Passport"; Rec."National ID/Passport")
//                 {
//                     ToolTip = 'Specifies the value of the National ID/Passport field.', Comment = '%';
//                 }
//                 field("Company Registration No."; Rec."Company Registration No.")
//                 {
//                     ToolTip = 'Specifies the value of the Company Registration No. field.', Comment = '%';
//                 }
//                 field("Tenant Type"; Rec."Tenant Type")
//                 {
//                     ToolTip = 'Specifies the value of the Tenant Type field.', Comment = '%';
//                 }
//                 field("Tenant Category"; Rec."Tenant Category")
//                 {
//                     ToolTip = 'Specifies the value of the Tenant Category field.', Comment = '%';
//                 }
//                 field("Tenant Status"; Rec."Tenant Status")
//                 {
//                     ToolTip = 'Specifies the value of the Tenant Status field.', Comment = '%';
//                 }
//                 field("Date of Birth"; Rec."Date of Birth")
//                 {
//                     ToolTip = 'Specifies the value of the Date of Birth field.', Comment = '%';
//                 }
//                 field("Move-in Date"; Rec."Move-in Date")
//                 {
//                     ToolTip = 'Specifies the value of the Move-in Date field.', Comment = '%';
//                 }
//                 field("Move-out Date"; Rec."Move-out Date")
//                 {
//                     ToolTip = 'Specifies the value of the Move-out Date field.', Comment = '%';
//                 }
//                 field("Reason for Exit"; Rec."Reason for Exit")
//                 {
//                     ToolTip = 'Specifies the value of the Reason for Exit field.', Comment = '%';
//                 }
//                 field("Current Unit No."; Rec."Current Unit No.")
//                 {
//                     ToolTip = 'Specifies the value of the Current Unit No. field.', Comment = '%';
//                 }
//                 field("Current Property No."; Rec."Current Property No.")
//                 {
//                     ToolTip = 'Specifies the value of the Current Property No. field.', Comment = '%';
//                 }
//                 field("Current Lease No."; Rec."Current Lease No.")
//                 {
//                     ToolTip = 'Specifies the value of the Current Lease No. field.', Comment = '%';
//                 }




//                 // field("Property Linked"; Rec."Property Linked")
//                 // {
//                 //     ToolTip = 'Specifies the property linked to this owner.';
//                 // }
//             }
//             group("Address & Contact")
//             {
//                 field(Address; Rec.Address)
//                 {
//                     ToolTip = 'Specifies the value of the Address field.', Comment = '%';
//                 }
//                 field("Address 2"; Rec."Address 2")
//                 {
//                     ToolTip = 'Specifies the value of the Address 2 field.', Comment = '%';
//                 }
//                 field("E-Mail"; Rec."E-Mail")
//                 {
//                     ToolTip = 'Specifies the value of the Email field.', Comment = '%';
//                 }
//                 field("Phone No."; Rec."Phone No.")
//                 {
//                     ToolTip = 'Specifies the value of the Phone No. field.', Comment = '%';
//                 }
//                 field("Emergency Contact Name"; Rec."Emergency Contact Name")
//                 {
//                     ToolTip = 'Specifies the value of the Emergency Contact Name field.', Comment = '%';
//                 }
//                 field("Emergency Contact Relation"; Rec."Emergency Contact Relation")
//                 {
//                     ToolTip = 'Specifies the value of the Emergency Contact Relation field.', Comment = '%';
//                 }
//                 field("Emergency Contact Phone"; Rec."Emergency Contact Phone")
//                 {
//                     ToolTip = 'Specifies the value of the Emergency Contact Phone field.', Comment = '%';
//                 }
//             }
//             group(Invoicing)
//             {

//                 field("Bill-to Customer No."; Rec."Bill-to Customer No.")
//                 {
//                     ToolTip = 'Specifies the value of the Bill-to Customer No. field.', Comment = '%';
//                 }
//                 field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
//                 {
//                     ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.', Comment = '%';
//                 }
//                 field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
//                 {
//                     ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.', Comment = '%';
//                 }
//                 field("Customer Posting Group"; Rec."Customer Posting Group")
//                 {
//                     ToolTip = 'Specifies the value of the Customer Posting Group field.', Comment = '%';
//                 }
//             }
//             group(Payments)
//             {
//                 field("Security Deposit Amount"; Rec."Security Deposit Amount")
//                 {
//                     ToolTip = 'Specifies the value of the Security Deposit Amount field.', Comment = '%';
//                 }
//                 field("Deposit Refunded"; Rec."Deposit Refunded")
//                 {
//                     ToolTip = 'Specifies the value of the Deposit Refunded field.', Comment = '%';
//                 }
//                 field(Balance; Rec.Balance)
//                 {
//                     ToolTip = 'Specifies the value of the Balance field.', Comment = '%';
//                 }



//             }

//             group(Statistics)
//             {
//                 field("Statistics Group"; Rec."Statistics Group")
//                 {
//                     ToolTip = 'Specifies the value of the Statistics Group field.', Comment = '%';
//                 }

//             }
//         }
//     }
// }
