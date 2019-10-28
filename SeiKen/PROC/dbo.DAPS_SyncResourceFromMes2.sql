SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
 ------------------------------------------------
 /*
  ���ߣ�Tom_Ma
  ���ڣ�2019/10/8
  ���ã�MESͬ����Դ��CRUD��
 */
 -------------------------------------------------
ALTER PROCEDURE  [dbo].[DAPS_SyncResourceFromMes] 
@I_ReturnMessage nvarchar(max)='' output,  --���ص���Ϣ,֧�ֶ�����
--���ϱ���Ϊϵͳ����̶��ӿڲ�����������ÿһ��DoEvent������ʵ��.
@ModifyType char(1)='',	--I ���룬U ����
@ResourceID char(12)='',	
@DependenceCapacity INT,
@BeforeResourceID char(12)='',	
@ModifierID char(12)='',
@ResourceType char(1)='' --M ģ��,--A �߹�� --O���� --C--ǻ�ţ�
-------------------------------------------------------------------------

-----------------------------------------------------------------------------
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	declare @ResourceDependenceId char(12)
	--��ӻ�̨��ģ�ߵ������ӿ�
	IF(@ResourceType='M')

	BEGIN
	--��̨��ģ�߹�ϵ����
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
					--�޸Ļ�̨��ģ�߹�ϵ
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
				SET @I_ReturnMessage=' cǻ��'
				END
			IF(@ResourceType='A')
					BEGIN
				SET @I_ReturnMessage=' A �߹��'
				END

				IF(@ResourceType='O')
				BEGIN
				SET @I_ReturnMessage=' HONGXIANG'
				END





     
END







GO

