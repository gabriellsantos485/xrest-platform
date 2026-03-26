package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.ClienteRequestDTO;
import com.gestao_restaurante.dto.ClienteResponseDTO;
import com.gestao_restaurante.exception.ClienteNaoEncontradoException;
import com.gestao_restaurante.mapper.ClienteMapper;
import com.gestao_restaurante.model.Cliente;
import com.gestao_restaurante.repository.ClienteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ClienteService {

    private final ClienteRepository clienteRepository;
    private final ClienteMapper clienteMapper;

    public List<ClienteResponseDTO> buscarTodos() {
        return clienteRepository.findAll()
                .stream()
                .map(clienteMapper::paraResponseDTO)
                .toList();
    }

    public ClienteResponseDTO buscarPorId(Long id) {
        Cliente cliente = clienteRepository.findById(id)
                .orElseThrow(() -> new ClienteNaoEncontradoException(id));
        return clienteMapper.paraResponseDTO(cliente);
    }

    public ClienteResponseDTO criar(ClienteRequestDTO dto) {
        if (clienteRepository.existsByEmail(dto.email())) {
            throw new IllegalArgumentException("Email já cadastrado.");
        }
        if (dto.cpf() != null && clienteRepository.existsByCpf(dto.cpf())) {
            throw new IllegalArgumentException("CPF já cadastrado.");
        }
        if (clienteRepository.existsByTelefone(dto.telefone())) {
            throw new IllegalArgumentException("Telefone já cadastrado.");
        }

        Cliente cliente = clienteMapper.paraEntidade(dto);
        return clienteMapper.paraResponseDTO(clienteRepository.save(cliente));
    }

    public ClienteResponseDTO atualizar(Long id, ClienteRequestDTO dto) {
        Cliente cliente = clienteRepository.findById(id)
                .orElseThrow(() -> new ClienteNaoEncontradoException(id));

        cliente.setNome(dto.nome());
        cliente.setSobrenome(dto.sobrenome());
        cliente.setCpf(dto.cpf());
        cliente.setEmail(dto.email());
        cliente.setCidade(dto.cidade());
        cliente.setBairro(dto.bairro());
        cliente.setNumeroCasa(dto.numeroCasa());
        cliente.setRua(dto.rua());
        cliente.setTelefone(dto.telefone());

        if (dto.senha() != null && !dto.senha().isBlank()) {
            cliente.setSenha(clienteMapper.passwordEncoder.encode(dto.senha()));
        }

        return clienteMapper.paraResponseDTO(clienteRepository.save(cliente));
    }

    public void deletar(Long id) {
        if (!clienteRepository.existsById(id)) {
            throw new ClienteNaoEncontradoException(id);
        }
        clienteRepository.deleteById(id);
    }
}
