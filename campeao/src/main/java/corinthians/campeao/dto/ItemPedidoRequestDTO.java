package corinthians.campeao.dto;

import corinthians.campeao.model.Cardapio;
import corinthians.campeao.model.Funcionario;
import corinthians.campeao.model.ItemPedidoStatus;
import corinthians.campeao.model.Pedido;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

public record ItemPedidoRequestDTO (

    @NotBlank(message = "Quantidade é obrigatório")
    Integer quantidade,

    @NotNull(message = "Valor unitario é obrigatório")
    BigDecimal valor_unitario,

    @NotNull(message = "Valor total é obrigatório")
    BigDecimal valor_total,

    @NotBlank(message = "Valor descontado é obrigatório")
    OffsetDateTime criadoEm,

    //Não obrigatório
    BigDecimal valor_descontado,
    String observacoes,
    ItemPedidoStatus status,

    @NotNull(message = "Pedido é obrigatório")
    Pedido pedido,

    @NotNull(message = "Cardápio é obrigatório")
    Cardapio cardapio,

    @NotNull(message = "Funcionario é obrigatório")
    Funcionario funcionario,

    @NotNull(message = "Liberacao do funcionario é obrigatório")
    Funcionario funcionario_liberou
    ){}
