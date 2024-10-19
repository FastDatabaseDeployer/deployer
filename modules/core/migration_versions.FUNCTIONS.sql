/*
 * This file is part of the "FastDatabaseDeployer" project.
 *
 * (c) Nazir Khusnutdinov <nazir@nazir.pro>
 *
 * Functions for table "core.migration_versions"
 */

SET CLIENT_ENCODING TO 'UTF8';

SET SESSION ROLE role_owner;

-- SELECT * FROM core.fc_session(user_id_inp => -1, user_agent_inp => 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0', ip_address_inp => '192.168.1.1', info_inp => '{"":""}', session_id => NULL);

-- DROP FUNCTION IF EXISTS core.fc_session(core.session.user_id%TYPE, core.session.user_agent%TYPE, core.session.ip_address%TYPE, core.session.info%TYPE, core.session.id%TYPE);
CREATE OR REPLACE FUNCTION core.fc_session(
  user_id_inp    core.session.user_id%TYPE    -- User ID
, user_agent_inp core.session.user_agent%TYPE -- User agent
, ip_address_inp core.session.ip_address%TYPE -- IP address
, info_inp       core.session.info%TYPE       -- Session information
, session_id_inp core.session.id%TYPE         -- Session ID
) RETURNS core.session.id%TYPE AS
$BODY$
DECLARE
  id_var     core.session.id%TYPE;
  app_id_var core.application.id%TYPE;
  is_bot_var boolean;
BEGIN
  is_bot_var := FALSE;
  IF is_bot_var THEN
    RETURN NULL;
  END IF;

  IF user_id_inp IS NULL THEN
    SELECT core.fc_get_current_user_id() INTO user_id_inp;
  END IF;

  SELECT core.fc_get_current_app_id() INTO app_id_var;

  -- IF user_id_inp IN (0) THEN
  --   -- id_var = -1;
  --   enabled_var := TRUE;
  -- ELSE
  --   enabled_var := FALSE;
  -- END IF;

  IF session_id_inp IS NULL THEN
    INSERT INTO core.session(app_id, user_id, user_agent, login_timestamp, ip_address, info)
    VALUES (app_id_var, user_id_inp, user_agent_inp, CURRENT_TIMESTAMP, ip_address_inp, info_inp)
    RETURNING id
    INTO id_var;
  ELSE
    id_var = session_id_inp;
    UPDATE core.session SET
      user_id = user_id_inp
    , user_agent = user_agent_inp
    , last_active = CURRENT_TIMESTAMP
    , ip_address = ip_address_inp
    , ip_address_last = ip_address
    , info = info_inp
    WHERE TRUE
      AND id = id_var;
  END IF;

  IF id_var IS NOT NULL THEN
    PERFORM core.fc_set_current_session_id(id_var);
  END IF;

  RETURN id_var;
END; $BODY$ LANGUAGE plpgsql;

ALTER FUNCTION core.fc_session(core.session.user_id%TYPE, core.session.user_agent%TYPE, core.session.ip_address%TYPE, core.session.info%TYPE, core.dm_session_id) OWNER TO role_owner;

COMMENT ON FUNCTION core.fc_session IS 'Creating a session';

RESET ROLE;
