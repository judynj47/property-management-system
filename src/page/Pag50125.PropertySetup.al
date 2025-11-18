page 50125 "Property SetUp"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Property Setup";

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                field("Property No."; Rec."Property No.")
                {
                    ToolTip = 'Specifies the value of the Property No. field.', Comment = '%';
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ToolTip = 'Specifies the value of the Unit No field.', Comment = '%';
                }
                field("Owner No."; Rec."Owner No.")
                {
                    ToolTip = 'Specifies the value of the Owner No. field.', Comment = '%';
                }
                field("Lease No."; Rec."Lease No.")
                {
                    ToolTip = 'Specifies the value of the Lease No. field.', Comment = '%';
                }
                field("Application ID"; Rec."Application ID")
                {
                    ToolTip = 'Specifies the value of the Application ID field.', Comment = '%';
                }
                field("Customer Nos"; Rec."Customer Nos")
                {
                    ToolTip = 'Specifies the value of the Customer Nos field.', Comment = '%';
                }
                field("Termination ID"; Rec."Termination ID")
                {
                    ToolTip = 'Specifies the value of the Termination ID field.', Comment = '%';
                }
                field("Maintenance Request Nos."; Rec."Maintenance Request Nos.")
                {
                    ToolTip = 'Specifies the value of the Maintenance Request Nos. field.', Comment = '%';
                }
                field("Revenue G/L Account"; Rec."Revenue G/L Account")
                {
                    ToolTip = 'Specifies the value of the Revenue G/L Account field.', Comment = '%';
                }
                field("Receivables G/L Account"; Rec."Receivables G/L Account")
                {
                    ToolTip = 'Specifies the value of the Receivables G/L Account field.', Comment = '%';
                }

                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ToolTip = 'Specifies the value of the Journal Template Name field.', Comment = '%';
                }
                field("Rent Invoice No."; Rec."Rent Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Rent Invoice No. field.', Comment = '%';
                }
                field("Rent G/L account No."; Rec."Rent G/L account No.")
                {
                    ToolTip = 'Specifies the value of the Rent G/L account No. field.', Comment = '%';
                }
                field("Penalty G/L Account"; Rec."Penalty G/L Account")
                {
                    ToolTip = 'Specifies the value of the Penalty G/L Account field.', Comment = '%';
                }
                field("Service Charge G/L Account"; Rec."Service Charge G/L Account")
                {
                    ToolTip = 'Specifies the value of the Service Charge G/L Account field.', Comment = '%';
                }
                field("Utility G/L Account"; Rec."Utility G/L Account")
                {
                    ToolTip = 'Specifies the value of the Utility G/L Account field.', Comment = '%';
                }
                field("Tax G/L Account"; Rec."Tax G/L Account")
                {
                    ToolTip = 'Specifies the value of the Tax G/L Account field.', Comment = '%';
                }

                // field("Clause ID"; Rec."Clause ID")
                // {
                //     ToolTip = 'Specifies the value of the Clause ID field.', Comment = '%';
                // }
            }
        }
    }


    trigger OnOpenPage()
    begin
        if Rec.IsEmpty() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}