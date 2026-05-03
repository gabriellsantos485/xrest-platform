package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.Pedido;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public class PedidoRepositoryCustomImpl implements PedidoRepositoryCustom{

    @Autowired
    private PedidoRepository pedidoRepository;

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<Pedido> pedidosPorData(LocalDate data) {
        return entityManager.createQuery("SELECT ped FROM Pedido ped WHERE ped.data = :data", Pedido.class)
                .setParameter("data", data)
                .getResultList();
    }
    public Long quantidadeVendas(LocalDate data){
        return entityManager.createQuery(
                        "SELECT COUNT(p) FROM Pedido p WHERE p.data = :data",
                        Long.class
                )
                .setParameter("data", data)
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
        return entityManager.createQuery(
                        "SELECT SUM(p.total) FROM Pedido p WHERE p.data >= :inicio AND p.data < :fim",
                        BigDecimal.class
                )
                .setParameter("inicio", inicio)
                .setParameter("fim", fim)
                .getSingleResult();
    }
}
