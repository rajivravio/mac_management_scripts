use jamfsoftware;
SELECT a.computer_name          AS 'Computer Name',
       c.logged_in_user         AS 'User',
       b.application_name       AS 'Application Name',
       b.application_version    AS 'Version',
       b.minutes_open 			AS 'Minutes Open',
       d.value_on_client 		AS 'URL Loading',
       FROM_UNIXTIME(`usage_date_epoch` / 1000, "%m/%d/%Y  %h:%i") as 'Usage Date Epoch'
From computers_denormalized a
       INNER JOIN computers c ON a.computer_id = c.computer_id
       INNER JOIN application_usage_logs b ON a.computer_id = b.computer_id
       INNER JOIN installed_printers i on a.computer_id = i.computer_id
       INNER JOIN extension_attribute_values d on a.last_report_id = d.report_id
WHERE b.application_name LIKE "Mail%"
  AND b.usage_date_epoch / 1000 > UNIX_TIMESTAMP(date_sub(NOW(), INTERVAL 30 day))
  AND minutes_open > 200
  AND i.printer_name LIKE "%PawPrint%"
  AND d.extension_attribute_id = 16
GROUP BY a.computer_name
ORDER BY a.computer_name;