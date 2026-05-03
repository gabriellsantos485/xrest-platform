package com.gestao_restaurante.service;

import com.gestao_restaurante.config.security.AuthService;
import com.gestao_restaurante.dto.ClienteRequestDTO;
import com.gestao_restaurante.mapper.ClienteMapper;
import com.gestao_restaurante.model.Cliente;
import com.gestao_restaurante.repository.ClienteRepository;
import org.springframework.security.crypto.password.PasswordEncoder;

public class ClienteService {

    private final ClienteRepository clienteRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthService authService;

    public ClienteService(ClienteRepository clienteRepository,
                          PasswordEncoder passwordEncoder,
                          AuthService authService){
        this.clienteRepository = clienteRepository;
        this.passwordEncoder = passwordEncoder;
        this.authService = authService;
    }

    public Cliente registrar(ClienteRequestDTO dto){
        Cliente cliente = ClienteMapper.toEntity(dto);
        cliente.setPassword(passwordEncoder.encode(cliente.getPassword()));
        return clienteRepository.save(cliente);
    }

    public String login(ClienteRequestDTO dto){
        return authService.verify(dto);
    }
}
