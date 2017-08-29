delete  from `wp_options`;
-- where  `option_name` like 'gblu%';

LOAD DATA LOCAL INFILE "C:\\wamp\\bin\\mysql\\mysql5.5.24\\data\\import-temp\\wp_options.csv"  INTO TABLE `wp_options`
FIELDS TERMINATED BY '|' 
LINES TERMINATED BY '\r\n';