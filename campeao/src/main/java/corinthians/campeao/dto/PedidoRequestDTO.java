package corinthians.campeao.dto;

import corinthians.campeao.model.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;

public record PedidoRequestDTO(

        @NotBlank(message= "Quando foi criado é obrigatório")
        OffsetDateTime criadoEm,

        @NotBlank(message= "Quando foi atualizado é obrigatório")
        OffsetDateTime atualizadoEm,

        @NotNull(message= "Valor total do pedido é obrigatório")
        BigDecimal valorTotal,

        @NotNull(message= "Valor pago do pedido é obrigatório")
        BigDecimal valorPago,

        //Não é obrigatório
        PedidoStatus status,
        Boolean viagem,
        BigDecimal desconto,

        @NotNull(message= "Quantidade de pessoas é obrigatório")
        Integer quantidadePessoas,

        @NotNull(message= "Cliente é obrigatório")
        Cliente cliente,

        @NotNull(message= "Mesa é obrigatório")
        Mesa mesa,

        @NotNull(message= "Funcionario é obrigatório")
        Funcionario funcionario,

        @NotNull(message= "ItemPedido é obrigatório")
        List<ItemPedido> itensPedido
) {}
