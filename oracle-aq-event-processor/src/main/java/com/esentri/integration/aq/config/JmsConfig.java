package com.esentri.integration.aq.config;

import javax.jms.QueueConnectionFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.jms.DefaultJmsListenerContainerFactoryConfigurer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jms.annotation.EnableJms;
import org.springframework.jms.config.DefaultJmsListenerContainerFactory;
import org.springframework.jms.config.JmsListenerContainerFactory;
import org.springframework.jms.core.JmsTemplate;

import oracle.jms.AQjmsFactory;

@Configuration
@EnableJms
public class JmsConfig {

	@Autowired
	DataSourceConfig dataSourceConfig;

	@Bean
	public QueueConnectionFactory connectionFactory() throws Exception {
		return AQjmsFactory.getQueueConnectionFactory(dataSourceConfig.getDataSource());
	}

	@Bean
	public JmsTemplate jmsTemplate() throws Exception {
		JmsTemplate jmsTemplate = new JmsTemplate();
		jmsTemplate.setConnectionFactory(connectionFactory());
		return jmsTemplate;
	}

	@Bean
	public JmsListenerContainerFactory<?> myJMSListenerFactory(QueueConnectionFactory connectionFactory,
			DefaultJmsListenerContainerFactoryConfigurer configurer) {
		DefaultJmsListenerContainerFactory factory = new DefaultJmsListenerContainerFactory();
		configurer.configure(factory, connectionFactory);
		return factory;
	}

}
