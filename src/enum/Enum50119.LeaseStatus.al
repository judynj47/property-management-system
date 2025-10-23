enum 50119 "Lease Status"
{
    Extensible = true;
    Caption = 'Lease Status';


    value(0; Draft) { Caption = 'Draft'; }
    value(1; Active) { Caption = 'Active'; }
    value(2; Expired) { Caption = 'Expired'; }
    value(3; Renewed) { Caption = 'Renewed'; }
    value(4; Terminated) { Caption = 'Terminated'; }
    value(5; Cancelled) { Caption = 'Cancelled'; }
}