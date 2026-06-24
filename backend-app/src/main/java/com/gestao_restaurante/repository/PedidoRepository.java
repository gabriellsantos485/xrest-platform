package com.gestao_restaurante.repository;

import com.gestao_restaurante.dto.ItensMaisVendidosResponseDTO;
import com.gestao_restaurante.model.ItemPedidoStatus;
import com.gestao_restaurante.model.Pedido;
import com.gestao_restaurante.model.PedidoStatus;
import org.springframework.boot.autoconfigure.data.web.SpringDataWebProperties;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.List;

public interface PedidoRepository extends JpaRepository<Pedido, Integer> {
    List<Pedido> findByStatus(String status);
    List<Pedido> findByCriadoEmBetween(OffsetDateTime dataInicio, OffsetDateTime dataFim);
    List<Pedido> findByMesaId(Integer mesaId);
    List<Pedido> findByClienteId(Integer clienteId);
    List<Pedido> findTop10ByClienteIdAndStatusOrderByCriadoEmDesc(Integer clienteId, PedidoStatus status);
    List<Pedido> findByClienteIdAndStatusOrderByCriadoEmDesc(Integer clienteId, PedidoStatus status);

    Integer countByStatusAndCriadoEmBetween(
            PedidoStatus status,
            OffsetDateTime inicio,
            OffsetDateTime fim
    );

    @Query("""
    SELECT COALESCE(SUM(p.valorTotal), 0)
    FROM Pedido p
    WHERE p.status = :status
      AND p.criadoEm >= :inicio
      AND p.criadoEm < :fim
""")
    BigDecimal sumFaturamentoPorPeriodo(
            @Param("status") PedidoStatus status,
            @Param("inicio") OffsetDateTime inicio,
            @Param("fim") OffsetDateTime fim
    );

    @Query("""
    SELECT new com.gestao_restaurante.dto.ItensMaisVendidosResponseDTO(
        i.id,
        i.foto,
        i.nome,
        c.nome,
        SUM(ip.quantidade),
        SUM(CAST(ip.quantidade * ip.valorUnitario AS bigdecimal ))
    )
    FROM ItemPedido ip
    JOIN ip.pedido p
    JOIN ip.cardapio i
    JOIN i.categoria c
    WHERE p.criadoEm >= :inicio
      AND p.criadoEm < :fim
      AND p.status = :status
    GROUP BY i.id, i.nome, c.nome
    ORDER BY SUM(ip.quantidade * ip.valorUnitario) DESC
""")
    List<ItensMaisVendidosResponseDTO> findTopItensPorFaturamento(
            @Param("inicio") OffsetDateTime inicio,
            @Param("fim") OffsetDateTime fim,
            @Param("status") PedidoStatus status,
            Pageable pageable
    );

    @Query("""
    SELECT COUNT(p)
    FROM Pedido p
    WHERE p.criadoEm >= :inicio
      AND p.criadoEm < :fim
""")
    Integer countPedidosNoDia(
            @Param("inicio") OffsetDateTime inicio,
            @Param("fim") OffsetDateTime fim
    );

}
