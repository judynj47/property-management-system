enum 50135 "Tenant Application Status"
{
    Extensible = true;
    value(0; Open) { Caption = 'Open'; }
    value(1; PendingApproval) { Caption = 'Pending approval'; }
    value(2; Approved) { Caption = 'Approved'; }
    value(3; Rejected) { Caption = 'Rejected'; }
}