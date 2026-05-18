package com.gestao_restaurante.controller;

import com.gestao_restaurante.dto.ItemPedidoRequestDTO;
import com.gestao_restaurante.dto.PedidoRequestDTO;
import com.gestao_restaurante.dto.PedidoResponseDTO;
import com.gestao_restaurante.service.PedidoService;
import jakarta.validation.Valid;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;

@RestController
@RequestMapping("/xrest/v1/pedidos")
@CrossOrigin(origins = "*")
public class PedidoController {

    private final PedidoService pedidoService;

    public PedidoController(PedidoService pedidoService) {
        this.pedidoService = pedidoService;
    }

    @PostMapping("/mesa/{mesaId}/pedido")
    public String abrirPedido (@RequestBody PedidoRequestDTO dto, @PathVariable Integer mesaId){
         pedidoService.abrirPedido(dto, mesaId);
         return "Tá cadastrado amigão, confia";
    }

    @GetMapping
    public ResponseEntity<List<PedidoResponseDTO>> listarPedidos() {
        List<PedidoResponseDTO> pedidos = pedidoService.listarPedidos();
        return ResponseEntity.ok(pedidos);
    }

    @GetMapping("/{id}")
    public ResponseEntity<PedidoResponseDTO> consultarPedido(@PathVariable Integer id) {
        PedidoResponseDTO response = pedidoService.consultarPedido(id);
        return ResponseEntity.ok(response);
    }

    @PatchMapping("/{id}/fechar")
    public ResponseEntity<Void> fecharPedido(@PathVariable Integer id) {
        pedidoService.fecharPedido(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{id}/itens")
    public ResponseEntity<PedidoResponseDTO> adicionarItens(
            @PathVariable Integer id,
            @Valid @RequestBody List<ItemPedidoRequestDTO> itens) {

        PedidoResponseDTO response = pedidoService.adicionarItens(id, itens);
        return ResponseEntity.ok(response);
    }

    @PatchMapping("/{id}/cancelar")
    public ResponseEntity<Void> cancelarPedido(@PathVariable Integer id) {
        pedidoService.cancelarPedido(id);
        return ResponseEntity.noContent().build();
    }

    // Corrigir a lógica
    @GetMapping("/{id}/dividir")
    public ResponseEntity<BigDecimal> dividirValor(
            @PathVariable Integer id,
            @RequestParam Integer pessoas) {

        BigDecimal valorDividido = pedidoService.dividirValor(id, pessoas);
        return ResponseEntity.ok(valorDividido);
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<PedidoResponseDTO>> listarPedidosPorStatus(@PathVariable String status) {
        List<PedidoResponseDTO> pedidos = pedidoService.listarPedidosPorStatus(status);
        return ResponseEntity.ok(pedidos);
    }

    // Example request: /xrest/pedidos/data?inicio=2026-05-16T00:00:00&fim=2026-05-16T23:59:59
    @GetMapping("/data")
    public ResponseEntity<List<PedidoResponseDTO>> listarPedidosPorData(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime inicio,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) OffsetDateTime fim) {

        List<PedidoResponseDTO> pedidos = pedidoService.listarPedidosPorData(inicio, fim);
        return ResponseEntity.ok(pedidos);
    }

    @GetMapping("/mesa/{mesaId}")
    public ResponseEntity<List<PedidoResponseDTO>> listarPedidosPorMesa(@PathVariable Integer mesaId) {
        List<PedidoResponseDTO> pedidos = pedidoService.listarPedidosPorMesa(mesaId);
        return ResponseEntity.ok(pedidos);
    }

    @GetMapping("/cliente/{clienteId}")
    public ResponseEntity<List<PedidoResponseDTO>> listarPedidosPorCliente(@PathVariable Integer clienteId) {
        List<PedidoResponseDTO> pedidos = pedidoService.listarPedidosPorCliente(clienteId);
        return ResponseEntity.ok(pedidos);
    }
}
