/*
 * This file is part of the "FastDatabaseDeployer" project.
 *
 * (c) Nazir Khusnutdinov <nazir@nazir.pro>
 *
 * Filling data for table "core.migration_versions"
 */

SET CLIENT_ENCODING TO 'UTF8';

SET SESSION ROLE role_owner;

BEGIN;
  -- TRUNCATE TABLE core.migration_versions;
  -- DELETE FROM core.migration_versions;

  INSERT INTO core.migration_versions (id, version) VALUES
    (0, 0)
    ON CONFLICT DO NOTHING
;

COMMIT;

RESET ROLE;
