REM ------------------------------------------------------------------
REM script:
REM      receive_event_notification_proc.sql
REM
REM description:
REM      Convienent procedure to receive events from the inbound advanced queue.
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

create or replace PROCEDURE receive_event_notification AS

    dequeue_options         sys.dbms_aq.dequeue_options_t;
    message_properties      sys.dbms_aq.message_properties_t;
    message_handle          RAW(16);
    jms_text_message        sys.aq$_jms_text_message;
    jms_message             sys.aq$_jms_message;
    message                 VARCHAR2(512);
    message_as_json         json_object_t;
    event_attribute_names   json_key_list;
    event_id                VARCHAR2(50);
    event_type              VARCHAR2(50);
    event_source            VARCHAR2(50);
    event_data              VARCHAR2(512);
BEGIN
    dequeue_options.visibility := sys.dbms_aq.immediate;
    sys.dbms_aq.dequeue(queue_name => 'aq_admin.in_queue', dequeue_options => dequeue_options, message_properties => message_properties
    , payload => jms_message, msgid => message_handle);

    jms_text_message := jms_message.cast_to_text_msg();
    jms_text_message.get_text(message);
    message_as_json := json_object_t.parse(message);

    event_id := message_as_json.get_string('id');
    event_type := message_as_json.get_string('type');
    event_source := message_as_json.get_string('source');
    event_data := message_as_json.get_string('data');

    INSERT INTO received_events VALUES (
        event_id,
        sysdate,
        event_source,
        event_type,
        event_data
    );

    commit;
END receive_event_notification;
/
