package com.gestao_restaurante.controller;

import com.gestao_restaurante.service.JwtService;
import com.gestao_restaurante.dto.LoginRequestDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/login")
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private UserDetailsService userDetailsService; // Ou o seu UserServiceDetails

    @PostMapping
    public ResponseEntity<String> authenticate(@RequestBody LoginRequestDTO request) {
        System.out.println("ENTRANDO NO MÉTODO");

        // Autentica o usuário no Spring Security
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.email(),
                        request.password()
                )
        );

        // Se a autenticação der certo, carrega os dados do usuário
        final UserDetails userDetails = userDetailsService.loadUserByUsername(request.email());

        // Gera o token JWT
        final String jwt = jwtService.generateToken(userDetails);

        // Retorna o token para o cliente
        return ResponseEntity.ok(jwt);
    }
}

