package com.esentri.integration.aq.config;

import java.sql.SQLException;

import javax.sql.DataSource;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import oracle.jdbc.pool.OracleDataSource;

@Configuration
@ConfigurationProperties(prefix = "spring.datasource")
@Setter
@Getter
@Slf4j
public class DataSourceConfig {

	private String username;
	private String password;
	private String url;

	@Bean
	public DataSource getDataSource() throws SQLException {
		log.info("Connects to {}...", url);
		OracleDataSource dataSource = new OracleDataSource();
		dataSource.setUser(username);
		dataSource.setPassword(password);
		dataSource.setURL(url);
		dataSource.setImplicitCachingEnabled(true);
		dataSource.setFastConnectionFailoverEnabled(true);
		return dataSource;
	}

}
