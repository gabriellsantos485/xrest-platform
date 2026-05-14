package corinthians.campeao.repository;

import corinthians.campeao.dto.ItemMaisVendidoDTO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public class ItemPedidoRepositoryCustomImpl implements ItemPedidoRepositoryCustom {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<ItemMaisVendidoDTO> findItensMaisVendidos() {
        return entityManager.createQuery(
                        "SELECT new corinthians.campeao.dto.ItemMaisVendidoDTO(" +
                                "i.cardapio.nome, SUM(i.quantidade)) " +
                                "FROM ItemPedido i " +
                                "GROUP BY i.cardapio.nome " +
                                "ORDER BY SUM(i.quantidade) DESC",
                        ItemMaisVendidoDTO.class)
                .getResultList();
    }
}

