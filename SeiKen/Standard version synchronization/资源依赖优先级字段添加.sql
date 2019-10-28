--更新依赖关系优先级属性
IF NOT EXISTS (select name from syscolumns where id=object_id(N'ResourceDependence') AND NAME='DependencePriority')
BEGIN
ALTER TABLE ResourceDependence  ADD  DependencePriority int
END
