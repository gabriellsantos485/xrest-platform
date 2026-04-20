package com.gestao_restaurante.mapper;

import com.gestao_restaurante.dto.PedidoRequestDTO;
import com.gestao_restaurante.dto.PedidoResponseDTO;
import com.gestao_restaurante.model.Pedido;

public class PedidoMapper {

    public static Pedido toEntity(PedidoRequestDTO dto){
        return Pedido.builder()
                .criadoEm(dto.criadoEm())
                .atualizadoEm(dto.atualizadoEm())
                .valorTotal(dto.valorTotal())
                .valorPago(dto.valorPago())
                .status(dto.status())
                .viagem(dto.viagem())
                .desconto(dto.desconto())
                .quantidadePessoas(dto.quantidadePessoas())
                .cliente(dto.cliente())
                .mesa(dto.mesa())
                .funcionario(dto.funcionario())
                .itensPedido(dto.itensPedido())
                .build();
    }

    public static PedidoResponseDTO toDTO(Pedido entity){
        return new PedidoResponseDTO(
                entity.getId(),
                entity.getCriadoEm(),
                entity.getAtualizadoEm(),
                entity.getValorTotal(),
                entity.getValorPago(),
                entity.getStatus(),
                entity.getViagem(),
                entity.getDesconto(),
                entity.getQuantidadePessoas(),
                entity.getCliente(),
                entity.getMesa(),
                entity.getFuncionario(),
                entity.getItensPedido()
        );
    }
}
