page 50103 "Owner Card"
{
    ApplicationArea = All;
    Caption = 'Owner Card';
    PageType = Card;
    SourceTable = Vendor;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the Owner No. field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }

                field("Owner Type"; Rec."Owner Type")
                {
                    ToolTip = 'Specifies the value of the Owner Type field.', Comment = '%';
                }
                field("Ownership Type"; Rec."Ownership Type")
                {
                    ToolTip = 'Specifies the value of the Ownership Type field.', Comment = '%';
                }
                field("Ownership Share"; Rec."Ownership Share")
                {
                    ToolTip = 'Specifies the value of the Ownership Share (%) field.', Comment = '%';
                }
                field("Property Owner"; Rec."Property Owner")
                {
                    ToolTip = 'Specifies the value of the Property Owner field.', Comment = '%';
                }

                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the value of the Balance field.', Comment = '%';
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ToolTip = 'Specifies the total value of your completed purchases from the vendor in the current fiscal year. It is calculated from amounts including VAT on all completed purchase invoices and credit memos.';
                }
                field("Balance Due"; Rec."Balance Due")
                {
                    ToolTip = 'Specifies the value of the Balance Due field.', Comment = '%';
                }
                field("Balance Due (LCY)"; Rec."Balance Due (LCY)")
                {
                    ToolTip = 'Specifies the total value of your unpaid purchases from the vendor in the current fiscal year. It is calculated from amounts including VAT on all open purchase invoices and credit memos.';
                }







            }
            group("Address & Contact")
            {
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the vendor''s mobile telephone number.';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the vendor''s address.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies additional address information.';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the vendor''s city.';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field(County; Rec.County)
                {
                    ToolTip = 'Specifies the state, province or county as a part of the address.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the vendor''s email address.';
                }
            }
            group(Invoicing)
            {
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ToolTip = 'Specifies the vendor''s trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.';
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    ToolTip = 'Specifies the vendor''s market type to link business transactions made for the vendor with the appropriate account in the general ledger.';
                }

            }
            group(Payments)
            {
                field("Preferred Payment Method"; Rec."Preferred Payment Method")
                {
                    ToolTip = 'Specifies the value of the Preferred Payment Method field.', Comment = '%';
                }

                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                }
                field("Preferred Bank Account Code"; Rec."Preferred Bank Account Code")
                {
                    ToolTip = 'Specifies the vendor bank account that will be used by default on payment journal lines for export to a payment bank file.';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ToolTip = 'Specifies the value of the Bank Account No. field.', Comment = '%';
                }

                // field("Property Linked"; Rec."Property Linked")
                // {
                //     ToolTip = 'Specifies the property linked to this owner.';
                // }
                field("Till No."; Rec."Till No.")
                {
                    ToolTip = 'Specifies the value of the Till No. field.', Comment = '%';
                }
                field("Paybill No."; Rec."Paybill No.")
                {
                    ToolTip = 'Specifies the value of the Paybill No. field.', Comment = '%';
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                }

                field("Mobile Money Account"; Rec."Mobile Money Account")
                {
                    ToolTip = 'Specifies the value of the Mobile Money Account field.', Comment = '%';
                }

            }
            part("Properties Owned"; "Property Owner Subform")
            {
                Visible = true;
                ApplicationArea = All;
                SubPageLink = "Owner No." = field("No.");

            }

        }
        area(factboxes)
        {

            part("Attached Documents List"; "Doc. Attachment List Factbox")
            {

                Visible = true;
                ApplicationArea = All;
                Caption = 'Documents';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::Vendor),
                              "No." = field("No.");



            }

        }


    }
}
