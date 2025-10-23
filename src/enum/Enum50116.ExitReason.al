enum 50116 "Exit Reason"
{
    Extensible = true;
    Caption = 'Exit Reason';

    value(0; "Lease End") { Caption = 'Lease End'; }
    value(1; Eviction) { Caption = 'Eviction'; }
    value(2; Relocation) { Caption = 'Relocation'; }
    value(3; "Non-Payment") { Caption = 'Non-Payment'; }
    value(4; "Mutual Agreement") { Caption = 'Mutual Agreement'; }
    value(5; Other) { Caption = 'Other'; }
}