--���²�Ʒ��ɫ��ƫ����
IF NOT EXISTS (select name from syscolumns where id=object_id(N'Product') AND NAME='productColorOffset')
BEGIN
ALTER TABLE Product  ADD  productColorOffset CHAR(12) 
END

--��