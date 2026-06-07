package corinthians.campeao.dto;

import corinthians.campeao.model.ItemPedido;
import corinthians.campeao.model.Pedido;

import java.math.BigDecimal;
import java.util.List;

public record RelatorioResponseDTO(
        List<Pedido> pedidos,
        Long quantidadeVendas,
        BigDecimal valorTotalVendas,
        Long pedidoPorStatus,
        BigDecimal valorPorHora,
        BigDecimal bigDecimal, List<ItemMaisVendidoDTO> itensMaisVendidos,
        List<ItemPedido> itemPedidos) {}
