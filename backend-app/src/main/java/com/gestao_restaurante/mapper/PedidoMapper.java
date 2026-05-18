package com.gestao_restaurante.mapper;

import com.gestao_restaurante.dto.ItemPedidoResponseDTO;
import com.gestao_restaurante.dto.PedidoRequestDTO;
import com.gestao_restaurante.dto.PedidoResponseDTO;
import com.gestao_restaurante.model.*;
import java.util.stream.Collectors;


public class PedidoMapper {
    public  static Pedido toEntity(PedidoRequestDTO dto, Cliente cliente, Mesa mesa, Funcionario funcionario){
        return Pedido.builder()
                .viagem(dto.viagem())
                .quantidadePessoas(dto.quantidadePessoas())
                .cliente(cliente)
                .mesa(mesa)
                .funcionario(funcionario)
               .build();
    }

    public static PedidoResponseDTO toDTO(Pedido entity){
        return new PedidoResponseDTO(
                entity.getId(),
                entity.getViagem(),
                entity.getCriadoEm(),
                entity.getAtualizadoEm(),
                entity.getValorTotal(),
                entity.getValorPago(),
                entity.getDesconto(),
                entity.getStatus(),
                entity.getQuantidadePessoas(),
                entity.getCliente() != null ? entity.getCliente().getNome() : null,
                entity.getMesa() != null ? entity.getMesa().getId() : null,
                entity.getFuncionario() != null ? entity.getFuncionario().getId() : null,
                entity.getItens().stream()
                        .map(PedidoMapper::toItemResponseDTO)
                        .collect(Collectors.toList())
        );
    }

    public static ItemPedidoResponseDTO toItemResponseDTO(ItemPedido item) {
        return new ItemPedidoResponseDTO(
                item.getId(),
                item.getQuantidade(),
                item.getValorUnitario(),
                item.getValorDescontado(),
                item.getValorTotal(),
                item.getObservacoes(),
                item.getPedido().getId(),
                item.getCardapio().getNome(),
                item.getStatus()
        );
    }
}
