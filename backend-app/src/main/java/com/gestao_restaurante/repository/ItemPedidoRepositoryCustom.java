package com.gestao_restaurante.repository;

import com.gestao_restaurante.dto.ItemMaisVendidoDTO;

import java.util.List;

public interface ItemPedidoRepositoryCustom {
    List<ItemMaisVendidoDTO> itensMaisVendidos();
}
