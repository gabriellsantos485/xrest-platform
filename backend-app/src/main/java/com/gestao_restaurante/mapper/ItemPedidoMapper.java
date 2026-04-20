package com.gestao_restaurante.mapper;

import com.gestao_restaurante.dto.ItemPedidoRequestDTO;
import com.gestao_restaurante.dto.ItemPedidoResponseDTO;
import com.gestao_restaurante.model.ItemPedido;

public class ItemPedidoMapper {

    public static ItemPedido toEntity(ItemPedidoRequestDTO dto){
        return ItemPedido.builder()
                .quantidade(dto.quantidade())
                .valor_unitario(dto.valor_unitario())
                .valor_total(dto.valor_total())
                .criadoEm(dto.criadoEm())
                .valor_descontado(dto.valor_descontado())
                .observacoes(dto.observacoes())
                .status(dto.status())
                .pedido(dto.pedido())
                .cardapio(dto.cardapio())
                .funcionario(dto.funcionario())
                .funcionario_liberou(dto.funcionario_liberou())
                .build();
    }

    public static ItemPedidoResponseDTO toDTO(ItemPedido entity){
        return new ItemPedidoResponseDTO(
                entity.getId(),
                entity.getQuantidade(),
                entity.getValor_unitario(),
                entity.getValor_total(),
                entity.getCriadoEm(),
                entity.getValor_descontado(),
                entity.getObservacoes(),
                entity.getStatus(),
                entity.getPedido(),
                entity.getCardapio(),
                entity.getFuncionario(),
                entity.getFuncionario_liberou()
        );
    }
}
