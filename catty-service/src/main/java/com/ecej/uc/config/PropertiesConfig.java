package com.ecej.uc.config;

import javax.annotation.PostConstruct;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.ImportResource;
import org.springframework.context.annotation.PropertySource;



@Configuration
@PropertySource(value = { "classpath:remote-db.properties", "classpath:remote-googleclient.properties","classpath:remote-dubbo.properties" })
public class PropertiesConfig {

}