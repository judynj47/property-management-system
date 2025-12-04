page 50107 "Paid Invoices"
{
    ApplicationArea = All;
    Caption = 'Paid Invoices';
    PageType = List;
    SourceTable = "Rent Invoice";
    SourceTableView = where(paid = const(true));
    CardPageId = "Rent Invoice Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."Rent Invoice No.")
                {
                    ToolTip = 'Specifies the posted invoice number.';
                }
                field("Name"; Rec."Tenant Name")
                {
                    ToolTip = 'Specifies the name of the customer that the invoice was sent to.';
                }
                field(Amount; Rec."Receipt Amount")
                {
                    ToolTip = 'Specifies the total, in the currency of the invoice, of the amounts on all the invoice lines. The amount does not include VAT.';
                }
                field(Paid; Rec.Paid)
                {
                    ToolTip = 'Specifies the value of the Paid field.', Comment = '%';
                }

            }
        }
    }
}
