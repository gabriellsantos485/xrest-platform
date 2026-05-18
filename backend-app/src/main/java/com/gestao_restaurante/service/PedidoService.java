package com.gestao_restaurante.service;


import com.gestao_restaurante.dto.*;
import com.gestao_restaurante.mapper.*;
import com.gestao_restaurante.model.*;
import com.gestao_restaurante.repository.*;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import com.gestao_restaurante.dto.*;
import com.gestao_restaurante.mapper.PedidoMapper;
import com.gestao_restaurante.model.*;
import com.gestao_restaurante.repository.*;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PedidoService {

    private final PedidoRepository pedidoRepository;
    private final CardapioRepository cardapioRepository;
    private final MesaRepository mesaRepository;
    private final FuncionarioRepository funcionarioRepository;
    private final ClienteRepository clienteRepository;
    private final ItemPedidoRepository itemPedidoRepository;

    @Transactional
    public PedidoResponseDTO abrirPedido(PedidoRequestDTO dto, Integer mesaId) {
        Pedido pedido = Pedido.builder()
                .criadoEm(OffsetDateTime.now())
                .status(PedidoStatus.ABERTO)
                .valorTotal(BigDecimal.ZERO)
                .viagem(dto.viagem())
                .quantidadePessoas(dto.quantidadePessoas())
                .funcionario(dto.funcionarioId() != null ? funcionarioRepository.findById(dto.funcionarioId()).orElseThrow() : null)
                .cliente(dto.clienteId() != null ? clienteRepository.findById(dto.clienteId()).orElseThrow() : null)
                .itens(new ArrayList<>())
                .build();

        if (mesaId != null) {
            Mesa mesa = mesaRepository.findById(mesaId).orElseThrow();
            mesa.setStatus(MesaStatus.OCUPADA);
            pedido.setMesa(mesa);
            mesaRepository.save(mesa);
        }

        if (dto.itensPedido() != null && !dto.itensPedido().isEmpty()) {
            BigDecimal totalPedido = BigDecimal.ZERO;

            for (ItemPedidoRequestDTO itemDto : dto.itensPedido()) {
                Cardapio cardapio = cardapioRepository.findById(itemDto.cardapioId()).orElseThrow();
                BigDecimal valorTotalItem = cardapio.getValorUnidade().multiply(BigDecimal.valueOf(itemDto.quantidade()));

                ItemPedido item = ItemPedido.builder()
                        .pedido(pedido)
                        .cardapio(cardapio)
                        .quantidade(itemDto.quantidade())
                        .valorUnitario(cardapio.getValorUnidade())
                        .valorTotal(valorTotalItem)
                        .status(ItemPedidoStatus.EM_PREPARO)
                        .observacoes(itemDto.observacoes())
                        .build();

                pedido.getItens().add(item);
                totalPedido = totalPedido.add(valorTotalItem);
            }

            pedido.setValorTotal(totalPedido);
        }


        Pedido salvo = pedidoRepository.save(pedido);
        return PedidoMapper.toDTO(salvo);
    }

    @Transactional(readOnly = true)
    public List<PedidoResponseDTO> listarPedidos() {
        return pedidoRepository.findAll().stream()
                .map(PedidoMapper::toDTO)
                .collect(Collectors.toList());
    }

    public PedidoResponseDTO consultarPedido(Integer id) {
        return PedidoMapper.toDTO(consultarPedidoEntity(id));
    }

    @Transactional
    public void fecharPedido(Integer id) {
        Pedido pedido = consultarPedidoEntity(id);
        pedido.setStatus(PedidoStatus.CONCLUÍDO);
        pedido.setAtualizadoEm(OffsetDateTime.now());

        if (pedido.getMesa() != null) {
            pedido.getMesa().setStatus(MesaStatus.LIVRE); //
        }

        pedidoRepository.save(pedido);
    }

    @Transactional
    public PedidoResponseDTO adicionarItens(Integer pedidoId, List<ItemPedidoRequestDTO> itensDTO) {
        Pedido pedido = consultarPedidoEntity(pedidoId);

        if (!"ABERTO".equals(pedido.getStatus())) {
            throw new IllegalStateException("Não é possível adicionar itens a um pedido não aberto.");
        }

        for (ItemPedidoRequestDTO dto : itensDTO) {
            Cardapio cardapio = cardapioRepository.findById(dto.cardapioId()).orElseThrow();
            BigDecimal valorItemTotal = cardapio.getValorUnidade().multiply(BigDecimal.valueOf(dto.quantidade()));
            ItemPedido item = ItemPedido.builder()
                    .pedido(pedido)
                    .cardapio(cardapio)
                    .quantidade(dto.quantidade())
                    .valorUnitario(cardapio.getValorUnidade()) // Snapshot financeiro
                    .valorTotal(valorItemTotal)
                    .status(ItemPedidoStatus.EM_PREPARO)
                    .observacoes(dto.observacoes())
                    .build();

            pedido.getItens().add(item);
            pedido.setValorTotal(pedido.getValorTotal().add(valorItemTotal));
        }

        Pedido atualizado = pedidoRepository.save(pedido);
        return PedidoMapper.toDTO(atualizado);
    }

    @Transactional
    public void cancelarPedido(Integer id) {
        Pedido pedido = consultarPedidoEntity(id);
        pedido.setStatus(PedidoStatus.CANCELADO);
        pedido.setAtualizadoEm(OffsetDateTime.now());

        if (pedido.getMesa() != null) {
            pedido.getMesa().setStatus(MesaStatus.LIVRE);
        }

        pedidoRepository.save(pedido);
    }

    public BigDecimal dividirValor(Integer pedidoId, Integer numeroPessoas) {
        if (numeroPessoas == null || numeroPessoas <= 0) {
            throw new IllegalArgumentException("O número de pessoas deve ser maior que zero.");
        }
        Pedido pedido = consultarPedidoEntity(pedidoId);
        return pedido.getValorTotal().divide(BigDecimal.valueOf(numeroPessoas), 2, RoundingMode.HALF_UP);
    }

    @Transactional(readOnly = true)
    public List<PedidoResponseDTO> listarPedidosPorStatus(String status) {
        return pedidoRepository.findByStatus(status).stream()
                .map(PedidoMapper::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<PedidoResponseDTO> listarPedidosPorData(OffsetDateTime dataInicio, OffsetDateTime dataFim) {
        return pedidoRepository.findByCriadoEmBetween(dataInicio, dataFim).stream()
                .map(PedidoMapper::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<PedidoResponseDTO> listarPedidosPorMesa(Integer mesaId) {
        return pedidoRepository.findByMesaId(mesaId).stream()
                .map(PedidoMapper::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<PedidoResponseDTO> listarPedidosPorCliente(Integer clienteId) {
        return pedidoRepository.findByClienteId(clienteId).stream()
                .map(PedidoMapper::toDTO)
                .collect(Collectors.toList());
    }

    private Pedido consultarPedidoEntity(Integer id) {
        return pedidoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pedido não encontrado: " + id));
    }
}