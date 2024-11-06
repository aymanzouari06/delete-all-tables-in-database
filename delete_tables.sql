DECLARE @table_name NVARCHAR(128);
DECLARE @sql NVARCHAR(MAX);

DECLARE table_cursor CURSOR FOR
SELECT distinct concat(columns.TABLE_SCHEMA,'.',tables.TABLE_NAME)
FROM information_schema.columns  columns inner join information_schema.tables tables on  columns.TABLE_SCHEMA=tables.TABLE_SCHEMA 
where tables.table_name NOT LIKE '%revision%' and tables.TABLE_TYPE='BASE TABLE' and tables.table_name NOT LIKE '%OLE%'
and tables.table_name NOT LIKE '%-%'

OPEN table_cursor;

FETCH NEXT FROM table_cursor INTO @table_name;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = N'TRUNCATE TABLE ' + @table_name;
  EXEC (@sql);
  FETCH NEXT FROM table_cursor INTO @table_name;
END;

CLOSE table_cursor;
DEALLOCATE table_cursor;
