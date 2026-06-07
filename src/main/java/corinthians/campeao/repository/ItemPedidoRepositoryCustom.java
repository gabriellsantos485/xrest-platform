package corinthians.campeao.repository;

import corinthians.campeao.dto.ItemMaisVendidoDTO;

import java.util.List;

public interface ItemPedidoRepositoryCustom {
    List<ItemMaisVendidoDTO> findItensMaisVendidos();
}
