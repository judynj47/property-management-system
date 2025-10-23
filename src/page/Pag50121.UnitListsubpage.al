page 50121 "Unit List subpage"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Property Unit";
    //CardPageId = "Unit Card";


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."Unit No.")
                {
                    trigger OnValidate()
                    var
                        unit: Record Unit;
                    begin
                        if unit.Get(Rec."Unit No.") then
                            Rec.Description := unit.Description;
                        Rec."Unit Size" := unit."Unit Size";
                        Rec."Unit Status" := unit."Unit Status";
                        Rec."Date Available" := unit."Date Available";
                        Rec."Rent Amount" := unit."Rent Amount";

                    end;
                    //TableRelation = Unit;


                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    Editable = false;
                }
                field("Unit Size"; Rec."Unit Size")
                {
                    ToolTip = 'Specifies the value of the Unit Size (sq. m) field.', Comment = '%';
                    Editable = false;
                }
                field("Unit Status"; Rec."Unit Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit Status field.', Comment = '%';
                }
                field("Date Available"; Rec."Date Available")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date Available field.', Comment = '%';
                }
                field("Rent Amount"; Rec."Rent Amount")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Rent Amount field.', Comment = '%';
                }

            }
        }

    }


}