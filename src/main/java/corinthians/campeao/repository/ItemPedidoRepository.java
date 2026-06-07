package corinthians.campeao.repository;

import corinthians.campeao.model.ItemPedido;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ItemPedidoRepository extends JpaRepository<ItemPedido, Integer>, ItemPedidoRepositoryCustom {

    @Query("SELECT i.cardapio.nome, SUM(i.quantidade) FROM ItemPedido i GROUP BY i.cardapio.nome ORDER BY SUM(i.quantidade) DESC")
    List<ItemPedido> consultarItensMaisConsumidos();

    @Query("SELECT i.cardapio.nome, i.status " +
            "FROM ItemPedido i " +
            "WHERE i.status = 'EM_PREPARO' " +
            "GROUP BY i.cardapio.nome, i.status")
    List<ItemPedido> consultarItensEmAndamento();

}