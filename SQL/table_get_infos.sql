SELECT 
  columns_name,
  data_type,
  character_maximum_length,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE TABLE_NAME = 'customers';