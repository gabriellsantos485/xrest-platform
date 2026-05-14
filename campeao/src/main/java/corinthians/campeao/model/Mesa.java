package corinthians.campeao.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Entity
@Table(name = "mesa")
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
    @NotBlank
    private MesaStatus status;

    @Column(name = "mesa_localizacao", length = 1, nullable = false, columnDefinition = "VARCHAR(1) DEFAULT 'B'")
    @NotBlank
    private String localizacao;

    @Column(name = "mesa_capacidade", nullable = false)
    @NotBlank
    private Short capacidade;
}

