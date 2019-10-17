
CREATE TABLE [dbo].[ResourceGroup](
	[ResourceGroupId] [CHAR](12) NOT NULL,
	[ResourceId] [CHAR](12) NULL,
	[ResourceGroupName] [NCHAR](50) NULL,
 CONSTRAINT [PK_ResourceGroup] PRIMARY KEY CLUSTERED 
(
	[ResourceGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ResourceGroup', @level2type=N'COLUMN',@level2name=N'ResourceGroupId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'资源ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ResourceGroup', @level2type=N'COLUMN',@level2name=N'ResourceId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'资源组名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ResourceGroup', @level2type=N'COLUMN',@level2name=N'ResourceGroupName'
GO


