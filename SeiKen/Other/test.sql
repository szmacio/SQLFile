	--获取模具、产品、穴号关系
		SELECT
		( 
			(SELECT  TOP 1 * 
			FROM 
			dbo.ConvertParameterToTable(Resource.ResourceName,'_')   ) 
			)  AS ModelName,
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
		INTO #temp1
		FROM dbo.Resource WHERE 
		Resource.ResourceDescription LIKE '%腔号%' 
		--AW040A_1807AW040000100_1
		SELECT ROW_NUMBER() OVER(ORDER BY #temp1.ModelName) AS rownumber,
		#temp1.ModelName,#temp1.productName ,#temp1.ModelsPN,#temp1.ResourceId
		FROM #temp1 
		WHERE #temp1.productName='1801BA071000100'
		GROUP BY #temp1.ModelName,#temp1.productName,#temp1.ModelsPN,#temp1.ResourceId

			Select #temp1.productName,#temp1.ModelsPN,COUNT(*) AS number from #temp1
			GROUP BY #temp1.productName,#temp1.ModelsPN HAVING COUNT(*)>1
		
	


	Select Resource.ResourceId from #temp1
	INNER JOIN dbo.Models ON dbo.Models.ModelsPN= #temp1.ModelName
	INNER JOIN dbo.Resource ON dbo.Resource.EquipmentRelationId=Models.ModelsId
	WHERE #temp1.productName='1801BA071000100'
	GROUP BY Resource.ResourceId

	Select * from dbo.ProcessCapacity

	BEGIN  --关闭临时表

TRUNCATE TABLE #MainResource
DROP TABLE #MainResource
TRUNCATE TABLE #S0
DROP TABLE #S0
	TRUNCATE TABLE #S1Temp
	DROP TABLE #S1Temp
	TRUNCATE TABLE #S1
	DROP TABLE #S1
TRUNCATE TABLE #Equipment_Model
DROP TABLE #Equipment_Model
--#TempCavitList
TRUNCATE TABLE #TempCavitList
DROP TABLE #TempCavitList

--#TempCavitList
TRUNCATE TABLE #tempOVEN
DROP TABLE #tempOVEN

TRUNCATE TABLE #ProductList
DROP TABLE #ProductList

TRUNCATE TABLE #Model_product_modelsPn
DROP TABLE #Model_product_modelsPn
 
END

	Select * from dbo.ProcessCapacity

	Select * from  dbo.Equipment_Model 


	-- 获取机台与模具之间的关系，多余字段可能以后会用上
		Select Models.ModelsId as ModelId,
		Resource.ResourceId,
		EquipmentNumber,
		Equipment_Model.EquipmentId,
		Models.ModelsPN as Model_Number,Models.Mtonnage,
		Models.ModelProSeries+' ' + Models.ProductNm as ModelProSeries,
		Equipment_Model.Prior,
		Equipment_Model.IsActivity ,
		Acycle,
		OperationPeriod,
		UpperModelOverTimeSet,AdjustOverTimeSet,
		LowerModelOverTimeSet
		FROM Equipment 
		INNER JOIN Equipment_Model ON Equipment_Model.EquipmentId=Equipment.EquipmentId 
		INNER JOIN dbo.Models ON dbo.Models.ModelsId=Equipment_Model.ModelId
		INNER JOIN dbo.Resource ON dbo.Resource.EquipmentRelationId=Equipment.EquipmentId
		WHERE  Equipment.EquipmentName='注塑机'
		ORDER BY Equipment.EquipmentId

		Select * from dbo.Resource WHERE Resource.ResourceId='RES100000108'


		Select Models.ModelsPN from dbo.Models

		Select COUNT(*) ,dbo.ProcessCapacity.InstructionClass FROM dbo.ProcessCapacity

	

		BEGIN --获取模具、产品、穴号关系

		SELECT
		( 
			(SELECT  TOP 1 * 
			FROM 
			dbo.ConvertParameterToTable(Resource.ResourceName,'_')   ) 
			)  AS ModelName,
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
		INTO #Model_product_modelsPn11
		FROM dbo.Resource WHERE 
		Resource.ResourceDescription LIKE '%腔号%' 

END

-

Select #Model_product_modelsPn11.ModelName 
FROM #Model_product_modelsPn11
GROUP BY #Model_product_modelsPn11.ModelName



WHERE #Model_product_modelsPn11.productName='1801BA071000100'

		Select Resource.ResourceId 
					FROM dbo.Models  
					INNER JOIN  dbo.Resource ON dbo.Models.ModelsId=dbo.Resource.EquipmentRelationId WHERE dbo.Models.ModelsPN IN 
					(
					SELECT ModelName from #Model_product_modelsPn11 
					WHERE #Model_product_modelsPn11.productName='1801BA071000100')

					Select * from dbo.Resource WHERE Resource.ResourceId='RES1000001BK'

		SELECT 1 FROM dbo.ProcessCapacity WHERE ProcessCapacity.PResourceID='RES100000108' AND ProcessCapacity.ParentPKId='PRD10002IY7R'

		Select Product.ProductId,ProductRoot.ProductName
FROM dbo.Product
INNER JOIN dbo.ProductRoot ON ProductRoot.ProductRootId=dbo.Product.ProductRootId
WHERE ProductRoot.productName='1802AA006000101E' 
	Select * from dbo.ProcessCapacity WHERE ProcessCapacity.ProcessCapacityName='1801BA071000100成型工艺'
		DELETE dbo.ProcessCapacity WHERE  ProcessCapacity.ProcessCapacityName='1801BA071000100成型工艺'

		Select Equipment_Model.AdjustOverTimeSet,Equipment_Model.Acycle from dbo.Equipment_Model
		GROUP BY Equipment_Model.AdjustOverTimeSet,Equipment_Model.Acycle

		Select * from dbo.Equipment_Model WHERE Equipment_Model.Acycle=26


		Select * from dbo.Product

	--	DELETE dbo.ProcessCapacity WHERE  ProcessCapacity.ProcessCapacityName='1802AA006000101E成型工艺'

		Select * from dbo.ResourceDependence WHERE ResourceDependence.ResourceDependenceID='RES1000001EB'

		EXEC [InstructionCode_ViewListWindow]
        
Select * from dbo.ResourceGroup

Select Product.productColorOffset from dbo.Product

Select * from dbo.SysModifyHistory ORDER BY SysModifyHistory.ModifyDate DESC

Select * from dbo.OvenToEquipment


Select Equipment.EquipmentId,* from dbo.Equipment WHERE Equipment.EquipmentId='EQM1000000ZM'

Select * from dbo.Resource WHERE Resource.EquipmentRelationId='EQM10000012U'

Select * from dbo.ResourceDependence WHERE ResourceDependence.ResourceDependenceID='RES100000126'

Select * from dbo.Resource WHERE Resource.ResourceId='RES10000010V'
		Select 
		Resource.ResourceId,
		OvenToEquipment.OvenId 

		FROM dbo.Equipment 
		INNER JOIN  dbo.OvenToEquipment ON OvenToEquipment.EquipmentId=Equipment.EquipmentId
		INNER JOIN   dbo.Resource ON dbo.Resource.EquipmentRelationId=Equipment.EquipmentId
		WHERE Equipment.EquipmentName='注塑机' AND Equipment.IsAvalid=1


		Select * from dbo.ResourceDependence WHERE ResourceDependence.BeforeResourceID='EQM100000139'


		Select * from  dbo.ResourceMaterialSwitch
		Select * from  dbo.ResourceSwitch

	  Select * from dbo.Resource WHERE Resource.ResourceId='RES1000001E7'

		DELETE FROM ResourceMaterialSwitch



		DECLARE @GaoguangResourceId  CHAR(12);
					DECLARE @PKID VARCHAR(12);             
					declare @i int;
					set @i=1;
					while @i<@GaoGuangCount+1
					BEGIN
			
					
					set @i=@i+1;
					end; 


		SELECT Resource.ResourceId
		FROM dbo.Equipment_Model 
		INNER JOIN dbo.Resource ON dbo.Resource.EquipmentRelationId=Equipment_Model.ModelId
		GROUP BY Resource.ResourceId  

		Select * from dbo.Resource WHERE Resource.ResourceId='RES1000001E7'

		INSERT INTO dbo.ResourceMaterialSwitch
		(
		    ResourceMaterialSwitchID,
		    ResourceID,
		    SwitchElapsedTime,
		    Createdate
		)
		VALUES
		(   '',       -- ResourceMaterialSwitchID - char(12)
		    '',       -- ResourceID - char(12)
		    0,        -- SwitchElapsedTime - int
		    GETDATE() -- Createdate - datetime
		    )


				--DECLARE @GaoguangResourceId  CHAR(12);
				DECLARE @ VARCHAR(12);             
					declare @i int;
					set @i=1;
					while @i<@GaoGuangCount+1
					BEGIN
			
					
					set @i=@i+1;
					end; 


					Select * from equi




		--获取模具、产品、穴号关系
		SELECT
		( 
			(SELECT  TOP 1 * 
			FROM 
			dbo.ConvertParameterToTable(Resource.ResourceName,'_')   ) 
			)  AS ModelName,
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
		INTO #temp1
		FROM dbo.Resource WHERE 
		Resource.ResourceDescription LIKE '%腔号%' 

		Select  #temp1.ModelName,#temp1.productName 
		FROM #temp1
		GROUP BY #temp1.ModelName,#temp1.productName


		Select * from  dbo.Models WHERE dbo.Models.GaoGuangJi=1

		Select * from dbo.Equipment_Model  

		Select * from  dbo.Models WHERE Models.ModelsPN='AW080A'--MODL000002GX
		Select * from  dbo.Equipment WHERE Equipment.EquipmentNumber='10Z002' --EQM10000010E

		Select * from  dbo.UserCode WHERE UserCode.UserCodeId ='URC1000000EU'

		Select Resource.ResourceId 
		FROM  dbo.Equipment  
		INNER JOIN dbo.Resource ON dbo.Resource.EquipmentRelationId=Equipment.EquipmentId 
		WHERE Equipment.EquipmentNumber='10Z061'

		Select * from dbo.Equipment_Model

		Select * from dbo.ResourceDependence 
		WHERE  ResourceDependence.ResourceID=
		(
		Select Resource.ResourceId 
		FROM  dbo.Equipment  
		INNER JOIN dbo.Resource ON dbo.Resource.EquipmentRelationId=Equipment.EquipmentId 
		WHERE Equipment.EquipmentNumber='10Z072'
		)
		AND   ResourceDependence.BeforeResourceID=
		(
		SELECT Resource.ResourceId from  dbo.Models 
		INNER JOIN dbo.Resource ON dbo.Resource.EquipmentRelationId=Models.ModelsId
		WHERE Models.ModelsPN='BF054B'
		)
		ORDER BY ResourceDependence.Createdate DESC


			Select Resource.ResourceId from dbo.Resource 
		WHERE Resource.EquipmentRelationId = (Select Equipment_Model.EquipmentId from dbo.Equipment_Model WHERE Equipment_ModelId = @I_PKId  )

	
		Select Resource.ResourceId from dbo.Resource 
		WHERE Resource.EquipmentRelationId = 'MODL000002UX'

		Select * from dbo.Equipment_Model 
		WHERE Equipment_Model.ModelId='MODL000002JO' 
		AND Equipment_Model.EquipmentId='EQM1000000YW'
		
		
		 
		 Select * from  dbo.Equipment_Model WHERE Equipment_Model.Equipment_ModelId='EQML00000KSJ'

		 Select * from  dbo.Equipmentattach