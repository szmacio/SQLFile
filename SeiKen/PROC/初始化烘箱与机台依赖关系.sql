USE [OrBitMOMJY]
GO
/****** Object:  StoredProcedure [dbo].[DAPS_InitialEquipmentOvendata]    Script Date: 2019/10/17 14:58:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ------------------------------------------------
 /*
  作者：Tom_Ma
  日期：2019/09/27
  作用：初始化烘箱与机台依赖关系
 */
 -------------------------------------------------
ALTER PROCEDURE  [dbo].[DAPS_InitialEquipmentOvendata] 
@I_Sender nvarchar(200)='', --客户端执行按钮
@I_ReturnMessage nvarchar(max)='' output,  --返回的信息,支持多语言
@I_ExceptionFieldName nvarchar(100)='' output, --向客户端报告引起冲突的字段
@I_LanguageId char(1)='1',				--客户端传入的语言ID
@I_PlugInCommand varchar(5)='',		--插件命令
@I_OrBitUserId char(12)='',			--用户ID
@I_OrBitUserName nvarchar(100)='',	--用户名
@I_ResourceId	char(12)='',		--资源ID(如果资源不在资源清单中，那么它将是空的)
@I_ResourceName nvarchar(100)='',	--资源名
@I_PKid char(12) ='',				--主键
@I_ParentPKId char(12)='',			--父级主键
@I_Parameter nvarchar(100)=''		--插件参数
--以上变量为系统服务固定接口参数，必须在每一个DoEvent过程中实现.

-------------------------------------------------------------------------

-----------------------------------------------------------------------------
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- 获取机台与模具之间的关系，多余字段可能以后会用上
		Select 
		Resource.ResourceId,
		OvenToEquipment.OvenId 
		INTO #EquipmentOven
		FROM dbo.Equipment 
		INNER JOIN  dbo.OvenToEquipment ON OvenToEquipment.EquipmentId=Equipment.EquipmentId
		INNER JOIN   dbo.Resource ON dbo.Resource.EquipmentRelationId=Equipment.EquipmentId
		WHERE Equipment.EquipmentName='注塑机' AND Equipment.IsAvalid=1

        declare @EquipmentId CHAR(12) --设备ID
		declare @EquipmentNumber NVARCHAR(50)--设备编码
		declare @ResourceId CHAR(12)--当前资源ID
		declare @BeforeResourceId CHAR(12)--前资源ID
		declare @DependResourceId CHAR(12)--前资源ID
		DECLARE @PKAttributeID VARCHAR(12);--资源主键ID
		DECLARE @UserId  CHAR(12)='SUR100000001'
		declare @ModelId CHAR(12)


        DECLARE  Mycursor CURSOR FOR
        select  ResourceId,OvenId FROM #EquipmentOven 
        OPEN Mycursor
        FETCH NEXT FROM Mycursor INTO @ResourceId,@BeforeResourceId
        WHILE @@FETCH_STATUS=0
        BEGIN
		--EXEC dbo.SysGetPublicPKIdNew @PKID = @PKAttributeID OUTPUT -- varchar(12)  申请主键

			DECLARE @PKID VARCHAR(12);
			EXEC dbo.SysGetPublicPKIdNew @PKID = @PKID OUTPUT -- varchar(12)

			Select @DependResourceId=Resource.ResourceId from dbo.Resource WHERE Resource.EquipmentRelationId=@BeforeResourceId

		--如果机台没有属性添加默认属性
		IF NOT EXISTS(
			Select 1 from dbo.ResourceDependence
				WHERE ResourceDependence.ResourceId=@ResourceId AND ResourceDependence.BeforeResourceId=@DependResourceId
				)
			begin
				--INSERT INTO dbo.ResourceAttribute
				--(
				--ResourceAttributeID,
				--ResourceID,
				--ResourceDistinguish,
				--ResourceType,
				--CreatotID,
				--CreateTime
				--)
				--VALUES
				--(
				--@PKAttributeID,       -- ResourceAttributeID - char(12)
				--@ResourceId,       -- ResourceID - char(12)
				--N'N',      -- ResourceDistinguish - nvarchar(10)
				--N'M',      -- ResourceType - nvarchar(10)
				--@UserId,       -- CreatotID - char(12)
				--GETDATE() -- CreateTime - datetime
				--)

				INSERT INTO dbo.ResourceDependence
							(
							ResourceDependenceID,
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
							( 
							@PKID,
							@ResourceId,        -- ResourceID - char(12)
							@DependResourceId,        -- BeforeResourceID - char(12)
							0,         -- DependenceCapacity - int
							@UserId,        -- ModifierID - char(12)
							@UserId,        -- CreatorID - char(12)
							GETDATE(), -- Createdate - datetime
							N'PCS',       -- CapacityUnit - nvarchar(10)
							0         -- DependenceProperty - char(1)
							)
			END

			FETCH NEXT FROM Mycursor INTO @ResourceId,@BeforeResourceId
        END
        CLOSE Mycursor
        DEALLOCATE Mycursor
		
	  TRUNCATE TABLE #EquipmentOven
	  DROP TABLE #EquipmentOven

     
END







