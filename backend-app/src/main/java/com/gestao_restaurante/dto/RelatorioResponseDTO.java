package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.*;
import java.math.BigDecimal;
import java.util.List;

public record RelatorioResponseDTO(
        List<Pedido> pedidos,
        Long quantidadeVendas,
        BigDecimal valorTotalVendas,
        BigDecimal valorPorHora,
        List<ItemMaisVendidoDTO> itensMaisVendidos
) {}
