report 50135 "Rent Invoicing Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/rdlc/RentInvoice.rdl';
    Caption = 'Rent Invoice';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(RentInvoice; "Rent Invoice")
        {
            column(Rent_Invoice_No; "Rent Invoice No.")
            {
            }
            column(Tenant_No; "Tenant No.")
            {
            }
            column(Tenant_Name; "Tenant Name")
            {
            }
            column(Lease_No; "Lease No.")
            {
            }
            column(Property_No; "Property No.")
            {
            }
            column(Unit_No; "Unit No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Date_Invoiced; "Date Invoiced")
            {
            }
            column(Receipt_Amount; "Receipt Amount")
            {
            }

            dataitem(RentInvoiceLine; "Rent Invoice Line")
            {
                DataItemLink = "Invoice No." = field("Rent Invoice No.");
                DataItemTableView = sorting("Invoice No.", "Line No.");

                column(Charge_Type; "Charge Type")
                {
                }
                column(Description; Description)
                {
                }
                column(Amount; Amount)
                {
                }
                column(GL_Account_No; "GL Account No.")
                {
                }
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(ShowDetails; ShowDetails)
                    {
                        Caption = 'Show Line Details';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
        }
    }

    var
        ShowDetails: Boolean;
}

