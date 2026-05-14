package corinthians.campeao.service;

import corinthians.campeao.dto.ItemSubTotalDTO;
import corinthians.campeao.model.Cardapio;
import corinthians.campeao.model.ItemPedido;
import corinthians.campeao.model.ItemPedidoStatus;
import corinthians.campeao.repository.ItemPedidoRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
public class ItemPedidoService {

    private ItemPedidoRepository itemPedidoRepository;
    private List<ItemPedido> itensCardapio;

    public ItemPedidoService( ItemPedidoRepository itemPedidoRepository, List<ItemPedido> itensCardapio){
        this.itemPedidoRepository = itemPedidoRepository;
        this.itensCardapio = itensCardapio;
    }
/*
    public BigDecimal calcularSubTotal(ItemPedido itemPedido){
        Cardapio cardapio = itemPedido.getCardapio();
        return cardapio.getValorUnidade().multiply(BigDecimal.valueOf(itemPedido.getQuantidade()));
    }
*/

    public BigDecimal calcularSubTotal(ItemSubTotalDTO dto){
        return dto.valor().multiply(BigDecimal.valueOf(dto.quantidade()));
    }

    public void registrarEntrega(ItemPedido itempedido){
            itempedido.setStatus(ItemPedidoStatus.PRONTO);
            itemPedidoRepository.save(itempedido);
    }

    public List<ItemPedido> consultarItensAndamento() {
        if (!this.itensCardapio.isEmpty()) {
            List<ItemPedido> emAndamento = new ArrayList<>();
            for (ItemPedido i : itensCardapio) {
                if (i.getStatus() == ItemPedidoStatus.EM_PREPARO) {
                    emAndamento.add(i);
                }
            }
            return emAndamento;
        }
        return null;
    }
}
