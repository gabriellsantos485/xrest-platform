package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.*;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public record RelatorioResponseDTO(
        List<Pedido> pedidos,
        Long quantidadeVendas,
        BigDecimal valorTotalVendas,
        List<ItemMaisVendidoDTO> itensMaisVendidos
) {}
