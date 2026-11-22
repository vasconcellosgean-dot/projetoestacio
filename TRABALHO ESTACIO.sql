CREATE DATABASE IF NOT EXISTS empresa;
USE empresa;
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
    cod_cliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome_cliente VARCHAR(30) NOT NULL,
    endereco VARCHAR(40),
    sexo CHAR(1)
);

INSERT INTO clientes (nome_cliente, endereco, sexo) VALUES ('João da Silva', 'Rua das Flores, 123', 'M');
INSERT INTO clientes (nome_cliente, endereco, sexo) VALUES ('Maria Oliveira', 'Avenida Brasil, 456', 'F');

SELECT * FROM clientes;
INSERT INTO clientes (nome_cliente, endereco, sexo) VALUES ('Carlos Souza', 'Rua X, 10', 'M');
SELECT * FROM clientes;