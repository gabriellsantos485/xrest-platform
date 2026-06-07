package corinthians.campeao.controler;

import corinthians.campeao.dto.PedidoRequestDTO;
import corinthians.campeao.dto.RelatorioResponseDTO;
import corinthians.campeao.model.Pedido;
import corinthians.campeao.model.PedidoStatus;
import corinthians.campeao.service.PedidoService;
import corinthians.campeao.service.RelatorioService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping(path = "/xrest/pedidos")
public class PedidoController {

    private final RelatorioService relatorioService;
    private final PedidoService pedidoService;

    public PedidoController(RelatorioService relatorioService, PedidoService pedidoService){
        this.relatorioService = relatorioService;
        this.pedidoService = pedidoService;
    }

    @PostMapping("/abrir")
    public void abrirPedido(){
        pedidoService.abrirPedido();
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
    public BigDecimal dividirValor(@PathVariable PedidoRequestDTO dto){return pedidoService.dividirValor(dto);}
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

    @GetMapping("/relatorio")
    public ResponseEntity<RelatorioResponseDTO> gerarRelatorio() {
        RelatorioResponseDTO relatorio = relatorioService.gerarRelatorio();
        return ResponseEntity.ok(relatorio);
    }

    @GetMapping
    public BigDecimal vendasPorHora(LocalDate data, int hora){
        return pedidoService.vendasPorHora(data, hora);
    }

}
