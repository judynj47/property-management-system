page 50127 "Lease Agreement Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Lease;

    layout
    {
        area(Content)
        {
            group("Parties and Properties")
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the Lease No. field.', Comment = '%';
                }
                field("Property No."; Rec."Property No.")
                {
                    ToolTip = 'Specifies the value of the Property No. field.', Comment = '%';
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ToolTip = 'Specifies the value of the Unit No. field.', Comment = '%';
                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    ToolTip = 'Specifies the value of the Tenant No. field.', Comment = '%';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ToolTip = 'Specifies the value of the Tenant Name field.', Comment = '%';
                }
                field("Owner No."; Rec."Owner No.")
                {
                    ToolTip = 'Specifies the value of the Owner No. field.', Comment = '%';
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ToolTip = 'Specifies the value of the Owner Name field.', Comment = '%';
                }
                group(Fees)
                {
                    field("Security Deposit"; Rec."Security Deposit")
                    {
                        ToolTip = 'Specifies the value of the Security Deposit field.', Comment = '%';
                    }
                    field("Rent Amount"; Rec."Rent Amount")
                    {
                        ToolTip = 'Specifies the value of the Rent Amount field.', Comment = '%';
                    }
                    field("Payment Frequency"; Rec."Payment Frequency")
                    {
                        ToolTip = 'Specifies the value of the Payment Frequency field.', Comment = '%';
                    }
                    field("Utilities & Service Charges"; Rec."Utilities & Service Charges")
                    {
                        ToolTip = 'Specifies the value of the Utilities & Service Charges field.', Comment = '%';
                    }
                }

                group("Lease term")
                {
                    field("Start Date"; Rec."Start Date")
                    {
                        ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
                    }
                    field("End Date"; Rec."End Date")
                    {
                        ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                    }
                    field("Signed Date"; Rec."Signed Date")
                    {
                        ToolTip = 'Specifies the value of the Signed Date field.', Comment = '%';
                    }
                    field("Lease Status"; Rec."Lease Status")
                    {
                        ToolTip = 'Specifies the value of the Lease Status field.', Comment = '%';
                    }
                    field("Renewal Notice Period"; Rec."Renewal Notice Period")
                    {
                        ToolTip = 'Specifies the value of the Notice Period (Days) field.', Comment = '%';
                    }
                    field("Renewal Notice Date"; Rec."Renewal Notice Date")
                    {
                        ToolTip = 'Specifies the value of the Renewal Notice Date field.', Comment = '%';
                    }
                }

            }
            part(SpecialClauses; "Special Clauses Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Lease No." = FIELD("No.");
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(PrintLeaseAgreement)
            {
                Caption = 'Sign Lease Agreement';
                ApplicationArea = All;
                Image = Signature;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LeaseReport: Report "Lease Agreement Report";
                begin
                    Report.RunModal(Report::"Lease Agreement Report", true, true, Rec);
                end;
            }
        }
    }



    var
        myInt: Integer;
}