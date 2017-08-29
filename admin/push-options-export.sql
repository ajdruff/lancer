-- note that the outfile cannot be a variable or a syntax error will result
select * from `wp_options`
-- where `option_name` LIKE 'gblu%'
into outfile "import-temp\\wp_options.csv"
FIELDS TERMINATED BY '|' 
-- OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

