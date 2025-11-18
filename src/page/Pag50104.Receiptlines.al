page 50104 "Receipt lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Rent Invoice Line";
    Editable = false;
    Caption = 'Rent Invoice Lines';
    DeleteAllowed = false; // Prevent deletion to avoid filter issues


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Charge Type"; Rec."Charge Type")
                {
                    ApplicationArea = All;
                    //ShowMandatory = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    //ShowMandatory = true;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    //ShowMandatory = true;
                }
                field("GL Account No."; Rec."GL Account No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    local procedure GetNextLineNo(InvoiceNo: Code[20]): Integer
    var
        RentInvoiceLine: Record "Rent Invoice Line";
    begin
        RentInvoiceLine.SetRange("Invoice No.", InvoiceNo);
        if RentInvoiceLine.FindLast() then
            exit(RentInvoiceLine."Line No." + 10000)
        else
            exit(10000);
    end;

    procedure SetInvoiceNo(InvoiceNo: Code[20])
    begin
        Rec.SetRange("Invoice No.", InvoiceNo);
        CurrPage.Update(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        RentInvoiceLine: Record "Rent Invoice Line";
        LineNo: Integer;

    begin
        if Rec."Invoice No." = '' then
            Error('Please save the invoice header first.');

        LineNo := GetNextLineNo(Rec."Invoice No.");
        RentInvoiceLine.Init();
        RentInvoiceLine."Invoice No." := Rec."Invoice No.";
        RentInvoiceLine."Line No." := LineNo;
        RentInvoiceLine.Insert();
        RentInvoiceLine.Find();
        CurrPage.SetRecord(RentInvoiceLine);

        Rec."Invoice No." := Rec."Invoice No.";
    end;


}
