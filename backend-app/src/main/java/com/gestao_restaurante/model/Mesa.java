/*package com.gestao_restaurante.model;*/

/*
public class Mesa {

    private int numero;
    private Pedido pedido;
    private boolean estadoMesa;

    //Constructor
    //- Pacote Service -
    public Mesa(int numero){
        if(numero < 1 || numero > 20)
            throw new IllegalArgumentException("Mesa Invalida");
        else {
            this.numero = numero;
            this.pedido = new Pedido();
            this.estadoMesa = false;
        }
    }//End Constructor

    //Metodo para ativar mesa. Agora estadoMesa é igual a true.
    public void ativarMesa(){
        if(pedido.getPedido().percorrendoListaItens() == 0)
            estadoMesa = true;
    }

    //Metodo para fechar conta, mostra pedido, mesa e desocupa mesa. estadoMesa é igual a false, novamente;
    public void fecharConta(){
        System.out.println("\n================");
        System.out.println("Conta da Mesa: " + numero);
        pedido.mostrarPedido();
        estadoMesa = false;
        System.out.println("\nConta encerrada");
        System.out.println("\n================");
    }

    //Getters and Setters
    public int getNumero() {
        return numero;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public Pedido getPedido(){
        return pedido;
    }//End Getters and Setters

    //ToString
    @java.lang.Override
    public java.lang.String toString() {
        return "Mesa{" +
                "numero=" + numero +
                ", pedido=" + pedido +
                ", estadoMesa=" + estadoMesa +
                '}';
    }//End ToString

}

 */
