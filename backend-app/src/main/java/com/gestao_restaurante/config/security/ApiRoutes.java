package com.gestao_restaurante.config.security;

public final class ApiRoutes {

    private ApiRoutes() {
        throw new UnsupportedOperationException("Não pode ser instanciada");
    }


    public static final String API_VERSION = "/xrest/v1";


    public static final String AUTH = API_VERSION + "/auth";
    public static final String LOGIN = "/login";
    public static final String FUNCIONARIOS = API_VERSION + "/funcionarios";

    // ---------------------------------------------------------------------------
    // (MESAS)
    // ---------------------------------------------------------------------------
    public static final String MESAS = API_VERSION + "/mesas";
    public static final String MESAS_DESABILITAR = "/{id}/desabilitar";
    public static final String MESAS_TRANSFERIR = MESAS + "/{idOrigem}/transferir/{idDestino}";

    // ---------------------------------------------------------------------------
    //  (PEDIDOS)
    // ---------------------------------------------------------------------------
    public static final String PEDIDOS = API_VERSION + "/pedidos";
    public static final String PEDIDOS_ITENS = "/{pedidoId}/itens";
    public static final String PEDIDOS_FECHAR = "/{pedidoId}/fechar";
    public static final String PEDIDOS_CANCELAR = "/{pedidoId}/cancelar";

    // ---------------------------------------------------------------------------
    //  (CARDAPIO)
    // ---------------------------------------------------------------------------
    public static final String CARDAPIO = API_VERSION + "/cardapio";
    public static final String CATEGORIAS = API_VERSION + "/categorias";

    // ---------------------------------------------------------------------------
    //  (CLIENTES)
    // ---------------------------------------------------------------------------
    public static final String CLIENTES = API_VERSION + "/clientes";

    // ---------------------------------------------------------------------------
    //  (ADMIN)
    // ---------------------------------------------------------------------------
    public static final String RELATORIOS = API_VERSION + "/relatorios";
    public static final String RELATORIOS_FATURAMENTO = "/faturamento";
}
