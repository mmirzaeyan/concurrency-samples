package org.cocurrency;



import java.util.Arrays;

import javax.annotation.PostConstruct;
import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.data.jpa.JpaRepositoriesAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.support.SpringBootServletInitializer;
import org.springframework.core.env.Environment;

@SpringBootApplication(exclude = {JpaRepositoriesAutoConfiguration.class })
@ServletComponentScan
public class MyAppliction extends SpringBootServletInitializer{
   
	private static final Logger log = LoggerFactory.getLogger(MyAppliction.class);

	@Inject
	private Environment env;

	@PostConstruct
	public void initApplication() {
		log.info("Running with Spring profile(s) : {}", Arrays.toString(env.getActiveProfiles()));
	}

	public static void main(String[] args) {
		SpringApplication.run(MyAppliction.class, args);
	}
	
	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
		return builder.sources(MyAppliction.class);
	}
    
  
    
}
