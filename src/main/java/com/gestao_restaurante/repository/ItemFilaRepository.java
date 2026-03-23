package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.ItemFila;
import com.gestao_restaurante.model.ItemPedido;
import java.util.ArrayList;

public class ItemFilaRepository {
    private ArrayList <ItemFila> filaPedidos;

    public ItemFilaRepository(){
        filaPedidos = new ArrayList<>();
    }

    public void receberItem(ItemPedido item){
        filaPedidos.add(item);
    }
    public void visualizarFila(){
        for(ItemFila i : filaPedidos){
            System.out.println(i.getQuantidade() +
                               i.getItem() +
                               i.getObservacao()
                                );
        }
    }
}
