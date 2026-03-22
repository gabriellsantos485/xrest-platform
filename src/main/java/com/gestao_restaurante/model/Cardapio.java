package com.gestao_restaurante.model;

public class Cardapio {

    private int codigo;
    private String nome;
    private Categoria categoria;
    private String urlFoto;
    private double preco;

    //Constructor
    public Cardapio(int codigo, String nome, Categoria categoria, String urlFoto, double preco) {
        this.codigo = codigo;
        this.nome = nome;
        this.categoria = categoria;
        this.urlFoto = urlFoto;
        this.preco = preco;
    }//End Constructor

    //Getters and Setters
    public int getCodigo() {
        return codigo;
    }

    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getUrlFoto() {
        return urlFoto;
    }

    public void setUrlFoto(String urlFoto) {
        this.urlFoto = urlFoto;
    }

    public double getPreco() {
        return preco;
    }

    public void setPreco(double preco) {
        this.preco = preco;
    }//End Getters and Setters

    //ToString
    @java.lang.Override
    public java.lang.String toString() {
        return "ItemCardapio{" +
                "codigo=" + codigo +
                ", nome='" + nome + '\'' +
                ", categoria='" + categoria + '\'' +
                ", urlFoto='" + urlFoto + '\'' +
                ", preco=" + preco +
                '}';
    }//End ToString
}
