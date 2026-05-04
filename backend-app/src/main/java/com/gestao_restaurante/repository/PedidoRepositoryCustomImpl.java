package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.Mesa;
import com.gestao_restaurante.model.MesaStatus;
import com.gestao_restaurante.model.Pedido;
import com.gestao_restaurante.model.PedidoStatus;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Repository
public class PedidoRepositoryCustomImpl implements PedidoRepositoryCustom{

    @Autowired
    private PedidoRepository pedidoRepository;

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<Pedido> pedidosPorData(LocalDate data) {
        OffsetDateTime criadoEm = data.atStartOfDay().atOffset(ZoneOffset.UTC);

        return entityManager.createQuery("SELECT ped FROM Pedido ped WHERE ped.data = :criadoEm", Pedido.class)
                .setParameter("criadoEm", criadoEm)
                .getResultList();
    }
    public Long quantidadeVendas(LocalDate data){
        OffsetDateTime criadoEm = data.atStartOfDay().atOffset(ZoneOffset.UTC);

        return entityManager.createQuery(
                        "SELECT COUNT(p) FROM Pedido p WHERE p.data = :criadoEm",
                        Long.class
                )
                .setParameter("criadoEm", criadoEm)
                .getSingleResult();
    }

    public BigDecimal valorTotalVendas(LocalDate data){
        return entityManager.createQuery(
                        "SELECT SUM(p.total) FROM Pedido p WHERE p.data = :data",
                        BigDecimal.class
                )
                .setParameter("data", data)
                .getSingleResult();
    }

    public BigDecimal pedidosPorHora(LocalDateTime inicio, LocalDateTime fim){
        BigDecimal total =  entityManager.createQuery(
                        "SELECT SUM(p.total) FROM Pedido p WHERE p.data >= :inicio AND p.data < :fim",
                        BigDecimal.class
                )
                .setParameter("inicio", inicio)
                .setParameter("fim", fim)
                .getSingleResult();

        return total != null ? total : BigDecimal.ZERO;
    }

    public List<Pedido> pedidosEmAndamento(){
        return entityManager.createQuery(
                "SELECT ped FROM Pedido ped WHERE ped.status = :status",
                    Pedido.class
        )
                .setParameter("status", PedidoStatus.EM_ANDAMENTO )
                .getResultList();
    }

    public List<Pedido> pedidosCancelados(LocalDate data){

        OffsetDateTime inicio = data.atStartOfDay().atOffset(ZoneOffset.UTC);
        OffsetDateTime fim = inicio.plusDays(1);

        return entityManager.createQuery(
                        "SELECT ped FROM Pedido ped WHERE ped.status = :status AND ped.data >= :inicio AND ped.data <= :fim",
                        Pedido.class
                )
                .setParameter("status", PedidoStatus.CANCELADO)
                .setParameter("inicio", inicio)
                .setParameter("fim", fim)
                .getResultList();
    }

    public String escolherMesa(Integer id){
        try {
            entityManager.createQuery(
                            "SELECT mesa FROM Mesa mesa WHERE mesa.id = :id AND mesa.status = :status",
                            Mesa.class
                    )
                    .setParameter("id", id)
                    .setParameter("status", MesaStatus.LIVRE)
                    .getSingleResult();

            return "Sucesso";

        } catch (NoResultException e) {
            return "Mesa nao disponivel";
        }
    }
}
