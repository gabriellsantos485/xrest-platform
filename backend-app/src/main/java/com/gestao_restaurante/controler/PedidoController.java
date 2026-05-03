package com.gestao_restaurante.controler;

import com.gestao_restaurante.model.Pedido;
import com.gestao_restaurante.service.PedidoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(path = "/xrest/pedidos")
public class PedidoController {

    private final PedidoService pedidoService;

    public PedidoController(PedidoService pedidoService){
        this.pedidoService = pedidoService;
    }

    @GetMapping
    public List<Pedido> listarPedidosEmAndamento(){
        return pedidoService.verFilaPedido();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Pedido> consultarPedido(@PathVariable Integer id) //Default Requirement: By default, path variables are mandatory. If a client calls the base URL without an ID, they will receive a 404 error before the method is even executed.
    {
        return pedidoService.consultarPedido(id)
                                .map(ResponseEntity::ok)
                                .orElse(ResponseEntity.notFound().build());

    }

    @DeleteMapping
    public void cancelarPedido(@PathVariable Integer id){ //Default Requirement: By default, path variables are mandatory. If a client calls the base URL without an ID, they will receive a 404 error before the method is even executed.
        pedidoService.cancelarPedido(id);
    }

}
