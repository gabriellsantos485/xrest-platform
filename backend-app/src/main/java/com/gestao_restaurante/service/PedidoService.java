package com.gestao_restaurante.service;


import com.gestao_restaurante.model.ItemPedido;
import com.gestao_restaurante.model.Pedido;
import com.gestao_restaurante.repository.MesaRepository;
import com.gestao_restaurante.repository.PedidoRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Objects;
import java.util.Optional;

@Service
public class PedidoService {

        private PedidoRepository pedidoRepository;
        private MesaRepository mesaRepository;
        private List<Pedido> pedidos;
        private Pedido pedido;

        public PedidoService(PedidoRepository pedidoRepository, MesaRepository mesaRepository, List<Pedido> pedidos){
            this.mesaRepository = mesaRepository;
            this.pedidoRepository = pedidoRepository;
            this.pedidos = pedidos;
        }

        public Pedido abrirPedido(){
            return new Pedido();
        }
        /*
        public void escolherMesa(Integer numero){
            mesaRepository.findById(numero).
                    orElseThrow(() -> new NoSuchElementException("\nERRO - Mesa não encontrada!!\n"));

        }*/

        public int adicionarItens(ItemPedido itemPedido){
            if(!pedidos.isEmpty()) {
                Integer pedidoId = itemPedido.getPedido().getId();
                for (Pedido p : pedidos) {
                    if (Objects.equals(p.getId(), pedidoId)) {
                        p.getItensPedido().add(itemPedido); //a ordem em que os itens são alocados talvez n importe tanto
                        return 0; // encontrou! o pedido já estava aberto
                    }
                }
                pedidos.addLast(abrirPedido());
                return 1; // lista tem alguns itens, mas nenhum com o id procurado. Então criou um novo pedido no fim da lista
            }
            pedidos.addFirst(abrirPedido());
            return -1; // lista vazia, então criou o primeiro pedido da lista
        }

        public Optional<Pedido> consultarPedido(Integer codigoPedido){ // recebe codigo do pedido
                for (Pedido p : pedidos) {  // itera na lista
                    if (Objects.equals(p.getId(), codigoPedido)) { // busca um pedido com código igual ao número passado
                        return Optional.of(p);
                    }
                }
            return Optional.empty(); //nao encontrou o codigo do pedido
        }

        public void cancelarPedido(Integer codigoPedido) {
            pedidos.remove(consultarPedido(codigoPedido).
                            orElseThrow(() -> new NoSuchElementException("\nERRO - Pedido não encontrado!!\n")));
        }

        public void fecharPedido(Integer codigoPedido){
            Pedido pedido = consultarPedido(codigoPedido).
                            orElseThrow(() -> new NoSuchElementException("\nERRO - Pedido não encontrado!!\n"));
            pedidoRepository.save(pedido);
        }

        public BigDecimal dividirValor(Pedido pedido){
            return pedido.getValorTotal().divide(BigDecimal.valueOf(pedido.getQuantidadePessoas()), 2);
        }

        public List<Pedido> verFilaPedido(){
            return this.pedidos;
        }

        public List<Pedido> verHistoricoPedidos(){
            return pedidoRepository.findAll();
        }

        public BigDecimal vendasPorHora(LocalDate data, int hora) {
            LocalDateTime inicio = data.atTime(hora, 0);
            LocalDateTime fim = inicio.plusHours(1);

            return pedidoRepository.pedidosPorHora(inicio, fim);
        }


}


