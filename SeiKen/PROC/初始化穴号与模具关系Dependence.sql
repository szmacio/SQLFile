USE [OrBitMOMJY]
GO
/****** Object:  StoredProcedure [dbo].[DAPS_InitialModelCavitdata]    Script Date: 2019/10/17 14:58:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ------------------------------------------------
 /*
  作者：Tom_Ma
  日期：2019/09/30
  作用：初始化穴号与模具关系Dependence
 */
 -------------------------------------------------
ALTER PROCEDURE  [dbo].[DAPS_InitialModelCavitdata] 
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


	--获取模具、产品、穴号关系
		SELECT
		( 
			(SELECT  TOP 1 * 
			FROM 
			dbo.ConvertParameterToTable(Resource.ResourceName,'_')   ) 
			)  AS modelName,
			(SELECT  TOP 1 * 
			FROM 
			dbo.ConvertParameterToTable(Resource.ResourceName,'_')  WHERE ConvertParameterToTable.parameter_Value NOT IN((SELECT  TOP 1 * 
			FROM 
			dbo.ConvertParameterToTable(Resource.ResourceName,'_') )  ) 
			)  AS productName
		,
			(SELECT  TOP 1 * 
			FROM 
			dbo.ConvertParameterToTable(Resource.ResourceName,'_')  WHERE ConvertParameterToTable.parameter_Value NOT IN((SELECT  TOP 2 * 
			FROM 
			dbo.ConvertParameterToTable(Resource.ResourceName,'_') )  ) 
			)  AS ModelsPN,
		Resource.ResourceId
		INTO #Model_product_modelsPn
		FROM dbo.Resource WHERE 
		Resource.ResourceDescription LIKE '%腔号%'


		 		--获取所有模具
		Select  Resource.ResourceId,Models.ModelsPN 
		INTO  #Tp_models
		from dbo.Resource
		INNER JOIN dbo.Models ON dbo.Models.ModelsId=dbo.Resource.EquipmentRelationId

        declare @EquipmentId CHAR(12) --设备ID
		declare @EquipmentNumber NVARCHAR(50)--设备编码
		declare @ResourceId CHAR(12)--当前资源ID
		declare @BeforeResourceId CHAR(12)--前资源ID
		DECLARE @PKAttributeID VARCHAR(12);--资源主键ID
		DECLARE @UserId  CHAR(12)='SUR100000001'
		declare @ModelId CHAR(12)
		declare @ModelsPN CHAR(12)

        DECLARE  Mycursor CURSOR FOR
        select  ResourceId,modelName from #Model_product_modelsPn 
        OPEN Mycursor
        FETCH NEXT FROM Mycursor INTO @BeforeResourceId,@ModelsPN
        WHILE @@FETCH_STATUS=0
        BEGIN
	
			--插入模具与穴号依赖关系
			Select @ResourceId=ResourceId from dbo.#Tp_models  WHERE #Tp_models.ModelsPN=@ModelsPN
			--Select @BeforeResourceId=ResourceId from dbo.#Tp_models  WHERE #Tp_models.ModelsPN=@ModelsPN

			DECLARE @PKID VARCHAR(12);
			EXEC dbo.SysGetPublicPKIdNew @PKID = @PKID OUTPUT -- varchar(12)
					IF NOT EXISTS(select 1 from ResourceDependence where  ResourceId=@ResourceId and BeforeResourceId=@BeforeResourceId)
					AND (@ResourceId IS NOT NULL AND @ResourceId !='')
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
							1,         -- DependenceCapacity - int
							@UserId,        -- ModifierID - char(12)
							@UserId,        -- CreatorID - char(12)
							GETDATE(), -- Createdate - datetime
							N'PCS',       -- CapacityUnit - nvarchar(10)
							0         -- DependenceProperty - char(1)
							)
							END
			FETCH NEXT FROM Mycursor INTO @BeforeResourceId,@ModelsPN

			end
        CLOSE Mycursor
        DEALLOCATE Mycursor


		--删除临时表
		TRUNCATE TABLE #Tp_models
		DROP TABLE #Tp_models
		TRUNCATE TABLE #Model_product_modelsPn
		DROP TABLE #Model_product_modelsPn
     
END







