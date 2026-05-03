package com.gestao_restaurante.controler;

import com.gestao_restaurante.dto.ClienteRequestDTO;
import com.gestao_restaurante.model.Cliente;
import com.gestao_restaurante.service.ClienteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ClienteController{

    @Autowired
    private ClienteService service;

    @PostMapping("/registrar")
    public Cliente registrar(@RequestBody ClienteRequestDTO dto){
        return service.registrar(dto);
    }

    @PostMapping("/login")
    public String login(@RequestBody ClienteRequestDTO dto){
        return service.login(dto);
    }
}

