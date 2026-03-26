package com.gestao_restaurante.service;

import com.gestao_restaurante.model.ItemFila;

public class CozinhaService {
    public void enviarItemProntoParaGarcom(ItemFila itemfila){
        itemfila.enviarItemProntoParaGarcom();
    }
}
