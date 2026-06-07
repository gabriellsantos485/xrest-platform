package corinthians.campeao.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Entity
@Table(name = "cardapio")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Cardapio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "car_id")
    private Integer id;

    @Column(name = "car_nome", length = 60, nullable = false, unique = true)
    @NotBlank
    @Size(max = 60)
    private String nome;

    @Column(name = "car_valor_unidade", precision = 7, scale = 2,nullable = false )
    private BigDecimal valorUnidade;

    @Column(name = "car_unidade_medida", length = 2, nullable = false)
    private String unidadeMedida;

    @Column(name = "car_descricao", length = 120, nullable = true)
    private String descricao;

    @Column(name = "car_ingredientes", length = 600, nullable = true)
    private String ingredientes;

    @Column(name = "car_porcoes_por_pessoa", nullable = true)
    private Integer porcoesPorPessoa;

    @Column(name = "car_inicio_promocao", nullable = true)
    private OffsetDateTime inicioPromocao;

    @Column(name = "car_valor_promocional", nullable = true, precision = 7, scale = 2)
    private BigDecimal valorPromocional;

    @Column(name = "car_termino_promocao", nullable = true )
    private OffsetDateTime terminoPromocao;

    @Column(
            name = "car_foto",
            nullable = false,
            length = 255
    )
    @Builder.Default
    private String foto = "https://i.pinimg.com/originals/de/b4/df/deb4df15b66367b7bc50d93ec5dc4395.jpg?nii=t";

    @Enumerated(EnumType.STRING)
    @Column(name = "car_status", nullable = false)
    @NotNull
    @Builder.Default
    private StatusCardapio status = StatusCardapio.ATIVO;

    @ManyToOne
    @JoinColumn(
            name = "cat_id",
            nullable = false,
            foreignKey = @ForeignKey(name = "car_fk_cat_id")
    )
    private Categoria categoria;
}
