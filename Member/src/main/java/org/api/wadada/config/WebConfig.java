package org.api.wadada.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {


    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/**").addResourceLocations("classpath:/static/");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("j10a102.p.ssafy.io:3000", "https://j10a102.p.ssafy.io", "http://localhost:3000","http://localhost:8080", "https://j10a102.p.ssafy.io/login/kakao")
                .allowedHeaders("Authorization", "content-type")
                .allowedMethods("GET", "POST", "DELETE", "PATCH", "OPTIONS")
                .allowCredentials(true);
    }

}
