/*
 * This file is part of the "FastDatabaseDeployer" project.
 *
 * (c) Nazir Khusnutdinov <nazir@nazir.pro>
 *
 * Creating a database user
 */

SET CLIENT_ENCODING TO 'UTF8';

SET SESSION ROLE role_owner;

/*
 * CREATE ROLE usename_inp
 */
CREATE OR REPLACE FUNCTION core.fc_add_user(
  usename_inp name
, password_inp text
, comment_inp  text DEFAULT ''
, options_inp varchar(40) DEFAULT ''
, valid_until_inp varchar(20) DEFAULT 'infinity'
, connection_limit_inp int DEFAULT 0
) RETURNS bool AS $BODY$
BEGIN
  IF NOT EXISTS (SELECT * FROM pg_catalog.pg_user WHERE usename = usename_inp) THEN
    EXECUTE 'CREATE ROLE '|| usename_inp || ' LOGIN';
  END IF;
  EXECUTE 'ALTER ROLE ' || usename_inp || ' WITH PASSWORD '|| quote_literal(password_inp);
  IF options_inp NOT like '' THEN
    EXECUTE 'ALTER ROLE ' || usename_inp || ' '|| options_inp;
  END IF;
  EXECUTE 'ALTER ROLE ' || usename_inp || ' CONNECTION LIMIT ' || connection_limit_inp;
  EXECUTE 'COMMENT ON ROLE ' || usename_inp || ' IS ' || quote_literal(comment_inp);

  RETURN TRUE;
END $BODY$ LANGUAGE plpgsql;
COMMENT ON FUNCTION core.fc_add_user(name, text, text, varchar, varchar, int) IS 'Add new user';
ALTER FUNCTION core.fc_add_user(name, text, text, varchar, varchar, int) OWNER TO role_owner;

/*
 * Grant membership in role role_inp to user user_inp
 */
CREATE OR REPLACE FUNCTION core.fc_grant_role(
  user_inp name
, role_inp name DEFAULT 'role_user'
) RETURNS bool AS $BODY$
BEGIN
  EXECUTE 'GRANT ' || role_inp || ' TO '|| user_inp;
  RETURN TRUE;
END $BODY$ LANGUAGE plpgsql;
COMMENT ON FUNCTION core.fc_grant_role(name, name) IS 'Grant membership in role role_inp to user user_inp';
ALTER FUNCTION core.fc_grant_role(name, name) OWNER TO role_owner;

/*
 * User "usr"
 */
-- SELECT core.fc_add_user('usr', 'usr', 'Default user', '', '2099-01-01 00:00:00', 100000);
-- SELECT core.fc_grant_role('usr', 'role_user');
-- SELECT core.fc_grant_role('usr', 'role_expert');
-- SELECT core.fc_grant_role('usr', 'role_moderator');
-- SELECT core.fc_grant_role('usr', 'role_read');
-- SELECT core.fc_grant_role('usr', 'role_supervisor');


-- DO $BODY$
-- BEGIN
--    -- DROP ROLE IF EXISTS usr;
--    IF NOT EXISTS (SELECT * FROM pg_catalog.pg_user WHERE usename = 'usr') THEN
--       CREATE ROLE usr LOGIN;
--    END IF;
-- END $BODY$;
-- ALTER ROLE usr WITH PASSWORD 'usr';
-- ALTER ROLE usr VALID UNTIL '2099-01-01 00:00:00';
-- ALTER ROLE usr CONNECTION LIMIT 100000;

-- REVOKE ALL FROM usr;
-- GRANT role_user TO usr;
-- GRANT role_expert TO usr;
-- GRANT role_moderator TO usr;
-- GRANT role_read TO usr;
-- GRANT role_supervisor TO usr;

-- ALTER ROLE usr IN DATABASE tmpldb SET role = 'role_read';

RESET ROLE;
