--����������ϵ���ȼ�����
IF NOT EXISTS (select name from syscolumns where id=object_id(N'ResourceDependence') AND NAME='DependencePriority')
BEGIN
ALTER TABLE ResourceDependence  ADD  DependencePriority int
END
