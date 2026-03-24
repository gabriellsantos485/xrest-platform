package com.gestao_restaurante.model;

public class Usuario {

    private String login;
    private String senha;
    private String username;

    //Constructor
    public Usuario(String login, String senha, String username) {
        this.login = login;
        this.senha = senha;
        this.username = username;
    }//End Constructor

    //Getters and Setters
    public String getLogin() {return login;}

    public void setLogin(String login) {this.login = login;}

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {this.senha = senha;}

    public String getUsername() {return username;}

    public void setUsername(String username) {this.username = username;}//End Getters and Setters

    //To String
    @Override
    public String toString() {
        return "Usuario{" +
                "login='" + login + '\'' +
                ", senha='" + senha + '\'' +
                ", username='" + username + '\'' +
                '}';
    }//End To String
}
