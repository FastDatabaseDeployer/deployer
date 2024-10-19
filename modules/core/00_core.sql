/*
 * This file is part of the "FastDatabaseDeployer" project.
 *
 * (c) Nazir Khusnutdinov <nazir@nazir.pro>
 *
 * Core script
 */

SET SESSION ROLE role_owner;

/*
 * Sets the environment variable
 */
\set ON_ERROR_STOP on

/*
 * Connecting to the created database
 */
-- \c tmpldb

/*
 * Create roles
 */
\i 20_Role.sql

/*
 * Create schemes
 */
\i 40_Schemas.sql

/*
 * Create extensions
 */
\i 50_Extensions.sql

/*
 * Create domains
 */
\i 60_Domains.sql

/*
 * Creation of sequences
 */
\i 70_Sequences.sql

/*
 * Creating functions
 */
\i 80_Functions.sql

/*
 * Create users
 */
\i 90_User.sql

/*
 * Security
 */
\i 91_Security.sql

/*
 * Tables
 */
\i migration_versions.sql

/*
 * Constraints
 */
\i migration_versions.CONSTRAINTS.sql

/*
 * Indexes
 */


/*
 * Functions
 */
-- \i migration_versions.FUNCTIONS.sql


/*
 * Triggers
 */


/*
 * Views
 */
\i uptime.VIEW.sql;

/*
 * Security
 */
\i migration_versions.SEC.sql

/*
 * Filling data
 */
\i migration_versions.DATA.sql


RESET ROLE;
