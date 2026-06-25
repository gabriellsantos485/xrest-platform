package com.gestao_restaurante.config.security;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.argon2.Argon2PasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final UserServiceDetails userDetailsService;
    private final JwtFilter jwtFilter;

    public SecurityConfig(JwtFilter jwtFilter, UserServiceDetails userDetailsService){
        this.userDetailsService = userDetailsService;
        this.jwtFilter = jwtFilter;
    }
    @Bean
    public SecurityFilterChain filtroDeSeguranca(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable) // = csrf -> csrf.disable()
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/xrest/v1/login/**",
                                "/xrest/v1/pedido/mesa/*/pedido",
                                "/xrest/v1/produtos",
                                "/xrest/v1/cliente/cadastrar",
                                "/xrest/v1/funcionario/**",
                                "/xrest/v1/pedido/top-itens"
                        ).permitAll()

                        .requestMatchers("/admin/**").hasAnyRole("ADMIN", "CAIXA")
                        .requestMatchers("/cadastrarFuncionario/**").hasAnyRole("ADMIN", "CAIXA")
                        .requestMatchers("/cozinha/**").hasAnyRole("CAIXA")
                        .requestMatchers("/pedidos/**").hasAnyRole("GARCOM", "ADMIN", "CAIXA")
                        .requestMatchers("/cliente/**").hasAnyRole("CLIENTE", "CAIXA")
                        .requestMatchers("/xrest/clientes").hasAnyRole("CLIENTE", "CAIXA")
                        .requestMatchers("/xrest/v1/pedido/ultimos-pedidos").hasAnyRole("CLIENTE", "CAIXA")
                        .requestMatchers("/xrest/v1/pedido/pedido-andamento").hasAnyRole("CLIENTE", "CAIXA")
                        .requestMatchers("/xrest/v1/pedido/*/itens").hasAnyRole("CLIENTE", "CAIXA")
                        .requestMatchers("/xrest/v1/funcionario/**").hasAnyRole("ADMIN", "CAIXA")
                        .requestMatchers("/xrest/v1/pedido/fila").hasAnyRole("COZINHEIRO", "ADMIN", "CAIXA")
                        .requestMatchers("/xrest/v1/pedido/*/fechar").hasAnyRole("FUNCIONARIO", "ADMIN", "CAIXA")
                        .requestMatchers("/xrest/v1/item-pedido/status/*").hasAnyRole("COZINHEIRO", "ADMIN", "CAIXA")
                        .requestMatchers("/xrest/v1/cliente/**").hasAnyRole("ADMIN", "CAIXA")
                        .requestMatchers("/xrest/v1/mesa/**").hasAnyRole("ADMIN","CAIXA")
                        .requestMatchers("/xrest/v1/categoria/**").hasAnyRole("ADMIN", "CAIXA")
                        .requestMatchers("/xrest/v1/formas-pagamento/**").hasAnyRole("ADMIN", "CAIXA")
                        .requestMatchers("/status/{itemId}").hasAnyRole("CLIENTE", "ADMIN", "COZINHEIRO", "GARCOM", "CAIXA")
                        .requestMatchers("/xrest/v1/pedido/relatorio").hasAnyRole("ADMIN", "CAIXA")
                        .requestMatchers("/xrest/v1/produtos/cadastrar").hasAnyRole("ADMIN")
                        .anyRequest().authenticated()
                )
                .authenticationProvider(authenticationProvider())
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new Argon2PasswordEncoder(
                16,   // saltLength
                32,   // hashLength
                1,    // parallelism
                65536,// memory (64MB)
                3     // iterations
        );
    }

    @Bean
    public AuthenticationProvider authenticationProvider(){
        //Instancia um provider para buscar usuário no banco e comparar senha
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        // Criptografia de senha a ser verificada
        provider.setPasswordEncoder(passwordEncoder());
        // Busca usuário pelo username
        provider.setUserDetailsService(userDetailsService);

        return provider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

}