 

-- =============================================
-- Author:		<Author,,Nic>
-- Create date: <Create Date,,>
-- Description:	<获取用于排程产品信息，根据需要更改，此为工单任务来自ERP>
-- =============================================
ALTER PROCEDURE  [dbo].[DAPS_GetProduct]
	-- Add the parameters for the stored procedure here
	 @WorkShopID CHAR(12)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 SELECT 
	  --TOP 200
	MOId ,
	ProductId,
	CustomerId
	INTO #mo 
	FROM dbo.MO 
	WHERE  
	 (dbo.MO.MOStates ='20'  OR dbo.MO.MOStates ='30')  
 
	CREATE INDEX IX_test ON #mo(MOId,ProductId,CustomerId)
    -- Insert statements for procedure here
	  SELECT DISTINCT product.ProductId,
	    ProductRootId,
	    ProductRevision,
	    ProductDescription ,
		productColor,
		productColorOffset,
	    #mo.CustomerId,
	    CustomerPN
		FROM  
		dbo.Product  
		INNER JOIN #mo ON	#mo.ProductId = Product.ProductId
   
	 TRUNCATE TABLE #mo
	 DROP TABLE #mo

END

