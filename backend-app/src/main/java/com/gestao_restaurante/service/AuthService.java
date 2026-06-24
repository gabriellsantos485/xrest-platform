package com.gestao_restaurante.service;

import com.gestao_restaurante.config.security.User;
import com.gestao_restaurante.dto.*;
import com.gestao_restaurante.mapper.ClienteMapper;
import com.gestao_restaurante.mapper.FuncionarioMapper;
import com.gestao_restaurante.model.Cliente;
import com.gestao_restaurante.model.Funcionario;
import com.gestao_restaurante.repository.ClienteRepository;
import com.gestao_restaurante.repository.FuncionarioRepository;
import com.gestao_restaurante.repository.PedidoRepository;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final AuthenticationManager authManager;
    private final JwtService jwtService;
    private final ClienteRepository clienteRepository;
    private final PedidoRepository pedidoRepository;
    private final FuncionarioRepository funcionarioRepository;

    public AuthService(
            AuthenticationManager authManager,
            JwtService jwtService,
            ClienteRepository clienteRepository,
            PedidoRepository pedidoRepository,
            FuncionarioRepository funcionarioRepository) {
        this.authManager = authManager;
        this.jwtService = jwtService;
        this.clienteRepository = clienteRepository;
        this.pedidoRepository = pedidoRepository;
        this.funcionarioRepository = funcionarioRepository;
    }

    public LoginResponseDTO verifyCliente(LoginRequestDTO dto) {

        Authentication authentication = authManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        dto.email(),
                        dto.senha()
                )
        );

        User principal = (User) authentication.getPrincipal();

        String token = jwtService.generateToken(principal);

        Cliente cliente = clienteRepository
                .findByEmail(dto.email())
                .orElseThrow();

        return new LoginResponseDTO(
                token,
                ClienteMapper.toDTO(cliente)
        );
    }

    public LoginFuncionarioResponseDTO verifyFuncionario(LoginFuncionarioRequestDTO dto){
        Authentication authentication = authManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        dto.email(),
                        dto.senha()
                )
        );

        User principal = (User) authentication.getPrincipal();

        String token = jwtService.generateToken(principal);

        Funcionario funcionario = funcionarioRepository
                .findByEmail(dto.email())
                .orElseThrow();

        return new LoginFuncionarioResponseDTO(
                token,
                FuncionarioMapper.toDTO(funcionario)
        );
    }
}

