SELECT
	am.asset_number,
	am.serial_numer_uid,
	am.bar_code,
	
	mm.name AS manufacturer,
	am.model_uid,
	
	
	icat.category_name,
	v.customer_name AS supplier_name,
	
	am.assign_touid,
	mainloc.title AS userLocation,
	
	IF(loc.locationunit_name != '',loc.locationunit_name,mainloc.title) physical_location,
	IF(am.location_uid != '',(SELECT locationunit_name FROM location_unit lu7 WHERE lu7.uid = 
(SELECT 
IF(lu.uid=lu.parent_locationunit,lu.uid,
(SELECT IF(lu2.uid=lu2.parent_locationunit,lu2.uid, (SELECT IF(lu3.uid=lu3.parent_locationunit,lu3.uid, (SELECT IF(lu4.uid=lu4.parent_locationunit,lu4.uid, (SELECT IF(lu5.uid=lu5.parent_locationunit,lu5.uid, (SELECT IF(lu6.uid=lu6.parent_locationunit,lu6.uid, 'hjhjhj' ) FROM location_unit lu6 WHERE lu6.uid = lu5.parent_locationunit) ) FROM location_unit lu5 WHERE lu5.uid = lu4.parent_locationunit) ) FROM location_unit lu4 WHERE lu4.uid = lu3.parent_locationunit) ) FROM location_unit lu3 WHERE lu3.uid = lu2.parent_locationunit)) FROM location_unit lu2 WHERE lu2.uid = lu.parent_locationunit)
) parent_location
FROM location_unit lu WHERE lu.uid = am.location_uid LIMIT 1)),mainloc.title) location,
	CONCAT(
        user.user_first_name,
        ' ',
        user.user_last_name
    ) AS user_name,
	ao.name,
	am.invoce_number,
	am.invoce_date,
	am.warranty_date_start,
	am.warranty_date_end,
	am.warranty_period,
	
	
	am.created_date,
	br.brand_name,
    item.item_name,
    ast.name AS asset_status
FROM
	asset_main am
LEFT JOIN user ON user.uid = am.user_uid
LEFT JOIN asset_owner AS ao ON ao.uid = am.asset_owner_uid
LEFT JOIN brand AS br ON br.uid = am.brand_uid
LEFT JOIN location_unit AS loc ON am.location_uid = loc.uid
LEFT JOIN item_category AS icat ON am.category_uid = icat.uid
LEFT JOIN link_user2address AS lua ON lua.useruid = am.user_uid
LEFT JOIN location AS mainloc ON lua.addressuid = mainloc.uid
LEFT JOIN manufacturer_master mm ON mm.uid = am.manufacturer_uid
LEFT JOIN vendor v ON v.uid = am.supplier_uid
LEFT JOIN item as item ON item.uid = am.item_uid
LEFT JOIN asset_status as ast on ast.uid = am.asset_statusuid
WHERE ast.uid NOT IN ('70903ffb588b4724a3fd1b6discard843fa25329a47730dd6a69798d1013befefc9f')
AND am.is_deleted = 0