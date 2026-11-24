CREATE DATABASE IF NOT EXISTS loja_estacio;
USE loja_estacio;

-- Desativa temporariamente a verificação de FK para recriação limpa na migração
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS itens_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS clientes;

SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================
-- 1. TABELA CLIENTES (PK, NOT NULL, UNIQUE, CHECK)
-- ==========================================
CREATE TABLE clientes (
    cod_cliente INT AUTO_INCREMENT NOT NULL,
    nome_cliente VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL,
    endereco VARCHAR(200) NOT NULL,
    sexo CHAR(1) NOT NULL,
    CONSTRAINT pk_clientes PRIMARY KEY (cod_cliente),
    CONSTRAINT uq_clientes_email UNIQUE (email),
    CONSTRAINT chk_clientes_sexo CHECK (sexo IN ('M', 'F'))
);

-- ==========================================
-- 2. TABELA PRODUTOS (PK, NOT NULL, UNIQUE, CHECK)
-- ==========================================
CREATE TABLE produtos (
    cod_produto INT AUTO_INCREMENT NOT NULL,
    nome_produto VARCHAR(120) NOT NULL,
    categoria VARCHAR(80) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0,
    CONSTRAINT pk_produtos PRIMARY KEY (cod_produto),
    CONSTRAINT uq_produtos_nome UNIQUE (nome_produto),
    CONSTRAINT chk_produtos_preco CHECK (preco > 0),
    CONSTRAINT chk_produtos_estoque CHECK (estoque >= 0)
);

-- ==========================================
-- 3. TABELA PEDIDOS (PK, FK, NOT NULL, CHECK)
-- ==========================================
CREATE TABLE pedidos (
    cod_pedido INT AUTO_INCREMENT NOT NULL,
    data_pedido DATE NOT NULL,
    status_entrega VARCHAR(30) NOT NULL,
    cod_cliente INT NOT NULL,
    CONSTRAINT pk_pedidos PRIMARY KEY (cod_pedido),
    CONSTRAINT fk_pedidos_clientes FOREIGN KEY (cod_cliente)
        REFERENCES clientes (cod_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_pedidos_status CHECK (status_entrega IN ('Pendente', 'Em rota', 'Entregue'))
);

-- ==========================================
-- 4. TABELA ITENS_PEDIDO (PK, FK, NOT NULL, CHECK)
-- ==========================================
CREATE TABLE itens_pedido (
    cod_item INT AUTO_INCREMENT NOT NULL,
    cod_pedido INT NOT NULL,
    cod_produto INT NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_itens_pedido PRIMARY KEY (cod_item),
    CONSTRAINT fk_itens_pedido FOREIGN KEY (cod_pedido)
        REFERENCES pedidos (cod_pedido)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_itens_produtos FOREIGN KEY (cod_produto)
        REFERENCES produtos (cod_produto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_itens_quantidade CHECK (quantidade > 0),
    CONSTRAINT chk_itens_valor CHECK (valor_unitario > 0)
);

-- ==========================================
-- 5. CARGA INICIAL DE DADOS
-- ==========================================
INSERT INTO clientes (nome_cliente, email, endereco, sexo) VALUES
('João da Silva', 'joao.silva@exemplo.com', 'Rua Nova, 500', 'M'),
('Maria Oliveira', 'maria.oliveira@exemplo.com', 'Avenida Brasil, 456', 'F'),
('Carlos Souza', 'carlos.souza@exemplo.com', 'Rua X, 10', 'M'),
('Ana Paula Costa', 'ana.costa@exemplo.com', 'Rua Augusta, 789', 'F'),
('Lucas Mendes', 'lucas.mendes@exemplo.com', 'Av. Paulista, 1000', 'M');

INSERT INTO produtos (nome_produto, categoria, preco, estoque) VALUES
('Teclado Mecânico', 'Periféricos', 270.00, 12),
('Mouse Sem Fio', 'Periféricos', 120.00, 30),
('Monitor 24 Polegadas', 'Monitores', 890.00, 8),
('Cadeira Ergonómica', 'Escritório', 1150.00, 5),
('Headset Gamer', 'Áudio', 320.00, 20);

INSERT INTO pedidos (data_pedido, status_entrega, cod_cliente) VALUES
('2026-11-10', 'Entregue', 1),
('2026-11-12', 'Entregue', 2),
('2026-11-15', 'Em rota', 3),
('2026-11-18', 'Entregue', 1);

INSERT INTO itens_pedido (cod_pedido, cod_produto, quantidade, valor_unitario) VALUES
(1, 1, 1, 270.00),
(1, 2, 1, 120.00),
(2, 3, 1, 890.00),
(3, 4, 1, 1150.00),
(4, 5, 2, 320.00);
SELECT * FROM clientes;
SELECT * FROM produtos;
SELECT * FROM pedidos;
SELECT * FROM itens_pedido;
