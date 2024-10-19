/*
 * This file is part of the "FastDatabaseDeployer" project.
 *
 * (c) Nazir Khusnutdinov <nazir@nazir.pro>
 *
 * Creating functions
 */

SET CLIENT_ENCODING TO 'UTF8';

SET SESSION ROLE role_dev;

/*
 * Function "core.fc_add_constraint"
 * Create or alter constraint
 * Example: SELECT core.fc_add_constraint('loc', 'country', '', 'PRIMARY KEY', 'id');
 */
-- DROP FUNCTION IF EXISTS core.fc_add_constraint(name, name, name, name, varchar(1024), name);
CREATE OR REPLACE FUNCTION core.fc_add_constraint(
  schema_inp name
, table_inp name
, name_inp name DEFAULT ''
, type_inp name DEFAULT 'PRIMARY KEY'
, fields_inp varchar(1024) DEFAULT 'id'
, comment_inp name DEFAULT ''
) RETURNS boolean
AS $BODY$
DECLARE
  name_var name;
  temp_var text;
BEGIN
  -- ALTER TABLE IF EXISTS table_name DROP CONSTRAINT IF EXISTS constraint_name [ RESTRICT | CASCADE ];
  name_var = name_inp;
  temp_var = '';
  IF name_var = '' THEN
    name_var = 'pk_' || table_inp;
    IF type_inp = 'PRIMARY KEY' THEN
      name_var = 'pk_' || table_inp;
    ELSIF type_inp = 'UNIQUE' THEN
      IF fields_inp = 'name' THEN
        name_var = 'unq_' || table_inp;
      ELSIF type_inp = '_uuid' THEN
        name_var = 'unq_' || table_inp || '__uuid';
      ELSE
        name_var = 'unq_' || table_inp;
      END IF;

    ELSIF type_inp = 'FOREIGN KEY' THEN
      name_var = 'fk_' || table_inp || '_' || fields_inp;
      -- temp_var = ' REFERENCES', ??sys.user?? (id), ' MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT';
    ELSE
    END IF;
  END IF;

  -- EXECUTE concat('ALTER TABLE IF EXISTS ', schema_inp, '.', table_inp, ' DROP CONSTRAINT IF EXISTS ', name_var, ';');
  IF NOT EXISTS (SELECT constraint_name FROM information_schema.constraint_column_usage WHERE TRUE AND table_schema LIKE schema_inp AND table_name LIKE table_inp AND constraint_name LIKE name_var) THEN
    EXECUTE concat('ALTER TABLE IF EXISTS ', schema_inp, '.', table_inp, ' ADD CONSTRAINT ', name_var, ' ', type_inp, ' (', fields_inp, ')', temp_var, ';');
  END IF;

  EXECUTE concat('COMMENT ON CONSTRAINT ', name_var, ' ON ', schema_inp, '.', table_inp, ' IS ', quote_literal(comment_inp), ';');
  -- EXECUTE concat('ALTER CONSTRAINT ', schema_inp, '.', name_inp, ' OWNER TO ', owner_inp, ';');
  RETURN TRUE;
END; $BODY$ LANGUAGE plpgsql;
COMMENT ON FUNCTION core.fc_add_constraint(name, name, name, name, varchar(1024), name) IS 'Create or alter constraint';
ALTER FUNCTION core.fc_add_constraint(name, name, name, name, varchar(1024), name) OWNER TO role_dev;

/*
 * Function "core.fc_add_timestamps_columns"
 * Create or alter timestamps columns in table
 * Example: SELECT core.fc_add_timestamps_columns('loc', 'country');
 */
-- DROP FUNCTION IF EXISTS core.fc_add_timestamps_columns(name, name);
CREATE OR REPLACE FUNCTION core.fc_add_timestamps_columns(
  schema_inp name
, table_inp name
) RETURNS boolean
AS $BODY$
DECLARE
  temp_var varchar(256);
