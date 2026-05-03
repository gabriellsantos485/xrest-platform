package com.gestao_restaurante.repository;

import com.gestao_restaurante.model.Pedido;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public class PedidoRepositoryCustomImpl implements PedidoRepositoryCustom{
    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public List<Pedido> pedidosPorData(LocalDate data) {
        return entityManager.createQuery("SELECT ped FROM Pedido ped WHERE ped.data = :data", Pedido.class)
                .setParameter("data", data)
                .getResultList();
    }
}
