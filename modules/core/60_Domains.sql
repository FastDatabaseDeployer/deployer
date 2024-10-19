/*
 * This file is part of the "FastDatabaseDeployer" project.
 *
 * (c) Nazir Khusnutdinov <nazir@nazir.pro>
 *
 * Domains
 */

/*
 * Domains
 * CREATE DOMAIN https://www.postgresql.org/docs/current/sql-createdomain.html
 * ALTER DOMAIN https://www.postgresql.org/docs/current/sql-alterdomain.html
 * DROP DOMAIN https://www.postgresql.org/docs/current/sql-dropdomain.html
 */

SET CLIENT_ENCODING TO 'UTF8';

SET SESSION ROLE role_owner;

/*
 * Function "core.fc_empty"
 * Find empty strings or strings containing only whitespace
 * Example: CREATE TABLE example (field text NOT NULL CHECK (NOT empty( field )));
 */
-- DROP FUNCTION core.fc_empty(text);
CREATE OR REPLACE FUNCTION core.fc_empty(text)
RETURNS bool AS
  $$ SELECT $1 ~ '^[[:space:]]*$'; $$
  LANGUAGE sql
  IMMUTABLE;
COMMENT ON FUNCTION core.fc_empty(text) IS 'Find empty strings or strings containing only whitespace';
ALTER FUNCTION core.fc_empty(text) OWNER TO role_owner;

/*
 * Function "core.fc_domain"
 * Create or alter domain
 */
-- DROP FUNCTION core.fc_domain(name, name, boolean, name, name, name);
CREATE OR REPLACE FUNCTION core.fc_domain(
  name_inp name
, type_inp name
, not_null_inp boolean DEFAULT FALSE
, comment_inp name DEFAULT ''
, schema_inp name DEFAULT 'core'
, owner_inp name DEFAULT 'role_owner'
) RETURNS boolean
AS $BODY$
BEGIN
  IF NOT EXISTS (SELECT * FROM pg_catalog.pg_type WHERE typtype = 'd' AND typnamespace = (SELECT OID FROM pg_catalog.pg_namespace WHERE nspname LIKE schema_inp) AND typname = name_inp) THEN
    EXECUTE 'CREATE DOMAIN '|| schema_inp || '.' || name_inp || ' AS ' || type_inp;
  ELSE

  END IF;
  IF not_null_inp THEN
    EXECUTE 'ALTER DOMAIN '|| schema_inp || '.' || name_inp || ' SET NOT NULL';
  ELSE
    EXECUTE 'ALTER DOMAIN '|| schema_inp || '.' || name_inp || ' DROP NOT NULL';
  END IF;

  EXECUTE 'COMMENT ON DOMAIN '|| schema_inp || '.' || name_inp || ' IS ' || quote_literal(comment_inp);
  EXECUTE 'ALTER DOMAIN '|| schema_inp || '.' || name_inp || ' OWNER TO ' || owner_inp;
  RETURN TRUE;
END; $BODY$ LANGUAGE plpgsql;
COMMENT ON FUNCTION core.fc_domain(name, name, boolean, name, name, name) IS 'Create or alter domain';
ALTER FUNCTION core.fc_domain(name, name, boolean, name, name, name) OWNER TO role_owner;

-- -- DROP DOMAIN IF EXISTS core.dm_id_null;
-- SELECT core.fc_domain('dm_id', 'integer', 'Код');
-- ALTER DOMAIN core.dm_id drop NOT NULL;
-- DO $$ BEGIN
--   -- DROP DOMAIN IF EXISTS core.dm_id;
--   IF NOT EXISTS (SELECT * FROM pg_catalog.pg_type WHERE typtype = 'd' AND typnamespace = (SELECT OID FROM pg_catalog.pg_namespace WHERE nspname like 'core') AND typname = 'dm_id') THEN
--     CREATE DOMAIN core.dm_id AS integer;
--   END IF;
--   COMMENT ON DOMAIN core.dm_id IS 'Код';
--   -- DROP DOMAIN IF EXISTS core.dm_id_null;
-- END $$;

/*
 * Integer-valued
 */
SELECT core.fc_domain('dm_bit', 'numeric(1,0) CHECK (VALUE IN (0, 1))', FALSE, 'Bit');

/*
 * Numeric Types. Real. Floating-Point Types.
 */

/*
 * Numeric Types. Numeric. Floating-Point Types.
 * The types decimal and numeric are equivalent. Both types are part of the SQL standard. User-specified precision, exact.
 * Up to 131072 digits before the decimal point; up to 16383 digits after the decimal point.
 */


/*
 * Monetary
 */
