/// <summary>
/// Table TKA Table Example (ID 50100).
/// </summary>
table 50100 "TKA Table Example"
{
    Caption = 'Table Example';
    ColumnStoreIndex = true;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(3; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            DataClassification = CustomerContent;
        }
        field(4; "Unique Identifier"; Guid)
        {
            Caption = 'Unique Identifier';
            DataClassification = CustomerContent;
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = false;
        }
        key(CK; "Posting Date", "G/L Account No.")
        {
            Clustered = false;
            IncludedFields = Amount;
        }
        key(UK; "Unique Identifier")
        {
            Unique = true;
            Enabled = false;
            SqlIndex = "Entry No.";
        }
    }

}