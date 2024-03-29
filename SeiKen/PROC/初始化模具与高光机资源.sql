USE [OrBitMOMJY]
GO
/****** Object:  StoredProcedure [dbo].[DAPS_InitialModelsAdditionalResource]    Script Date: 2019/10/17 14:58:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ------------------------------------------------
 /*
  作者：Tom_Ma
  日期：2019/09/23
  作用：初始化模具与高光机资源
 */
 -------------------------------------------------
ALTER PROCEDURE  [dbo].[DAPS_InitialModelsAdditionalResource] 
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

	--	获取高光机
		SELECT
		ROW_NUMBER() OVER(ORDER BY Resource.ResourceId) AS RowId,
		Resource.ResourceId,
		Resource.ResourceName,
		Resource.ResourceDescription
		INTO #gaoguang
		FROM dbo.Resource
		WHERE Resource.ResourceDescription LIKE '%模温机%' 
		AND Resource.IsActivity=0

		--获取所有模具
		Select ResourceId 
		INTO #models
		from dbo.Resource
		INNER JOIN dbo.Models ON dbo.Models.ModelsId=dbo.Resource.EquipmentRelationId


		--给所有模具添加高光机的依赖关系
		declare @ResourceId CHAR(12)--当前资源ID
		declare @BeforeResourceId CHAR(12)--前资源ID
		DECLARE @GaoGuangCount INT --高光机数量
		DECLARE @PKAttributeID VARCHAR(12); 
		DECLARE @UserId  CHAR(12)='SUR100000001'
		SELECT @GaoGuangCount=COUNT(*) FROM #gaoguang
        DECLARE  Mycursor CURSOR FOR
        select  ResourceId from #models 
        OPEN Mycursor
        FETCH NEXT FROM Mycursor INTO @ResourceId
        WHILE @@FETCH_STATUS=0
        BEGIN
		EXEC dbo.SysGetPublicPKIdNew @PKID = @PKAttributeID OUTPUT -- varchar(12) 

		--如果模具没有属性添加默认属性
		IF NOT EXISTS(	SELECT 1 FROM dbo.Resource
				INNER JOIN dbo.Models ON dbo.Models.ModelsId=dbo.Resource.EquipmentRelationId
				INNER JOIN dbo.ResourceAttribute ON ResourceAttribute.ResourceID=Resource.ResourceId
				WHERE Resource.ResourceId=@ResourceId)
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
            
			--插入模具与高光机的依赖关系
				IF NOT EXISTS
				(
				SELECT 1 FROM dbo.Resource
				INNER JOIN dbo.Models ON dbo.Models.ModelsId=dbo.Resource.EquipmentRelationId
				INNER JOIN dbo.ResourceDependence ON ResourceDependence.ResourceID=Resource.ResourceId
				WHERE Resource.ResourceId=@ResourceId
				)
				BEGIN

					DECLARE @GaoguangResourceId  CHAR(12)
					DECLARE @PKID VARCHAR(12);             
					declare @i int
					set @i=1
					while @i<@GaoGuangCount+1
					BEGIN
					Select @GaoguangResourceId=ResourceId from #gaoguang WHERE  #gaoguang.RowId=@i
					EXEC dbo.SysGetPublicPKIdNew @PKID = @PKID OUTPUT -- varchar(12)  
						insert into ResourceDependence
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
								@GaoguangResourceId,        -- BeforeResourceID - char(12)
								0,         -- DependenceCapacity - int
								@UserId,        -- ModifierID - char(12)
								@UserId,        -- CreatorID - char(12)
								GETDATE(), -- Createdate - datetime
								N'PCS',       -- CapacityUnit - nvarchar(10)
								0         -- DependenceProperty - char(1)
							 )
					set @i=@i+1
					end 
				END

                FETCH NEXT FROM Mycursor INTO @ResourceId
        END
        CLOSE Mycursor
        DEALLOCATE Mycursor
		
			TRUNCATE TABLE #models
			DROP TABLE #models
			TRUNCATE TABLE #gaoguang
			DROP TABLE #gaoguang
     
END







