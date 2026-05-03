package com.gestao_restaurante.config.security;

import com.gestao_restaurante.dto.ClienteRequestDTO;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final AuthenticationManager authManager;
    private final JwtService jwtService;

    public AuthService(AuthenticationManager authManager, JwtService jwtService) {
        this.authManager = authManager;
        this.jwtService = jwtService;
    }

    public String verify(ClienteRequestDTO dto) {

        Authentication authentication = authManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        dto.nome(),
                        dto.senha()
                )
        );

        if (authentication.isAuthenticated()) {
            return jwtService.generateToken(dto.nome());
        }

        throw new RuntimeException("Credenciais inválidas");
    }
}