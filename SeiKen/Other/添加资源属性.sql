GO
--���δ������Դ���Լ�¼
Select Resource.ResourceId 
INTO #unAttributeResource
FROM  dbo.Resource
LEFT JOIN dbo.ResourceAttribute ON ResourceAttribute.ResourceID=Resource.ResourceId
WHERE (Resource.ResourceDescription  like'%ע�ܻ�%' 
OR Resource.ResourceDescription  like'%ǻ��%' 
OR Resource.ResourceDescription  like'%�﹩��ϵͳ%'
OR Resource.ResourceDescription  like'%ģ�»�%'
)    AND ResourceAttribute.ResourceAttributeID IS NULL


--	Select * from #unAttributeResource
--��ʼѭ�������Դ����
declare @ResourceId CHAR(12)--��ǰ��ԴID
DECLARE @UserId  CHAR(12)='SUR100000001'
DECLARE  Mycursor CURSOR FOR
select  ResourceId from #unAttributeResource
OPEN Mycursor
FETCH NEXT FROM Mycursor INTO @ResourceId
WHILE @@FETCH_STATUS=0
BEGIN

		DECLARE @PKAttributeID VARCHAR(12);--��Դ����ID
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





