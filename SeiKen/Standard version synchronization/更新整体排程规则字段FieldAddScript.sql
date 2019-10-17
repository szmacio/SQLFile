--更新整体排程规则字段
IF NOT EXISTS (select name from syscolumns where id=object_id(N'ScheduleRegulation') AND NAME='WorkShopID')
BEGIN
ALTER TABLE ScheduleRegulation  ADD  WorkShopID CHAR(12) 
END

--是