package com.gestao_restaurante.dto;

public record ItemPedidoRequestDTO(
        Integer quantidade,
        String observacoes,
        Integer cardapioId
) {
}
