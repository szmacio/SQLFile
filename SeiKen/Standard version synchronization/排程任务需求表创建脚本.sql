USE [OrBitMOMJY]
GO

/****** Object:  Table [dbo].[TaskMaterialRequirement]    Script Date: 2019/10/10 14:57:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TaskMaterialRequirement](
	[TaskMaterialRequirementID] [CHAR](12) NOT NULL,
	[BillTitle] [NVARCHAR](50) NULL,
	[TaskID] [CHAR](12) NULL,
	[MoID] [CHAR](12) NULL,
	[DemandedQTY] [DECIMAL](18, 4) NULL,
	[CutOffInventory] [DECIMAL](18, 4) NULL,
	[OweMaterialQTY] [DECIMAL](18, 4) NULL,
	[BillStatus] [CHAR](1) NULL,
	[RequiredTime] [DATETIME] NULL,
	[CreateDate] [DATETIME] NULL,
 CONSTRAINT [PK_TaskMaterialRequirement] PRIMARY KEY CLUSTERED 
(
	[TaskMaterialRequirementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TaskMaterialRequirement] ADD  CONSTRAINT [DF_TaskMaterialRequirement_DemandedQTY]  DEFAULT ((0)) FOR [DemandedQTY]
GO

ALTER TABLE [dbo].[TaskMaterialRequirement] ADD  CONSTRAINT [DF_TaskMaterialRequirement_CutOffInventory]  DEFAULT ((0)) FOR [CutOffInventory]
GO

ALTER TABLE [dbo].[TaskMaterialRequirement] ADD  CONSTRAINT [DF_TaskMaterialRequirement_BillStatus]  DEFAULT ((0)) FOR [BillStatus]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�ų�������������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TaskMaterialRequirement', @level2type=N'COLUMN',@level2name=N'TaskMaterialRequirementID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TaskMaterialRequirement', @level2type=N'COLUMN',@level2name=N'BillTitle'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ID��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TaskMaterialRequirement', @level2type=N'COLUMN',@level2name=N'TaskID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TaskMaterialRequirement', @level2type=N'COLUMN',@level2name=N'MoID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TaskMaterialRequirement', @level2type=N'COLUMN',@level2name=N'DemandedQTY'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�ų�Ϊֹ�Ŀ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TaskMaterialRequirement', @level2type=N'COLUMN',@level2name=N'CutOffInventory'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ƿȱ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TaskMaterialRequirement', @level2type=N'COLUMN',@level2name=N'OweMaterialQTY'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'���ϵ���״̬(0-δ���ϣ�1-������)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TaskMaterialRequirement', @level2type=N'COLUMN',@level2name=N'BillStatus'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��������ʱ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TaskMaterialRequirement', @level2type=N'COLUMN',@level2name=N'RequiredTime'
GO


