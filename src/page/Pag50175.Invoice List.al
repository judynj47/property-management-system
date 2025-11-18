page 50175 "Invoice List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Rent Invoice";
    CardPageId = "Rent Invoice Card";
    SourceTableView = where("Document Type" = const(Invoice));
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."Rent Invoice No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Lease No."; Rec."Lease No.")
                {
                    ToolTip = 'Specifies the value of the Lease No. field.', Comment = '%';
                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    ToolTip = 'Specifies the value of the Tenant No. field.', Comment = '%';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ToolTip = 'Specifies the value of the Tenant Name field.', Comment = '%';
                }
                field("Invoice Amount"; Rec."Receipt Amount")
                {
                    ToolTip = 'Specifies the value of the Receipt Amount field.', Comment = '%';
                }
                field("Document Status"; Rec."Document Status")
                {
                    ToolTip = 'Specifies the value of the Document Status field.', Comment = '%';
                }
                field("Date Invoiced"; Rec."Date Invoiced")
                {
                    ToolTip = 'Specifies the value of the Date Invoiced field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateNewInvoice)
            {
                Caption = 'New Invoice';
                Image = New;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RentInvoice: Record "Rent Invoice";
                begin
                    RentInvoice.Init();
                    RentInvoice."Document Type" := RentInvoice."Document Type"::Invoice;
                    RentInvoice."Posting Date" := WorkDate();
                    RentInvoice."Date Invoiced" := WorkDate();
                    RentInvoice."Document Status" := RentInvoice."Document Status"::Open;
                    RentInvoice.Insert(true);

                    Page.Run(Page::"Rent Invoice Card", RentInvoice);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Ensure we're only showing invoices
        Rec.SetRange("Document Type", Rec."Document Type"::Invoice);
    end;
}