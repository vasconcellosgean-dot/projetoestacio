CREATE DATABASE IF NOT EXISTS loja_estacio;
USE loja_estacio;

CREATE TABLE clientes (
    cod_cliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome_cliente VARCHAR(100) NOT NULL,
    endereco VARCHAR(100),
    sexo CHAR(1)
);

CREATE TABLE produtos (
    cod_produto INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0
);

CREATE TABLE pedidos (
    cod_pedido INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    data_pedido DATE NOT NULL,
    status_entrega VARCHAR(30) NOT NULL DEFAULT 'Pendente',
    cod_cliente INT NOT NULL,
    CONSTRAINT fk_pedidos_clientes
        FOREIGN KEY (cod_cliente) REFERENCES clientes(cod_cliente)
);

CREATE TABLE itens_pedido (
    cod_item INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cod_pedido INT NOT NULL,
    cod_produto INT NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_itens_pedidos
        FOREIGN KEY (cod_pedido) REFERENCES pedidos(cod_pedido),
    CONSTRAINT fk_itens_produtos
        FOREIGN KEY (cod_produto) REFERENCES produtos(cod_produto)
);
