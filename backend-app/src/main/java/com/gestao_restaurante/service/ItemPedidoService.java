package com.gestao_restaurante.service;

import com.gestao_restaurante.model.Cardapio;
import com.gestao_restaurante.model.ItemPedido;
import com.gestao_restaurante.model.ItemPedidoStatus;
import com.gestao_restaurante.repository.ItemPedidoRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
public class ItemPedidoService {

    private ItemPedidoRepository itemPedidoRepository;
    private List<ItemPedido> itensCardapio;

    public ItemPedidoService( ItemPedidoRepository itemPedidoRepository, List<ItemPedido> itensCardapio){
        this.itemPedidoRepository = itemPedidoRepository;
        this.itensCardapio = itensCardapio;
    }

    public BigDecimal calcularSubTotal(ItemPedido itemPedido){
        Cardapio cardapio = itemPedido.getCardapio();
        return cardapio.getValorUnidade().multiply(BigDecimal.valueOf(itemPedido.getQuantidade()));
    }

    public void registrarEntrega(ItemPedido itempedido){
            itempedido.setStatus(ItemPedidoStatus.PRONTO);
            itemPedidoRepository.save(itempedido);
    }

    public List<ItemPedido> consultarItensAndamento() {
        if (!this.itensCardapio.isEmpty()) {
            List<ItemPedido> emAndamento = new ArrayList<>();
            for (ItemPedido i : itensCardapio) {
                if (i.getStatus() == ItemPedidoStatus.EM_PREPARO) {
                    emAndamento.add(i);
                }
            }
            return emAndamento;
        }
        return null;
    }
}
