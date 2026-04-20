package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.MesaStatus;


public record MesaResponseDTO (
     Integer id,
     MesaStatus status,
     String localizacao,
     Short capacidade
) {}
