package org.cocurrency.config;

import java.util.Arrays;
import java.util.EnumSet;

import javax.inject.Inject;
import javax.servlet.DispatcherType;
import javax.servlet.FilterRegistration;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRegistration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.embedded.ConfigurableEmbeddedServletContainer;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.boot.web.servlet.ServletContextInitializer;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.orm.hibernate4.support.OpenSessionInViewFilter;

@Configuration
public class WebConfigurer implements ServletContextInitializer, EmbeddedServletContainerCustomizer {

	private final Logger log = LoggerFactory.getLogger(WebConfigurer.class);

	@Inject
	private Environment env;


	@Override
	public void onStartup(ServletContext servletContext) throws ServletException {
		log.info("Web application configuration, using profiles: {}", Arrays.toString(env.getActiveProfiles()));


		EnumSet<DispatcherType> disps = EnumSet.of(DispatcherType.REQUEST, DispatcherType.FORWARD, DispatcherType.ASYNC);
		initOpenSessionInViewFilter(servletContext, disps);
		// initWelcomePageServlet(servletContext);
		initWelcomePageFilter(servletContext, disps);

		log.info("Web application fully configured");
	}



	/**
	 * Initializes the OpenSessionInViewFilter Filter.
	 */
	private void initOpenSessionInViewFilter(ServletContext servletContext, EnumSet<DispatcherType> disps) {
		log.debug("Registering OpenSessionInView Filter");
		FilterRegistration.Dynamic cachingHttpHeadersFilter = servletContext.addFilter("osiv", new OpenSessionInViewFilter());
		cachingHttpHeadersFilter.addMappingForUrlPatterns(disps, true, "/*");
		cachingHttpHeadersFilter.setAsyncSupported(true);
	}


	private void initWelcomePageServlet(ServletContext servletContext) {
		ServletRegistration.Dynamic welcomePageServlet = servletContext.addServlet("welcomePageServlet", new WelcomePageServlet());
		welcomePageServlet.setLoadOnStartup(1);
		welcomePageServlet.addMapping("");
	}

	private void initWelcomePageFilter(ServletContext servletContext, EnumSet<DispatcherType> disps) {
		FilterRegistration.Dynamic welcomePageFilter = servletContext.addFilter("welcomePageFilter", new WelcomePageFilter());
		welcomePageFilter.addMappingForUrlPatterns(disps, true, "/");
		welcomePageFilter.setAsyncSupported(true);
	}


	@Override
	public void customize(ConfigurableEmbeddedServletContainer arg0) {
		// TODO Auto-generated method stub
		
	}
	

}