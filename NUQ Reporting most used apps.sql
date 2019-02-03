use jamfsoftware;
SELECT b.application_name                                          AS 'Application Name',
       b.application_version                                       AS 'Version',
       SUM(b.minutes_open)/60										   AS 'Usage in hours (last 180 days)'
From application_usage_logs b 
WHERE b.usage_date_epoch / 1000 > UNIX_TIMESTAMP(date_sub(NOW(), INTERVAL 180 day))
GROUP BY b.application_name
ORDER BY SUM(b.minutes_open) DESC