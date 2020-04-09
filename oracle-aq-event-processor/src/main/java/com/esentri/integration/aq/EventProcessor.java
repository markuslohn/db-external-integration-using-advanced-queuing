package com.esentri.integration.aq;

import javax.jms.Message;
import javax.jms.TextMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.annotation.JmsListener;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class EventProcessor {

	private final static String IN_QUEUE_NAME = "aq_admin.in_queue";
	private final static String OUT_QUEUE_NAME = "aq_admin.out_queue";
	@Autowired
	private JmsTemplate jmsTemplate;

	private ObjectMapper objectMapper = new ObjectMapper();

	@JmsListener(destination = OUT_QUEUE_NAME, containerFactory = "myJMSListenerFactory")
	public void processEvent(Message eventMessage) {
		try {
			String text = ((TextMessage) eventMessage).getText();
			log.info("Received an event with the following text {}.", text);
			EventData event = readEvent(text);

			log.info("Modify event and send back a confirmation.");
			confirmEvent(event);
			
		} catch (Exception e) {
			log.error("Couldn't process eventMessage, because of {}.", e.getMessage());
			if (log.isTraceEnabled()) {
				log.error(e.getMessage(), e);
			}
		}
	}

	private EventData readEvent(String text) throws JsonMappingException, JsonProcessingException {
		EventData event = objectMapper.readValue(text, EventData.class);
		return event;
	}

	private void confirmEvent(EventData event) throws JsonProcessingException {
		event.setData("Confirmation : " + event.getData());
		String text = objectMapper.writeValueAsString(event);
		jmsTemplate.convertAndSend(IN_QUEUE_NAME, text);
	}
}
