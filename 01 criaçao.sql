-- 01_criacao.sql : banco, tabelas, índices e view
-- Loja virtual (loja_estacio) - 9 tabelas

CREATE DATABASE IF NOT EXISTS loja_estacio
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE loja_estacio;

-- Recriação limpa (ordem inversa da criação)
SET FOREIGN_KEY_CHECKS = 0;
DROP VIEW  IF EXISTS vw_total_pedido;
DROP TABLE IF EXISTS pagamentos;
DROP TABLE IF EXISTS itens_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS produto_fornecedor;
DROP TABLE IF EXISTS produtos;
DROP TABLE IF EXISTS fornecedores;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS cartoes_fidelidade;
DROP TABLE IF EXISTS telefones_cliente;
DROP TABLE IF EXISTS clientes;
SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================
-- 1. CLIENTES
-- Regra: e-mail do cliente não pode se repetir (UNIQUE)
-- ==========================================
CREATE TABLE clientes (
    cod_cliente  INT AUTO_INCREMENT NOT NULL,
    nome_cliente VARCHAR(120) NOT NULL,
    email        VARCHAR(120) NOT NULL,
    endereco     VARCHAR(200) NOT NULL,
    sexo         CHAR(1) NOT NULL,
    CONSTRAINT pk_clientes PRIMARY KEY (cod_cliente),
    CONSTRAINT uq_clientes_email UNIQUE (email),
    CONSTRAINT chk_clientes_sexo CHECK (sexo IN ('M', 'F'))
);

-- ==========================================
-- 2. TELEFONES_CLIENTE (atributo multivalorado: vários telefones por cliente)
-- ==========================================
CREATE TABLE telefones_cliente (
    cod_telefone INT AUTO_INCREMENT NOT NULL,
    cod_cliente  INT NOT NULL,
    numero       VARCHAR(20) NOT NULL,
    CONSTRAINT pk_telefones_cliente PRIMARY KEY (cod_telefone),
    CONSTRAINT fk_telefones_clientes FOREIGN KEY (cod_cliente)
        REFERENCES clientes (cod_cliente)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT uq_telefone_cliente UNIQUE (cod_cliente, numero)
);

-- ==========================================
-- 3. CARTOES_FIDELIDADE (relacionamento 1:1: FK com UNIQUE)
-- Regra: cada cliente tem no máximo um cartão
-- ==========================================
CREATE TABLE cartoes_fidelidade (
    cod_cartao  INT AUTO_INCREMENT NOT NULL,
    cod_cliente INT NOT NULL,
    pontos      INT NOT NULL DEFAULT 0,
    CONSTRAINT pk_cartoes PRIMARY KEY (cod_cartao),
    CONSTRAINT uq_cartoes_cliente UNIQUE (cod_cliente),
    CONSTRAINT fk_cartoes_clientes FOREIGN KEY (cod_cliente)
        REFERENCES clientes (cod_cliente)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT chk_cartoes_pontos CHECK (pontos >= 0)
);

-- ==========================================
-- 4. CATEGORIAS (1:N com produtos; 3ª FN: categoria sai da tabela produtos)
-- ==========================================
CREATE TABLE categorias (
    cod_categoria  INT AUTO_INCREMENT NOT NULL,
    nome_categoria VARCHAR(80) NOT NULL,
    CONSTRAINT pk_categorias PRIMARY KEY (cod_categoria),
    CONSTRAINT uq_categorias_nome UNIQUE (nome_categoria)
);

-- ==========================================
-- 5. FORNECEDORES
-- ==========================================
CREATE TABLE fornecedores (
    cod_fornecedor  INT AUTO_INCREMENT NOT NULL,
    nome_fornecedor VARCHAR(120) NOT NULL,
    cnpj            CHAR(14) NOT NULL,
    CONSTRAINT pk_fornecedores PRIMARY KEY (cod_fornecedor),
    CONSTRAINT uq_fornecedores_cnpj UNIQUE (cnpj)
);

