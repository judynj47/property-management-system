enum 50100 "Charge Type"
{
    Extensible = true;
    value(0; " ")
    {
    }

    value(1; Rent)
    {
        Caption = 'Rent';
    }
    value(2; Service)
    {
        Caption = 'Service';
    }
    value(3; Utility)
    {
        Caption = 'Utility';
    }
    value(4; Penalty)
    {
        Caption = 'Penalty';
    }
    value(5; Tax)
    {
        Caption = 'Tax';
    }
}