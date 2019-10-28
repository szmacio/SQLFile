SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
 ------------------------------------------------
 /*
  作者：Tom_Ma
  日期：2019/10/8
  作用：MES同步资源（CRUD）
 */
 -------------------------------------------------
ALTER PROCEDURE  [dbo].[DAPS_SyncResourceFromMes] 
@I_ReturnMessage nvarchar(max)='' output,  --返回的信息,支持多语言
--以上变量为系统服务固定接口参数，必须在每一个DoEvent过程中实现.
@ModifyType char(1)='',	--I 插入，U 更新
@ResourceID char(12)='',	
@DependenceCapacity INT,
@BeforeResourceID char(12)='',	
@ModifierID char(12)='',
@ResourceType char(1)='' --M 模具,--A 高光机 --O烘箱 --C--腔号，
-------------------------------------------------------------------------

-----------------------------------------------------------------------------
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	declare @ResourceDependenceId char(12)
	--添加机台与模具的依赖接口
	IF(@ResourceType='M')

	BEGIN
	--机台与模具关系新增
		IF(@ModifyType='I')
					BEGIN
					
						EXEC	[dbo].[SysGetObjectPKId]
						@ObjectName = 'ResourceDependence',
						@PKID = @ResourceDependenceId OUTPUT	
					INSERT INTO dbo.ResourceDependence
						(
							ResourceDependenceId,
							ResourceID,
							BeforeResourceID,
							DependenceCapacity,
							ModifierID,
							CreatorID,
							Createdate,
							CapacityUnit,
							DependenceProperty
						)
						VALUES
						(   @ResourceDependenceId,        -- ResourceDependenceID - char(12)
							@ResourceID,        -- ResourceID - char(12)
							@BeforeResourceID,        -- BeforeResourceID - char(12)
							@DependenceCapacity,         -- DependenceCapacity - int
							@ModifierID,        -- ModifierID - char(12)
							@ModifierID,        -- CreatorID - char(12)
							GETDATE(), -- Createdate - datetime
							N'PCS',       -- CapacityUnit - nvarchar(10)
							'0'         -- DependenceProperty - char(1)
							)
					END
					--修改机台与模具关系
		IF(@ModifyType='U')
					BEGIN
						DELETE FROM dbo.ResourceDependence 
						WHERE  ResourceDependence.ResourceID=@ResourceID 
						AND ResourceDependence.BeforeResourceID=@BeforeResourceID

						EXEC	[dbo].[SysGetObjectPKId]
						@ObjectName = 'ResourceDependence',
						@PKID = @ResourceDependenceId OUTPUT	
					INSERT INTO dbo.ResourceDependence
						(
							ResourceDependenceId,
							ResourceID,
							BeforeResourceID,
							DependenceCapacity,
							ModifierID,
							CreatorID,
							Createdate,
							CapacityUnit,
							DependenceProperty
						)
						VALUES
						(   @ResourceDependenceId,        -- ResourceDependenceID - char(12)
							@ResourceID,        -- ResourceID - char(12)
							@BeforeResourceID,        -- BeforeResourceID - char(12)
							@DependenceCapacity,         -- DependenceCapacity - int
							@ModifierID,        -- ModifierID - char(12)
							@ModifierID,        -- CreatorID - char(12)
							GETDATE(), -- Createdate - datetime
							N'PCS',       -- CapacityUnit - nvarchar(10)
							'0'         -- DependenceProperty - char(1)
							)
					END

	END
		IF(@ResourceType='C')
					BEGIN
				SET @I_ReturnMessage=' c腔号'
				END
			IF(@ResourceType='A')
					BEGIN
				SET @I_ReturnMessage=' A 高光机'
				END

				IF(@ResourceType='O')
				BEGIN
				SET @I_ReturnMessage=' HONGXIANG'
				END





     
END







GO

