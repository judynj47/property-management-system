report 50136 "Lease Agreement Report"
{
    Caption = 'Lease Agreement';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = 'LeaseAgreement.docx';

    DataSet
    {
        dataitem(Lease; Lease)
        {
            // Temporarily comment out filters for testing
            // RequestFilterFields = "No.";

            column(LeaseNo; "No.")
            {

            }
            column(TenantNo; "Tenant No.")
            {

            }
            column(PropertyNo; "Property No.")
            {

            }
            column(UnitNo; "Unit No.")
            {

            }
            column(OwnerNo; "Owner No.")
            {

            }
            column(StartDate; "Start Date")
            {

            }
            column(EndDate; "End Date")
            {

            }
            column(Duration; Duration)
            {

            }
            column(RentAmount; "Rent Amount")
            {

            }
            column(SecurityDeposit; "Security Deposit")
            {

            }
            column(PaymentFrequency; "Payment Frequency")
            {

            }
            column(SignedDate; "Signed Date")
            {

            }
            column(NoticePeriod; "Renewal Notice Period")
            {

            }
            column(Utilities; "Utilities & Service Charges")
            {

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
                    field("Include Signature Lines"; IncludeSignatureLines)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    var
        IncludeSignatureLines: Boolean;
}