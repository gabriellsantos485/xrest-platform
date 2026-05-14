package corinthians.campeao.controler;

import corinthians.campeao.dto.ItemSubTotalDTO;
import corinthians.campeao.model.ItemPedido;
import corinthians.campeao.repository.ItemPedidoRepository;
import corinthians.campeao.service.ItemPedidoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.List;

@RestController
public class ItemPedidoController {

    @Autowired
    private ItemPedidoRepository repository;
    @Autowired
    private ItemPedidoService itemPedidoService;

    @GetMapping
    public BigDecimal calcularSubTotal(@RequestBody ItemSubTotalDTO dto){
        return itemPedidoService.calcularSubTotal(dto);
    }
    @GetMapping
    public List<ItemPedido> consultarItensEmAndamento(){
        return repository.consultarItensEmAndamento();
    }

}
