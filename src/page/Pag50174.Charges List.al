page 50174 "Property Charge List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Charge Setup";
    Caption = 'Property Charges';
    //CardPageId = "Property Charge Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Property No."; Rec."Property No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the property number.';
                }
                field("Charge ID"; Rec."Charge ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the charge ID.';
                }
                field("Charge Description"; Rec."Charge Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the charge description.';
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the charge type.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the charge amount.';
                }
                field("GL Account No."; Rec."GL Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the G/L account for this charge.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewCharge)
            {
                Caption = 'New Charge';
                Image = New;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = New;

                trigger OnAction()
                var
                    PropertyCharge: Record "Property Charge";
                //PropertyChargeCard: Page "Property Charge Card";
                begin
                    PropertyCharge.Init();
                    PropertyCharge."Property No." := GetCurrentPropertyNo();
                    // PropertyChargeCard.SetRecord(PropertyCharge);
                    // PropertyChargeCard.RunModal();
                end;
            }
        }
    }

    local procedure GetCurrentPropertyNo(): Code[20]
    var
        PropertyCharge: Record "Property Charge";
    begin
        if PropertyCharge.GetFilter("Property No.") <> '' then
            exit(CopyStr(PropertyCharge.GetFilter("Property No."), 1, 20));

        exit('');
    end;
}