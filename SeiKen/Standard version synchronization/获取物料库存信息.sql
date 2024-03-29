 


-- =============================================
-- Author:		<Author,,Nic>
-- Create date: <Create Date,,>
-- Description:	<Description,获取物料库存信息>
-- =============================================
CREATE PROCEDURE  [dbo].[DAPS_GetMaterialInventoryInformation ]
	-- Add the parameters for the stored procedure here
	 @WorkShopID CHAR(12)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @TEMPDATE DATETIME=GETDATE()

    -- Insert statements for procedure here
	SELECT dbo.WW_RMInventory.ProductId,SUM(Qty) AS Qty ,@TEMPDATE AS MaterialAvailabilityTime
	 FROM dbo.WW_RMInventory
	 INNER JOIN dbo.Product ON	 Product.ProductId = WW_RMInventory.ProductId
	 WHERE dbo.Product.IsQiset=1  AND  WW_RMInventory.LotId NOT IN(SELECT dbo.LotOnResource.LotId FROM dbo.LotOnResource)
	 AND WorkcenterId NOT IN (SELECT WorkcenterId FROM dbo.Workcenter WHERE WorkcenterDescription LIKE '%报废%' AND WorkcenterDescription LIKE '%不良%')
	 GROUP BY dbo.WW_RMInventory.ProductId 
 
	UNION ALL
	SELECT dbo.Product.ProductId,SUM( dbo.LotOnResource.BeginQty) AS Qty ,@TEMPDATE AS MaterialAvailabilityTime
	FROM dbo.LotOnResource
	INNER JOIN  dbo.WW_RMInventory ON WW_RMInventory.LotId = LotOnResource.LotId
	INNER JOIN dbo.Product ON	Product.ProductId = WW_RMInventory.ProductId
	WHERE dbo.Product.IsQiset=1   AND WW_RMInventory.WorkcenterId NOT IN (SELECT WorkcenterId FROM dbo.Workcenter WHERE WorkcenterDescription LIKE '%报废%' AND WorkcenterDescription LIKE '%不良%')
	GROUP BY dbo.Product.ProductId 
	
 
 

END

