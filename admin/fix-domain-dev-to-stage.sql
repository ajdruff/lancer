
-- ##############################################################################################
-- ##############################################################################################
-- ###################################################
-- #########  Convert Dev To Stage
-- ###########################################
-- #########  Usage:
--  This file is to be used in conjunction with config-sql.sql and fix-domain.sql
-- Run them in this order:
--  config-sql.sql  -- these set common sql variables
--  convert-dev-to-stage.sql -- this file
--  fix-domain.sql -- the core of the query 
-- Example:cat ${DIR_PARENT%%/}/temp/wp_stage.sql ${DIR%%/}/config-sql.sql ${DIR%%/}/convert-dev-to-stage.sql ${DIR%%/}/fix-domain.sql
-- ##############################################################################################
-- ##############################################################################################

SET @DOMAIN_SEARCH=@DOMAIN_DEV;
SET @DOMAIN_REPLACE=@DOMAIN_STAGE;
SET @ROOT_PATH_SEARCH=@ROOT_PATH_DEV;
SET @ROOT_PATH_REPLACE=@ROOT_PATH_STAGE;

