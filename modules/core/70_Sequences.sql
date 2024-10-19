/*
 * This file is part of the "FastDatabaseDeployer" project.
 *
 * (c) Nazir Khusnutdinov <nazir@nazir.pro>
 *
 * Sequences
 */

SET CLIENT_ENCODING TO 'UTF8';

SET SESSION ROLE role_owner;

-- CREATE [ TEMPORARY | TEMP ] SEQUENCE name [ INCREMENT [ BY ] increment ]
--     [ MINVALUE minvalue | NO MINVALUE ] [ MAXVALUE maxvalue | NO MAXVALUE ]
--     [ START [ WITH ] start ] [ CACHE cache ] [ [ NO ] CYCLE ]
--     [ OWNED BY { table_name.column_name | NONE } ]

-- DROP SEQUENCE IF EXISTS sq_temp;
CREATE TEMPORARY SEQUENCE IF NOT EXISTS sq_temp;
ALTER SEQUENCE IF EXISTS sq_temp INCREMENT BY 1 START WITH 0 MINVALUE 0;
COMMENT ON SEQUENCE sq_temp IS 'Temporal sequence';

RESET ROLE;
