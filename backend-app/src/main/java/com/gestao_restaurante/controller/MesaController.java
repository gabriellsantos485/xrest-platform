package com.gestao_restaurante.controller;

import com.gestao_restaurante.config.security.ApiRoutes;
import com.gestao_restaurante.dto.MesaRequestDTO;
import com.gestao_restaurante.dto.MesaResponseDTO;
import com.gestao_restaurante.service.MesaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(ApiRoutes.MESAS)
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class MesaController {

    private final MesaService mesaService;

    /// Retrieves a list of all registered tables.
    @GetMapping
    public ResponseEntity<List<MesaResponseDTO>> listarTodas() {
        List<MesaResponseDTO> mesas = mesaService.listarTodas();
        return ResponseEntity.ok(mesas);
    }

    @PostMapping
    public ResponseEntity<MesaResponseDTO> cadastrarMesa(@Valid @RequestBody MesaRequestDTO requestDTO) {
        MesaResponseDTO response = mesaService.cadastrarMesa(requestDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PatchMapping(ApiRoutes.MESAS_DESABILITAR)
    public ResponseEntity<Void> desabilitarMesa(@PathVariable Integer id) {
        mesaService.desabilitarMesa(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping(ApiRoutes.MESAS_TRANSFERIR)
    public ResponseEntity<Void> trocarMesa(
            @PathVariable Integer idOrigem,
            @PathVariable Integer idDestino) {

        mesaService.trocarMesa(idOrigem, idDestino);
        return ResponseEntity.ok().build();
    }
}