package com.gestao_restaurante.service;

import com.gestao_restaurante.dto.ItemPedidoRequestDTO;
import com.gestao_restaurante.mapper.ItemPedidoMapper;
import com.gestao_restaurante.model.Cardapio;
import com.gestao_restaurante.model.Funcionario;
import com.gestao_restaurante.model.ItemPedido;
import com.gestao_restaurante.model.Pedido;
import com.gestao_restaurante.repository.CardapioRepository;
import com.gestao_restaurante.repository.FuncionarioRepository;
import com.gestao_restaurante.repository.ItemPedidoRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
public class ItemPedidoService {
    CardapioRepository cardapioRepository;
    FuncionarioRepository funcionarioRepository;
    ItemPedidoRepository itemPedidoRepository;

    public ItemPedidoService(CardapioRepository cardapioRepository,
                             FuncionarioRepository funcionarioRepository,
                             ItemPedidoRepository itemPedidoRepository
    ){
        this.cardapioRepository = cardapioRepository;
        this.funcionarioRepository = funcionarioRepository;
        this.itemPedidoRepository = itemPedidoRepository;
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

}
