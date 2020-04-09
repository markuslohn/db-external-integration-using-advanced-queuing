# oracle-aq-event-processor

It connects to an Oracle database and consumes events from an Advanced Queue. It confirms the event placing a new event also into an Advanced Queue for this purpose.

When using this applicatio consider to update the connection data to the database in application.properties.

## Build

```
mvn clean install
```

## Usage

```
mvn spring-boot:run
```


### Reference Documentation
For further reference, please consider the following sections:

* [Official Apache Maven documentation](https://maven.apache.org/guides/index.html)
* [Spring Boot Maven Plugin Reference Guide](https://docs.spring.io/spring-boot/docs/2.2.6.RELEASE/maven-plugin/)
