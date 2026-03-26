package com.gestao_restaurante.dto;

import java.time.LocalDateTime;

// senha nunca é retornada na resposta
public record ClienteResponseDTO(
        Long id,
        String nome,
        String sobrenome,
        String cpf,
        String email,
        String cidade,
        String bairro,
        String numeroCasa,
        String rua,
        String telefone,
        LocalDateTime criadoEm
) {}