package corinthians.campeao.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;



@Repository
public class PedidoRepositoryCustomImpl implements PedidoRepositoryCustom {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public BigDecimal sumValorByData(LocalDate data) {
        String sql = "SELECT SUM(p.valorTotal) FROM Pedido p WHERE CAST(p.criadoEm AS date) = :data";
        return entityManager.createQuery(sql, BigDecimal.class)
                .setParameter("data", data)
                .getSingleResult();
    }

    @Override
    public BigDecimal sumValorByDataHoraBetween(OffsetDateTime inicio, OffsetDateTime fim) {
        String sql = "SELECT SUM(p.valorTotal) FROM Pedido p WHERE p.criadoEm BETWEEN :inicio AND :fim";
        return entityManager.createQuery(sql, BigDecimal.class)
                .setParameter("inicio", inicio)
                .setParameter("fim", fim)
                .getSingleResult();
    }

}