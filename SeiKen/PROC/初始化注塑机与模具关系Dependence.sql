USE [OrBitMOMJY]
GO
/****** Object:  StoredProcedure [dbo].[DAPS_InitialEquipmentModlesdata]    Script Date: 2019/10/17 14:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ------------------------------------------------
 /*
  作者：Tom_Ma
  日期：2019/09/23
  作用：初始化注塑机与模具关系Dependence
 */
 -------------------------------------------------
ALTER PROCEDURE  [dbo].[DAPS_InitialEquipmentModlesdata] 
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
		Select Models.ModelsId as ModelId,
		EquipmentNumber,
		Equipment_Model.EquipmentId,
		Models.ModelsPN as Model_Number,Models.Mtonnage,
		Models.ModelProSeries+' ' + Models.ProductNm as ModelProSeries,
		Equipment_Model.Prior,
		IsActivity ,
		Acycle,
		OperationPeriod,
		UpperModelOverTimeSet,AdjustOverTimeSet,
		LowerModelOverTimeSet
		INTO #ResourceDependence
		FROM Equipment 
		INNER JOIN UserCode ON UserCode.UserCodeId =Equipment.EquipmentTypeId 
		INNER JOIN Equipment_Model ON Equipment_Model.EquipmentId=Equipment.EquipmentId 
		INNER JOIN dbo.Models ON dbo.Models.ModelsId=Equipment_Model.ModelId
		WHERE  Equipment.EquipmentName='注塑机'
		ORDER BY Equipment.EquipmentId

        declare @EquipmentId CHAR(12) --设备ID
		declare @EquipmentNumber NVARCHAR(50)--设备编码
		declare @ResourceId CHAR(12)--当前资源ID
		declare @BeforeResourceId CHAR(12)--前资源ID
		DECLARE @PKAttributeID VARCHAR(12);--资源主键ID
		DECLARE @UserId  CHAR(12)='SUR100000001'
		declare @ModelId CHAR(12)


        DECLARE  Mycursor CURSOR FOR
        select  EquipmentId,EquipmentNumber,ModelId from #ResourceDependence 
        OPEN Mycursor
        FETCH NEXT FROM Mycursor INTO @EquipmentId,@EquipmentNumber,@ModelId
        WHILE @@FETCH_STATUS=0
        BEGIN
		EXEC dbo.SysGetPublicPKIdNew @PKID = @PKAttributeID OUTPUT -- varchar(12) 

		SELECT  @ResourceId=Resource.ResourceId from dbo.Resource WHERE dbo.Resource.EquipmentRelationId=@EquipmentId
		--如果机台没有属性添加默认属性
		IF NOT EXISTS(
		SELECT 1 FROM dbo.Resource
				INNER JOIN dbo.ResourceAttribute ON ResourceAttribute.ResourceID=Resource.ResourceId
				WHERE Resource.ResourceId=@ResourceId
				)
			begin
				INSERT INTO dbo.ResourceAttribute
				(
				ResourceAttributeID,
				ResourceID,
				ResourceDistinguish,
				ResourceType,
				CreatotID,
				CreateTime
				)
				VALUES
				(
				@PKAttributeID,       -- ResourceAttributeID - char(12)
				@ResourceId,       -- ResourceID - char(12)
				N'N',      -- ResourceDistinguish - nvarchar(10)
				N'M',      -- ResourceType - nvarchar(10)
				@UserId,       -- CreatotID - char(12)
				GETDATE() -- CreateTime - datetime
				)
			END
			--插入机台与模具的依赖关系
			
			Select @BeforeResourceId=Resource.ResourceId from dbo.Resource  WHERE dbo.Resource.EquipmentRelationId=@ModelId
			DECLARE @PKID VARCHAR(12);
			EXEC dbo.SysGetPublicPKIdNew @PKID = @PKID OUTPUT -- varchar(12)
					IF NOT EXISTS(select 1 from ResourceDependence where  ResourceId=@ResourceId and BeforeResourceId=@BeforeResourceId)
							BEGIN
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
							@BeforeResourceId,        -- BeforeResourceID - char(12)
							0,         -- DependenceCapacity - int
							@UserId,        -- ModifierID - char(12)
							@UserId,        -- CreatorID - char(12)
							GETDATE(), -- Createdate - datetime
							N'PCS',       -- CapacityUnit - nvarchar(10)
							0         -- DependenceProperty - char(1)
							)
							END
			FETCH NEXT FROM Mycursor INTO @EquipmentId,@EquipmentNumber,@ModelId
        END
        CLOSE Mycursor
        DEALLOCATE Mycursor
		
	  TRUNCATE TABLE #ResourceDependence
	  DROP TABLE #ResourceDependence

     
END







