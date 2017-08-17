package org.cocurrency.config;

import javax.inject.Inject;

import org.springframework.beans.factory.BeanInitializationException;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.encoding.ShaPasswordEncoder;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;

@Configuration
@EnableWebSecurity
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {


    @Inject
    private CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler;
    

    @Inject
    private UserDetailsService userDetailsService;

    @Bean
    public ShaPasswordEncoder passwordEncoder() {
        return new ShaPasswordEncoder();
    }

    @Inject
    public void configureGlobal(AuthenticationManagerBuilder auth) {
        try {
            auth
                .userDetailsService(userDetailsService)
                    .passwordEncoder(passwordEncoder());
        } catch (Exception e) {
            throw new BeanInitializationException("Security configuration failed", e);
        }
    }
    
    @Override
	public void configure(AuthenticationManagerBuilder auth) throws Exception {
		//@formatter:off
		auth
			.userDetailsService(userDetailsService)
			.passwordEncoder(passwordEncoder());
		//@formatter:on
	}
    

    @Override
    public void configure(WebSecurity web) throws Exception {
        web.ignoring()
            .antMatchers(HttpMethod.OPTIONS, "/**")
            .antMatchers("/app/**/*.{js,html}");
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .csrf()
            .disable()
            .exceptionHandling()
        .and()
            .formLogin().loginPage("/View/frontEnd/login.jsp")
            .loginProcessingUrl("/perform_login")
            .successHandler(customAuthenticationSuccessHandler)
            .usernameParameter("j_username")
            .passwordParameter("j_password")
            .permitAll()
        .and()
            .logout().logoutSuccessUrl("/")
            .permitAll()
        .and()
            .headers()
            .frameOptions()
            .disable()
        .and()
            .authorizeRequests()
            .antMatchers("/Login.jsp").permitAll()
            .antMatchers("/assets/**").permitAll()
            .antMatchers("/Scripts/**").permitAll()
            .antMatchers("/NewTheme/**").permitAll()
            .antMatchers("/rest/**/front/**").permitAll()
            .antMatchers("/View/frontEnd/**").permitAll()
            .antMatchers("/View/adminView/**").hasRole("ADMIN")
            .antMatchers("/View/**/**").hasRole("ADMIN")
            .antMatchers("/admin/**").hasRole("ADMIN")
         .and()
         	.exceptionHandling().accessDeniedPage("/View/frontEnd/security/accessDenied.jsp")
         .and()
         	.sessionManagement()
         	.maximumSessions(1);
    }

}
