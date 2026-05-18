package com.gestao_restaurante.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record FormaPagamentoRequestDTO(

        @NotBlank(message = "O nome da forma de pagamento é obrigatório")
        @Size(max = 20, message = "O nome não pode exceder 20 caracteres")
        String nome
) {}
