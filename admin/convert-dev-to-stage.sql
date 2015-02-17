
-- ##############################################################################################
-- ##############################################################################################
-- ###################################################
-- #########  Convert Dev To Stage
-- ###########################################
-- #########  Usage:
--  This file is to be used in conjunction with config-sql.sql and convert-database.sql
-- Run them in this order:
--  config-sql.sql  -- these set common sql variables
--  convert-dev-to-stage.sql -- this file
--  convert-database.sql -- the core of the query 
-- Example:cat ${DIR_PARENT%%/}/temp/wp_stage.sql ${DIR%%/}/config-sql.sql ${DIR%%/}/convert-dev-to-stage.sql ${DIR%%/}/convert-database.sql
-- ##############################################################################################
-- ##############################################################################################

SET @DOMAIN_SEARCH=@DOMAIN_DEV;
SET @DOMAIN_REPLACE=@DOMAIN_STAGE;
SET @ROOT_PATH_SEARCH=@ROOT_PATH_DEV;
SET @ROOT_PATH_REPLACE=@ROOT_PATH_STAGE;

