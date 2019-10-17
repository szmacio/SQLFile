--更新产品颜色的偏移量
IF NOT EXISTS (select name from syscolumns where id=object_id(N'Product') AND NAME='productColorOffset')
BEGIN
ALTER TABLE Product  ADD  productColorOffset CHAR(12) 
END

--是