enum 50136 "Maintenance Status"
{
    Extensible = true;
    
    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Open)
    {
        Caption = 'Open';
    }
    value(2; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(3; Completed)
    {
        Caption = 'Completed';
    }
    value(4; Cancelled)
    {
        Caption = 'Cancelled';
    }
}

enum 50137 "Maintenance Type"
{
    Extensible = true;
    
    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Repair)
    {
        Caption = 'Repair';
    }
    value(2; Preventive)
    {
        Caption = 'Preventive';
    }
    value(3; Emergency)
    {
        Caption = 'Emergency';
    }
    value(4; Inspection)
    {
        Caption = 'Inspection';
    }
}

enum 50138 "Maintenance Priority"
{
    Extensible = true;
    
    value(0; Low)
    {
        Caption = 'Low';
    }
    value(1; Normal)
    {
        Caption = 'Normal';
    }
    value(2; High)
    {
        Caption = 'High';
    }
    value(3; Emergency)
    {
        Caption = 'Emergency';
    }
}