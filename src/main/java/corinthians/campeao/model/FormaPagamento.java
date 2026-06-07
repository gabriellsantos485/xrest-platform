package corinthians.campeao.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Entity
@Table(name = "forma_pagamento")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FormaPagamento {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "fpa_id")
    private Integer id;

    @Column(name = "fpa_nome", length = 20, unique = true)
    @NotBlank
    private String nome;

}