SELECT core.fc_domain('dm_money', 'money', FALSE, 'Money');
SELECT core.fc_domain('dm_currency', 'numeric(17, 2)', FALSE, 'Currency (17,2)');

/*
 * Percent
 */
SELECT core.fc_domain('dm_percent', 'numeric(6, 3) CHECK (VALUE BETWEEN 0.000 AND 100.000)', FALSE, 'Percent');

/*
 * Logical
 */

/*
 * String
 */
SELECT core.fc_domain('dm_char_single_byte', '"char"', FALSE, 'Character single-byte. Storage Size - 1 byte');
SELECT core.fc_domain('dm_char_1', 'char(1)', FALSE, 'Character fixed-length, blank padded - 1');

SELECT core.fc_domain('dm_short_string', 'varchar(255)', FALSE, 'Short string');
SELECT core.fc_domain('dm_long_string', 'varchar(2048)', FALSE, 'Long string');

SELECT core.fc_domain('dm_memo', 'varchar(32765)', FALSE, 'Memo');
SELECT core.fc_domain('dm_note', 'varchar(5120)', FALSE, 'Note');

/*
 * Text
 */
SELECT core.fc_domain('dm_text', 'text', FALSE, 'Text variable unlimited length');
-- https://www.postgresql.org/docs/current/citext.html  The citext module provides a case-insensitive character string type
SELECT core.fc_domain('dm_citext', 'citext', FALSE, 'Case-insensitive character string type');
SELECT core.fc_domain('dm_md5', 'text', FALSE, 'MD5 hexadecimal hash');

/*
 * Date, time & timestamp
 */
SELECT core.fc_domain('dm_timestamp', 'timestamp', FALSE, 'Timestamp');
SELECT core.fc_domain('dm_current_date', 'date DEFAULT current_date', FALSE, 'Current date');
SELECT core.fc_domain('dm_current_time', 'time DEFAULT current_time', FALSE, 'Current time');
SELECT core.fc_domain('dm_current_timestamp', 'timestamp DEFAULT current_timestamp', FALSE, 'Current date & time');
SELECT core.fc_domain('dm_record_date', 'timestamp DEFAULT current_timestamp', TRUE, 'Record date');
SELECT core.fc_domain('dm_year', 'smallint CHECK (VALUE BETWEEN 1900 and 2100)', FALSE, 'Year');
SELECT core.fc_domain('dm_quarter', 'smallint CHECK (VALUE BETWEEN 1 and 4)', FALSE, 'Quarter');
SELECT core.fc_domain('dm_month', 'smallint CHECK (VALUE BETWEEN 1 and 12)', FALSE, 'Month');
SELECT core.fc_domain('dm_week', 'smallint CHECK (VALUE BETWEEN 1 and 7)', FALSE, 'Week');
SELECT core.fc_domain('dm_day', 'smallint CHECK (VALUE BETWEEN 1 and 31)', FALSE, 'Day');
SELECT core.fc_domain('dm_hour', 'smallint CHECK (VALUE BETWEEN 0 and 59)', FALSE, 'Hour');
SELECT core.fc_domain('dm_minute', 'smallint CHECK (VALUE BETWEEN 0 and 59)', FALSE, 'Minute');
SELECT core.fc_domain('dm_second', 'smallint CHECK (VALUE BETWEEN 0 and 59)', FALSE, 'Second');

/*
 * JSON
 */
SELECT core.fc_domain('dm_json', 'json', FALSE, 'JSON');
SELECT core.fc_domain('dm_jsonb', 'jsonb', FALSE, 'JSONB');

/*
 * XML
 */
SELECT core.fc_domain('dm_xml', 'xml', FALSE, 'XML data');

/*
 * Code
 */
SELECT core.fc_domain('dm_barcode', 'varchar(128)', FALSE, 'Barcode');
SELECT core.fc_domain('dm_qrcode', 'varchar(4290)', FALSE, 'QR code (Quick Response Code)');

/*
 * Binary data
 */
SELECT core.fc_domain('dm_blob', 'bytea', FALSE, 'BLOB (Binary Large Object)');
SELECT core.fc_domain('dm_binary_data', 'bytea', FALSE, 'Binary data (“byte array”)');

/*
 * File system
 */
SELECT core.fc_domain('dm_filename', 'varchar(255)', FALSE, 'The maximum length for a file name');
SELECT core.fc_domain('dm_path', 'varchar(4096)', FALSE, 'The maximum combined length of both the file name and path name');


/*
 * WWW
 */
SELECT core.fc_domain('dm_url', 'varchar(2048)', FALSE, 'URL');
SELECT core.fc_domain('dm_alias', 'varchar(255)', FALSE, 'Alias for URL');

/*
 * Network
 */
