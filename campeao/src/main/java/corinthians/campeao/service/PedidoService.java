package corinthians.campeao.service;

import corinthians.campeao.dto.PedidoRequestDTO;
import corinthians.campeao.mapper.PedidoMapper;
import corinthians.campeao.model.*;
import corinthians.campeao.repository.MesaRepository;
import corinthians.campeao.repository.PedidoRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Objects;
import java.util.Optional;

@Service
public class PedidoService {

        private PedidoRepository pedidoRepository;
        private MesaRepository mesaRepository;
        private List<Pedido> pedidos;

        public PedidoService(PedidoRepository pedidoRepository, MesaRepository mesaRepository, List<Pedido> pedidos){
            this.mesaRepository = mesaRepository;
            this.pedidoRepository = pedidoRepository;
            this.pedidos = pedidos;
        }

        public Pedido abrirPedido(){
            return pedidoRepository.save(new Pedido());
        }

         @Transactional
        public void escolherMesa(Integer pedidoId, Integer mesaId) {
            // 1. Busca o pedido ou lança exceção se não existir
            Pedido pedido = pedidoRepository.findById(pedidoId)
                .orElseThrow(() -> new EntityNotFoundException("Pedido não encontrado"));

            // 2. Busca a mesa (para garantir que ela existe)
            Mesa mesa = mesaRepository.findById(mesaId)
                    .orElseThrow(() -> new EntityNotFoundException("Mesa não encontrada"));
             mesa.setStatus(MesaStatus.LOTADA);

            // 3. Define a mesa no pedido
            pedido.setMesa(mesa);

            // 4. Salva as alterações
            pedidoRepository.save(pedido);
        }

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
            pedido.setStatus(PedidoStatus.CONCLUÍDO);
            pedidoRepository.save(pedido);
        }

        public BigDecimal dividirValor(PedidoRequestDTO dto){
            Pedido pedido = PedidoMapper.toEntity(dto);
            return pedido.getValorTotal().divide(BigDecimal.valueOf(pedido.getQuantidadePessoas()), 2);
        }


        public List<Pedido> pedidosPorStatusData(PedidoStatus status, LocalDate data){
            return pedidoRepository.pedidosByStatusAndData(status, data);
        }

        public List<Pedido> verHistoricoPedidos(){
            return pedidoRepository.findAll();
        }

        public BigDecimal vendasPorHora(LocalDate data, int hora) {
            OffsetDateTime inicio = OffsetDateTime.from(data.atTime(hora, 0));
            LocalDateTime fim = inicio.plusHours(1).toLocalDateTime();

            return pedidoRepository.sumValorByDataHoraBetween(inicio, OffsetDateTime.from(fim));
        }


}


