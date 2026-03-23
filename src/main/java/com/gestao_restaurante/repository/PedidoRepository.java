package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.ItemPedido;

import java.util.ArrayList;

public class PedidoRepository {

    private ArrayList <ItemPedido> itens;

    public PedidoRepository(){
        itens = new ArrayList<>();
    }

    public void adicionarItem(ItemPedido item){
        itens.add(item);
    }

}
