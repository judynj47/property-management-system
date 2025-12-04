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
                    TableRelation = "Rent Invoice"."Rent Invoice No." where(
        "Tenant No." = FIELD("Invoiced Tenant No."),
        "Paid" = const(false),
        "Document Type" = const(Invoice)
    );

                }
                field("Source Invoice No."; Rec."Source Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Source Invoice No. field.', Comment = '%';
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }

                field("Invoiced Tenant No."; Rec."Invoiced Tenant No.")
                {
                    ToolTip = 'Specifies the value of the Invoiced Tenant No. field.', Comment = '%';
                    trigger OnValidate()

                    begin
                        //Rec.Validate("Invoiced Tenant No.", Rec."Invoiced Tenant No."); 11.19.25
                        CurrPage.Update(true);
                    end;


                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    //Visible = false;
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Importance = Promoted;
                    TableRelation = Customer."No." where(Tenant = const(true));

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
                    TableRelation = Lease."No." where("Tenant No." = field("Invoiced Tenant No."));
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

                        ApplicationArea = All;
                        ShowMandatory = true;
                        Caption = 'Receipted Date';
                    }
                }
                group("Payment Details")
                {
                    field("Receipt Amount"; Rec."Receipt Amount")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Document Type"; Rec."Document Type")
                    {
                        ApplicationArea = All;
                    }

                    field(Paid; Rec.Paid)
                    {
                        ToolTip = 'Specifies the value of the Paid field.', Comment = '%';
                    }
                    field("Payment Mode"; Rec."Payment Mode")
                    {
                        ToolTip = 'Specifies the value of the Payment Mode field.', Comment = '%';
                    }

                    field("Document Status"; Rec."Document Status")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }

                }

            }

            part(ReceiptLines; "Receipt lines")
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
            action(GetInvoice)
            {
                trigger OnAction()
                begin
                    if Rec."Source Invoice No." = '' then
                        Error('Select Invoice no.');

                    Rec.AutoPopulateReceiptLines();
                    CurrPage.ReceiptLines.Page.Update();
                    CurrPage.Update();
                    Message('Receipt lines populated from invoice %1.', Rec."Source Invoice No.");
                end;
            }


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
                    InvoiceRec: Record "Rent Invoice";
                begin
                    if Rec."Document Status" = Rec."Document Status"::Posted then
                        Error('This invoice has already been posted.');
                    Rec.Modify(true);
                    BillingCU.ProcessReceipt(Rec);

                    //BillingCU.ProcessReceipt(Rec);

                    if Rec."Rent Invoice No." <> '' then begin
                        if InvoiceRec.Get(Rec."Rent Invoice No.") then begin
                            InvoiceRec."Paid" := true;
                            InvoiceRec.Modify();
                        end;
                    end;

                    CurrPage.Update();
                end;
            }


        }
        area(Reporting)
        {
            action(PrintReceipt)
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
                    Report.Run(Report::Receipt, true, false, RentInvoice);
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
        Rec.Validate("Document Type", Rec."Document Type"::Receipt);



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
        CurrPage.ReceiptLines.Page.SetInvoiceNo(Rec."Rent Invoice No.");
    end;

    local procedure SetDefaultDocumentType()
    var
        RentInvoiceList: Page "Rent Invoice List";
        ReceiptList: Page "Receipt List";
    begin

        if Rec."Document Type" = Rec."Document Type"::" " then
            Rec."Document Type" := Rec."Document Type"::Receipt;
    end;

    //fix
    trigger OnOpenPage()
    var
    // RentInvoiceCalculation: Codeunit "Rent Invoice Calculation";
    // InvRec: Record "Rent Invoice";
    // LineRec: Record "Rent Invoice Line";
    begin


        // Rec."Receipt Amount" := InvRec.CalculateTotalAmount();
        // //RentInvoiceCalculation.CalculateInvoiceCharges(Rec);
        // CurrPage.ReceiptLines.Page.Update();
        // CurrPage.Update();
        //Message('All charges calculated successfully. Rent, Penalty, Utility, and Service charges have been added.');
    end;

}