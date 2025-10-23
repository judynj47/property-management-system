page 50142 "Approved Tenants List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Tenant Application";
    Caption = 'Approved Tenants';
    UsageCategory = Lists;
    SourceTableView = where("Tenant Application Status" = const(Approved));

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
        // Filter to show only approved tenants
        Rec.SetRange("Tenant Application Status", Rec."Tenant Application Status"::Approved);
    end;

    var
        StatusStyleTxt: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec."Tenant Application Status" of
            Rec."Tenant Application Status"::Approved:
                StatusStyleTxt := 'Favorable';
            else
                StatusStyleTxt := 'Standard';
        end;
    end;
}
