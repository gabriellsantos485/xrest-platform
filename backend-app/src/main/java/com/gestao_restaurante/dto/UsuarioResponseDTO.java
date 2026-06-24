package com.gestao_restaurante.dto;

public record UsuarioResponseDTO(
        Integer id,
        String nome,
        String sobrenome,
        String email,
        String role
) {
}
