/*package com.gestao_restaurante.repository;
import com.gestao_restaurante.model.Cardapio;
import org.springframework.boot.web.error.Error;

 */

/*
public class ItemCardapioRepository {
    private Arraylist <Cardapio> itensCardapio;

    public ItemCardapioRepository() {
        this.itensCardapio = new ArrayList<>();
    }

    public boolean adicionarItemCardapio(int codigo, String nome, String categoria, String urlFoto){
        for(Cardapio i : itensCardapio){
            if(i.getCodigo() == codigo){
                throw new Error("Valor existente! O codigo precisa ser unico");
                return false;
            }
        }
        itensCardapio.add(new Cardapio(codigo, nome, categoria, urlFoto));
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
}

 */
