package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.RelatorioResponseDTO;
import com.gestao_restaurante.repository.*;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
public class RelatorioService{

    private PedidoRepository pedidoRepository;
    private MesaRepository mesaRepository;
    private ClienteRepository clienteRepository;
    private ItemPedidoRepository itemPedidoRepository;
    private CozinhaRepository cozinhaRepository;
    private GarcomRepository garcomRepository;

    public RelatorioService(PedidoRepository pedidoRepository,
                     MesaRepository mesaRepository,
                     ClienteRepository clienteRepository,
                     ItemPedidoRepository itemPedidoRepository,
                     CozinhaRepository cozinhaRepository,
                     GarcomRepository garcomRepository) {

        this.pedidoRepository = pedidoRepository;
        this.mesaRepository = mesaRepository;
        this.clienteRepository = clienteRepository;
        this.itemPedidoRepository = itemPedidoRepository;
        this.cozinhaRepository = cozinhaRepository;
        this.garcomRepository = garcomRepository;
    }

    public RelatorioResponseDTO gerarRelatorio(LocalDate date) {
        return new RelatorioResponseDTO(
                pedidoRepository.pedidosPorData(date),
                mesaRepository.mesasMaisUsadas(),
                clienteRepository.clientesMaisFrequentes(),
                itemPedidoRepository.itensMaisVendidos(),
                cozinhaRepository.itensTempoMedioDePreparo(),
                garcomRepository.garcomVendasMensal()
        );
    }
}

}
