-- Amount not included in key PostingDate,GLAccountName
-- Included column
SELECT
     [Amount]
FROM [default].[dbo].[CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059]
WHERE
	[Posting Date] >= GETDATE()

-- Included column & non included column
SELECT
     [Amount],[Unique Identifier]
FROM [default].[dbo].[CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059]
WHERE
	[Posting Date] >= GETDATE()