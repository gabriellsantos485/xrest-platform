package com.gestao_restaurante.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.math.BigDecimal;

@Entity
@Table(name = "pedido_formapagamento", schema = "x_rest")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PedidoFormaPagamento {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "pfo_id")
    private Integer id;

    @Column(name = "pfo_valor_pago", precision = 7, scale = 2, nullable = false)
    @NotNull
    private BigDecimal valorPago;

    @Column(name = "pfo_troco", precision = 7, scale = 2, nullable = false)
    @Builder.Default
    private BigDecimal troco = BigDecimal.ZERO;

    @ManyToOne
    @NotNull
    @JoinColumn(
            name = "fpa_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "fpa_id")
    )
    private FormaPagamento formaPagamento;

    @ManyToOne
    @NotNull
    @JoinColumn(
            name = "ped_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "ped_id")
    )
    private Pedido pedido;

}
