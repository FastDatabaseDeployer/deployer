/*
 * This file is part of the "FastDatabaseDeployer" project.
 *
 * (c) Nazir Khusnutdinov <nazir@nazir.pro>
 *
 * Security: "core.migration_versions"
 */

SET CLIENT_ENCODING TO 'UTF8';

SET SESSION ROLE role_owner;

/*
 * Table security
 */
ALTER TABLE IF EXISTS core.migration_versions OWNER TO role_owner;
GRANT ALL ON TABLE core.migration_versions TO role_owner;
/*
 * Columns security
 */


RESET ROLE;
