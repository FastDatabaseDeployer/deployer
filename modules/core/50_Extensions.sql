/*
 * This file is part of the "FastDatabaseDeployer" project.
 *
 * (c) Nazir Khusnutdinov <nazir@nazir.pro>
 *
 * Extensions
 */

SET CLIENT_ENCODING TO 'UTF8';

SET SESSION ROLE role_dev;

/*
 * Extension: "citext"
 * https://www.postgresql.org/docs/current/citext.html
 */
CREATE EXTENSION IF NOT EXISTS citext SCHEMA public CASCADE;

/*
 * Extension: "uuid-ossp"
 * https://www.postgresql.org/docs/current/uuid-ossp.html
 */
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp" SCHEMA core CASCADE;

/*
 * Extension: "pgcrypto"
 * https://www.postgresql.org/docs/current/pgcrypto.html
 */
CREATE EXTENSION IF NOT EXISTS pgcrypto SCHEMA public CASCADE;

/*
 * Extension: "dblink"
 * https://www.postgresql.org/docs/current/dblink.html
 */
CREATE EXTENSION IF NOT EXISTS dblink SCHEMA public CASCADE;

RESET ROLE;
