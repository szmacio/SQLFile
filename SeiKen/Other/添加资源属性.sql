GO
--添加未更新资源属性记录
Select Resource.ResourceId 
INTO #unAttributeResource
FROM  dbo.Resource
LEFT JOIN dbo.ResourceAttribute ON ResourceAttribute.ResourceID=Resource.ResourceId
WHERE (Resource.ResourceDescription  like'%注塑机%' 
OR Resource.ResourceDescription  like'%腔号%' 
OR Resource.ResourceDescription  like'%燥供料系统%'
OR Resource.ResourceDescription  like'%模温机%'
)    AND ResourceAttribute.ResourceAttributeID IS NULL


--	Select * from #unAttributeResource
--开始循环添加资源属性
declare @ResourceId CHAR(12)--当前资源ID
DECLARE @UserId  CHAR(12)='SUR100000001'
DECLARE  Mycursor CURSOR FOR
select  ResourceId from #unAttributeResource
OPEN Mycursor
FETCH NEXT FROM Mycursor INTO @ResourceId
WHILE @@FETCH_STATUS=0
BEGIN

		DECLARE @PKAttributeID VARCHAR(12);--资源主键ID
		EXEC dbo.SysGetPublicPKIdNew @PKID = @PKAttributeID OUTPUT -- varchar(12) 
		INSERT INTO dbo.ResourceAttribute
		(
			ResourceAttributeID,
			ResourceID,
			CreatotID,
			CreateTime
		)
		VALUES
		(   @PKAttributeID,       -- ResourceAttributeID - char(12)
			@ResourceId,       -- ResourceID - char(12)
			@UserId,       -- CreatotID - char(12)
			GETDATE() -- CreateTime - datetime
			)

		FETCH NEXT FROM Mycursor INTO @ResourceId
END
CLOSE Mycursor
DEALLOCATE Mycursor


TRUNCATE TABLE #unAttributeResource
DROP TABLE #unAttributeResource





