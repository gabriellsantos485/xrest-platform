package com.gestao_restaurante.controller;

import com.gestao_restaurante.dto.PedidoRequestDTO;
import com.gestao_restaurante.service.PedidoService;
import org.springframework.web.bind.annotation.*;

@RestController
public class PedidoController {

    private final PedidoService pedidoService;

    public PedidoController(PedidoService pedidoService) {
        this.pedidoService = pedidoService;
    }


    @PostMapping("/xrest/mesa/{mesaId}/pedido")
    public String criar (@RequestBody PedidoRequestDTO dto, @PathVariable Integer mesaId){
         pedidoService.criar(dto, mesaId);
         return "Tá cadastrado paezão, confia no pae";
    }



}
