package com.gestao_restaurante.model;


import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.OffsetDateTime;


@Entity
@Table(name = "pedido", schema = "x_rest")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Pedido {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ped_id")
    private Integer id;

    @Column(name = "ped_viagem", nullable = false)
    @NotNull
    @Builder.Default
    private Boolean viagem = false;

    @Column(name = "ped_criado_em", nullable = false, updatable = false)
    @NotNull
    @CreationTimestamp
    private OffsetDateTime criadoEm;

    @Column(name = "ped_atualizado_em")
    @org.hibernate.annotations.UpdateTimestamp
    private OffsetDateTime atualizadoEm;

    @Column(name = "ped_valor_total", precision = 7, scale = 2)
    @NotNull
    @DecimalMin("0.0")
    private BigDecimal valorTotal;

    @Column(name = "ped_valor_pago", precision = 7, scale = 2)
    @DecimalMin("0.0")
    private BigDecimal valorPago;

    @Column(name = "ped_desconto", precision = 7, scale = 2)
    @DecimalMin("0.0")
    private BigDecimal desconto;

    @Enumerated(EnumType.STRING)
    @Column(name = "ped_status", nullable = false)
    @NotNull
    private PedidoStatus status;

    @Column(name = "ped_quant_pessoas", nullable = false, columnDefinition = "INTEGER DEFAULT 1")
    @Min(1)
    @NotNull
    private Integer quantidadePessoas;

    @NotNull
    @ManyToOne
    @JoinColumn(
            name = "cli_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "cli_id")
    )
    private Cliente cliente;

    @NotNull
    @ManyToOne
    @JoinColumn(
            name = "mesa_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "mesa_id")
    )
    private Mesa mesa;

    @NotNull
    @ManyToOne
    @JoinColumn(
            name = "fun_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "fun_id")
    )
    private Funcionario funcionario;
}