BEGIN
  temp_var = concat('ALTER TABLE IF EXISTS ', schema_inp, '.', table_inp, ' ');

  /**
   * _date_create core.dm_date_create -- Date of record creation in the database
   */
  EXECUTE concat(temp_var, 'ADD COLUMN IF NOT EXISTS _date_create core.dm_date_create;');
  EXECUTE concat('COMMENT ON COLUMN ', schema_inp, '.', table_inp, '._date_create IS ', quote_literal('Date of record creation in the database'), ';');

  /**
   * _date_update core.dm_date_update -- Date of record update in the database
   */
  EXECUTE concat(temp_var, 'ADD COLUMN IF NOT EXISTS _date_update core.dm_date_update;');
  EXECUTE concat('COMMENT ON COLUMN ', schema_inp, '.', table_inp, '._date_update IS ', quote_literal('Date of record update in the database'), ';');

  RETURN TRUE;
END; $BODY$ LANGUAGE plpgsql;
COMMENT ON FUNCTION core.fc_add_timestamps_columns(name, name) IS 'Create or alter timestamps columns in table';
ALTER FUNCTION core.fc_add_timestamps_columns(name, name) OWNER TO role_owner;

/*
 * Function "core.fc_add_column_deleted"
 * Create or alter column _deleted in table
 * Example: SELECT core.fc_add_timestamps_columns('loc', 'country');
 */
-- DROP FUNCTION IF EXISTS core.fc_add_column_deleted(name, name);
CREATE OR REPLACE FUNCTION core.fc_add_column_deleted(
  schema_inp name
, table_inp name
) RETURNS boolean
AS $BODY$
DECLARE
  temp_var varchar(256);
BEGIN
  temp_var = concat('ALTER TABLE IF EXISTS ', schema_inp, '.', table_inp, ' ');

  /**
   * _deleted core.dm_deleted -- Date of Soft Delete
   */
  EXECUTE concat(temp_var, 'ADD COLUMN IF NOT EXISTS _deleted core.dm_deleted;');
  EXECUTE concat('COMMENT ON COLUMN ', schema_inp, '.', table_inp, '._deleted IS ', quote_literal('Date of Soft Delete'), ';');

  RETURN TRUE;
END; $BODY$ LANGUAGE plpgsql;
COMMENT ON FUNCTION core.fc_add_column_deleted(name, name) IS 'Create or alter column deleted in table';
ALTER FUNCTION core.fc_add_column_deleted(name, name) OWNER TO role_owner;

/*
 * Function "core.fc_add_system_columns"
 * Create or alter system columns in table
 * Example: SELECT core.fc_add_system_columns('loc', 'country');
 */

-- , _date_create core.dm_date_create   -- Date of record creation in the database
-- , _user_create core.dm_id            -- User ID when creating a record
-- , _date_update core.dm_date_update   -- Date of record update in the database
-- , _user_update core.dm_id            -- User ID when updating a record
-- , _uuid        core.dm_uuid          -- UUID
-- , _version     core.dm_version       -- Version of the record in the database
-- , _read_only   boolean DEFAULT FALSE         -- Record is read-only. If TRUE, then it is impossible to remove
-- , _deleted     core.dm_deleted       -- Date of Soft Delete

-- -- -- ALTER TABLE !.! DROP CONSTRAINT IF EXISTS unq_!_uuid;
-- -- ALTER TABLE !.! ADD CONSTRAINT unq_!_uuid UNIQUE (_uuid);
-- SELECT core.fc_add_constraint('!', '!', '', 'UNIQUE', '_uuid');

-- COMMENT ON COLUMN .._date_create IS 'Date of record creation in the database';
-- COMMENT ON COLUMN .._user_create IS 'User ID when creating a record';
-- COMMENT ON COLUMN .._date_update IS 'Date of record update in the database';
-- COMMENT ON COLUMN .._user_update IS 'User ID when updating a record';
-- COMMENT ON COLUMN .._uuid IS 'UUID';
-- COMMENT ON COLUMN .._version IS 'Version of the record in the database';
-- COMMENT ON COLUMN .._read_only IS 'Record is read-only. If TRUE, then it is impossible to remove';
-- COMMENT ON COLUMN .._deleted IS 'Date of Soft Delete';

-- DROP FUNCTION IF EXISTS core.fc_add_system_columns(name, name);
CREATE OR REPLACE FUNCTION core.fc_add_system_columns(
  schema_inp name
, table_inp name
) RETURNS boolean
AS $BODY$
DECLARE
  temp_var varchar(256);
