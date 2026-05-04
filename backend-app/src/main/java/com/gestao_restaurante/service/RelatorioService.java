package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.RelatorioResponseDTO;
import com.gestao_restaurante.repository.*;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;

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

        LocalDate hoje = LocalDate.now();
        LocalDateTime agora = LocalDateTime.now();

        return new RelatorioResponseDTO(
                pedidoRepository.pedidosPorData(hoje),
                pedidoRepository.quantidadeVendas(hoje),
                pedidoRepository.valorTotalVendas(hoje),
                pedidoRepository.pedidosPorHora(
                        agora.minusHours(1),
                        agora
                ),
                itemPedidoRepository.itensMaisVendidos()
        );
    }
}

