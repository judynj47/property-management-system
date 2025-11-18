page 50167 "Tenant Cue"
{
    Caption = 'Tenants';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            cuegroup("Total Tenants")
            {

                field("Total Tenant"; Rec."Total Active Tenants")
                {
                    DrillDownPageId = "Active Tenant List";

                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Properties field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}