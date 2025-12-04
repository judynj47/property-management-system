page 50106 "Rent Setup"
{
    ApplicationArea = All;
    Caption = 'Rent Setup';
    PageType = Card;
    SourceTable = "Rent Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {


                field("Mpesa Receipts G/L Account"; Rec."Mpesa Receipts G/L Account")
                {
                    ToolTip = 'Specifies the value of the Mpesa Receipts G/L Account field.', Comment = '%';
                }
                field("Automatic Processing Enabled"; Rec."Automatic Processing Enabled")
                {
                    ToolTip = 'Specifies the value of the Automatic Processing Enabled field.', Comment = '%';
                }
                field("Bank Transfer Nos"; Rec."Bank Transfer Nos")
                {
                    ToolTip = 'Specifies the value of the Bank Transfer Nos field.', Comment = '%';
                }
                field("Bank Transfer Template"; Rec."Bank Transfer Template")
                {
                    ToolTip = 'Specifies the value of the Bank Transfer Template field.', Comment = '%';
                }
                field("Due From"; Rec."Due From")
                {
                    ToolTip = 'Specifies the value of the Due From field.', Comment = '%';
                }
                field("Due To"; Rec."Due To")
                {
                    ToolTip = 'Specifies the value of the Due To field.', Comment = '%';
                }
                field("Cash Receipts G/L Account"; Rec."Cash Receipts G/L Account")
                {
                    ToolTip = 'Specifies the value of the Cash Receipts G/L Account field.', Comment = '%';
                }
                field("General Bus. Posting Group"; Rec."General Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the General Bus. Posting Group field.', Comment = '%';
                }
                field("Invoicing Template"; Rec."Invoicing Template")
                {
                    ToolTip = 'Specifies the value of the Invoicing Template field.', Comment = '%';
                }
                field("Processing Time"; Rec."Processing Time")
                {
                    ToolTip = 'Specifies the value of the Processing Time field.', Comment = '%';
                }
                field("Rent Invoice No."; Rec."Rent Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Rent Invoice No. field.', Comment = '%';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.', Comment = '%';
                }
                field("Receipt Template"; Rec."Receipt Template")
                {
                }
            }
        }
    }
}
