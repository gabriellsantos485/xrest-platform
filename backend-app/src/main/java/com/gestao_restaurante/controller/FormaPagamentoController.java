package com.gestao_restaurante.controller;

import com.gestao_restaurante.dto.FormaPagamentoRequestDTO;
import com.gestao_restaurante.dto.FormaPagamentoResponseDTO;
import com.gestao_restaurante.service.FormaPagamentoService;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import java.util.List;

@RestController
@RequestMapping("/xrest/v1/formas-pagamento")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class FormaPagamentoController {

    private final FormaPagamentoService service;

    @GetMapping
    public ResponseEntity<List<FormaPagamentoResponseDTO>> listarTodos() {
        List<FormaPagamentoResponseDTO> metodos = service.listarTodos();
        return ResponseEntity.ok(metodos);
    }

    @PostMapping
    public ResponseEntity<FormaPagamentoResponseDTO> cadastrarMetodo(
            @Valid @RequestBody FormaPagamentoRequestDTO requestDTO) {
        FormaPagamentoResponseDTO response = service.cadastrarMetodo(requestDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PutMapping("/{id}")
    public ResponseEntity<FormaPagamentoResponseDTO> atualizarMetodo(
            @PathVariable Integer id,
            @Valid @RequestBody FormaPagamentoRequestDTO requestDTO) {

        FormaPagamentoResponseDTO response = service.atualizarMetodo(id, requestDTO);
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletarMetodo(@PathVariable Integer id) {
        service.deletarMetodo(id);
        return ResponseEntity.noContent().build();
    }
}
