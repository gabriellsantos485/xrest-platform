package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.Cardapio;

import java.math.BigDecimal;
import java.util.List;

public record RelatorioResponseDTO(
        Integer quantidadePedidoTotalMes,
        Integer quantidadePedidoCanceladoTotalMes,
        Integer quantidadePedidoDia,
        BigDecimal faturamentoMes,
        BigDecimal faturamentoAnual,
        List<ItensMaisVendidosResponseDTO> maisVendidos
) {
}
