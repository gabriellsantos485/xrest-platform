package com.gestao_restaurante.dto;

public record LoginFuncionarioResponseDTO(
        String token,
        FuncionarioResponseDTO funcionarioResponseDTO
) {
}
