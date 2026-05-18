package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.Funcionario;
import com.gestao_restaurante.model.ItemPedidoStatus;

import java.math.BigDecimal;

public record ItemPedidoResponseDTO(
        Integer id,
        Integer quantidade,
        BigDecimal valorUnitario,
        BigDecimal valorDescontado,
        BigDecimal valorTotal,
        String observacoes,
        Integer pedidoId,
        String cardapioId,
        //Integer funcionarioId,
        ItemPedidoStatus status
) {
}
