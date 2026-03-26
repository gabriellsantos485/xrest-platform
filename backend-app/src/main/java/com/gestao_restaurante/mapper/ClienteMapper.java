package com.gestao_restaurante.mapper;

import com.gestao_restaurante.dto.ClienteRequestDTO;
import com.gestao_restaurante.dto.ClienteResponseDTO;
import com.gestao_restaurante.model.Cliente;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ClienteMapper {

    public final PasswordEncoder passwordEncoder;

    public Cliente paraEntidade(ClienteRequestDTO dto) {
        return Cliente.builder()
                .nome(dto.nome())
                .sobrenome(dto.sobrenome())
                .cpf(dto.cpf())
                .email(dto.email())
                .cidade(dto.cidade())
                .bairro(dto.bairro())
                .numeroCasa(dto.numeroCasa())
                .rua(dto.rua())
                .telefone(dto.telefone())
                .senha(passwordEncoder.encode(dto.senha()))
                .build();
    }

    public ClienteResponseDTO paraResponseDTO(Cliente cliente) {
        return new ClienteResponseDTO(
                cliente.getId(),
                cliente.getNome(),
                cliente.getSobrenome(),
                cliente.getCpf(),
                cliente.getEmail(),
                cliente.getCidade(),
                cliente.getBairro(),
                cliente.getNumeroCasa(),
                cliente.getRua(),
                cliente.getTelefone(),
                cliente.getCriadoEm()
        );
    }
}