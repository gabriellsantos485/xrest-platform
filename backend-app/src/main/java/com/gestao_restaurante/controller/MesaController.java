package com.gestao_restaurante.controller;

import com.gestao_restaurante.config.security.ApiRoutes;
import com.gestao_restaurante.dto.MesaRequestDTO;
import com.gestao_restaurante.dto.MesaResponseDTO;
import com.gestao_restaurante.service.MesaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/xrest/v1/mesa")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class MesaController {

    private final MesaService mesaService;

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

    @PatchMapping("/{id}/desabilitar")
    public ResponseEntity<Void> desabilitarMesa(@PathVariable Integer id) {
        mesaService.desabilitarMesa(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{idOrigem}/transferir/{idDestino}")
    public ResponseEntity<Void> trocarMesa(
            @PathVariable Integer idOrigem,
            @PathVariable Integer idDestino) {

        mesaService.trocarMesa(idOrigem, idDestino);
        return ResponseEntity.ok().build();
    }

    @PutMapping()
    public ResponseEntity<Void> atualizar(){
        return ResponseEntity.ok().build();
    }

}