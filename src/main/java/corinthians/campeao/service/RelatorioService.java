package corinthians.campeao.service;

import corinthians.campeao.dto.ItemMaisVendidoDTO;
import corinthians.campeao.dto.RelatorioResponseDTO;
import corinthians.campeao.model.ItemPedido;
import corinthians.campeao.model.Pedido;
import corinthians.campeao.model.PedidoStatus;
import corinthians.campeao.repository.ItemPedidoRepository;
import corinthians.campeao.repository.PedidoRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class RelatorioService{

    private PedidoRepository pedidoRepository;
    private ItemPedidoRepository itemPedidoRepository;

    public RelatorioService(PedidoRepository pedidoRepository,
                     ItemPedidoRepository itemPedidoRepository) {

        this.pedidoRepository = pedidoRepository;
        this.itemPedidoRepository = itemPedidoRepository;
    }

    public RelatorioResponseDTO gerarRelatorio() {

        LocalDate hoje = LocalDate.now();
        OffsetDateTime agora = OffsetDateTime.from(LocalDateTime.now());

        // Buscando os dados e tratando nulos com Optional ou Coalesce
        List<Pedido> pedidos = pedidoRepository.findByCriadoEmData(hoje);
        Long quantidade = pedidoRepository.countByCriadoEmData(hoje);

        BigDecimal totalVendas = Optional.ofNullable(pedidoRepository.sumValorByData(hoje))
                .orElse(BigDecimal.ZERO);

        Long abertos = pedidoRepository.countByStatus(PedidoStatus.ABERTO);

        BigDecimal media = Optional.ofNullable(pedidoRepository.calcularValorMedio(hoje))
                .orElse(BigDecimal.ZERO);

        BigDecimal ultimaHora = Optional.ofNullable(pedidoRepository.sumValorByDataHoraBetween(agora.minusHours(1), agora))
                .orElse(BigDecimal.ZERO);

        List<ItemMaisVendidoDTO> maisVendidos = itemPedidoRepository.findItensMaisVendidos();
        List<ItemPedido> itensConsumidos = itemPedidoRepository.consultarItensMaisConsumidos();

        return new RelatorioResponseDTO(
                pedidos,      // Busca todos os pedidos criados na data de hoje
                quantidade,   // Conta o total de pedidos realizados hoje
                totalVendas,  // Soma o valor total faturado no dia de hoje
                abertos,      // Conta quantos pedidos estão com o status "ABERTO"
                media,        // Valor médio gasto por pedido no dia de hoje
                ultimaHora,   // Soma o valor total de pedidos na última hora
                maisVendidos, // Retorna a lista dos itens que tiveram mais vendas
                itensConsumidos  // Consulta quais itens são mais consumidos pelos clientes
        );
    }
}


