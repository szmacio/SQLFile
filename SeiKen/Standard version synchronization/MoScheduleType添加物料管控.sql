 


IF NOT EXISTS (select name from syscolumns where id=object_id(N'MoScheduleType') AND NAME='IsMaterialSupervision')
 BEGIN
  ALTER TABLE MoScheduleType  ADD  IsMaterialSupervision bit DEFAULT 1
 END
 IF NOT EXISTS (select name from syscolumns where id=object_id(N'MoScheduleType') AND NAME='MaterialSupervisionDays')
 BEGIN
  ALTER TABLE MoScheduleType  ADD  MaterialSupervisionDays INT DEFAULT 365
 END

 UPDATE MoScheduleType SET IsMaterialSupervision=1 ,MaterialSupervisionDays=365