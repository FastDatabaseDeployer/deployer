/*
 * This file is part of the "FastDatabaseDeployer" project.
 *
 * (c) Nazir Khusnutdinov <nazir@nazir.pro>
 *
 * Schemas
 */

SET CLIENT_ENCODING TO 'UTF8';

SET SESSION ROLE role_owner;

CREATE SCHEMA IF NOT EXISTS core AUTHORIZATION role_owner;
COMMENT ON SCHEMA core IS 'Core';

CREATE SCHEMA IF NOT EXISTS data AUTHORIZATION role_owner;
COMMENT ON SCHEMA data IS 'Data';

/*
 * Security
 */

/*
 * Grants in schema core to role_dev
 */
-- REVOKE USAGE ON SCHEMA PUBLIC FROM role_dev; 
GRANT ALL ON SCHEMA core TO role_dev; 
-- REVOKE ALL ON ALL SEQUENCES IN SCHEMA PUBLIC FROM role_dev;
GRANT ALL ON ALL SEQUENCES IN SCHEMA core TO role_dev;
-- REVOKE ALL ON ALL TABLES IN SCHEMA PUBLIC FROM role_dev;
GRANT ALL ON ALL TABLES IN SCHEMA core TO role_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA core GRANT USAGE, SELECT ON SEQUENCES TO role_dev;

/*
 * Grants in schema core to PUBLIC
 */
REVOKE ALL ON SCHEMA core FROM PUBLIC;
-- GRANT USAGE ON SCHEMA core TO PUBLIC;

/*
 * Grants in schema public to role_guest
 */
REVOKE ALL ON SCHEMA core FROM role_guest;
GRANT USAGE ON SCHEMA core TO role_guest;
-- GRANT SELECT ON ALL SEQUENCES IN SCHEMA core TO role_guest;
-- GRANT SELECT ON ALL TABLES IN SCHEMA core TO role_guest;
ALTER DEFAULT PRIVILEGES IN SCHEMA core GRANT USAGE, SELECT ON SEQUENCES TO role_guest;

/*
 * Grants in schema core to role_owner
 */
REVOKE ALL ON SCHEMA core FROM role_owner;
GRANT ALL ON SCHEMA core TO role_owner; 
GRANT ALL ON ALL TABLES IN SCHEMA core TO role_owner;
GRANT ALL ON ALL SEQUENCES IN SCHEMA core TO role_owner;
ALTER DEFAULT PRIVILEGES IN SCHEMA core GRANT USAGE, SELECT ON SEQUENCES TO role_owner;

/*
 * Grants in schema data to role_owner
 */
REVOKE ALL ON SCHEMA data FROM role_owner;
GRANT ALL ON SCHEMA data TO role_owner; 
GRANT ALL ON ALL TABLES IN SCHEMA data TO role_owner;
GRANT ALL ON ALL SEQUENCES IN SCHEMA data TO role_owner;
ALTER DEFAULT PRIVILEGES IN SCHEMA data GRANT USAGE, SELECT ON SEQUENCES TO role_owner;

RESET ROLE;
