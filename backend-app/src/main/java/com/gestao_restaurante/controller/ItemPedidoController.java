package com.gestao_restaurante.controller;

import com.gestao_restaurante.dto.ItemPedidoFilaResponseDTO;
import com.gestao_restaurante.model.ItemPedido;
import com.gestao_restaurante.repository.ItemPedidoRepository;
import com.gestao_restaurante.service.ItemPedidoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/xrest/v1/item-pedido")
@CrossOrigin(origins = "*")
public class ItemPedidoController {

    final private ItemPedidoService itemPedidoService;

    public ItemPedidoController(ItemPedidoService itemPedidoService){
        this.itemPedidoService = itemPedidoService;
    }

    @PutMapping("/status/{itemId}")
    public ResponseEntity<ItemPedidoFilaResponseDTO> listar(@PathVariable Integer itemId){
        return ResponseEntity.ok(itemPedidoService.alterarStatus(itemId));
    }
}
