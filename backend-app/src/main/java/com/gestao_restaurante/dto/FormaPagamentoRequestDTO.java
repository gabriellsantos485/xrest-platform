package com.gestao_restaurante.dto;

import jakarta.validation.constraints.NotBlank;

public record FormaPagamentoRequestDTO(
        @NotBlank(message = "Nome é obrigatório")
        String nome
) {
}
