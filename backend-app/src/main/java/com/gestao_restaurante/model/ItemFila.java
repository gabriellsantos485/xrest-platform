package com.gestao_restaurante.model;

public class ItemFila extends ItemPedido{

    public ItemFila(Cardapio item, int quantidade, String observacao){
        super(item, quantidade, observacao);
    }

    @Override
    public Cardapio getItem() {
        return super.getItem();
    }

    @Override
    public void setItem(Cardapio item) {
        super.setItem(item);
    }

    @Override
    public int getQuantidade() {
        return super.getQuantidade();
    }

    @Override
    public void setQuantidade(int quantidade) {
        super.setQuantidade(quantidade);
    }

    @Override
    public String getObservacao() {
        return super.getObservacao();
    }

    @Override
    public void setObservacao(String observacao) {
        super.setObservacao(observacao);
    }

    public void enviarItemProntoParaGarcom() {

    }
}

