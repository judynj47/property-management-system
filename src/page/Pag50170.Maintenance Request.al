page 50170 "Maintenance Request Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Maintenance Request";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit No."; Rec."Unit No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Property No."; Rec."Property No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Maintenance Type"; Rec."Maintenance Type")
                {
                    ApplicationArea = All;
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                }
                field("Completed Date"; Rec."Completed Date")
                {
                    ApplicationArea = All;
                }
                field("Request Details"; Rec."Request Details")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CompleteMaintenance)
            {
                Caption = 'Complete Maintenance';
                ApplicationArea = All;
                Image = Completed;

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Completed then
                        Error('Maintenance request is already completed.');

                    Rec.Status := Rec.Status::Completed;
                    Rec."Completed Date" := Today;
                    Rec.Modify(true);
                    Message('Maintenance request completed. Unit status updated.');
                end;
            }
        }
    }
}