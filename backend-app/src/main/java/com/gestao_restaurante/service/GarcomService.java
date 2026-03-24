package com.gestao_restaurante.service;

import com.gestao_restaurante.model.Mesa;

public class GarcomService {

    public void enviarPedidoParaCozinha(int numeroMesa){
        Mesa mesa = selecionarMesa(numeroMesa);
        mesa.enviarPedidoParaCozinha();
    }
}
