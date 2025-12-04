page 50158 "Rent Invoice Card"
{
    Caption = 'Rent Bill Card';
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Rent Invoice";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Rent Invoice No."; Rec."Rent Invoice No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;

                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Lease No."; Rec."Lease No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Property No."; Rec."Property No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Rent Amount"; Rec."Rent Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                group(Dates)
                {
                    field("Date Invoiced"; Rec."Date Invoiced")
                    {
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                    field("Posting Date"; Rec."Posting Date")
                    {
                        Caption = 'Due Date';
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                }
                field("Receipt Amount"; Rec."Receipt Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Charges"; Rec."Total Charges")
                {
                    ToolTip = 'Specifies the value of the Total Charges field.', Comment = '%';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Process Automatically"; Rec."Process Automatically")
                {
                    ApplicationArea = All;
                }
                field(Paid; Rec.Paid)
                {
                    ToolTip = 'Specifies the value of the Paid field.', Comment = '%';
                    Editable = false;
                }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }

            part(RentInvoiceLines; "Rent Invoice Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Invoice No." = FIELD("Rent Invoice No.");
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(CalculateCharges)
            {
                Caption = 'Calculate All Charges';
                Image = Calculate;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RentInvoiceCalculation: Codeunit "Rent Invoice Calculation";
                begin
                    if Rec."Lease No." = '' then
                        Error('Please select a Lease No. first.');

                    RentInvoiceCalculation.CalculateInvoiceCharges(Rec);
                    CurrPage.RentInvoiceLines.Page.Update();
                    CurrPage.Update();
                    Message('All charges calculated successfully. Rent, Penalty, Utility, and Service charges have been added.');
                end;
            }

            action(PostInvoiceSales)
            {
                Caption = 'Post Invoice';
                Image = Post;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    BillingCU: Codeunit "Rent Billing";
                begin
                    if Rec."Document Status" = Rec."Document Status"::Posted then
                        Error('This invoice has already been posted.');

                    BillingCU.ProcessInvoice_Sales(Rec);
                    CurrPage.Update();
                end;
            }
        }
        area(Navigation)
        {
            action(ShowLease)
            {
                Caption = 'Show Lease';
                Image = View;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = Rec."Lease No." <> '';

                trigger OnAction()
                var
                    Lease: Record Lease;
                begin
                    if Lease.Get(Rec."Lease No.") then
                        Page.Run(Page::"Lease Agreement Card", Lease)
                    else
                        Message('Lease not found.');
                end;
            }

            action(ShowTenant)
            {
                Caption = 'Show Tenant';
                Image = Customer;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = Rec."Tenant No." <> '';

                trigger OnAction()
                var
                    Customer: Record Customer;
                begin
                    if Customer.Get(Rec."Tenant No.") then
                        Page.Run(Page::"Customer Card", Customer)
                    else
                        Message('Customer not found.');
                end;
            }
        }
        area(Reporting)
        {
            action(PrintInvoice)
            {
                ApplicationArea = All;
                Caption = 'Print Rent Invoice';
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    RentInvoice: Record "Rent Invoice";
                begin
                    RentInvoice.SetRange("Rent Invoice No.", Rec."Rent Invoice No.");
                    Report.Run(Report::"Rent Invoicing Report", true, false, RentInvoice);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Initialize new record with default values
        Rec."Posting Date" := WorkDate();
        Rec."Date Invoiced" := WorkDate();
        Rec."Document Status" := Rec."Document Status"::Open;
        Rec."Document Type" := Rec."Document Type"::Invoice;

        // Set default Document Type based on which list page opened this card
        SetDefaultDocumentType();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Document Type" := Rec."Document Type"::Invoice;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        // Update action enablement based on current record state
        CurrPage.RentInvoiceLines.Page.SetInvoiceNo(Rec."Rent Invoice No.");
    end;

    local procedure SetDefaultDocumentType()
    var
        RentInvoiceList: Page "Rent Invoice List";
        ReceiptList: Page "Receipt List";
    begin
        if Rec."Document Type" = Rec."Document Type"::" " then
            Rec."Document Type" := Rec."Document Type"::Invoice;
    end;

}