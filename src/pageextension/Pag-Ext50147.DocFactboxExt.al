// pageextension 50147 DocumentAttachmentFactboxExt extends "Doc. Attachment List Factbox"
// {
//     layout
//     {
//         addlast(content)
//         {
//             repeater(Attachments)
//             {
//                 field("File Name"; Rec."File Name")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Attachment';
//                     trigger OnDrillDown()
//                     begin
//                         if Rec.HasContent() then
//                             Rec.Export(true);
//                     end;
//                 }
//                 field("File Type"; Rec."File Type")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'File Type';
//                 }
//             }
//         }
//     }
// }