package com.gestao_restaurante.dto;

import java.math.BigDecimal;

public record ItemPedidoRequestDTO(
        Integer quantidade,
        String observacoes,
        Integer cardapioId
) {
}
