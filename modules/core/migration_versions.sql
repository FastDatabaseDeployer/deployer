/*
 * This file is part of the "FastDatabaseDeployer" project.
 *
 * (c) Nazir Khusnutdinov <nazir@nazir.pro>
 *
 * Table: "core.migration_versions"
 * Migration versions
 */

SET CLIENT_ENCODING TO 'UTF8';

SET SESSION ROLE role_owner;

-- DROP TABLE IF EXISTS core.migration_versions;
CREATE TABLE IF NOT EXISTS core.migration_versions (
  id             SERIAL                    -- ID (Identifier)
, version        integer                   -- Version
, filename       core.dm_filename          -- Filename
, executed_at    core.dm_current_timestamp -- Executed at
, execution_time integer                   -- Executed time
) WITHOUT OIDS;

/*
 * Create system columns in table
 */
-- SELECT core.fc_add_system_columns('core', 'migration_versions');

/*
 * Constraints
 */
-- \i migration_versions.CONSTRAINTS.sql

/*
 * Indexes
 */


/*
 * Triggers
 */
-- \i migration_versions.TRIGGERS.sql

/*
 * Comments
 */
COMMENT ON TABLE core.migration_versions IS 'Migration versions';
COMMENT ON COLUMN core.migration_versions.id IS 'ID (Identifier)';
COMMENT ON COLUMN core.migration_versions.version IS 'Version';
COMMENT ON COLUMN core.migration_versions.filename IS 'Filename';
COMMENT ON COLUMN core.migration_versions.executed_at IS 'Executed at';
COMMENT ON COLUMN core.migration_versions.execution_time IS 'Executed time';

/*
 * Security
 */
-- \i migration_versions.SEC.sql

/*
 * Filling data
 */
-- \i migration_versions.DATA.sql

RESET ROLE;
