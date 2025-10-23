// pageextension 50100 "Owner Ext Vendor Card" extends "Vendor Card"
// {
//     layout
//     {
//         addlast(General)
//         {
//             group("Owner Details")
//             {
//                 Caption = 'Owner Details';

//                 field("Owner Type"; Rec."Owner Type")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Ownership Share (%)"; Rec."Ownership Share")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Property Linked"; Rec."Property Linked")
//                 {
//                     ApplicationArea = All;
//                     ToolTip = 'Specifies the property linked to this owner.';
//                 }
//                 field("Preferred Payment Method"; Rec."Preferred Payment Method")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Mobile Money Account"; Rec."Mobile Money Account")
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }

//     actions
//     {
//         addlast(processing)
//         {
//             action("New Property")
//             {
//                 Caption = 'New Property';
//                 ApplicationArea = All;
//                 Image = New;
//                 RunObject = page "Property Card";
//                 RunPageLink = "Owner No." = field("No.");
//                 RunPageMode = Create;
//             }

//         }
//         addlast(Navigation)
//         {
//             group("Property Management")
//             {
//                 Caption = 'Property Management';
//                 action("View Linked Properties")
//                 {
//                     Caption = 'View Linked Properties';
//                     ApplicationArea = All;
//                     Image = List;
//                     RunObject = page "Property List";
//                     RunPageLink = "Owner No." = field("No.");
//                     RunPageMode = Create; // ensures it opens in context for new entries
//                 }


//             }
//         }
//     }
// }
