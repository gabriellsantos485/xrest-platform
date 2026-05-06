package com.gestao_restaurante.mapper;

import com.gestao_restaurante.dto.PedidoRequestDTO;
import com.gestao_restaurante.dto.PedidoResponseDTO;
import com.gestao_restaurante.model.Cliente;
import com.gestao_restaurante.model.Funcionario;
import com.gestao_restaurante.model.Mesa;
import com.gestao_restaurante.model.Pedido;
import com.gestao_restaurante.repository.ClienteRepository;

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
                entity.getCliente().getId(),
                entity.getMesa().getId(),
                entity.getFuncionario().getId()
        );
    }

}
