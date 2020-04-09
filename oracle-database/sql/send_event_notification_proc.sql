REM ------------------------------------------------------------------
REM script:
REM      send_event_notification_proc.sql
REM
REM description:
REM      Convienent procedure to send events to the outbound advanced queue.
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

create or replace PROCEDURE send_event_notification (
    id        IN   VARCHAR2,
    type      IN   VARCHAR2,
    message   IN   VARCHAR2
) AS

    enqueue_options      dbms_aq.enqueue_options_t;
    message_properties   dbms_aq.message_properties_t;
    message_handle       RAW(16);
    text_message         sys.aq$_jms_text_message;
    jms_message          sys.aq$_jms_message;
BEGIN
    text_message := sys.aq$_jms_text_message.construct;
    text_message.set_text('{'
                          || chr(10)
                          || '"specversion" : "1.0",'
                          || chr(10)
                          || '"id" : "'
                          || id
                          || '",'
                          || chr(10)
                          || '"type" : "'
                          || type
                          || '",'
                          || chr(10)
                          || ' "source" : "https://ids.com/cloudevents/spec/pull",'
                          || chr(10)
                          || ' "data" : "'
                          || message
                          || '"'
                          || chr(10)
                          || '}'
                          || chr(10));

    jms_message := sys.aq$_jms_message.construct(text_message);
    sys.dbms_aq.enqueue(queue_name => 'aq_admin.out_queue', enqueue_options => enqueue_options, message_properties => message_properties
    , payload => jms_message, msgid => message_handle);

    dbms_output.put_line('Successfully send event notification with id ' || message_handle);
END send_event_notification;
/