BEGIN
  -- ALTER TABLE [ IF EXISTS ] [ ONLY ] name [ * ] ADD [ COLUMN ] [ IF NOT EXISTS ] column_name data_type [ COLLATE collation ] [ column_constraint [ ... ] ]
  -- IF NOT EXISTS (SELECT column_name FROM information_schema.columns WHERE TRUE AND table_schema LIKE schema_inp AND table_name LIKE table_inp AND column_name LIKE '_date_create') THEN
  -- ELSE
  -- END IF;

  temp_var = concat('ALTER TABLE IF EXISTS ', schema_inp, '.', table_inp, ' ');

  /**
   * _date_create core.dm_date_create -- Date of record creation in the database
   */
  EXECUTE concat(temp_var, 'ADD COLUMN IF NOT EXISTS _date_create core.dm_date_create;');
  EXECUTE concat('COMMENT ON COLUMN ', schema_inp, '.', table_inp, '._date_create IS ', quote_literal('Date of record creation in the database'), ';');

  /**
   * _user_create core.dm_id -- User ID when creating a record
   */
  EXECUTE concat(temp_var, 'ADD COLUMN IF NOT EXISTS _user_create core.dm_id;');
  EXECUTE concat('COMMENT ON COLUMN ', schema_inp, '.', table_inp, '._user_create IS ', quote_literal('User ID when creating a record'), ';');
  -- IF EXISTS (SELECT constraint_name FROM information_schema.constraint_column_usage WHERE TRUE AND constraint_schema LIKE quote_literal(schema_inp) AND table_schema LIKE 'sys' AND table_name LIKE 'users' AND constraint_name LIKE quote_literal('fk_' || table_inp || '__user_create')) THEN
    EXECUTE concat(temp_var, 'DROP CONSTRAINT IF EXISTS fk_', table_inp, '__user_create;');
  -- END IF;
  EXECUTE concat(temp_var, 'ADD CONSTRAINT fk_', table_inp, '__user_create FOREIGN KEY (_user_create) REFERENCES sys.user (id) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;');
  EXECUTE concat('COMMENT ON CONSTRAINT fk_' || table_inp || '__user_create ON ', schema_inp, '.', table_inp, ' IS ', quote_literal(concat('Foreign key for table "', schema_inp, '.', table_inp, '"', ' to table "sys.user"')), ';');

  /**
   * _date_update core.dm_date_update -- Date of record update in the database
   */
  EXECUTE concat(temp_var, 'ADD COLUMN IF NOT EXISTS _date_update core.dm_date_update;');
  EXECUTE concat('COMMENT ON COLUMN ', schema_inp, '.', table_inp, '._date_update IS ', quote_literal('Date of record update in the database'), ';');

  /**
   * _user_update core.dm_id -- User ID when updating a record
   */
  EXECUTE concat(temp_var, 'ADD COLUMN IF NOT EXISTS _user_update core.dm_id;');
  EXECUTE concat('COMMENT ON COLUMN ', schema_inp, '.', table_inp, '._user_update IS ', quote_literal('User ID when updating a record'), ';');
  -- IF EXISTS (SELECT constraint_name FROM information_schema.constraint_column_usage WHERE TRUE AND constraint_schema LIKE quote_literal(schema_inp) AND table_schema LIKE 'sys' AND table_name LIKE 'users' AND constraint_name LIKE quote_literal('fk_' || table_inp || '__user_update')) THEN
    EXECUTE concat(temp_var, 'DROP CONSTRAINT IF EXISTS fk_', table_inp, '__user_update;');
  -- END IF;
  EXECUTE concat(temp_var, 'ADD CONSTRAINT fk_', table_inp, '__user_update FOREIGN KEY (_user_update) REFERENCES sys.user (id) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE RESTRICT;');
  EXECUTE concat('COMMENT ON CONSTRAINT fk_' || table_inp || '__user_update ON ', schema_inp, '.', table_inp, ' IS ', quote_literal(concat('Foreign key for table "', schema_inp, '.', table_inp, '"', ' to table "sys.user"')), ';');

  /**
   * _uuid core.dm_uuid -- UUID
   */
  -- IF EXISTS (SELECT constraint_name FROM information_schema.constraint_column_usage WHERE TRUE AND table_schema LIKE schema_inp AND table_name LIKE table_inp AND constraint_name LIKE 'unq_' || table_inp || '__uuid;') THEN
    EXECUTE concat(temp_var, 'DROP CONSTRAINT IF EXISTS unq_' || table_inp || '__uuid;');
  -- END IF;
  EXECUTE concat(temp_var, 'ADD COLUMN IF NOT EXISTS _uuid core.dm_uuid;');
  EXECUTE concat('COMMENT ON COLUMN ', schema_inp, '.', table_inp, '._uuid IS ', quote_literal('UUID'), ';');
  -- EXECUTE concat(temp_var, 'ADD COLUMN IF NOT EXISTS _uuid core.dm_uuid CONSTRAINT unq_' || table_inp || '__uuid UNIQUE;');
  EXECUTE concat(temp_var, 'ADD CONSTRAINT unq_' || table_inp || '__uuid UNIQUE (_uuid);');
  EXECUTE concat('COMMENT ON CONSTRAINT unq_' || table_inp || '__uuid ON ', schema_inp, '.', table_inp, ' IS ', quote_literal(concat('Unique for column "UUID" for table "', schema_inp, '.', table_inp, '"')), ';');

  /**
   * _version core.dm_version -- Version of the record in the database
   */
  EXECUTE concat(temp_var, 'ADD COLUMN IF NOT EXISTS _version core.dm_version;');
  EXECUTE concat('COMMENT ON COLUMN ', schema_inp, '.', table_inp, '._version IS ', quote_literal('Version of the record in the database'), ';');

  /*
   * _read_only boolean DEFAULT FALSE -- Record is read-only. If TRUE, then it is impossible to remove
   */
  EXECUTE concat(temp_var, 'ADD COLUMN IF NOT EXISTS _read_only boolean DEFAULT FALSE;');
  EXECUTE concat('COMMENT ON COLUMN ', schema_inp, '.', table_inp, '._read_only IS ', quote_literal('Record is read-only. If TRUE, then it is impossible to remove'), ';');

  /**
   * _deleted core.dm_deleted -- Date of Soft Delete
   */
  EXECUTE concat(temp_var, 'ADD COLUMN IF NOT EXISTS _deleted core.dm_deleted;');
  EXECUTE concat('COMMENT ON COLUMN ', schema_inp, '.', table_inp, '._deleted IS ', quote_literal('Date of Soft Delete'), ';');

  RETURN TRUE;
