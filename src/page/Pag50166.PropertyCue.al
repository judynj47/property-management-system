page 50166 "Property Cue"
{
    Caption = 'Properties';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = Property;

    layout
    {
        area(Content)
        {
            cuegroup("Total Properties")
            {

                field("TotalProperties"; Rec."Total Properties")
                {
                    DrillDownPageId = "Property List";
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