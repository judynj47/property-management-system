enum 50105 "Preferred Payment Method"
{
    Extensible = true;
    Caption = 'Preferred Payment Method';
    value(0; " ")
    {
    }

    value(1; "Bank Transfer") { Caption = 'Bank Transfer'; }
    value(2; "Mobile Money") { Caption = 'Mobile Money'; }
    value(3; Cheque) { Caption = 'Cheque'; }
    value(4; Cash) { Caption = 'Cash'; }
}