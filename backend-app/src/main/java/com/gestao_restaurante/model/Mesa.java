package com.gestao_restaurante.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Entity
@Table(name = "mesa", schema = "x_rest")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Mesa {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "mesa_id")
    private Integer id;

    @Enumerated(EnumType.STRING)
    @Column(name = "mesa_status", nullable = false)
    @NotNull
    private MesaStatus status;

    @Column(name = "mesa_localizacao", length = 1, nullable = false, columnDefinition = "VARCHAR(1) DEFAULT 'B'")
    @NotBlank
    private String localizacao;

    @Column(name = "mesa_capacidade", nullable = false)
    @NotNull
    private Short capacidade;
}

