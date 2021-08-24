USE [default]
GO

/****** Object:  Table [dbo].[CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059]    Script Date: 24.08.2021 23:32:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059](
	[timestamp] [timestamp] NOT NULL,
	[Entry No_] [int] NOT NULL,
	[Posting Date] [datetime] NOT NULL,
	[G_L Account No_] [nvarchar](20) NOT NULL,
	[Unique Identifier] [uniqueidentifier] NOT NULL,
	[Amount] [decimal](38, 20) NOT NULL,
	[$systemId] [uniqueidentifier] NOT NULL,
	[$systemCreatedAt] [datetime] NOT NULL,
	[$systemCreatedBy] [uniqueidentifier] NOT NULL,
	[$systemModifiedAt] [datetime] NOT NULL,
	[$systemModifiedBy] [uniqueidentifier] NOT NULL,
 CONSTRAINT [CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059$PK] PRIMARY KEY CLUSTERED 
(
	[Entry No_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059$$systemId] UNIQUE NONCLUSTERED 
(
	[$systemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059] ADD  CONSTRAINT [MDF$CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059$$systemId]  DEFAULT (newsequentialid()) FOR [$systemId]
GO

ALTER TABLE [dbo].[CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059] ADD  CONSTRAINT [MDF$CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059$$systemCreatedAt]  DEFAULT ('1753.01.01') FOR [$systemCreatedAt]
GO

ALTER TABLE [dbo].[CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059] ADD  CONSTRAINT [MDF$CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059$$systemCreatedBy]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [$systemCreatedBy]
GO

ALTER TABLE [dbo].[CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059] ADD  CONSTRAINT [MDF$CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059$$systemModifiedAt]  DEFAULT ('1753.01.01') FOR [$systemModifiedAt]
GO

ALTER TABLE [dbo].[CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059] ADD  CONSTRAINT [MDF$CRONUS International Ltd_$TKA Table Example$08292c4a-b44a-4cc6-8993-1558a379a059$$systemModifiedBy]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [$systemModifiedBy]
GO

