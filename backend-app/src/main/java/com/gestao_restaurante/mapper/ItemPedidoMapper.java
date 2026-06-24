package com.gestao_restaurante.mapper;

import com.gestao_restaurante.dto.ItemPedidoFilaResponseDTO;
import com.gestao_restaurante.dto.ItemPedidoRequestDTO;
import com.gestao_restaurante.model.Cardapio;
import com.gestao_restaurante.model.ItemPedido;
import com.gestao_restaurante.model.Pedido;
import java.math.BigDecimal;

public class ItemPedidoMapper {

    public static ItemPedido toEntity(
            ItemPedidoRequestDTO dto,
            Cardapio produto,
            BigDecimal valorTotal,
            BigDecimal valorDescontado,
            BigDecimal valorUnitario,
            Pedido pedido){
        return ItemPedido.builder()
                .quantidade(dto.quantidade())
                .valorUnitario(valorUnitario)
                .valorDescontado(valorDescontado)
                .valorTotal(valorTotal)
                .observacoes(dto.observacoes())
                .pedido(pedido)
                .cardapio(produto).build();
    }

    public static ItemPedidoFilaResponseDTO toDto(ItemPedido itemPedido) {
        return new ItemPedidoFilaResponseDTO(
                itemPedido.getCardapio().getNome(), // Buscando o nome do prato/bebida através do relacionamento
                itemPedido.getQuantidade(),
                itemPedido.getObservacoes(),
                itemPedido.getStatus(),
                itemPedido.getPedido().getId(),
                itemPedido.getId()
        );
    }
}
