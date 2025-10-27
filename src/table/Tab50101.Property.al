table 50101 "Property"
{
    DataClassification = CustomerContent;
    Caption = 'Property';
    DrillDownPageId = "Property List";
    LookupPageId = "Property List";

    fields
    {
        field(1; "Property ID"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Property Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Search Name"; Code[100])
        {
            Caption = 'Search Name';
            ToolTip = 'Specifies an alternate name that you can use to search for a customer.';
        }
        field(4; "Property Type"; Enum "Property Type")
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Category"; Enum "Property Category")
        {
            DataClassification = ToBeClassified;
        }
        field(6; Address; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Address 2"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(8; City; Text[100])
        {
            Caption = 'City';
            OptimizeForTextSearch = true;
            TableRelation = if ("Country/Region Code" = const('')) "Post Code".City
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                OnBeforeLookupCity(Rec, PostCode);

                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");

                OnAfterLookupCity(Rec, PostCode);
            end;

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnBeforeValidateCity(Rec, PostCode, CurrFieldNo, IsHandled);
                if not IsHandled then
                    PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);

                OnAfterValidateCity(Rec, xRec);
            end;
        }

        field(9; Country; Text[50])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                PostCode.CheckClearPostCodeCityCounty(City, "Post Code", County, "Country/Region Code", xRec."Country/Region Code");

                // if "Country/Region Code" <> xRec."Country/Region Code" then
                //     VATRegistrationValidation();
            end;
        }
        field(10; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code"
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                OnBeforeLookupPostCode(Rec, PostCode);

                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");

                OnAfterLookupPostCode(Rec, PostCode);
            end;

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnBeforeValidatePostCode(Rec, PostCode, CurrFieldNo, IsHandled);
                if not IsHandled then
                    PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);

                OnAfterValidatePostCode(Rec, xRec);
            end;
        }
        field(11; "GPS Coordinates"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Land area"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Owner No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor where("No." = field("Owner No."));
        }
        field(14; "Ownership Type"; Enum "Ownership Type")
        {
            Caption = 'Ownership Type';
            DataClassification = CustomerContent;
        }
        field(15; "Market Value"; Decimal)
        {
            Caption = 'Market Value';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(16; "Annual Property Tax"; Decimal)
        {
            Caption = 'Annual Property Tax';
            DataClassification = CustomerContent;
            AutoFormatType = 1;
        }
        field(17; "Insurance Policy No."; Code[30])
        {
            Caption = 'Insurance Policy No.';
            DataClassification = CustomerContent;
        }
        field(18; "Total Units"; Integer)
        {
            Caption = 'Total Units';
            DataClassification = CustomerContent;
            Editable = false;

            trigger OnValidate()
            var
                UnitNosRec: Record Unit;
            begin
                UnitNosRec.Reset();
                UnitNosRec.SetRange("Property No.", Rec."Property ID");
                Rec."Total Units" := UnitNosRec.Count;
            end;
        }
        field(19; "Occupied Units"; Integer)
        {
            Caption = 'Occupied Units';
            FieldClass = FlowField;
            CalcFormula = Count("Property Unit" WHERE("Property No." = FIELD("Property ID"),
                                              "Unit Status" = CONST(Occupied)));
        }

        field(20; "Vacancy Rate"; Decimal)
        {
            Caption = 'Vacancy Rate %';
            DataClassification = CustomerContent;
            Editable = false;
            DecimalPlaces = 1 : 1;
        }
        field(21; "Blocked"; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(22; "Date Created"; Date)
        {
            Caption = 'Date Created';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(23; County; Text[50])
        {
            CaptionClass = '5,1,' + "Country/Region Code";
            Caption = 'County';
            OptimizeForTextSearch = true;
        }
        field(35; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                PostCode.CheckClearPostCodeCityCounty(City, "Post Code", County, "Country/Region Code", xRec."Country/Region Code");
            end;
        }
        field(36; "Unit No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Unit;
        }
    }

    keys
    {
        key(PK; "Property ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Property ID", "Property Name")
        {
        }


    }



    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit "No. Series";
        PropertySetup: Record "Property Setup";
    begin

        if "Property ID" = '' then begin
            PropertySetup.Get();
            PropertySetup.TestField("Property No.");
            "Property ID" := NoSeriesMgt.GetNextNo(PropertySetup."Property No.", 0D, true);
        end;
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupCity(var Property: Record Property; var PostCodeRec: Record "Post Code")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLookupCity(var Property: Record Property; var PostCodeRec: Record "Post Code")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateCity(var Property: Record Property; var PostCodeRec: Record "Post Code"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateCity(var Property: Record Property; xProperty: Record Property)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLookupPostCode(var Property: Record Property; var PostCodeRec: Record "Post Code")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLookupPostCode(var Property: Record Property; var PostCodeRec: Record "Post Code")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidatePostCode(var Property: Record Property; var PostCodeRec: Record "Post Code"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidatePostCode(var Property: Record Property; xProperty: Record Property)
    begin
    end;

    var
        PostCode: Record "Post Code";





}