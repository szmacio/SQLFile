 

-- =============================================
-- Author:		<Author,,Nic>
-- Create date: <Create Date,,>
-- Description:	<获取资源日历信息>
-- =============================================
CREATE PROCEDURE [dbo].[DAPS_GetResourceProductGroup]
    -- Add the parameters for the stored procedure here
    @WorkShopID CHAR(12) = ''
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT ResourceProductGroup.*
    FROM ResourceProductGroup
	INNER JOIN Resource  ON	Resource.ResourceId = ResourceProductGroup.ResourceID
	WHERE Resource.IsUseInSchedule=1
 
END;

