package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.ItemPedidoStatus;
import jakarta.validation.constraints.NotBlank;

public record AtualizarStatusItemPedidoRequestDTO(
        @NotBlank(message = "Valor não pode ser nulo")
        ItemPedidoStatus novoStatus
) {
}