END; $BODY$ LANGUAGE plpgsql;
COMMENT ON FUNCTION core.fc_add_system_columns(name, name) IS 'Create or alter system columns in table';
ALTER FUNCTION core.fc_add_system_columns(name, name) OWNER TO role_dev;

/*
 * Function "core.fc_get_last_id"
 * Get last value for ID
 * Example: SELECT core.fc_get_last_id('loc.country');
 */
-- DROP FUNCTION IF EXISTS core.fc_get_last_id(name);
CREATE OR REPLACE FUNCTION core.fc_get_last_id(
  name_inp name
) RETURNS core.dm_id
AS $BODY$
DECLARE
  name_seq_var name;
  current_role_var name;
  result_var core.dm_id;
BEGIN
  SELECT CURRENT_ROLE INTO current_role_var;
  SET SESSION ROLE role_owner;

  -- https://www.postgresql.org/docs/current/functions-info.html#FUNCTIONS-INFO-CATALOG-TABLE
  SELECT pg_get_serial_sequence(name_inp, 'id') 
  INTO name_seq_var;

  EXECUTE 'SELECT last_value FROM ' || name_seq_var
  INTO result_var;
  -- RESET ROLE;
  -- EXECUTE format('SET SESSION ROLE %I;', current_role_var);
  EXECUTE $$SET SESSION ROLE $$ || current_role_var || $$;$$;
  RETURN result_var;
END; $BODY$ LANGUAGE plpgsql;
COMMENT ON FUNCTION core.fc_get_last_id(name) IS 'Get last value for ID';
ALTER FUNCTION core.fc_get_last_id(name) OWNER TO role_owner;
GRANT EXECUTE ON FUNCTION core.fc_get_last_id(name) TO PUBLIC;

