package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.PedidoStatus;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

public record PedidoResponseDTO(
        Integer id,
        Boolean viagem,
        OffsetDateTime criadoEm,
        OffsetDateTime atualizadoEm,
        BigDecimal valorTotal,
        BigDecimal valorPago,
        BigDecimal desconto,
        PedidoStatus status,
        Integer quantidadePessoas,
        Integer clienteId,
        Integer mesaId,
        Integer funcionarioId
) {
}
