report 50137 "Receipt"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = LayoutName;

    dataset
    {
        dataitem(DataItemName; "Rent Invoice")
        {
            column("Invoice_no"; "Rent Invoice No.")
            {

            }
            column(LeaseNo_DataItemName; "Lease No.")
            {
            }
            column(TenantNo_DataItemName; "Tenant No.")
            {
            }
            column(TenantName_DataItemName; "Tenant Name")
            {
            }
            column(DateInvoiced_DataItemName; "Date Invoiced")
            {
            }
            column(PaymentMode_DataItemName; "Payment Mode")
            {
            }
            column(ReceiptAmount_DataItemName; "Receipt Amount")
            {
            }
            column(DocumentType_DataItemName; "Document Type")
            {
            }
            column(Company_logo; companyinfo.Picture)
            {
            }
            column(company_name; companyinfo.Name)
            {
            }
            column(Address; companyinfo.Address)
            {
            }
            column(Phone_No_; companyinfo."Phone No.")
            {
            }
        }
    }

    // requestpage
    // {
    //     AboutTitle = 'Teaching tip title';
    //     AboutText = 'Teaching tip content';
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(GroupName)
    //             {
    //                 field(Name; SourceExpression)
    //                 {

    //                 }
    //             }
    //         }
    //     }

    //     actions
    //     {
    //         area(processing)
    //         {
    //             action(LayoutName)
    //             {

    //             }
    //         }
    //     }
    // }

    rendering
    {
        layout(LayoutName)
        {
            Type = Excel;
            LayoutFile = 'Receipt.xlsx';
        }
    }
    trigger OnPreReport()
    begin
        companyinfo.Get();//BLOB fields don't automatically load binary data when you get() company info
        companyinfo.CalcFields(Picture);
    end;

    var
        myInt: Integer;
        companyinfo: Record "Company Information";

}