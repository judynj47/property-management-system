enum 50119 "Lease Status"
{
    Extensible = true;
    Caption = 'Lease Status';


    value(0; Draft) { Caption = 'Draft'; }
    value(1; PendingApproval)
    {
        Caption = 'Pending Approval';
    }
    value(2; Active) { Caption = 'Active'; }
    value(3; Expired) { Caption = 'Expired'; }
    value(4; Renewed) { Caption = 'Renewed'; }
    value(5; Terminated) { Caption = 'Terminated'; }
    value(6; Cancelled) { Caption = 'Cancelled'; }
}