-- ==========================================
-- 6. PRODUTOS
-- Regras: preço > 0 e estoque nunca negativo
-- ==========================================
CREATE TABLE produtos (
    cod_produto   INT AUTO_INCREMENT NOT NULL,
    nome_produto  VARCHAR(120) NOT NULL,
    cod_categoria INT NOT NULL,
    preco         DECIMAL(10, 2) NOT NULL,
    estoque       INT NOT NULL DEFAULT 0,
    CONSTRAINT pk_produtos PRIMARY KEY (cod_produto),
    CONSTRAINT uq_produtos_nome UNIQUE (nome_produto),
    CONSTRAINT fk_produtos_categorias FOREIGN KEY (cod_categoria)
        REFERENCES categorias (cod_categoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_produtos_preco CHECK (preco > 0),
    CONSTRAINT chk_produtos_estoque CHECK (estoque >= 0)
);

-- ==========================================
-- 7. PRODUTO_FORNECEDOR (N:N com chave primária composta)
-- ==========================================
CREATE TABLE produto_fornecedor (
    cod_produto    INT NOT NULL,
    cod_fornecedor INT NOT NULL,
    custo          DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_produto_fornecedor PRIMARY KEY (cod_produto, cod_fornecedor),
    CONSTRAINT fk_pf_produtos FOREIGN KEY (cod_produto)
        REFERENCES produtos (cod_produto)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_pf_fornecedores FOREIGN KEY (cod_fornecedor)
        REFERENCES fornecedores (cod_fornecedor)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_pf_custo CHECK (custo > 0)
);

-- ==========================================
-- 8. PEDIDOS
-- Regra: todo novo pedido começa 'Pendente' (DEFAULT)
-- ==========================================
CREATE TABLE pedidos (
    cod_pedido     INT AUTO_INCREMENT NOT NULL,
    data_pedido    DATE NOT NULL,
    status_entrega VARCHAR(30) NOT NULL DEFAULT 'Pendente',
    cod_cliente    INT NOT NULL,
    CONSTRAINT pk_pedidos PRIMARY KEY (cod_pedido),
    CONSTRAINT fk_pedidos_clientes FOREIGN KEY (cod_cliente)
        REFERENCES clientes (cod_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_pedidos_status CHECK (status_entrega IN ('Pendente', 'Em rota', 'Entregue'))
);

-- ==========================================
-- 9. ITENS_PEDIDO (N:N pedidos x produtos, PK composta)
-- valor_unitario guarda o preço praticado na data da compra
-- (desnormalização intencional, justificar no relatório)
-- ==========================================
CREATE TABLE itens_pedido (
    cod_pedido     INT NOT NULL,
    cod_produto    INT NOT NULL,
    quantidade     INT NOT NULL,
    valor_unitario DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_itens_pedido PRIMARY KEY (cod_pedido, cod_produto),
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
-- 10. PAGAMENTOS (1:N com pedidos)
-- ==========================================
CREATE TABLE pagamentos (
    cod_pagamento   INT AUTO_INCREMENT NOT NULL,
    cod_pedido      INT NOT NULL,
    forma_pagamento VARCHAR(20) NOT NULL,
    valor           DECIMAL(10, 2) NOT NULL,
    data_pagamento  DATE NOT NULL,
    CONSTRAINT pk_pagamentos PRIMARY KEY (cod_pagamento),
    CONSTRAINT fk_pagamentos_pedidos FOREIGN KEY (cod_pedido)
        REFERENCES pedidos (cod_pedido)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT chk_pagamentos_forma CHECK (forma_pagamento IN ('Pix', 'Cartão', 'Boleto')),
    CONSTRAINT chk_pagamentos_valor CHECK (valor > 0)
);

-- ==========================================
-- ÍNDICES (colunas muito usadas em filtros e junções)
-- ==========================================
CREATE INDEX idx_clientes_nome ON clientes (nome_cliente);
CREATE INDEX idx_pedidos_data ON pedidos (data_pedido);
CREATE INDEX idx_pedidos_cliente ON pedidos (cod_cliente);

-- ==========================================
-- VIEW: total de cada pedido
-- ==========================================
CREATE VIEW vw_total_pedido AS
SELECT p.cod_pedido,
       c.nome_cliente AS cliente,
       p.data_pedido,
       p.status_entrega,
       SUM(i.quantidade * i.valor_unitario) AS total
FROM pedidos p
INNER JOIN clientes c ON c.cod_cliente = p.cod_cliente
INNER JOIN itens_pedido i ON i.cod_pedido = p.cod_pedido
GROUP BY p.cod_pedido, c.nome_cliente, p.data_pedido, p.status_entrega;

-- Conferência (tirar prints para o relatório)
SHOW TABLES;
DESCRIBE clientes;
DESCRIBE itens_pedido;