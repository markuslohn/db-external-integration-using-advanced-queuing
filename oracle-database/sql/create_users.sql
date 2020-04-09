REM ------------------------------------------------------------------
REM script:
REM      create_users.sql
REM
REM description:
REM      Creates new users aq_admin and aq_user. The password is fixed and
REM      can be changed if appropriate.
REM
REM parameter:
REM
REM note:
REM      Have to be run as system admin user
REM
REM ------------------------------------------------------------------
REM author     date          description
REM mlohn      2020-04-09    creation
REM ------------------------------------------------------------------

CREATE USER aq_admin IDENTIFIED BY "apexManager=1"
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp;

ALTER USER aq_admin QUOTA UNLIMITED ON users;
GRANT aq_administrator_role TO aq_admin;
GRANT connect TO aq_admin;
GRANT CREATE TYPE TO aq_admin;
GRANT connect TO aq_admin;

CREATE USER aq_user IDENTIFIED BY "apexManager=1"
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp;

GRANT aq_user_role TO aq_user;
GRANT connect TO aq_user;
GRANT CREATE TABLE TO aq_user;
GRANT CREATE VIEW TO aq_user;
GRANT CREATE PROCEDURE TO aq_user;
GRANT CREATE TRIGGER TO aq_user;
GRANT EXECUTE ON sys.dbms_aq TO aq_user;
GRANT CREATE SEQUENCE TO "AQ_USER";
ALTER USER aq_user QUOTA UNLIMITED ON users;
BEGIN
  DBMS_AQADM.GRANT_QUEUE_PRIVILEGE(
  privilege => 'ALL',
  queue_name => 'aq_admin.in_queue',
  grantee => 'aq_user',
  grant_option => FALSE);

  DBMS_AQADM.GRANT_QUEUE_PRIVILEGE(
  privilege => 'ALL',
  queue_name => 'aq_admin.out_queue',
  grantee => 'aq_user',
  grant_option => FALSE);
END;
/