/*
 * Function "core.fc_recalculation_id"
 * ID recalculation
 * Example: SELECT core.fc_recalculation_id('loc.country');
 */
-- DROP FUNCTION IF EXISTS core.fc_grecalculation_id(name);
CREATE OR REPLACE FUNCTION core.fc_recalculation_id(
  name_inp name
) RETURNS core.dm_id
AS $BODY$
DECLARE
  name_seq_var name;
  current_role_var name;
  result_var core.dm_id;
BEGIN
  SELECT CURRENT_ROLE INTO current_role_var;
  SET SESSION ROLE role_owner;

  -- https://www.postgresql.org/docs/current/functions-info.html#FUNCTIONS-INFO-CATALOG-TABLE
  SELECT pg_get_serial_sequence(name_inp, 'id') 
  INTO name_seq_var;

  IF COALESCE(name_seq_var, '') LIKE '' THEN
    RETURN NULL;
  END IF;

  EXECUTE 'SELECT max(id) + 1 FROM ' || name_inp
  INTO result_var;

  IF COALESCE(result_var, -1) < 0 THEN
  	result_var = 0;
  END IF;

  EXECUTE concat('ALTER SEQUENCE IF EXISTS ', name_seq_var, ' RESTART WITH ', result_var, ';');

  EXECUTE 'SELECT last_value FROM ' || name_seq_var
  INTO result_var;

  -- RESET ROLE;
  -- EXECUTE format('SET SESSION ROLE %I;', current_role_var);
  EXECUTE $$SET SESSION ROLE $$ || current_role_var || $$;$$;
  RETURN result_var;
END; $BODY$ LANGUAGE plpgsql;
COMMENT ON FUNCTION core.fc_recalculation_id(name) IS 'ID recalculation';
ALTER FUNCTION core.fc_recalculation_id(name) OWNER TO role_owner;
GRANT EXECUTE ON FUNCTION core.fc_recalculation_id(name) TO PUBLIC;

/*
 * Function "core.fc_get__uuid"
 * Get _uuid for ID
 * Example: SELECT core.fc_get__uuid('loc', 'country', 1);
 */
-- DROP FUNCTION IF EXISTS core.fc_get__uuid(name, name, core.dm_id);
CREATE OR REPLACE FUNCTION core.fc_get__uuid(
  table_schema_inp name
, table_name_inp name
, id_inp core.dm_id
) RETURNS core.dm_uuid
AS $BODY$
DECLARE
  current_role_var name;
  result_var core.dm_text;
BEGIN
  SELECT CURRENT_ROLE INTO current_role_var;
  SET SESSION ROLE role_owner;

  IF EXISTS (SELECT column_name FROM information_schema.columns WHERE column_name LIKE '_uuid' AND table_schema = table_schema_inp AND table_name = table_name_inp) THEN
    EXECUTE 'SELECT _uuid FROM ' || table_schema_inp || '.' || table_name_inp || ' WHERE id = ' || id_inp::text
    INTO result_var;
  END IF;

  IF result_var IS NULL THEN
    RETURN gen_random_uuid();
  END IF;

  EXECUTE $$SET SESSION ROLE $$ || current_role_var || $$;$$;

  RETURN result_var;
END; $BODY$ LANGUAGE plpgsql;
COMMENT ON FUNCTION core.fc_get__uuid(name, name, core.dm_id) IS 'Get _uuid for ID';
ALTER FUNCTION core.fc_get__uuid(name, name, core.dm_id) OWNER TO role_owner;
GRANT EXECUTE ON FUNCTION core.fc_get__uuid(name, name, core.dm_id) TO PUBLIC;

/*
 * Function "core.fc_sha512"
 * SHA-512 hash
 */
CREATE OR REPLACE FUNCTION core.fc_sha512(bytea) returns text AS $BODY$
    SELECT encode(digest($1, 'sha512'), 'hex')
