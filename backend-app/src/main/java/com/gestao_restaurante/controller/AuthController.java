package com.gestao_restaurante.controller;

import com.gestao_restaurante.dto.*;
import com.gestao_restaurante.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/xrest/v1/login")
@CrossOrigin(origins = "*")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/cliente")
    public ResponseEntity<LoginResponseDTO> login(@RequestBody LoginRequestDTO dto) {
        return ResponseEntity.ok(authService.verifyCliente(dto));
    }

    @PostMapping("/funcionario")
    public ResponseEntity<LoginFuncionarioResponseDTO> login(@RequestBody LoginFuncionarioRequestDTO dto) {
        return ResponseEntity.ok(authService.verifyFuncionario(dto));
    }
}

