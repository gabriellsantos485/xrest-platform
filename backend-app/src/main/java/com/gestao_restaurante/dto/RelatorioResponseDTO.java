package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.*;

import java.util.List;
import java.util.Map;

public record RelatorioResponseDTO(
        List<Pedido> pedidos,
        List<Mesa> mesas,
        List<Cliente> clientes,
        List<ItemPedido> itensMaisVendidos,
        Map<ItemPedido, Double> tempoMedio,
        List<Garcom> garcons
) {}