$BODY$ LANGUAGE SQL STRICT IMMUTABLE;
COMMENT ON FUNCTION core.fc_sha512(bytea) IS 'SHA-512 hash';
ALTER FUNCTION core.fc_sha512(bytea) OWNER TO role_owner;
-- GRANT EXECUTE ON FUNCTION core.fc_sha512(bytea) TO PUBLIC;

/*
 * WP Nazir 27.08.2015
 * Example: SELECT core.fc_add_zero(83, 4)
 */
CREATE OR REPLACE FUNCTION core.fc_add_zero(
  value_inp integer 
, size_inp integer
) RETURNS varchar(99)
AS $BODY$
DECLARE
  result varchar(99);
  x int;
  i int;
BEGIN
  -- SELECT div(3719,10)

  result := value_inp;
  x = value_inp;
  i := 0;
  WHILE x > 0 LOOP
    x := div(x, 10);
    i := i + 1;
  END LOOP;

  -- WHILE NOT done LOOP
  -- END LOOP;

  i := size_inp - i;
  WHILE i > 0 LOOP
    i := i - 1;
    -- IF i  > size_inp THEN
    --   EXIT;
    -- -- ELSIF i > size_inp THEN
    -- END IF;

    result := concat('0', result);
  END LOOP;

  RETURN result;
 -- RETURN i;

END; $BODY$ LANGUAGE plpgsql;
COMMENT ON FUNCTION core.fc_add_zero(value_inp integer, size_inp integer) IS 'Дополнить нулями';
ALTER FUNCTION core.fc_add_zero(value_inp integer, size_inp integer) OWNER TO role_owner;
-- GRANT EXECUTE ON FUNCTION core.fc_add_zero(value_inp integer, size_inp integer) TO PUBLIC;

/*
 * WP Nazir 30.08.2015
 * Возвращает название месяца в виде строки
 * Example: SELECT core.fc_month_long('2015-08-30 20:27:48')
 */
-- DROP FUNCTION IF EXISTS core.fc_month_long(date_inp timestamp);
CREATE OR REPLACE FUNCTION core.fc_month_long(
  date_inp timestamp
) RETURNS varchar(8)
AS $BODY$
DECLARE
  result varchar(8);
BEGIN
  CASE extract(month from date_inp)
    WHEN 1 THEN result := 'январь';
    WHEN 2 THEN result := 'февраль';
    WHEN 3 THEN result := 'март';
    WHEN 4 THEN result := 'апрель';
    WHEN 5 THEN result := 'май';
    WHEN 6 THEN result := 'июнь';
    WHEN 7 THEN result := 'июль';
    WHEN 8 THEN result := 'август';
    WHEN 9 THEN result := 'сентябрь';
    WHEN 10 THEN result := 'октябрь';
    WHEN 11 THEN result := 'ноябрь';
    WHEN 12 THEN result := 'декабрь';
  END CASE;

  RETURN result;
END; $BODY$ LANGUAGE plpgsql;
COMMENT ON FUNCTION core.fc_month_long(date_inp timestamp) IS 'Возвращает название месяца в виде строки';
ALTER FUNCTION core.fc_month_long(date_inp timestamp) OWNER TO role_owner;
-- GRANT EXECUTE ON FUNCTION core.fc_month_long(date_inp timestamp) TO PUBLIC;

/*
 * WP Nazir 30.08.2015
 * Возвращает полную дату с названием месяца в виде строки
 * Example: SELECT core.fc_date_long('2015-08-30')
 */
-- DROP FUNCTION IF EXISTS core.fc_date_long(date_inp timestamp);
CREATE OR REPLACE FUNCTION core.fc_date_long(
  date_inp timestamp
) RETURNS varchar(20)
AS $BODY$
DECLARE
  result varchar(20);
  x int;
  i int;
BEGIN
  result := extract(day from date_inp)
  ||' ' 
  -- || core.fc_month_long(date_inp)
  ||trim(trailing from
          substring
          (
              'января   февраля  марта    апреля   мая      июня     '
            ||'июля     августа  сентября октября  ноября   декабря  '
            from ((extract(month from date_inp) - 1) * 9 + 1)::int
            for 9
          )
        )
  ||' '||extract(year from date_inp)
  || ' г.';

  RETURN result;
