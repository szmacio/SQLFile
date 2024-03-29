USE [OrBitMOMJY]
GO
/****** Object:  StoredProcedure [dbo].[DAPS_InitialEquipMentAdditionalResource]    Script Date: 2019/10/17 14:57:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 ------------------------------------------------
 /*
  作者：Tom_Ma
  日期：2019/09/26
  作用：初始化--高光机与机台依赖关系导入
 */
 -------------------------------------------------
ALTER PROCEDURE  [dbo].[DAPS_InitialEquipMentAdditionalResource] 
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

	--	获取所有机台关联的辅助设备 如高光机等
        SELECT
        Resource.ResourceId,
        (SELECT ResourceId FROM [dbo].[Resource]
        WHERE Resource.EquipmentRelationId=Equipmentattach.AttachEqId)  as EquipmentattachResourceId
        INTO #Equipment_Equipmentattach
        from Equipment 
        INNER JOIN Equipmentattach on Equipment.EquipmentId=Equipmentattach.EquipmentId
        INNER JOIN Resource on Resource.EquipmentRelationId=Equipment.EquipmentId
        where isActive=1 and Equipment.EquipmentName='注塑机'
        ORDER BY Equipment.EquipmentId


		--给所有机台添加辅助设备关系
		declare @ResourceId CHAR(12)--当前资源ID
		declare @ResourceDependenceID CHAR(12)--当前资源ID
		declare @BeforeResourceId CHAR(12)--前资源ID
		DECLARE @UserId  CHAR(12)='SUR100000001'
        DECLARE  Mycursor CURSOR FOR
        select  ResourceId,EquipmentattachResourceId from #Equipment_Equipmentattach
        OPEN Mycursor
        FETCH NEXT FROM Mycursor INTO @ResourceId,@BeforeResourceId
        WHILE @@FETCH_STATUS=0
        BEGIN
		EXEC dbo.SysGetPublicPKIdNew @PKID = @ResourceDependenceID OUTPUT -- varchar(12) 

			--给所有机台添加辅助设备关系
				IF NOT EXISTS
				(
				Select 1 from dbo.ResourceDependence
				WHERE ResourceDependence.ResourceId=@ResourceId AND ResourceDependence.BeforeResourceId=@BeforeResourceId
				)
				BEGIN

                    INSERT INTO dbo.ResourceDependence
                    (
                    ResourceDependenceID,
                    ResourceID,
                    BeforeResourceID,
                    DependenceCapacity,
                    ModifierID,
                    CreatorID,
                    Createdate
                    )
                    VALUES
                    (  
					@ResourceDependenceID,        -- ResourceDependenceID - char(12)
                    @ResourceId,        -- ResourceID - char(12)
                    @BeforeResourceId,        -- BeforeResourceID - char(12)
                    0,         -- DependenceCapacity - int
                    @UserId,        -- ModifierID - char(12)
                    @UserId,        -- CreatorID - char(12)
                    GETDATE() -- Createdate - datetime
                
                    )
				END

                FETCH NEXT FROM Mycursor INTO @ResourceId,@BeforeResourceId
        END
        CLOSE Mycursor
        DEALLOCATE Mycursor
		
			TRUNCATE TABLE #Equipment_Equipmentattach
			DROP TABLE #Equipment_Equipmentattach

     
END

