page 50169 "Lease Termination Dialog"
{
    PageType = StandardDialog;
    Caption = 'Lease Termination Details';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Termination Reason"; TermReason)
                {
                    ApplicationArea = All;
                    Caption = 'Reason for Termination';
                }
                field("Deposit Refund Amount"; RefundAmt)
                {
                    ApplicationArea = All;
                    Caption = 'Deposit Refund Amount';
                }
            }
        }
    }

    var
        TermReason: Text[100];
        RefundAmt: Decimal;

    procedure GetTerminationDetails(var Reason: Text[100]; var Refund: Decimal)
    begin
        Reason := TermReason;
        Refund := RefundAmt;
    end;
}
