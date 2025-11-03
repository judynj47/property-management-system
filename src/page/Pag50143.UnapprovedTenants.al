page 50144 "Pending Tenants List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Tenant Application";
    Caption = 'Pending Tenants';
    UsageCategory = Lists;
    SourceTableView = where("Tenant Application Status" = const(PendingApproval));
    CardPageId = "Tenant Application Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Application ID"; Rec."Application ID") { ApplicationArea = All; }
                field("Tenant Name"; Rec."Tenant Name") { ApplicationArea = All; }
                field("Tenant Type"; Rec."Tenant Type") { ApplicationArea = All; }
                field("National ID/Passport"; Rec."National ID/Passport") { ApplicationArea = All; }
                field("Tenant Category"; Rec."Tenant Category") { ApplicationArea = All; }
                field("Tenant Application Status"; Rec."Tenant Application Status")
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyleTxt;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Filter to show only tenants pending approval or rejected
        Rec.SetFilter("Tenant Application Status", '%1|%2',
                      Rec."Tenant Application Status"::"PendingApproval",
                      Rec."Tenant Application Status"::Rejected);
    end;

    var
        StatusStyleTxt: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec."Tenant Application Status" of
            Rec."Tenant Application Status"::"PendingApproval":
                StatusStyleTxt := 'Strong';
            Rec."Tenant Application Status"::Rejected:
                StatusStyleTxt := 'Unfavorable';
            else
                StatusStyleTxt := 'Standard';
        end;
    end;
}
