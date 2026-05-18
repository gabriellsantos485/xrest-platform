package com.gestao_restaurante.dto;

import com.gestao_restaurante.model.MesaStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MesaResponseDTO {

    private Integer id;
    private MesaStatus status;
    private String localizacao;
    private Short capacidade;

}
