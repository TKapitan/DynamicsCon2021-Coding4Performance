/// <summary>
/// Report TKA Partial Records Tester (ID 50100).
/// </summary>
report 50100 "TKA Partial Records Tester"
{
    Caption = 'Partial Records Tester';
    UsageCategory = Administration;
    ProcessingOnly = true;
    AllowScheduling = false;
    ApplicationArea = All;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(NoOfRuns; NoOfRuns)
                    {
                        Caption = 'No. of Runs';
                        ApplicationArea = All;
                    }
                    field(SumType; SumType)
                    {
                        Caption = 'Sum Type';
                        OptionCaption = 'Normal - Amount field,Partial Records - Amount field,Partial Records - Amount+VAT Amount field,Partial Records - Amount field (proc without VAR),Partial Records - Amount field (proc with VAR),Partial Records - VAT Amount field (proc without VAR),Partial Records - VAT Amount field (proc with VAR),Partial Records - VAT Amount field (proc without VAR); load field,Partial Records - VAT Amount field (proc with VAR); load field,Partial Records - VAT Amount field (proc without VAR); add loaded field,Partial Records - VAT Amount field (proc with VAR); add loaded field';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    var
        SumType: Option NormalAmount,PartRecsAmount,PartRecsAmountVATAmount,PartRecsAmountProcWithoutVAR,PartRecsAmountProcWithVAR,PartRecsVATAmountProcWithoutVAR,PartRecsVATAmountProcWithVAR,PartRecsVATAmountProcWithoutVARLoad,PartRecsVATAmountProcWithVARLoad,PartRecsVATAmountProcWithoutVARAddLoaded,PartRecsVATAmountProcWithVARAddLoaded;
        NoOfRuns: Integer;
        ResultMessage: Text;


    trigger OnPostReport()
    var
        CurrRunNo: Integer;
        AmountSum: Decimal;
        SumMsg: Label 'Sum of amount: %1', Comment = '%1 - total sum of amount';
    begin
        CurrRunNo := 1;
        repeat
            case SumType of
                SumType::NormalAmount:
                    AmountSum := DoNormalSumAmountField();
                SumType::PartRecsAmount:
                    AmountSum := DoPartialRecordsSumAmountField();
                SumType::PartRecsAmountVATAmount:
                    AmountSum := DoPartialRecordsSumAmountVATAmountField();
                SumType::PartRecsAmountProcWithoutVAR:
                    AmountSum := DoPartialRecordsSumAmountFieldAnotherProc();
                SumType::PartRecsAmountProcWithVAR:
                    AmountSum := DoPartialRecordsSumAmountFieldAnotherProcWithVAR();
                SumType::PartRecsVATAmountProcWithoutVAR:
                    AmountSum := DoPartialRecordsSumVATAmountFieldAnotherProc();
                SumType::PartRecsVATAmountProcWithVAR:
                    AmountSum := DoPartialRecordsSumVATAmountFieldAnotherProcWithVAR();
                SumType::PartRecsVATAmountProcWithoutVARLoad:
                    AmountSum := DoPartialRecordsSumVATAmountFieldAnotherProcLoad();
                SumType::PartRecsVATAmountProcWithVARLoad:
                    AmountSum := DoPartialRecordsSumVATAmountFieldAnotherProcWithVARLoad();
                SumType::PartRecsVATAmountProcWithoutVARAddLoaded:
                    AmountSum := DoPartialRecordsSumVATAmountFieldAnotherProcAddLoaded();
                SumType::PartRecsVATAmountProcWithVARAddLoaded:
                    AmountSum := DoPartialRecordsSumVATAmountFieldAnotherProcWithVARAddLoaded();
            end;
            CurrRunNo += 1;
        until CurrRunNo > NoOfRuns;
        Message(ResultMessage + '\\' + SumMsg, AmountSum);
    end;

    /* Standard approach
    Time spent: 5 seconds 491 milliseconds
    Time spent: 5 seconds 845 milliseconds
    Time spent: 5 seconds 568 milliseconds
    Time spent: 6 seconds 46 milliseconds
    Time spent: 6 seconds 155 milliseconds
    */
    local procedure DoNormalSumAmountField(): Decimal
    var
        GLEntry: Record "G/L Entry";

        StartingTime: DateTime;
        AmountSum: Decimal;
        TimeSpentMsg: Label 'Time spent: %1', Comment = '%1 - time spent';
    begin
        StartingTime := CurrentDateTime();
        GLEntry.FindSet();
        repeat
            AmountSum += GLEntry.Amount;
        until GLEntry.Next() < 1;

        if ResultMessage <> '' then
            ResultMessage += '\';
        ResultMessage += StrSubstNo(TimeSpentMsg, CurrentDateTime() - StartingTime);
        exit(AmountSum);
    end;

    /* Partial Records
    Time spent: 2 seconds 50 milliseconds
    Time spent: 2 seconds 122 milliseconds
    Time spent: 1 second 992 milliseconds
    Time spent: 2 seconds 68 milliseconds
    Time spent: 2 seconds 12 milliseconds
    */
    local procedure DoPartialRecordsSumAmountField(): Decimal
    var
        GLEntry: Record "G/L Entry";

        StartingTime: DateTime;
        AmountSum: Decimal;
        TimeSpentMsg: Label 'Time spent: %1', Comment = '%1 - time spent';
    begin
        StartingTime := CurrentDateTime();
        GLEntry.SetLoadFields(Amount);
        GLEntry.FindSet();
        repeat
            AmountSum += GLEntry.Amount;
        until GLEntry.Next() < 1;

        if ResultMessage <> '' then
            ResultMessage += '\';
        ResultMessage += StrSubstNo(TimeSpentMsg, CurrentDateTime() - StartingTime);
        exit(AmountSum);
    end;

    /* Partial Records + another field (compiler optimalization)
    Time spent: 2 seconds 147 milliseconds
    Time spent: 2 seconds 158 milliseconds
    Time spent: 2 seconds 126 milliseconds
    Time spent: 2 seconds 207 milliseconds
    Time spent: 2 seconds 174 milliseconds
    */
    local procedure DoPartialRecordsSumAmountVATAmountField(): Decimal
    var
        GLEntry: Record "G/L Entry";

        StartingTime: DateTime;
        AmountSum: Decimal;
        TimeSpentMsg: Label 'Time spent: %1', Comment = '%1 - time spent';
    begin
        StartingTime := CurrentDateTime();
        GLEntry.SetLoadFields(Amount);
        GLEntry.FindSet();
        repeat
            AmountSum += GLEntry.Amount;
            AmountSum += GLEntry."VAT Amount";
        until GLEntry.Next() < 1;

        if ResultMessage <> '' then
            ResultMessage += '\';
        ResultMessage += StrSubstNo(TimeSpentMsg, CurrentDateTime() - StartingTime);
        exit(AmountSum);
    end;

    /* Partial Records passing to procedure without var modifier
    Time spent: 3 seconds 551 milliseconds
    Time spent: 3 seconds 405 milliseconds
    Time spent: 3 seconds 668 milliseconds
    Time spent: 3 seconds 413 milliseconds
    Time spent: 3 seconds 564 milliseconds
    */
    local procedure DoPartialRecordsSumAmountFieldAnotherProc(): Decimal
    var
        GLEntry: Record "G/L Entry";

        StartingTime: DateTime;
        AmountSum: Decimal;
        TimeSpentMsg: Label 'Time spent: %1', Comment = '%1 - time spent';
    begin
        StartingTime := CurrentDateTime();
        GLEntry.SetLoadFields(Amount);
        GLEntry.FindSet();
        repeat
            AmountSum += DoAmountSumWithoutVAR(GLEntry);
        until GLEntry.Next() < 1;

        if ResultMessage <> '' then
            ResultMessage += '\';
        ResultMessage += StrSubstNo(TimeSpentMsg, CurrentDateTime() - StartingTime);
        exit(AmountSum);
    end;

    /* Partial Records passing to procedure with var modifier
    Time spent: 2 seconds 493 milliseconds
    Time spent: 2 seconds 568 milliseconds
    Time spent: 2 seconds 519 milliseconds
    Time spent: 2 seconds 570 milliseconds
    Time spent: 2 seconds 463 milliseconds
    */
    local procedure DoPartialRecordsSumAmountFieldAnotherProcWithVAR(): Decimal
    var
        GLEntry: Record "G/L Entry";

        StartingTime: DateTime;
        AmountSum: Decimal;
        TimeSpentMsg: Label 'Time spent: %1', Comment = '%1 - time spent';
    begin
        StartingTime := CurrentDateTime();
        GLEntry.SetLoadFields(Amount);
        GLEntry.FindSet();
        repeat
            AmountSum += DoAmountSumWithVAR(GLEntry);
        until GLEntry.Next() < 1;

        if ResultMessage <> '' then
            ResultMessage += '\';
        ResultMessage += StrSubstNo(TimeSpentMsg, CurrentDateTime() - StartingTime);
        exit(AmountSum);
    end;

    /* Accessing field that is not loaded in procedure without var modifier
    Time spent: 7 seconds 906 milliseconds
    Time spent: 7 seconds 40 milliseconds
    Time spent: 7 seconds 194 milliseconds
    Time spent: 7 seconds 139 milliseconds
    Time spent: 6 seconds 924 milliseconds
    */
    local procedure DoPartialRecordsSumVATAmountFieldAnotherProc(): Decimal
    var
        GLEntry: Record "G/L Entry";

        StartingTime: DateTime;
        AmountSum: Decimal;
        TimeSpentMsg: Label 'Time spent: %1', Comment = '%1 - time spent';
    begin
        StartingTime := CurrentDateTime();
        GLEntry.SetLoadFields(Amount);
        GLEntry.FindSet();
        repeat
            AmountSum += DoVATAmountSumWithoutVAR(GLEntry);
        until GLEntry.Next() < 1;

        if ResultMessage <> '' then
            ResultMessage += '\';
        ResultMessage += StrSubstNo(TimeSpentMsg, CurrentDateTime() - StartingTime);
        exit(AmountSum);
    end;

    /* Accessing field that is not loaded in procedure with var modifier
    Time spent: 2 seconds 727 milliseconds
    Time spent: 2 seconds 718 milliseconds
    Time spent: 2 seconds 861 milliseconds
    Time spent: 2 seconds 617 milliseconds
    Time spent: 2 seconds 875 milliseconds
    */
    local procedure DoPartialRecordsSumVATAmountFieldAnotherProcWithVAR(): Decimal
    var
        GLEntry: Record "G/L Entry";

        StartingTime: DateTime;
        AmountSum: Decimal;
        TimeSpentMsg: Label 'Time spent: %1', Comment = '%1 - time spent';
    begin
        StartingTime := CurrentDateTime();
        GLEntry.SetLoadFields(Amount);
        GLEntry.FindSet();
        repeat
            AmountSum += DoVATAmountSumWithVAR(GLEntry);
        until GLEntry.Next() < 1;

        if ResultMessage <> '' then
            ResultMessage += '\';
        ResultMessage += StrSubstNo(TimeSpentMsg, CurrentDateTime() - StartingTime);
        exit(AmountSum);
    end;

    /* Accessing field that is not loaded in procedure without var modifier but load the field first
    Time spent: 7 seconds 358 milliseconds
    Time spent: 6 seconds 584 milliseconds
    Time spent: 6 seconds 505 milliseconds
    Time spent: 6 seconds 690 milliseconds
    Time spent: 6 seconds 528 milliseconds
    */
    local procedure DoPartialRecordsSumVATAmountFieldAnotherProcLoad(): Decimal
    var
        GLEntry: Record "G/L Entry";

        StartingTime: DateTime;
        AmountSum: Decimal;
        TimeSpentMsg: Label 'Time spent: %1', Comment = '%1 - time spent';
    begin
        StartingTime := CurrentDateTime();
        GLEntry.SetLoadFields(Amount);
        GLEntry.FindSet();
        repeat
            AmountSum += DoVATAmountSumWithoutVARLoad(GLEntry);
        until GLEntry.Next() < 1;

        if ResultMessage <> '' then
            ResultMessage += '\';
        ResultMessage += StrSubstNo(TimeSpentMsg, CurrentDateTime() - StartingTime);
        exit(AmountSum);
    end;

    /* Accessing field that is not loaded in procedure with var modifier but load the field first
    Time spent: 3 seconds 235 milliseconds
    Time spent: 3 seconds 53 milliseconds
    Time spent: 3 seconds 326 milliseconds
    Time spent: 2 seconds 979 milliseconds
    Time spent: 2 seconds 961 milliseconds
    */
    local procedure DoPartialRecordsSumVATAmountFieldAnotherProcWithVARLoad(): Decimal
    var
        GLEntry: Record "G/L Entry";

        StartingTime: DateTime;
        AmountSum: Decimal;
        TimeSpentMsg: Label 'Time spent: %1', Comment = '%1 - time spent';
    begin
        StartingTime := CurrentDateTime();
        GLEntry.SetLoadFields(Amount);
        GLEntry.FindSet();
        repeat
            AmountSum += DoVATAmountSumWithVARLoad(GLEntry);
        until GLEntry.Next() < 1;

        if ResultMessage <> '' then
            ResultMessage += '\';
        ResultMessage += StrSubstNo(TimeSpentMsg, CurrentDateTime() - StartingTime);
        exit(AmountSum);
    end;

    /* Accessing field that is not loaded in procedure without var modifier but add loaded field first
    Time spent: 6 seconds 478 milliseconds
    Time spent: 6 seconds 511 milliseconds
    Time spent: 6 seconds 504 milliseconds
    Time spent: 6 seconds 844 milliseconds
    Time spent: 6 seconds 777 milliseconds
    */
    local procedure DoPartialRecordsSumVATAmountFieldAnotherProcAddLoaded(): Decimal
    var
        GLEntry: Record "G/L Entry";

        StartingTime: DateTime;
        AmountSum: Decimal;
        TimeSpentMsg: Label 'Time spent: %1', Comment = '%1 - time spent';
    begin
        StartingTime := CurrentDateTime();
        GLEntry.SetLoadFields(Amount);
        GLEntry.FindSet();
        repeat
            AmountSum += DoVATAmountSumWithoutVARLoad(GLEntry);
        until GLEntry.Next() < 1;

        if ResultMessage <> '' then
            ResultMessage += '\';
        ResultMessage += StrSubstNo(TimeSpentMsg, CurrentDateTime() - StartingTime);
        exit(AmountSum);
    end;

    /* Accessing field that is not loaded in procedure with var modifier but add loaded field first
    Time spent: 3 seconds 483 milliseconds
    Time spent: 2 seconds 915 milliseconds
    Time spent: 2 seconds 762 milliseconds
    Time spent: 2 seconds 773 milliseconds
    Time spent: 2 seconds 869 milliseconds
    */
    local procedure DoPartialRecordsSumVATAmountFieldAnotherProcWithVARAddLoaded(): Decimal
    var
        GLEntry: Record "G/L Entry";

        StartingTime: DateTime;
        AmountSum: Decimal;
        TimeSpentMsg: Label 'Time spent: %1', Comment = '%1 - time spent';
    begin
        StartingTime := CurrentDateTime();
        GLEntry.SetLoadFields(Amount);
        GLEntry.FindSet();
        repeat
            AmountSum += DoVATAmountSumWithVARAddLoaded(GLEntry);
        until GLEntry.Next() < 1;

        if ResultMessage <> '' then
            ResultMessage += '\';
        ResultMessage += StrSubstNo(TimeSpentMsg, CurrentDateTime() - StartingTime);
        exit(AmountSum);
    end;

    local procedure DoAmountSumWithoutVAR(GLEntry: Record "G/L Entry"): Decimal
    begin
        exit(GLEntry.Amount);
    end;

    local procedure DoAmountSumWithVAR(var GLEntry: Record "G/L Entry"): Decimal
    begin
        exit(GLEntry.Amount);
    end;

    local procedure DoVATAmountSumWithoutVAR(GLEntry: Record "G/L Entry"): Decimal
    var
        Amount: Decimal;
    begin
        Amount := GLEntry."VAT Amount";
        exit(Amount);
    end;

    local procedure DoVATAmountSumWithVAR(var GLEntry: Record "G/L Entry"): Decimal
    var
        Amount: Decimal;
    begin
        Amount := GLEntry."VAT Amount";
        exit(Amount);
    end;

    local procedure DoVATAmountSumWithoutVARLoad(GLEntry: Record "G/L Entry"): Decimal
    var
        Amount: Decimal;
    begin
        GLEntry.LoadFields("VAT Amount");
        Amount := GLEntry."VAT Amount";
        exit(Amount);
    end;

    local procedure DoVATAmountSumWithVARLoad(var GLEntry: Record "G/L Entry"): Decimal
    var
        Amount: Decimal;
    begin
        GLEntry.LoadFields("VAT Amount");
        Amount := GLEntry."VAT Amount";
        exit(Amount);
    end;

    local procedure DoVATAmountSumWithoutVARAddLoaded(GLEntry: Record "G/L Entry"): Decimal
    var
        Amount: Decimal;
    begin
        GLEntry.AddLoadFields("VAT Amount");
        Amount := GLEntry."VAT Amount";
        exit(Amount);
    end;

    local procedure DoVATAmountSumWithVARAddLoaded(var GLEntry: Record "G/L Entry"): Decimal
    var
        Amount: Decimal;
    begin
        GLEntry.AddLoadFields("VAT Amount");
        Amount := GLEntry."VAT Amount";
        exit(Amount);
    end;
}