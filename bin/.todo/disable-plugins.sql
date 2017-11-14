

-- View Active Plugins
select * from wp_options where option_name='active_plugins';

update wp_options
set option_value=''
where option_name='active_plugins';