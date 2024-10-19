/*
 * This file is part of the "FastDatabaseDeployer" project.
 *
 * (c) Nazir Khusnutdinov <nazir@nazir.pro>
 *
 * Group roles
 */

SET CLIENT_ENCODING TO 'UTF8';

SET SESSION ROLE role_dev;

/*
 * Group role "role_guest"
 * Inherits: NONE
 * Group role for guest
 */
DO $BODY$
BEGIN
   -- DROP ROLE IF EXISTS role_guest;
   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'role_guest') THEN
      CREATE ROLE role_guest;
   END IF;
END $BODY$;
ALTER ROLE role_guest RESET ALL;
ALTER ROLE role_guest NOLOGIN;
ALTER ROLE role_guest CONNECTION LIMIT 10000000;
COMMENT ON ROLE role_guest IS 'Group role for guest';
-- REVOKE ALL PRIVILEGES ON  FROM ;
-- GRANT  TO role_guest;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO role_guest;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT UPDATE ON SEQUENCES TO role_guest;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT EXECUTE ON FUNCTIONS TO role_guest;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE ON TYPES TO role_guest;

/*
 * Group role "role_read"
 * Inherits: "role_guest"
 * Read only group role
 */
DO $BODY$
BEGIN
   -- DROP ROLE IF EXISTS role_read;
   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'role_read') THEN
      CREATE ROLE role_read;
   END IF;
END $BODY$;
ALTER ROLE role_read RESET ALL;
ALTER ROLE role_read NOLOGIN;
ALTER ROLE role_read CONNECTION LIMIT 10000000;
COMMENT ON ROLE role_read IS 'Read only group role';
GRANT role_guest TO role_read;
GRANT role_read TO role_api;

/*
 * Group role "role_user"
 * Inherits: "role_read"
 * User
 */
DO $BODY$
BEGIN
   -- DROP ROLE IF EXISTS role_user;
   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'role_user') THEN
      CREATE ROLE role_user;
   END IF;
END $BODY$;
ALTER ROLE role_user RESET ALL;
ALTER ROLE role_user NOLOGIN;
ALTER ROLE role_user CONNECTION LIMIT 2000000;
COMMENT ON ROLE role_user IS 'Group role for users';
-- REVOKE role_read FROM role_user CASCADE;
GRANT role_read TO role_user;

/*
 * Group role "role_accountant"
 * Inherits: "role_user"
 * Group role for accountant
 */
DO $BODY$
BEGIN
   -- DROP ROLE IF EXISTS role_accountant;
   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'role_accountant') THEN
      CREATE ROLE role_accountant;
   END IF;
END $BODY$;
ALTER ROLE role_accountant RESET ALL;
ALTER ROLE role_accountant NOLOGIN;
ALTER ROLE role_accountant CONNECTION LIMIT 90000;
COMMENT ON ROLE role_accountant IS 'Group role for accountant';
GRANT role_user TO role_accountant;

/*
 * Group role "role_dispatcher"
 * Inherits: "role_user"
 * Group role for dispatcher
 * Диспетчер — должностное лицо, отвечающее за координацию каких-либо действий в определённой сфере.
 */
DO $BODY$
BEGIN
   -- DROP ROLE IF EXISTS role_dispatcher;
   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'role_dispatcher') THEN
      CREATE ROLE role_dispatcher;
   END IF;
END $BODY$
;
ALTER ROLE role_dispatcher RESET ALL;
ALTER ROLE role_dispatcher NOLOGIN;
ALTER ROLE role_dispatcher CONNECTION LIMIT 50000;
COMMENT ON ROLE role_dispatcher IS 'Group role for dispatcher';
GRANT role_user TO role_dispatcher;

/*
 * Group role "role_moderator"
 * Inherits: "role_user"
 * Group role moderator
 */
DO $BODY$
BEGIN
   -- DROP ROLE IF EXISTS role_moderator;
   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'role_moderator') THEN
      CREATE ROLE role_moderator;
   END IF;
