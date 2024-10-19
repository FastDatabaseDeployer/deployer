/*
 * This file is part of the "FastDatabaseDeployer" project.
 *
 * (c) Nazir Khusnutdinov <nazir@nazir.pro>
 *
 * Init script
 */

/*
 * Sets the environment variable
 */
\set ON_ERROR_STOP on

/*
 * Create roles
 */
\i 20_Role.sql
