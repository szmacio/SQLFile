 --
SELECT ResourceDependence.ResourceDependenceID, ResourceDependence.BeforeResourceID
INTO #ModlesResourceList
FROM dbo.Resource 
INNER JOIN dbo.ResourceDependence ON Resource.ResourceId=ResourceDependence.ResourceID
--	INNER JOIN dbo.Models ON dbo.Models.ModelsId=dbo.Resource.EquipmentRelationId
WHERE dbo.Resource.ResourceDescription LIKE '%×¢ËÜ»ú%'
AND ResourceDependence.BeforeResourceID IS NOT NULL

UPDATE ResourceDependence SET ResourceDependence.DependenceCapacity=25 WHERE ResourceDependence.ResourceDependenceID 
IN ( 	
SELECT #ModlesResourceList.ResourceDependenceID from #ModlesResourceList
INNER JOIN Resource ON Resource.ResourceId=#ModlesResourceList.BeforeResourceID
INNER JOIN dbo.Models ON dbo.Models.ModelsId=Resource.EquipmentRelationId
)