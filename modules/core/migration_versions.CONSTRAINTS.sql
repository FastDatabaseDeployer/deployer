/*
 * This file is part of the "FastDatabaseDeployer" project.
 *
 * (c) Nazir Khusnutdinov <nazir@nazir.pro>
 *
 * Constraints for table "core.migration_versions"
 */

SET CLIENT_ENCODING TO 'UTF8';

SET SESSION ROLE role_owner;

/*
 * Primary key for table "core.migration_versions"
 */
-- -- ALTER TABLE IF EXISTS core.migration_versions DROP CONSTRAINT IF EXISTS pk_migration_versions;
-- ALTER TABLE IF EXISTS core.migration_versions ADD CONSTRAINT pk_migration_versions PRIMARY KEY (id);
SELECT core.fc_add_constraint('core', 'migration_versions');

/*
 * Unique for table "core.migration_versions"
 */
-- -- ALTER TABLE IF EXISTS core.migration_versions DROP CONSTRAINT IF EXISTS unq_migration_versions;
-- ALTER TABLE IF EXISTS core.migration_versions ADD CONSTRAINT unq_migration_versions UNIQUE (version);
SELECT core.fc_add_constraint('core', 'migration_versions', '', 'UNIQUE', 'version');

RESET ROLE;
