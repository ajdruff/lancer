-- ###########################################
-- #########  Delete all comments
-- ###########################################
-- start config

-- ##### Be sure you are connected to right database! ##############

-- end config
TRUNCATE TABLE wp_comments;




-- ###########################################
-- #########  Delete all Posts 
-- #########  delete all posts, pages, and custom post types for a specific author
-- #########   (includes view query for safety) 
-- ###########################################
-- start config

SET @WPUSERID='1';
-- end config
-- Select * FROM wp_posts a LEFT JOIN wp_term_relationships b ON (a.ID = b.object_id)LEFT JOIN wp_postmeta c ON (a.ID = c.post_id) WHERE a.post_author = @WPUSERID;
Delete a,b,c FROM wp_posts a LEFT JOIN wp_term_relationships b ON (a.ID = b.object_id)LEFT JOIN wp_postmeta c ON (a.ID = c.post_id) WHERE a.post_author = @WPUSERID;

