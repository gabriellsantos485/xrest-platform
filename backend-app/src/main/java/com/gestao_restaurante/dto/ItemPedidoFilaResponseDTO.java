package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.ItemPedidoStatus;

public record ItemPedidoFilaResponseDTO (
        String cardapioName,
        Integer quantidade,
        String observacoes,
        ItemPedidoStatus status,
        Integer pedidoId,
        Integer itemID
){
}
