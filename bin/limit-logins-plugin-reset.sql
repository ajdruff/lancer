
-- I locked myself out testing this thing, what do I do?
-- ref:https://wordpress.org/plugins/limit-login-attempts/faq/
UPDATE wp_options SET option_value = '' WHERE option_name = 'limit_login_lockouts'

