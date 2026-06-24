package com.gestao_restaurante.dto;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

public record PedidoResumoDTO(
        Integer id,
        String status,
        BigDecimal valorTotal,
        OffsetDateTime dataPedido
) {
}
