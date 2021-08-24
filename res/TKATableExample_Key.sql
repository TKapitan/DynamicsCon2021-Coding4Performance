USE [default]
GO

CREATE UNIQUE NONCLUSTERED INDEX [$CK] ON [dbo].[CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059]
(
	[Posting Date] ASC,
	[G_L Account No_] ASC,
	[Entry No_] ASC
)
INCLUDE ([Amount]) 
WITH (
	PAD_INDEX = OFF, 
	STATISTICS_NORECOMPUTE = OFF, 
	SORT_IN_TEMPDB = OFF, 
	IGNORE_DUP_KEY = OFF, 
	DROP_EXISTING = OFF, 
	ONLINE = OFF, 
	ALLOW_ROW_LOCKS = ON, 
	ALLOW_PAGE_LOCKS = ON
) ON [PRIMARY]


GO


