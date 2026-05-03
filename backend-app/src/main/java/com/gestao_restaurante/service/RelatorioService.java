package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.RelatorioResponseDTO;
import com.gestao_restaurante.repository.*;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
public class RelatorioService{

    private PedidoRepository pedidoRepository;
    private ItemPedidoRepository itemPedidoRepository;

    public RelatorioService(PedidoRepository pedidoRepository,
                     ItemPedidoRepository itemPedidoRepository) {

        this.pedidoRepository = pedidoRepository;
        this.itemPedidoRepository = itemPedidoRepository;
    }

    public RelatorioResponseDTO gerarRelatorio() {
        return new RelatorioResponseDTO(
                pedidoRepository.pedidosPorData(LocalDate.now()),
                pedidoRepository.quantidadeVendas(LocalDate.now()),
                pedidoRepository.valorTotalVendas(LocalDate.now()),
                itemPedidoRepository.itensMaisVendidos()
        );
    }
}

