package com.gestao_restaurante.repository;
import com.gestao_restaurante.model.Cardapio;
import com.gestao_restaurante.model.Categoria;
import org.springframework.boot.web.error.Error;
import java.util.ArrayList;

public class CardapioRepository {

    private ArrayList <Cardapio> itensCardapio;

    public CardapioRepository() {
        this.itensCardapio = new ArrayList<>();
    }

    public boolean adicionarItemCardapio(int codigo, String nome, Categoria categoria, String urlFoto, double preco){
        for(Cardapio i : itensCardapio){
            if(i.getCodigo() == codigo){
                throw new Error("Valor existente! O codigo precisa ser unico");
                return false;
            }
        }
        itensCardapio.add(new Cardapio(codigo, nome, categoria, urlFoto, preco));
        return true;
    }

    public boolean excluirItemCardapio(int codigo){
        for(Cardapio i : itensCardapio){
            if(i.getCodigo() == codigo){
                return true;
            }
        }
        return false;
    }

    public boolean atualizarItemCardapio(int codigo,
                                        String nome,
                                        Categoria categoria,
                                        String urlFoto,
                                        double preco){
        for(Cardapio i : itensCardapio){
            if(i.getCodigo() == codigo){
                i.setNome(nome);
                i.setCategoria(categoria);
                i.setUrlFoto(urlFoto);
                i.setPreco(preco);
                return true;
            }
        }
        return false;
    }

    public void listarItensCardapio(){
        for(Cardapio i: itensCardapio){
            System.out.println(i.getCodigo() +
                               i.getNome() +
                               i.getCategoria() +
                               i.getUrlFoto() + "\n"
                                )
        }
    }

    public Cardapio buscarItemCardapioCodigo(int codigo){
        for(Cardapio i : itensCardapio){
            if(i.getCodigo() == codigo)
                return i;
        }
        return null;
    }

}
