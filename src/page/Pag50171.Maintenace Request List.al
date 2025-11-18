// page 50180 "Maintenance Request List"
// {
//     PageType = List;
//     ApplicationArea = All;
//     UsageCategory = Lists;
//     SourceTable = "Maintenance Request";
//     CardPageId = "Maintenance Request Card";

//     layout
//     {
//         area(Content)
//         {
//             repeater(GroupName)
//             {
//                 field("No."; Rec."No.") { ApplicationArea = All; }
//                 field("Unit No."; Rec."Unit No.") { ApplicationArea = All; }
//                 field("Property No."; Rec."Property No.") { ApplicationArea = All; }
//                 field("Maintenance Type"; Rec."Maintenance Type") { ApplicationArea = All; }
//                 field(Priority; Rec.Priority) { ApplicationArea = All; }
//                 field(Status; Rec.Status) { ApplicationArea = All; }
//                 field("Request Date"; Rec."Request Date") { ApplicationArea = All; }
//                 field("Completed Date"; Rec."Completed Date") { ApplicationArea = All; }
//             }
//         }
//     }

//     actions
//     {
//         area(Reporting)
//         {
//             action(PrintMaintenanceReport)
//             {
//                 Caption = 'Maintenance Report';
//                 ApplicationArea = All;
//                 Image = Print;
//                 // Trigger OnAction = // Report action
//             }
//         }
//     }
// }