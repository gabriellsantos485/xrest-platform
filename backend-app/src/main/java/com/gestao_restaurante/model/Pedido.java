package com.gestao_restaurante.model;

import com.gestao_restaurante.repository.PedidoRepository;
import jakarta.persistence.GeneratedValue;

public class Pedido {

    private int codigo;
    private double Valortotal;
    private String data;

    //Constructor
    public Pedido(){

    }//End Constructor

    public double total(){
        for(ItemPedido i : itens)
            Valortotal += i.subTotal();
        return Valortotal;
    }

    public void mostrarPedido(){
        System.out.println("\n=============Pedido Atual=============");
        if(itens.isEmpty()){
            System.out.println("Nenhum item no pedido");
            return;
        }
        for(ItemPedido i : itens){
            System.out.println(i);
            System.out.println("=============");
            System.out.println("Total: R$" + total());
            System.out.println("=============");
        }
    }
    public ItemPedido getItemPedido(int index){
        return itens.index(index);
    }

    //Getters and Setters
    public double getValorTotal(){
        return Valortotal;
    }
    public void setValortotal(double valortotal) {
        Valortotal = valortotal;
    }
    public String getData() {
        return data;
    }
    public void setData(String data) {
        this.data = data;
    }//End Getters and Setters
    public int getCodigo() {return codigo;}
    public void setCodigo(int codigo) {this.codigo = codigo;}

    //ToString
    @Override
    public String toString() {
        return "Pedido{" +
                "codigo=" + codigo +
                ", Valortotal=" + Valortotal +
                ", data='" + data + '\'' +
                '}';
    }//End ToString

}
