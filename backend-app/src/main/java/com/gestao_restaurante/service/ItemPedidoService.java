package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.AtualizarStatusItemPedidoRequestDTO;
import com.gestao_restaurante.dto.ItemPedidoFilaResponseDTO;
import com.gestao_restaurante.dto.ItemPedidoRequestDTO;
import com.gestao_restaurante.mapper.ItemPedidoMapper;
import com.gestao_restaurante.model.*;
import com.gestao_restaurante.repository.CardapioRepository;
import com.gestao_restaurante.repository.FuncionarioRepository;
import com.gestao_restaurante.repository.ItemPedidoRepository;
import com.gestao_restaurante.repository.PedidoRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
public class ItemPedidoService {
    private final PedidoRepository pedidoRepository;
    CardapioRepository cardapioRepository;
    FuncionarioRepository funcionarioRepository;
    ItemPedidoRepository itemPedidoRepository;

    public ItemPedidoService(CardapioRepository cardapioRepository,
                             FuncionarioRepository funcionarioRepository,
                             ItemPedidoRepository itemPedidoRepository,
                             PedidoRepository pedidoRepository){
        this.cardapioRepository = cardapioRepository;
        this.funcionarioRepository = funcionarioRepository;
        this.itemPedidoRepository = itemPedidoRepository;
        this.pedidoRepository = pedidoRepository;
    }

    public List<ItemPedido> criar(List<ItemPedidoRequestDTO> itensDTO, Pedido pedido){

        List<ItemPedido> listaItens = new ArrayList<>();

        for (ItemPedidoRequestDTO item : itensDTO){

            Cardapio produto = cardapioRepository.findById(item.cardapioId())
                    .orElseThrow(() -> new RuntimeException("Produto não encontrado"));

            BigDecimal precoUnitario = produto.getValorPromocional() != null
                    ? produto.getValorPromocional()
                    : produto.getValorUnidade();

            BigDecimal subtotal = precoUnitario.multiply(
                    BigDecimal.valueOf(item.quantidade())
            );

            BigDecimal desconto = produto.getValorPromocional() != null
                    ? produto.getValorUnidade()
                    .subtract(produto.getValorPromocional())
                    .multiply(BigDecimal.valueOf(item.quantidade()))
                    : BigDecimal.ZERO;

            ItemPedido itemPedido = ItemPedidoMapper.toEntity(
                    item,
                    produto,
                    subtotal,
                    desconto,
                    produto.getValorUnidade(),
                    pedido
            );

            listaItens.add(itemPedido);
        }

        return listaItens;
    }

    public List<ItemPedidoFilaResponseDTO> listarItens(){
        List<ItemPedidoStatus> status = List.of(
                ItemPedidoStatus.NAO_INICIADO,
                ItemPedidoStatus.EM_PREPARO
        );
        List<ItemPedido> itens = itemPedidoRepository.findByStatusIn(status);
        return itens.stream()
                .map(ItemPedidoMapper::toDto)
                .toList();
    }

    @Transactional
    public ItemPedidoFilaResponseDTO alterarStatus(Integer itemId, AtualizarStatusItemPedidoRequestDTO dto) {
        ItemPedido item = itemPedidoRepository.findById(itemId)
                .orElseThrow(() -> new RuntimeException("Item do pedido não encontrado"));

        // 2. Atualiza o status do item com o valor que veio do Flutter (EM_PREPARO, PRONTO, etc)
        System.out.println("NOVO STATUS: " + dto.novoStatus());
        item.setStatus(dto.novoStatus());

        if (dto.novoStatus() == ItemPedidoStatus.CANCELADO) {
            Pedido pedido = item.getPedido();
            pedido.setValorTotal(pedido.getValorTotal().subtract(item.getValorTotal()));
            pedidoRepository.save(pedido);
        }
        item = itemPedidoRepository.save(item);

        // 3. Monta e retorna o DTO de resposta para o Flutter
        ItemPedidoFilaResponseDTO response = ItemPedidoMapper.toDto(item);
        return response;
    }
}
