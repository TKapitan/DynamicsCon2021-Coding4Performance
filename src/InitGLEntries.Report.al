/// <summary>
/// Report TKA Init G/L Entries (ID 50101).
/// </summary>
report 50101 "TKA Init G/L Entries"
{
    Caption = 'Init G/L Entries';
    UsageCategory = Administration;
    ProcessingOnly = true;
    ApplicationArea = All;

    trigger OnPostReport()
    var
        GLEntry, GLEntry2 : Record "G/L Entry";
        RequestedNoOfRec, NoOfRec, EntryNo : Integer;
        NoOfRecMsg: Label 'There is %1 records in G/L Entry table', Comment = '%1 - Total number of records';
    begin
        RequestedNoOfRec := 250000;
        NoOfRec := GLEntry.Count();

        GLEntry.FindLast();
        EntryNo := GLEntry."Entry No.";
        while true do begin
            if NoOfRec >= RequestedNoOfRec then
                break;
            EntryNo += 1;
            NoOfRec += 1;

            GLEntry2 := GLEntry;
            GLEntry2."Entry No." := EntryNo;
            GLEntry2.Insert();
        end;
        Message(NoOfRecMsg, GLEntry.Count());
    end;
}