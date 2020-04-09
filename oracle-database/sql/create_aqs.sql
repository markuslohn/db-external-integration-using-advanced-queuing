REM ------------------------------------------------------------------
REM script:
REM      create_aqs.sql
REM
REM description:
REM      Creates 2 Advanced Queues for inbound and outbound communication.
REM
REM parameter:
REM
REM note:
REM      Have to be run as aq_admin user
REM
REM ------------------------------------------------------------------
REM author     date          description
REM mlohn      2020-04-09    creation
REM ------------------------------------------------------------------

BEGIN
    dbms_aqadm.create_queue_table(queue_table => 'aq_admin.in_queue_qt',
           queue_payload_type => 'SYS.AQ$_JMS_MESSAGE',
           sort_list => 'PRIORITY, ENQ_TIME');
    dbms_aqadm.create_queue(queue_name => 'aq_admin.in_queue',
           queue_table => 'aq_admin.in_queue_qt',
           queue_type => dbms_aqadm.normal_queue);
    dbms_aqadm.start_queue(queue_name => 'aq_admin.in_queue', enqueue => true, dequeue => true);


    dbms_aqadm.create_queue_table(queue_table => 'aq_admin.out_queue_qt',
           queue_payload_type => 'SYS.AQ$_JMS_MESSAGE',
           sort_list=> 'PRIORITY, ENQ_TIME');

    dbms_aqadm.create_queue(queue_name => 'aq_admin.out_queue',
           queue_table => 'aq_admin.out_queue_qt',
           queue_type => dbms_aqadm.normal_queue);

    dbms_aqadm.start_queue(queue_name => 'aq_admin.out_queue', enqueue => true, dequeue => true);

END;
/
