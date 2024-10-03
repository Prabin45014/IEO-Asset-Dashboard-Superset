SELECT
    t1.asset_number,
    CONCAT(t1.user_first_name, ' ', t1.user_last_name) AS User_name,
    t1.department_name,
    t1.asset_owner,
    t1.category_name,
    CONCAT('Frequency in GHz: ', t1.FrequencyinGHz, ' GHz') AS FrequencyinGHz,
    CONCAT('RAM: ', t1.RAM, ' GB') AS RAM,
    CONCAT('Processor: ', t1.Processor) AS Processor,
    CONCAT('SATA: ', t1.SATA, ' GB') AS SATA,
    CONCAT('Generation: ', t1.Generation) AS Generation,
    CONCAT('SSD: ', t1.SSD, ' GB') AS SSD,
    CONCAT('Mac Address: ', t1.Macaddress) AS Macaddress,
    t2.assign_touid,
    t2.userLocation,
    t2.physical_location,
    t2.location,
    name
FROM
    (
        SELECT
            aast.asset_number,
            user.user_first_name,
            user.user_last_name,
            department.department_name,
            ao.name as asset_owner,
            icat.category_name,
            attribute_uom.name,
            MAX(CASE WHEN akc.uid = '0d071b3bb1b945298e79ae428103ffede7f6faef10258630c9560296271809f3' THEN asd.key_details END) AS FrequencyinGHz,
            MAX(CASE WHEN akc.uid = '3e7a64076e2040d3878b79830bd6c9b46dc48c040c58956cebedf398c71c2a24' THEN asd.key_details END) AS RAM,
            MAX(CASE WHEN akc.uid = '556b4cd85f0b4e66a6ff829da480642c4d791b5bb1337b14f1cd39a18ff059a9' THEN asd.key_details END) AS Processor,
            MAX(CASE WHEN akc.uid = '8b5ccc9e967449cf94417743db5ddd9f14a9f696d63c59ec9846982846b6c2bd' THEN asd.key_details END) AS SATA,
            MAX(CASE WHEN akc.uid = 'd33cb2b45720439788f99fa7f2f493a309d9d0cb893e3301e9d3a8441b5c91b3' THEN asd.key_details END) AS Generation,
            MAX(CASE WHEN akc.uid = 'c178f23f782e42e28bdf9e1e9ee89854bbfdbbddd8bb1bb994cd46cc23b5fa83' THEN asd.key_details END) AS SSD,
            MAX(CASE WHEN akc.uid = '669d2d4257944934ac54c8b27eccc6716d6ccebfb580e8f26a9bf1fda8316a2d' THEN asd.key_details END) AS Macaddress
        FROM
            asset_attributes_details AS asd
        LEFT JOIN
            asset_key_category AS akc ON akc.uid = asd.keyitem_uid
        LEFT JOIN
            attribute_uom AS au ON au.uid = asd.attributeuom_uid
        INNER JOIN
            asset_main AS aast ON aast.uid = asd.asset_main_uid
        LEFT JOIN
            user ON user.uid = aast.user_uid 
        LEFT JOIN
            link_user_department ON link_user_department.useruid = aast.user_uid
        LEFT JOIN
            department ON department.uid = link_user_department.departmentuid 
        LEFT JOIN
            asset_owner AS ao ON ao.uid = aast.asset_owner_uid
        LEFT JOIN
            item_category AS icat ON aast.category_uid = icat.uid
        LEFT JOIN attribute_uom ON attribute_uom.uid = asd.attributeuom_uid
        GROUP BY
            aast.asset_number
    ) AS t1
LEFT JOIN 
    (
        SELECT
            am.asset_number,
            am.assign_touid,
            mainloc.title AS userLocation,
            IF(loc.locationunit_name != '',loc.locationunit_name,mainloc.title) AS physical_location,
            IF(am.location_uid != '',(SELECT locationunit_name FROM location_unit lu7 WHERE lu7.uid = 
(SELECT 
IF(lu.uid=lu.parent_locationunit,lu.uid,
(SELECT IF(lu2.uid=lu2.parent_locationunit,lu2.uid, (SELECT IF(lu3.uid=lu3.parent_locationunit,lu3.uid, (SELECT IF(lu4.uid=lu4.parent_locationunit,lu4.uid, (SELECT IF(lu5.uid=lu5.parent_locationunit,lu5.uid, (SELECT IF(lu6.uid=lu6.parent_locationunit,lu6.uid, 'hjhjhj' ) FROM location_unit lu6 WHERE lu6.uid = lu5.parent_locationunit) ) FROM location_unit lu5 WHERE lu5.uid = lu4.parent_locationunit) ) FROM location_unit lu4 WHERE lu4.uid = lu3.parent_locationunit) ) FROM location_unit lu3 WHERE lu3.uid = lu2.parent_locationunit)) FROM location_unit lu2 WHERE lu2.uid = lu.parent_locationunit)
) parent_location
FROM location_unit lu WHERE lu.uid = am.location_uid LIMIT 1)),mainloc.title) AS location,
            CONCAT(user.user_first_name, ' ', user.user_last_name) AS user_name
        FROM
            asset_main am
        LEFT JOIN
            user ON user.uid = am.user_uid
        LEFT JOIN
            location_unit AS loc ON am.location_uid = loc.uid
        LEFT JOIN
            link_user2address AS lua ON lua.useruid = am.user_uid
        LEFT JOIN
            location AS mainloc ON lua.addressuid = mainloc.uid
        WHERE
            am.is_deleted = 0
    ) AS t2
ON 
    t1.asset_number = t2.asset_number
