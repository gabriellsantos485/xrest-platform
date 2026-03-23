package com.gestao_restaurante.model;

public class ItemPedido {

    private Cardapio item;
    private int quantidade;
    private String observacao;

    //Constructor
    public ItemPedido(Cardapio item, int quantidade, String observacao){
        this.item = item;
        this.quantidade = quantidade;
        this.observacao = observacao.equals("")? "Sem observacoes": observacao;
    }//End Constructor

    public double subTotal(){
        return item.getPreco() * quantidade;
    }

    //Getters and Setters
    public Cardapio getItem() {
        return item;
    }

    public void setItem(Cardapio item) {
        this.item = item;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }

    public String getObservacao() {
        return observacao;
    }

    public void setObservacao(String observacao) {
        this.observacao = observacao;
    }//End Getters and Setters

    //ToString '
    @java.lang.Override
    public java.lang.String toString() {
        return "ItemPedido{" +
                "item=" + item +
                ", quantidade=" + quantidade +
                ", observacao='" + observacao + '\'' +
                '}';
    }//End ToString

}
