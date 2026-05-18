package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.ClienteRequestDTO;
import com.gestao_restaurante.dto.ClienteResponseDTO;
import com.gestao_restaurante.mapper.ClienteMapper;
import com.gestao_restaurante.model.Cliente;
import com.gestao_restaurante.repository.ClienteRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.OffsetDateTime;
import java.util.List;

@Service
public class ClienteService {

    ClienteRepository clienteRepository;
    private final PasswordEncoder passwordEncoder;

    public ClienteService(ClienteRepository clienteRepository, PasswordEncoder passwordEncoder){
        this.clienteRepository = clienteRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public List<ClienteResponseDTO> listarClientes(){
        return clienteRepository.findAllBy()
                .stream()
                .map(ClienteMapper::toDTO)
                .toList();
    }

    public ClienteResponseDTO verCliente(Integer id){
        Cliente cliente = clienteRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Cliente não encontrado"));
        return ClienteMapper.toDTO(cliente);
    }

    public ClienteResponseDTO criarCliente(ClienteRequestDTO dto){

        if(clienteRepository.existsByEmail(dto.email())){
            throw new RuntimeException("Email já cadastrado");
        }

        if(clienteRepository.existsByCpf(dto.cpf())){
            throw new RuntimeException("CPF já cadastrado");
        }

        if(clienteRepository.existsByTelefone(dto.telefone())){
            throw new RuntimeException("Telefone já cadastrado");
        }

        Cliente cliente = ClienteMapper.toEntity(dto);

        if (dto.senha() != null){
            cliente.setPassword(
                    passwordEncoder.encode(dto.senha())
            );
        }

        cliente = clienteRepository.save(cliente);

        return ClienteMapper.toDTO(cliente);
    }

    public ClienteResponseDTO atualizarCliente(Integer id, ClienteRequestDTO dto){
        Cliente cliente = clienteRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException("Cliente não encontrado"));

        cliente.setNome(dto.nome());
        cliente.setEmail(dto.email());
        cliente.setTelefone(dto.telefone());
        cliente.setCidade(dto.cidade());
        cliente.setNumeroCasa(dto.numeroCasa());
        cliente.setBairro(dto.bairro());
        cliente.setSobrenome(dto.sobrenome());
        cliente = clienteRepository.save(cliente);
        if (dto.senha()!= null)
            cliente.setPassword(passwordEncoder.encode(dto.senha()));
        return ClienteMapper.toDTO(cliente);
    }
}
