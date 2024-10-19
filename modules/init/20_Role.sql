/*
 * This file is part of the "FastDatabaseDeployer" project.
 *
 * (c) Nazir Khusnutdinov <nazir@nazir.pro>
 *
 * Group roles
 */

SET CLIENT_ENCODING TO 'UTF8';

/*
 * Group role "role_dev"
 * Inherits: "role_owner", "role_superadmin", "role_api"
 * Developer
 */
DO $BODY$
BEGIN
   -- DROP ROLE IF EXISTS role_dev;
   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'role_dev') THEN
      CREATE ROLE role_dev;
   END IF;
END $BODY$;
ALTER ROLE role_dev RESET ALL;
ALTER ROLE role_dev NOLOGIN SUPERUSER CREATEDB CREATEROLE REPLICATION;
ALTER ROLE role_dev CONNECTION LIMIT 3;
COMMENT ON ROLE role_dev IS 'Developer';


SET SESSION ROLE role_dev;

/*
 * Group role "role_owner"
 * Inherits: "role_superadmin"
 * Owner
 */
DO $BODY$
BEGIN
   -- DROP ROLE IF EXISTS role_owner;
   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'role_owner') THEN
      CREATE ROLE role_owner;
   END IF;
END $BODY$;
ALTER ROLE role_owner RESET ALL;
ALTER ROLE role_owner NOLOGIN CREATEDB;
ALTER ROLE role_owner CONNECTION LIMIT 5;
COMMENT ON ROLE role_owner IS 'Owner';

/*
 * Group role "role_replication"
 * Inherits: NONE
 * Replication
 */
DO $BODY$
BEGIN
   -- DROP ROLE IF EXISTS role_replication;
   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'role_replication') THEN
      CREATE ROLE role_replication;
   END IF;
END $BODY$;
ALTER ROLE role_replication RESET ALL;
ALTER ROLE role_replication NOLOGIN REPLICATION;
ALTER ROLE role_replication CONNECTION LIMIT 2;
COMMENT ON ROLE role_replication IS 'Replication';

/*
 * Group role "role_api"
 * Inherits: "role_read"
 * API
 */
DO $BODY$
BEGIN
   -- DROP ROLE IF EXISTS role_api;
   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'role_api') THEN
      CREATE ROLE role_api;
   END IF;
END $BODY$;
ALTER ROLE role_api NOLOGIN;
ALTER ROLE role_api CONNECTION LIMIT 1000000;
COMMENT ON ROLE role_api IS 'API';

/*
 * Security group roles
 */
GRANT role_owner TO role_dev;
GRANT role_replication TO role_dev;
GRANT role_api TO role_dev;

RESET ROLE;
