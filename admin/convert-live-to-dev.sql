-- ##############################################################################################
-- ##############################################################################################
-- ###################################################
-- #########  Convert Live To Dev
-- ######### Converts Data from a Live Database to Dev 
-- #########  Usage:
--  This file is to be used in conjunction with config-sql.sql and convert-database-to-new-domain.sql
-- Run them in this order:
--  config-sql.sql  -- these set common sql variables
--  convert-live-to-dev.sql -- this file
--  convert-database-to-new-domain.sql -- the core of the query 
-- Example:cat ${DIR_PARENT%%/}/temp/wp_stage.sql ${DIR%%/}/config-sql.sql ${DIR%%/}/convert-live-to-dev.sql ${DIR%%/}/convert-database-to-new-domain.sql
-- ##############################################################################################
-- ##############################################################################################

SET @DOMAIN_SEARCH=@DOMAIN_LIVE;
SET @DOMAIN_REPLACE=@DOMAIN_DEV;
SET @ROOT_PATH_SEARCH=@ROOT_PATH_LIVE;
SET @ROOT_PATH_REPLACE=@ROOT_PATH_DEV;