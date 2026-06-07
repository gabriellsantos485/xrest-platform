package corinthians.campeao.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Entity
@Table(name = "item_pedido")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ItemPedido {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ipe_id")
    private Integer id;

    @Column(name = "ipe_quantidade", nullable = false)
    @NotNull
    @Min(1)
    private Integer quantidade;

    @Column(name = "ipe_valor_unitario", nullable = false)
    @NotNull
    @DecimalMin("0.0")
    private BigDecimal valor_unitario;

    @Column(name = "ipe_valor_descontado", nullable = false)
    @DecimalMin("0.0")
    @Builder.Default
    @NotNull
    private BigDecimal valor_descontado = BigDecimal.ZERO;

    @Column(name = "ipe_valor_total", nullable = false)
    @DecimalMin("0.0")
    @NotNull
    private BigDecimal valor_total;

    @Column(name = "ipe_criado_em", nullable = false, updatable = false)
    @NotNull
    @CreationTimestamp
    private OffsetDateTime criadoEm;

    @Column(name = "ipe_observacoes", nullable = false, updatable = false, length = 60)
    private String observacoes;

    @Enumerated(EnumType.STRING)
    @Column(name = "ipe_status", nullable = false)
    @Builder.Default
    private ItemPedidoStatus status = ItemPedidoStatus.NAO_INICIADO;

    @ManyToOne
    @JoinColumn(
            name = "ped_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "itp_fk_ped_id")
    )
    private Pedido pedido;

    @ManyToOne
    @JoinColumn(
            name = "car_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "itp_fk_car_id")
    )
    private Cardapio cardapio;

    @ManyToOne
    @JoinColumn(
            name = "fun_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "itp_fk_fun_id")
    )
    private Funcionario funcionario;

    @ManyToOne
    @JoinColumn(
            name = "fun_funcionario_liberou",
            nullable = false,
            foreignKey = @ForeignKey(name = "itp_fk_fun_funcionario_liberou_id")
    )
    private  Funcionario funcionario_liberou;
}
