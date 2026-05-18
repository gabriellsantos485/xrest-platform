package com.gestao_restaurante.controller;

import com.gestao_restaurante.dto.ClienteRequestDTO;
import com.gestao_restaurante.dto.ClienteResponseDTO;
import com.gestao_restaurante.service.ClienteService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/xrest")
@CrossOrigin(origins = "*")
public class ClienteController {
    ClienteService clienteService;

    public ClienteController(ClienteService clienteService){
        this.clienteService = clienteService;
    }

    @GetMapping("/clientes")
    public ResponseEntity<List<ClienteResponseDTO>> listarClientes(){
        return ResponseEntity.ok(
                clienteService.listarClientes()
        );
    }

    @GetMapping("/cliente/{id}")
    public ResponseEntity<ClienteResponseDTO> verCliente(@PathVariable Integer id){
        return ResponseEntity.ok(
                clienteService.verCliente(id)
        );
    }


    @PostMapping("/cliente/cadastrar")
    public ResponseEntity<ClienteResponseDTO> criarCliente(@RequestBody ClienteRequestDTO dto){
        ClienteResponseDTO cliente =
                clienteService.criarCliente(dto);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(cliente);
    }


    @PutMapping("/cliente/atualizar/{id}")
    public ResponseEntity<ClienteResponseDTO> atualizarCliente(
            @PathVariable Integer id,
            @RequestBody ClienteRequestDTO dto
    ){
        return ResponseEntity.ok(clienteService.atualizarCliente(id, dto));
    }

    /*
    @DeleteMapping("/cliente/{id}")
    public Boolean apagarCliente(@PathVariable Integer id ){

    }

     */

}
