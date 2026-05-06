package com.gestao_restaurante.dto;

import java.math.BigDecimal;

public record ItempedidoResponseDTO(
        Integer quantidade,
        BigDecimal valorUnitario,
        BigDecimal valorDescontado,
        BigDecimal valorTotal,
        String observacoes,
        Integer pedidoId,
        Integer cardapioId,
        Integer funcionarioId
) {
}