END $BODY$;
ALTER ROLE role_moderator RESET ALL;
ALTER ROLE role_moderator NOLOGIN;
ALTER ROLE role_moderator CONNECTION LIMIT 10000;
COMMENT ON ROLE role_moderator IS 'Group role moderator';
GRANT role_user TO role_moderator;

/*
 * Group role "role_expert"
 * Inherits: "role_user", "role_dispatcher", "role_moderator"
 * Group role expert
 * Экспе́рт (от лат. expertus — опытный) — лицо, обладающее специальными знаниями
 */
DO $BODY$
BEGIN
   -- DROP ROLE IF EXISTS role_expert;
   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'role_expert') THEN
      CREATE ROLE role_expert;
   END IF;
END $BODY$;
ALTER ROLE role_expert RESET ALL;
ALTER ROLE role_expert NOLOGIN;
ALTER ROLE role_expert CONNECTION LIMIT 5000;
COMMENT ON ROLE role_expert IS 'Group role expert';
GRANT role_user TO role_expert;
GRANT role_moderator TO role_expert;
GRANT role_dispatcher TO role_expert;


/*
 * Group role "role_manager"
 * Inherits: "role_read"
 * Group role manager
 */
DO $BODY$
BEGIN
   -- DROP ROLE IF EXISTS role_manager;
   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'role_manager') THEN
      CREATE ROLE role_manager;
   END IF;
END $BODY$;
ALTER ROLE role_manager RESET ALL;
ALTER ROLE role_manager NOLOGIN;
ALTER ROLE role_manager CONNECTION LIMIT 10000;
COMMENT ON ROLE role_manager IS 'Group role manager';
GRANT role_read TO role_manager;

/*
 * Group role "role_supervisor"
 * Inherits: "role_read"
 * Group role supervisor
 * Cупервизор (наблюдатель, смотритель, руководитель) — административная должность в различных отраслях бизнеса, государственных учреждениях, а также в научных и образовательных институтах. Функции супервайзера в основном ограничиваются контролем за работой персонала.
 */
DO $BODY$
BEGIN
   -- DROP ROLE IF EXISTS role_supervisor;
   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'role_supervisor') THEN
      CREATE ROLE role_supervisor;
   END IF;
END $BODY$;
ALTER ROLE role_supervisor RESET ALL;
ALTER ROLE role_supervisor NOLOGIN;
ALTER ROLE role_supervisor CONNECTION LIMIT 50000;
COMMENT ON ROLE role_supervisor IS 'Group role supervisor';
GRANT role_read TO role_supervisor;

/*
 * Group role "role_admin"
 * Inherits: "role_expert"
 * Group role administrator
 */
DO $BODY$
BEGIN
   -- DROP ROLE IF EXISTS role_admin;
   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'role_admin') THEN
      CREATE ROLE role_admin;
   END IF;
END $BODY$;
ALTER ROLE role_admin RESET ALL;
ALTER ROLE role_admin NOLOGIN;
ALTER ROLE role_admin CONNECTION LIMIT 200;
COMMENT ON ROLE role_admin IS 'Group role administrator';
GRANT role_expert TO role_admin;

/*
 * Group role "role_superadmin"
 * Inherits: "role_admin"
 * Group role super administrator
 * Super Administrator - can manage administrators, etc.
 */
DO $BODY$
BEGIN
   -- DROP ROLE IF EXISTS role_superadmin;
   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_roles WHERE rolname = 'role_superadmin') THEN
      CREATE ROLE role_superadmin;
   END IF;
END $BODY$;
ALTER ROLE role_superadmin RESET ALL;
ALTER ROLE role_superadmin NOLOGIN;
ALTER ROLE role_superadmin CONNECTION LIMIT 5;
COMMENT ON ROLE role_superadmin IS 'Group role super administrator';
GRANT role_admin TO role_superadmin;
GRANT role_superadmin TO role_owner;
GRANT role_superadmin TO role_dev;

/*
 * Security group roles
 */


RESET ROLE;
