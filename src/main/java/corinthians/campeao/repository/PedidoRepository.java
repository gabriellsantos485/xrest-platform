package corinthians.campeao.repository;

import corinthians.campeao.model.Pedido;
import corinthians.campeao.model.PedidoStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;


public interface PedidoRepository extends JpaRepository<Pedido, Integer>, PedidoRepositoryCustom {


    //Como criadoEm é OffsetDateTime, a comparação direta com LocalDate pode exigir cast ou @Query
    @Query("SELECT p FROM Pedido p WHERE CAST(p.criadoEm AS date) = :date")
    List<Pedido> findByCriadoEmData(LocalDate date);

    @Query("SELECT COUNT(p) FROM Pedido p WHERE CAST(p.criadoEm AS date) = :date")
    Long countByCriadoEmData(LocalDate date);

    // findByStatus precisa receber o status por parâmetro
    List<Pedido> findByStatus(PedidoStatus status);

    @Query("SELECT p FROM Pedido p WHERE p.status = :status AND CAST(p.criadoEm AS date) = :data")
    List<Pedido> pedidosByStatusAndData(@Param("status") PedidoStatus status, @Param("data") LocalDate data);

    @Query("SELECT COUNT(p) FROM Pedido p WHERE p.status = :status")
    Long countByStatus(PedidoStatus status);

    // Calcula o valor total dividido pela quantidade de pedidos do dia
    @Query("SELECT AVG(p.valorTotal) FROM Pedido p WHERE p.criadoEm = :data AND p.status != 'CANCELADO'")
    BigDecimal calcularValorMedio(LocalDate data);
}