END; $BODY$ LANGUAGE plpgsql;
COMMENT ON FUNCTION core.fc_date_long(date_inp timestamp) IS 'Возвращает полную дату с названием месяца в виде строки';
ALTER FUNCTION core.fc_date_long(date_inp timestamp) OWNER TO role_owner;
-- GRANT EXECUTE ON FUNCTION core.fc_date_long(date_inp timestamp) TO PUBLIC;

/*
 * WP Nazir 28.07.2016
 * Возвращает название дня недели в виде строки
 * Example: SELECT core.fc_day_of_week_long('2016-07-28 09:26:00')
 */
-- DROP FUNCTION IF EXISTS core.fc_day_of_week_long(date_inp timestamp);
CREATE OR REPLACE FUNCTION core.fc_day_of_week_long(
  date_inp timestamp
) RETURNS varchar(12)
AS $BODY$
DECLARE
  result varchar(12);
BEGIN
  CASE EXTRACT(DOW FROM date_inp)
    WHEN 1 THEN result := 'Понедельник';
    WHEN 2 THEN result := 'Вторник';
    WHEN 3 THEN result := 'Среда';
    WHEN 4 THEN result := 'Четверг';
    WHEN 5 THEN result := 'Пятница';
    WHEN 6 THEN result := 'Суббота';
    WHEN 0 THEN result := 'Воскресенье';
  ELSE
    result := '';
  END CASE;

  RETURN result;
END;
$BODY$ LANGUAGE plpgsql;
COMMENT ON FUNCTION core.fc_day_of_week_long(date_inp timestamp) IS 'Возвращает название дня недели в виде строки';
ALTER FUNCTION core.fc_day_of_week_long(date_inp timestamp) OWNER TO role_owner;
-- GRANT EXECUTE ON FUNCTION core.fc_day_of_week_long(date_inp timestamp) TO PUBLIC;

/*
 * Example: INSERT INTO my_table(bytea_data) SELECT fc_bytea_import('/my/file.name');
 */
-- DROP FUNCTION IF EXISTS core.fc_bytea_import(p_path text, p_result OUT bytea);
CREATE OR REPLACE FUNCTION core.fc_bytea_import(p_path text, p_result OUT bytea)
LANGUAGE plpgsql
AS $BODY$
DECLARE
  l_oid oid;
  r record;
BEGIN
  p_result := '';
  SELECT lo_import(p_path) INTO l_oid;
  FOR r IN ( SELECT data
             FROM pg_largeobject
             WHERE loid = l_oid
             ORDER BY pageno ) LOOP
    p_result = p_result || r.data;
  END LOOP;
  perform lo_unlink(l_oid);
END; $BODY$;
COMMENT ON FUNCTION core.fc_bytea_import(p_path text, p_result OUT bytea) IS 'Example: INSERT INTO my_table(bytea_data) SELECT ...';
ALTER FUNCTION core.fc_bytea_import(p_path text, p_result OUT bytea) OWNER TO role_owner;
-- GRANT EXECUTE ON FUNCTION core.fc_bytea_import(p_path text, p_result OUT bytea) TO PUBLIC;

/*
 * WP Nazir 06.05.2021
 * Checking values [int8] in array between min & max
 * Example: SELECT core.fc_arr_int8_chk(ARRAY[10, 19999999999, 89], 1, 9999999999);
 */
DROP FUNCTION IF EXISTS core.fc_arr_int8_chk;
CREATE FUNCTION core.fc_arr_int8_chk (arr int8[], min int8, max int8) RETURNS boolean AS
$BODY$
DECLARE
  r int8;
BEGIN
  FOR r IN
    SELECT val FROM unnest(arr) AS val
  LOOP
    IF NOT r BETWEEN min AND max THEN
      RETURN FALSE;
    END IF;
  END LOOP;
  RETURN TRUE;
END; $BODY$ LANGUAGE plpgsql;
COMMENT ON FUNCTION core.fc_arr_int8_chk IS 'Checking values [int8] in array between min & max';
ALTER FUNCTION core.fc_arr_int8_chk OWNER TO role_owner;
-- GRANT EXECUTE ON FUNCTION core.fc_arr_int8_chk TO PUBLIC;

RESET ROLE;
