package com.gestao_restaurante.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.util.List;

public record PedidoRequestDTO(
        Boolean viagem,

        Integer quantidadePessoas,

        @NotNull(message = "Cliente é obrigatório")
        Integer clienteId,

        @NotNull(message = "Mesa é obrigatório")
        Integer mesaId,

        Integer funcionarioId,
        List<ItemPedidoRequestDTO> itensPedido
) {
}
