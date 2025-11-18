page 50177 "Receipt Card"
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
                    Caption = 'Receipt No.';
                    TableRelation = Customer."No." where(Tenant = const(true));
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
                    // field("Date Invoiced"; Rec."Date Invoiced")
                    // {
                    //     ApplicationArea = All;
                    //     ShowMandatory = true;
                    // }
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
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                // field("Process Automatically"; Rec."Process Automatically")
                // {
                //     ApplicationArea = All;
                // }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }

            part(RentInvoiceLines; "Receipt lines")
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


            action(PostReceipt)
            {
                Caption = 'Post Receipt';
                Image = Post;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    BillingCU: Codeunit "Rent Billing";
                begin
                    if Rec."Document Status" = Rec."Document Status"::Posted then
                        Error('This invoice has already been posted.');

                    BillingCU.ProcessReceipt(Rec);
                    CurrPage.Update();
                end;
            }


        }
        area(Reporting)
        {
            action(PrintInvoice)
            {
                ApplicationArea = All;
                Caption = 'Print Receipt';
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
    var
        noseries: Codeunit "No. Series";
        PropertySetupRec: Record "Property Setup";

    begin
        // Initialize new record with default values
        Rec."Rent Invoice No." := noseries.GetNextNo(PropertySetupRec."Rent Invoice No.", 0D, true); //no.series generate
        Rec."Posting Date" := WorkDate();
        Rec."Date Invoiced" := WorkDate();
        Rec."Document Status" := Rec."Document Status"::Open;
        Rec."Document Type" := Rec."Document Type"::Receipt;


        // Set default Document Type based on which list page opened this card
        SetDefaultDocumentType();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        noseries: Codeunit "No. Series";
        PropertySetupRec: Record "Property Setup";
    begin
        Rec."Rent Invoice No." := noseries.GetNextNo(PropertySetupRec."Rent Invoice No.", 0D, true);
        Rec."Document Type" := Rec."Document Type"::Receipt;
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
        // This sets the default document type based on which list opened the card
        // When creating from Rent Invoice List, default to Invoice
        // When creating from Receipt List, default to Receipt
        // Otherwise, default to Invoice
        if Rec."Document Type" = Rec."Document Type"::" " then
            Rec."Document Type" := Rec."Document Type"::Receipt;
    end;

    //fix
    trigger OnOpenPage()
    var
        RentInvoiceCalculation: Codeunit "Rent Invoice Calculation";
    begin
        RentInvoiceCalculation.CalculateInvoiceCharges(Rec);
        CurrPage.RentInvoiceLines.Page.Update();
        CurrPage.Update();
        Message('All charges calculated successfully. Rent, Penalty, Utility, and Service charges have been added.');
    end;

}