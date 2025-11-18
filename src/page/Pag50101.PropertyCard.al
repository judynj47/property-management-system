page 50101 "Property Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Property;
    Caption = 'Property Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the property.';
                }
                field(Name; Rec."Property Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the property.';
                }
                field(Type; Rec."Property Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of property.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category of the property.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the address of the property.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the additional address information.';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country field.', Comment = '%';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city of the property.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the post code.';
                }
                field("GPS Coordinates"; Rec."GPS Coordinates")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the GPS coordinates.';
                }
            }

            group(Details)
            {
                Caption = 'Details';
                field("Land Area"; Rec."Land Area")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the land area in square meters.';
                }
                field("Owner No."; Rec."Owner No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the owner of the property.';
                }
                field("Ownership Type"; Rec."Ownership Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ownership type.';
                }
                field("Market Value"; Rec."Market Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the market value of the property.';
                }
                field("Annual Property Tax"; Rec."Annual Property Tax")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the annual property tax.';
                }
                field("Insurance Policy No."; Rec."Insurance Policy No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the insurance policy number.';
                }
            }

            group(Statistics)
            {
                Caption = 'Statistics';
                field("Total Units"; Rec."Total Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of units.';
                    Editable = false;
                }
                field("Occupied Units"; Rec."Occupied Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of occupied units.';
                    Editable = false;
                }
                field("Vacancy Rate"; Rec."Vacancy Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vacancy rate percentage.';
                    Editable = false;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the property is blocked.';
                }
            }

            part(PropertyUnit; "Unit List subpage")
            {
                SubPageLink = "Property No." = field("Property ID");
            }
            part(PropertyAmenities; "Property Amenity Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Property No." = FIELD("Property ID");
            }
            part(PropertyCharges; "Property Charges Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Property No." = field("Property ID");
            }
            cuegroup(TotalProperties)
            {
                Visible = false;
                Caption = 'Total Properties';
                field("Total Properties"; Rec."Total Properties")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Property List";
                }
            }
        }

        area(factboxes)
        {
            part("Attached Documents List"; "Doc. Attachment List Factbox")
            {
                Visible = true;
                ApplicationArea = All;
                Caption = 'Documents';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::Property),
                              "No." = field("Property ID");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("&Properties")
            {
                action(Attachments)
                {
                    Promoted = true;
                    PromotedCategory = New;
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal();
                    end;
                }
            }
        }
        area(Processing)
        {
            action(SetupCharge)
            {
                Caption = 'Setup additional service and utility charges';
                Image = SetupList;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PropertyCharge: Record "Charge Setup";
                    PropertyChargePage: Page "Property Charge List";
                begin
                    // Set filter to show only charges for this property
                    PropertyCharge.SetRange("Property No.", Rec."Property ID");

                    // Open the Property Charge list page filtered for this property
                    PropertyChargePage.SetTableView(PropertyCharge);
                    PropertyChargePage.RunModal();
                end;
            }

            action(ManageCharges)
            {
                Caption = 'Manage Property Charges';
                //Image = Charges;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PropertyCharge: Record "Property Charge";
                    ChargeSetup: Record "Charge Setup";
                    ChargeSetupPage: Page "Property Charge List";
                begin
                    // Open the Charge Setup page to manage available charge types
                    ChargeSetupPage.RunModal();
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        PropertyUnit: Record "Property Unit";
    begin
        PropertyUnit.ValidateUnitNo(Rec."Property ID");
    end;
}