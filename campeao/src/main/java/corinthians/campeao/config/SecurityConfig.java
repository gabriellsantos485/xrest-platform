package corinthians.campeao.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

/*
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // 1. Desabilita o CSRF usando o novo estilo Lambda
                .csrf(csrf -> csrf.disable())

                // 2. Permite frames para o H2 Console não ficar em branco
                .headers(headers -> headers.frameOptions(frame -> frame.sameOrigin()))

                // 3. Configura as permissões de rota
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(AntPathRequestMatcher.antMatcher("/h2-console/**")).permitAll()
                        .anyRequest().authenticated()
                )

                // 4. Habilita o formulário de login padrão
                .formLogin(Customizer.withDefaults());

        return http.build();
    }
}
*/