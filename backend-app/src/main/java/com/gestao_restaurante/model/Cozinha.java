package com.gestao_restaurante.model;

import java.util.ArrayList;

public class Cozinha extends Usuario{

    private ArrayList<ItemPedido> filaPedidos;
    private StatusPedido status;

    public Cozinha(String login, String senha, String username){
        super(login, senha, username);
    }
    public void visualizarFila(){
        for(ItemPedido i: filaPedidos){
            System.out.println(i);
        }
    }
    public void receberItem(ItemPedido item){
        filaPedidos.add(item);
    }

}
