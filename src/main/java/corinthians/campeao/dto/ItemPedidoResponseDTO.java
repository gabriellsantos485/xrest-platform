package corinthians.campeao.dto;

import corinthians.campeao.model.Cardapio;
import corinthians.campeao.model.Funcionario;
import corinthians.campeao.model.ItemPedidoStatus;
import corinthians.campeao.model.Pedido;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

public record ItemPedidoResponseDTO (
    Integer id,
    Integer quantidade,
    BigDecimal valor_unitario,
    BigDecimal valor_total,
    OffsetDateTime criadoEm,
    BigDecimal valor_descontado,
    String observacoes,
    ItemPedidoStatus status,
    Pedido pedido,
    Cardapio cardapio,
    Funcionario funcionario,
    Funcionario funcionario_liberou
) {}
