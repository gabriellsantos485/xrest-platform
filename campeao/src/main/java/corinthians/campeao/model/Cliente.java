package corinthians.campeao.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

@Entity
@Table(name = "cliente")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Cliente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "cli_id")
    private Integer id;

    @Column(name = "cli_nome", length = 60)
    @Size(max = 60)
    private String nome;

    @Column(name = "cli_sobrenome", length = 60)
    @Size(max = 60)
    private String sobrenome;

    @Column(name = "cli_cpf", length = 14, unique = true)
    @Size(max = 14, min = 11)
    private String cpf;

    @Column(name = "cli_email", unique = true, length = 80)
    @Size(max = 80)
    @Email
    private String email;

    @Column(name = "cli_telefone", unique = true, length = 13)
    @Size(max = 13)
    private String telefone;

    @Column(name = "cli_numero")
    private Integer numeroCasa;

    @Column(name = "cli_rua", length = 40)
    @Size(max = 40)
    private String rua;

    @Column(name = "cli_bairro", length = 100)
    @Size(max = 100)
    private String bairro;

    @Column(name = "cli_cidade", length = 60)
    @Size(max = 60)
    private String cidade;

    @Column(name = "cli_password", length = 255)
    @Size(max = 255)
    private String password;

}