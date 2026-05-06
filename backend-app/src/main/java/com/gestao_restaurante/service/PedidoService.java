package com.gestao_restaurante.service;


import com.gestao_restaurante.dto.*;
import com.gestao_restaurante.mapper.*;
import com.gestao_restaurante.model.*;
import com.gestao_restaurante.repository.*;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
public class PedidoService {
    /*
    * Constrói o pedido em memória
    * */

    PedidoRepository pedidoRepository;
    ItemPedidoRepository itemPedidoRepository;
    ClienteRepository clienteRepository;
    MesaRepository mesaRepository;
    FuncionarioRepository funcionarioRepository;
    CardapioRepository cardapioRepository;
    ItemPedidoService itemPedidoService;

    public PedidoService(PedidoRepository pedidoRepository, ItemPedidoRepository itemPedidoRepository,
                         ClienteRepository clienteRepository,
                         MesaRepository mesaRepository,
                         FuncionarioRepository funcionarioRepository,
                         CardapioRepository cardapioRepository,
                         ItemPedidoService itemPedidoService)
    {
        this.pedidoRepository = pedidoRepository;
        this.itemPedidoRepository = itemPedidoRepository;
        this.clienteRepository = clienteRepository;
        this.mesaRepository = mesaRepository;
        this.funcionarioRepository = funcionarioRepository;
        this.cardapioRepository = cardapioRepository;
        this.itemPedidoService = itemPedidoService;
    }

    @Transactional
    public void criar(PedidoRequestDTO dto, Integer mesaId){

        Cliente cliente = clienteRepository.findById(dto.clienteId())
                .orElseThrow(() -> new RuntimeException("Cliente não encontrado"));

        Mesa mesa = mesaRepository.findById(mesaId)
                .orElseThrow(() -> new RuntimeException("Mesa não existe"));

        Funcionario funcionario = null;
        if (dto.funcionarioId() != null) {
            funcionario = funcionarioRepository.findById(dto.funcionarioId())
                    .orElseThrow(() -> new RuntimeException("Funcionário não encontrado"));
        }

        Pedido pedido = PedidoMapper.toEntity(dto, cliente, mesa, funcionario);
        List<ItemPedido> itens = itemPedidoService.criar(dto.itensPedido(), pedido);

        pedido.setValorTotal(calcularValorTotal(itens));
        pedido.setDesconto(calcularDesconto(itens));

        pedidoRepository.save(pedido);
        itemPedidoRepository.saveAll(itens);
    }

    public BigDecimal calcularValorTotal(List<ItemPedido> listaItens){
        BigDecimal valorTotal = BigDecimal.ZERO;

        for (ItemPedido item : listaItens){
            valorTotal = valorTotal.add(item.getValorTotal());
        }

        return valorTotal;
    }


    private BigDecimal calcularDesconto(List<ItemPedido> listaItens){
        BigDecimal valorTotal = BigDecimal.ZERO;

        for (ItemPedido item : listaItens){
            valorTotal = valorTotal.add(item.getValorDescontado());
        }
        return valorTotal;
    }

}


