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

        public PedidoService(PedidoRepository pedidoRepository, MesaRepository mesaRepository){
            this.mesaRepository = mesaRepository;
            this.pedidoRepository = pedidoRepository;
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
        /* ADICIONAR ITENS INCOMPLETE DUE TO NOT KNOWING HOW TO DO
        public void adicionarItens(Integer id){
            Pedido pedido = pedidoRepository.findById(id).orElseThrow();
        }
       */
        public Optional<Pedido> consultarPedido(Integer codigoPedido){ // Recebe codigo do pedido
            return pedidoRepository.findById(codigoPedido);
        }

        public void cancelarPedido(Integer codigoPedido) {
            Pedido pedido = pedidoRepository.findById(codigoPedido).
                            orElseThrow(() -> new NoSuchElementException("\nERRO - Pedido não encontrado!!\n"));
            pedido.setStatus(PedidoStatus.CANCELADO);
            pedidoRepository.save(pedido);
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


