SELECT 
  item.item_code, 
  item.item_name, 
  ic.category_name, 
  itm.name as item_type, 
  mm.name as manufacturer, 
  brand.brand_name, 
  item.model, 
  CONCAT(
    user.user_first_name, ' ', user.user_last_name
  ) as created_by, 
  item.created_date 
FROM 
  item 
  LEFT JOIN item_type_master as itm on itm.uid = item.item_type_uid 
  LEFT JOIN item_category as ic ON ic.uid = item.category_uid 
  LEFT JOIN manufacturer_master as mm ON mm.uid = item.manufacturer 
  LEFT JOIN brand as brand ON brand.uid = item.brand_uid 
  LEFT JOIN user as user ON user.uid = item.created_by
