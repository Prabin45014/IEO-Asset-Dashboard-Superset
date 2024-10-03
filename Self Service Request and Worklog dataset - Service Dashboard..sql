SELECT 
    ssr.reference_number,
    ssr.request_date,
    sswl.request_date_time as requested_time,
    CONCAT(usr.user_first_name, ' ', usr.user_last_name) AS requester_name,
    pm.name as priority_name,
    pc.problem_name,
    ssr.subject,
    ssr.created_date,
    CONCAT(u.user_first_name, ' ', u.user_last_name) AS assigned_to,
    CONCAT(uer.user_first_name, ' ', uer.user_last_name) AS created_by,
    am.asset_number,
    mainloc.title as locationname,
    reg.region_name,
    ss.status_name,
    ssr.request_date as request_date_time,
    CONCAT(sswl.hours, ' Hours ', sswl.minutes, ' Min' ) as hours,
    sswl.problem_identified,
    sswl.solution,
    CONCAT(
        uc.user_first_name,
        ' ',
        uc.user_last_name
    ) AS worklog_created_by,
    CONCAT(
        ur.user_first_name,
        ' ',
        ur.user_last_name
    ) AS next_assign_to,
    CONCAT(
        us.user_first_name,
        ' ',
        us.user_last_name
    ) AS previous_assigned_uid,
    sswl.created_date as worklog_created_date,
    svr.status_name as worklog_status_name
FROM 
    self_service_request ssr
LEFT JOIN user as u ON u.uid = ssr.assigned_to
LEFT JOIN user as uer ON uer.uid = ssr.created_by
LEFT JOIN asset_main as am ON am.uid = ssr.asset_uid
LEFT JOIN priority_master as pm ON pm.uid = ssr.priority_uid
LEFT JOIN problem_category as pc ON pc.uid = ssr.problem_category_uid
LEFT JOIN user as usr ON usr.uid = ssr.requester_uid
LEFT JOIN link_user2address AS lua ON lua.useruid = ssr.requester_uid
LEFT JOIN location AS mainloc ON lua.addressuid = mainloc.uid
LEFT JOIN region AS reg ON mainloc.region_uid = reg.uid
LEFT JOIN service_status as ss ON ss.uid = ssr.status_uid
LEFT JOIN self_service_work_log sswl ON ssr.uid = sswl.self_service_request_uid
LEFT JOIN user AS uc ON uc.uid = sswl.created_by
LEFT JOIN user AS ur ON ur.uid = sswl.next_assign_to
LEFT JOIN user AS us ON us.uid = sswl.previous_assigned_uid
LEFT JOIN service_status AS svr ON svr.uid = sswl.status_uid