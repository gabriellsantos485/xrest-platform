package com.gestao_restaurante.dto;

public record PedidoFormaPagamentoRequestDTO(
        Integer formaPagamentoId,
        Double valor
) {
}