SELECT core.fc_domain('dm_ip_address', 'inet', FALSE, 'IP-address'); -- IPv4 or IPv6 host address
SELECT core.fc_domain('dm_cidr', 'cidr', FALSE, 'IPv4 or IPv6 network address');
SELECT core.fc_domain('dm_macaddr', 'macaddr', FALSE, 'MAC (Media Access Control) address');
SELECT core.fc_domain('dm_macaddr8', 'macaddr8', FALSE, 'MAC (Media Access Control) address (EUI-64 format)');

/*
 * FTS
 */
SELECT core.fc_domain('dm_tsvector', 'tsvector', FALSE, 'Full Text Search. A tsvector value is a sorted list of distinct lexemes, which are words that have been normalized to merge different variants of the same word'); -- Full Text Search. A tsvector value is a sorted list of distinct lexemes, which are words that have been normalized to merge different variants of the same word

/*
 * Common
 */
SELECT core.fc_domain('dm_name', 'name', FALSE, 'name'); -- "Table 8.5. Special Character Types" name [64 bytes] - internal type for object names
SELECT core.fc_domain('dm_sys_string', 'varchar(31)');
-- The SESSION_USER is normally the user who initiated the current database connection; but superusers can change this setting with SET SESSION AUTHORIZATION
SELECT core.fc_domain('dm_session_user', 'name DEFAULT SESSION_USER', FALSE, 'The SESSION_USER is normally the user who initiated the current DB connection');
-- CURRENT_ROLE, USER, CURRENT_USER - user name of current execution context
SELECT core.fc_domain('dm_current_user', 'name DEFAULT SESSION_USER', FALSE, 'Session user');
SELECT core.fc_domain('dm_current_role', 'name DEFAULT CURRENT_ROLE', FALSE, 'Current role');

/*
 * IDs
 */
-- ID (Identifier)
SELECT core.fc_domain('dm_id', 'integer', FALSE, 'ID (Identifier)');
-- Universally unique identifier (UUID).
SELECT core.fc_domain('dm_uuid', 'uuid DEFAULT gen_random_uuid()', TRUE, 'UUID');
-- Globally Unique Identifier (GUID) фирмы Microsoft является наиболее распространённым использованием данного стандарта UUID.
SELECT core.fc_domain('dm_guid', 'char(32)', FALSE, 'GUID');

SELECT core.fc_domain('dm_session_id', 'uuid DEFAULT gen_random_uuid()', FALSE, 'Session ID');
SELECT core.fc_domain('dm_token', 'uuid DEFAULT gen_random_uuid()', FALSE, 'Token');

/*
 * System
 */
SELECT core.fc_domain('dm_date_create', 'timestamp DEFAULT current_timestamp', TRUE, 'Date of record creation in the database');
SELECT core.fc_domain('dm_date_update', 'timestamp', FALSE, 'Date of record update in the database');
SELECT core.fc_domain('dm_version', 'bigint DEFAULT 1', TRUE, 'Version of the record in the database');
SELECT core.fc_domain('dm_deleted', 'timestamp', FALSE, 'Date of Soft Delete');

/*
 * User
 */
SELECT core.fc_domain('dm_username', 'citext', FALSE, 'User name');
ALTER DOMAIN core.dm_username DROP CONSTRAINT IF EXISTS chk_username_empty CASCADE;
ALTER DOMAIN core.dm_username ADD CONSTRAINT chk_username_empty CHECK (NOT core.fc_empty(VALUE));

SELECT core.fc_domain('dm_email', 'citext', FALSE, 'Email');
ALTER DOMAIN core.dm_email DROP CONSTRAINT IF EXISTS chk_email_empty CASCADE;
ALTER DOMAIN core.dm_email ADD CONSTRAINT chk_email_empty CHECK (NOT core.fc_empty(VALUE));
ALTER DOMAIN core.dm_email DROP CONSTRAINT IF EXISTS chk_email CASCADE;
ALTER DOMAIN core.dm_email ADD CONSTRAINT chk_email CHECK (char_length(VALUE) <= 320);

SELECT core.fc_domain('dm_phone', 'numeric(11, 0)', FALSE, 'Phone');

SELECT core.fc_domain('dm_password', 'text', FALSE, 'Password');
ALTER DOMAIN core.dm_password DROP CONSTRAINT IF EXISTS chk_password CASCADE;
-- ALTER DOMAIN core.dm_password DROP CONSTRAINT chk_password;
-- ALTER DOMAIN core.dm_password ADD CONSTRAINT chk_password CHECK (char_length(VALUE) <= 64); -- For bcrypt

SELECT core.fc_domain('dm_salt', 'citext', FALSE, 'Salt (cryptography)');

RESET ROLE;
