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
                field("Rent Invoice No."; Rec."Rent Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Rent Invoice No. field.', Comment = '%';
                }
                field("Rent G/L account No."; Rec."Rent G/L account No.")
                {
                    ToolTip = 'Specifies the value of the Rent G/L account No. field.', Comment = '%';
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