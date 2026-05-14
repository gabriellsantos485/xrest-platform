package corinthians.campeao.controler;

import corinthians.campeao.dto.PedidoRequestDTO;
import corinthians.campeao.model.Pedido;
import corinthians.campeao.model.PedidoStatus;
import corinthians.campeao.service.PedidoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping(path = "/xrest/pedidos")
public class PedidoController {

    private final PedidoService pedidoService;

    public PedidoController(PedidoService pedidoService){
        this.pedidoService = pedidoService;
    }

    @GetMapping("/status")
    public List<Pedido> listarPedidosPorStatusData(@PathVariable PedidoStatus status, @PathVariable LocalDate data){
        return pedidoService.pedidosPorStatusData(status, data);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Pedido> consultarPedido(@PathVariable Integer id) //Default Requirement: By default, path variables are mandatory. If a client calls the base URL without an ID, they will receive a 404 error before the method is even executed.
    {
        return pedidoService.consultarPedido(id)
                                .map(ResponseEntity::ok)
                                .orElse(ResponseEntity.notFound().build());

    }

    @DeleteMapping("/cancelar")
    public void cancelarPedido(@PathVariable Integer id){ //Default Requirement: By default, path variables are mandatory. If a client calls the base URL without an ID, they will receive a 404 error before the method is even executed.
        pedidoService.cancelarPedido(id);
    }

    @GetMapping("/dividir")
    public BigDecimal dividirValorPorPessoa(@PathVariable PedidoRequestDTO dto){return pedidoService.dividirValor(dto);}
    @GetMapping("/historico")
    public List<Pedido> verHistoricoPedidos(){
        return pedidoService.verHistoricoPedidos();
    }

    @PutMapping("/fechar")
    public void fecharPedido(@PathVariable Integer id){
        pedidoService.fecharPedido(id);
    }

    @GetMapping("/mesa")
    public void escolherMesa(@PathVariable Integer pedidoId, @PathVariable Integer mesaId){pedidoService.escolherMesa(pedidoId, mesaId);}

}
