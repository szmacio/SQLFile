	--ͬ������Resuorce
		DECLARE @ResourceId CHAR(12)
		Select @ResourceId=Resource.ResourceId from dbo.Resource WHERE Resource.EquipmentRelationId=@I_ParentPKId
		DECLARE @BeforeResourceId CHAR(12)
		Select @BeforeResourceId=Resource.ResourceId from dbo.Resource WHERE Resource.EquipmentRelationId=@ModelId
		
		EXEC dbo.DAPS_SyncResourceFromMes                             
						@ModifyType ='I',	--I ���룬U ����
						@ResourceID=@ResourceId, 	
						@DependenceCapacity =@Acycle,
						@BeforeResourceID =@BeforeResourceId,	
						@ModifierID =@I_OrBitUserId,
						@ResourceType ='M'