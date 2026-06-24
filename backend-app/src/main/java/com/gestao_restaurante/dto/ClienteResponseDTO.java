package com.gestao_restaurante.dto;

public record ClienteResponseDTO(
        Integer id,
        String nome,
        String sobrenome,
        String cpf,
        String email,
        String cidade,
        String bairro,
        Integer numeroCasa,
        String rua,
        String telefone
) {}