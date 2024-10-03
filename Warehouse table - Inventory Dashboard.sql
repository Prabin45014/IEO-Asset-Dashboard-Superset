SELECT 
  (item.item_code), 
  (item.item_name), 
  warehouse.title as warehouse, 
  stock_maintain.item_quantity, 
  CONCAT(
    user.user_first_name, ' ', user.user_last_name
  ) as created_by, 
  stock_maintain.created_date 
FROM 
  stock_maintain as stock_maintain 
  LEFT JOIN warehouse as warehouse ON warehouse.uid = stock_maintain.warehouse_id 
  LEFT JOIN user as user ON user.uid = stock_maintain.created_by 
  LEFT JOIN item as item ON item.uid = stock_maintain.item_uid
