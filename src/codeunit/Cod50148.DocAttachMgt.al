codeunit 50148 "Document Attachment"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Attachment Mgmt", 'OnAfterGetRefTable', '', false, false)]
    local procedure OnAfterGetNewRefTable(var RecRef: RecordRef; DocumentAttachment: Record "Document Attachment")
    var
        PropertyRec: Record Property;
        UnitRec: Record Unit;
        CustomerRec: Record Customer;
        LeaseRec: Record Lease;
        TenantAppRec: Record "Tenant Application";
    begin
        case DocumentAttachment."Table ID" of
            Database::Property:
                begin
                    RecRef.Open(Database::Property);
                    if PropertyRec.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(PropertyRec);
                end;
            Database::Unit:
                begin
                    RecRef.Open(Database::Unit);
                    if UnitRec.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(UnitRec);

                end;
            Database::"Tenant Application":
                begin
                    RecRef.Open(Database::"Tenant Application");
                    if CustomerRec.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(TenantAppRec);
                end;
            Database::Lease:
                begin
                    RecRef.Open(Database::Lease);
                    if LeaseRec.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(LeaseRec);
                end;


        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnBeforeInsertAttachment', '', false, false)]
    local procedure OnBeforeInsertAttachment(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
    begin
        case RecRef.Number of
            DATABASE::Property:
                begin
                    FieldRef := RecRef.Field(1);
                    DocumentAttachment."No." := FieldRef.Value;
                end;
            Database::Unit:
                begin
                    FieldRef := RecRef.Field(1);
                    DocumentAttachment."No." := FieldRef.Value;
                end;
            Database::Customer:
                begin
                    FieldRef := RecRef.Field(1);
                    DocumentAttachment."No." := FieldRef.Value;

                end;
            Database::"Tenant Application":
                begin
                    FieldRef := RecRef.Field(1);
                    DocumentAttachment."No." := FieldRef.Value;

                end;

            Database::Lease:
                begin
                    FieldRef := RecRef.Field(1);
                    DocumentAttachment."No." := FieldRef.Value;

                end;
        end;
    end;



}

