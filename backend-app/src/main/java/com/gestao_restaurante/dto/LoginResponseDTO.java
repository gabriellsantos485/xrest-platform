package com.gestao_restaurante.dto;

public record LoginResponseDTO(
        String token,
        ClienteResponseDTO cliente
) {
}
