SELECT 
  prd.created_date, 
  pr.reference_number, 
  pr.purchase_receipt_date, 
  pr.purchase_number, 
  pr.purchase_date, 
  CONCAT(
    ur.user_first_name, ' ', ur.user_last_name
  ) as created_by, 
  item.item_name, 
  vendor.customer_name AS vender_name, 
  warehouse.title as warehouse, 
  prd.quantity_ordered, 
  prd.quantity_pending, 
  prd.quantity_total 
from 
  purchase_receipt_details AS prd 
  LEFT JOIN purchase_receipt as pr ON pr.uid = prd.purchase_receipt_uid 
  LEFT JOIN user as ur ON ur.uid = prd.created_by 
  LEFT JOIN item as item ON item.uid = prd.item_id 
  LEFT JOIN vendor as vendor ON vendor.uid = pr.vendor_id 
  LEFT JOIN warehouse as warehouse ON warehouse.uid = pr.warehouse_id
