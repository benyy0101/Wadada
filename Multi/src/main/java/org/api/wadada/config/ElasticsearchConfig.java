package org.api.wadada.config;

import org.apache.http.conn.ssl.TrustAllStrategy;
import org.apache.http.ssl.SSLContextBuilder;
import org.apache.http.ssl.TrustStrategy;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;
import org.springframework.data.elasticsearch.client.ClientConfiguration;
import org.springframework.data.elasticsearch.client.elc.ElasticsearchConfiguration;
import org.springframework.data.elasticsearch.repository.config.EnableElasticsearchRepositories;

import javax.net.ssl.SSLContext;
import java.io.InputStream;
import java.security.KeyStore;
import javax.net.ssl.TrustManagerFactory;

@Configuration
@EnableElasticsearchRepositories(basePackages = "org.api.wadada.multi.repository")
public class ElasticsearchConfig extends ElasticsearchConfiguration {

    @Value("${spring.elasticsearch.username}")
    private String username;

    @Value("${spring.elasticsearch.password}")
    private String password;

    @Value("${spring.elasticsearch.uris}")
    private String[] esHost;


    @Override
    public ClientConfiguration clientConfiguration() {
        try {
            return ClientConfiguration.builder()
                    .connectedTo(esHost)
                    .withBasicAuth(username, password)
                    .build();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
