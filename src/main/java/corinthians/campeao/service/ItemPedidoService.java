package corinthians.campeao.service;

import corinthians.campeao.dto.ItemPedidoResponseDTO;
import corinthians.campeao.dto.ItemSubTotalDTO;
import corinthians.campeao.mapper.ItemPedidoMapper;
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

    private ItemPedidoRepository repository;
    private List<ItemPedido> itensCardapio;

    public ItemPedidoService( ItemPedidoRepository itemPedidoRepository, List<ItemPedido> itensCardapio){
        this.repository = itemPedidoRepository;
        this.itensCardapio = itensCardapio;
    }

    public BigDecimal calcularSubTotal(ItemSubTotalDTO dto){
        return dto.valor().multiply(BigDecimal.valueOf(dto.quantidade()));
    }

    public void registrarEntrega(ItemPedidoResponseDTO dto) {
        ItemPedido itempedido = ItemPedidoMapper.toEntity(dto);
        itempedido.setStatus(ItemPedidoStatus.PRONTO);
        repository.save(itempedido);
    }

}
