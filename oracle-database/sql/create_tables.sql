REM ------------------------------------------------------------------
REM script:
REM      create_tables.sql
REM
REM description:
REM      Creates tables for the use case.
REM
REM parameter:
REM
REM note:
REM      Have to be run as "aq_user" user
REM
REM ------------------------------------------------------------------
REM author     date          description
REM mlohn      2020-04-09    creation
REM ------------------------------------------------------------------

  CREATE TABLE "AQ_USER"."CUSTOMERS"
   (	"ID" NUMBER(10,0) GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  NOT NULL ENABLE,
	"FIRST_NAME" VARCHAR2(50 BYTE) NOT NULL ENABLE,
	"LAST_NAME" VARCHAR2(50 BYTE) NOT NULL ENABLE,
	"STREET" VARCHAR2(50 BYTE),
	"POSTAL_CODE" VARCHAR2(10 BYTE),
	"CITY" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "AQ_USER"."CUSTER_AFTER_INSERT_TRG" AFTER
    INSERT OR UPDATE OR DELETE ON aq_user.customers
    REFERENCING
            OLD AS old
            NEW AS new
    FOR EACH ROW
DECLARE
    transaction_type   VARCHAR2(10);
    customer_id        VARCHAR2(50);
    customer           VARCHAR2(100);
BEGIN
    transaction_type :=
        CASE
            WHEN updating THEN
                'UPDATE'
            WHEN deleting THEN
                'DELETE'
            ELSE 'CREATE'
        END;
    customer_id :=
        CASE
            WHEN updating THEN
                :old.id
            WHEN deleting THEN
                :old.id
            ELSE :new.id
        END;

    customer :=
        CASE
            WHEN updating THEN
                :new.first_name
                || ' '
                || :new.last_name
            WHEN deleting THEN
                :old.first_name
                || ' '
                || :old.last_name
            ELSE :new.first_name
                 || ' '
                 || :new.last_name
        END;

    send_event_notification(customer_id, transaction_type, transaction_type
                                                           || ': '
                                                           || customer);
END;
/
ALTER TRIGGER "AQ_USER"."CUSTER_AFTER_INSERT_TRG" ENABLE;

CREATE TABLE "AQ_USER"."RECEIVED_EVENTS"
   (	"ID" VARCHAR2(50 BYTE),
	"RECEIVED" TIMESTAMP (6),
	"SOURCE" VARCHAR2(50 BYTE),
	"TYPE" VARCHAR2(50 BYTE),
	"DATA" VARCHAR2(512 BYTE)
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
