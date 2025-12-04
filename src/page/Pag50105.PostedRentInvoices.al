page 50105 "Posted Rent Invoices"
{
    ApplicationArea = All;
    Caption = 'Posted Rent Invoices';
    PageType = List;
    CardPageId = "Rent Invoice Card";
    SourceTable = "Rent Invoice";
    SourceTableView = where("Document Status" = filter(Posted));
    //SourceTableView = WHERE("Customer Posting Group" = CONST('TENANT'));

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
                // field("Bal. Account No."; Rec."Bal. Account No.")
                // {
                //     ToolTip = 'Specifies the value of the Bal. Account No. field.', Comment = '%';
                // }
                // field("Bal. Account Type"; Rec."Bal. Account Type")
                // {
                //     ToolTip = 'Specifies the value of the Bal. Account Type field.', Comment = '%';
                // }

                // field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
                // {
                //     ToolTip = 'Specifies the value of the Applies-to Doc. No. field.', Comment = '%';
                // }
                field(Closed; Rec.Paid)
                {
                    ToolTip = 'Specifies if the posted invoice is paid. The check box will also be selected if a credit memo for the remaining amount has been applied.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the date on which the invoice was posted.';
                }
            }
        }
    }
}
