-- 03_consultas.sql : 14 consultas de validação
USE loja_estacio;

-- Consulta 01
-- Pergunta: quais pedidos já foram entregues e custaram mais que o valor mínimo de R$ 500?
-- Conceitos: WHERE com AND (sobre a view)
SELECT cod_pedido, cliente, total
FROM vw_total_pedido
WHERE status_entrega = 'Entregue' AND total > 500
ORDER BY total DESC;

-- Consulta 02
-- Pergunta: quais produtos de Periféricos ou Áudio custam entre 100 e 300 reais?
-- Conceitos: WHERE, BETWEEN, IN
SELECT p.nome_produto, c.nome_categoria, p.preco
FROM produtos p
INNER JOIN categorias c ON c.cod_categoria = p.cod_categoria
WHERE c.nome_categoria IN ('Periféricos', 'Áudio')
  AND p.preco BETWEEN 100 AND 300;

-- Consulta 03
-- Pergunta: quais clientes têm e-mail com "silva" ou nome começando com "Maria"?
-- Conceitos: LIKE, OR
SELECT nome_cliente, email
FROM clientes
WHERE email LIKE '%silva%' OR nome_cliente LIKE 'Maria%';

-- Consulta 04
-- Pergunta: quais clientes não têm cartão de fidelidade?
-- Conceitos: LEFT JOIN + IS NULL
SELECT c.nome_cliente
FROM clientes c
LEFT JOIN cartoes_fidelidade f ON f.cod_cliente = c.cod_cliente
WHERE f.cod_cartao IS NULL;

-- Consulta 05
-- Pergunta: quais são os 5 produtos mais caros?
-- Conceitos: ORDER BY + LIMIT (ranking)
SELECT nome_produto, preco
FROM produtos
ORDER BY preco DESC
LIMIT 5;

-- Consulta 06
-- Pergunta: quantos pedidos existem em cada status de entrega?
-- Conceitos: COUNT + GROUP BY
SELECT status_entrega, COUNT(*) AS total_pedidos
FROM pedidos
GROUP BY status_entrega;

-- Consulta 07
-- Pergunta: qual o faturamento, o ticket médio e o maior item por categoria?
-- Conceitos: SUM, AVG, MAX + GROUP BY + JOIN de 3 tabelas
SELECT c.nome_categoria,
       SUM(i.quantidade * i.valor_unitario) AS faturamento,
       ROUND(AVG(i.valor_unitario), 2)      AS preco_medio,
       MAX(i.valor_unitario)                AS maior_valor
FROM itens_pedido i
INNER JOIN produtos p ON p.cod_produto = i.cod_produto
INNER JOIN categorias c ON c.cod_categoria = p.cod_categoria
GROUP BY c.nome_categoria
ORDER BY faturamento DESC;

-- Consulta 08
-- Pergunta: quais clientes gastaram mais de R$ 1.000 no total?
-- Conceitos: HAVING + JOIN de 3 tabelas
SELECT c.nome_cliente, SUM(i.quantidade * i.valor_unitario) AS total_gasto
FROM clientes c
INNER JOIN pedidos p ON p.cod_cliente = c.cod_cliente
INNER JOIN itens_pedido i ON i.cod_pedido = p.cod_pedido
GROUP BY c.nome_cliente
HAVING SUM(i.quantidade * i.valor_unitario) > 1000
ORDER BY total_gasto DESC;

-- Consulta 09
-- Pergunta: quais produtos foram vendidos, para quem e em qual data?
-- Conceitos: INNER JOIN com 4 tabelas
SELECT cl.nome_cliente, pr.nome_produto, i.quantidade, p.data_pedido
FROM itens_pedido i
INNER JOIN pedidos p ON p.cod_pedido = i.cod_pedido
INNER JOIN clientes cl ON cl.cod_cliente = p.cod_cliente
INNER JOIN produtos pr ON pr.cod_produto = i.cod_produto
WHERE p.data_pedido >= '2026-11-01'
ORDER BY p.data_pedido, cl.nome_cliente;

-- Consulta 10
-- Pergunta: quais produtos nunca foram vendidos?
-- Conceitos: LEFT JOIN + IS NULL
SELECT pr.nome_produto
FROM produtos pr
LEFT JOIN itens_pedido i ON i.cod_produto = pr.cod_produto
WHERE i.cod_pedido IS NULL;

-- Consulta 11
-- Pergunta: quais itens foram vendidos por valor acima da média geral dos itens?
-- Conceitos: subconsulta
SELECT pr.nome_produto, i.valor_unitario
FROM itens_pedido i
INNER JOIN produtos pr ON pr.cod_produto = i.cod_produto
WHERE i.valor_unitario > (SELECT AVG(valor_unitario) FROM itens_pedido)
ORDER BY i.valor_unitario DESC;

-- Consulta 12
-- Pergunta: quais pedidos ainda não foram entregues, com cliente e total?
-- Conceitos: consulta sobre VIEW
SELECT cod_pedido, cliente, data_pedido, status_entrega, total
FROM vw_total_pedido
WHERE status_entrega != 'Entregue'
ORDER BY data_pedido;

-- Consulta 13
-- Pergunta: quais pedidos não possuem nenhum pagamento registrado?
-- Conceitos: LEFT JOIN + IS NULL
SELECT p.cod_pedido, p.data_pedido, p.status_entrega
FROM pedidos p
LEFT JOIN pagamentos g ON g.cod_pedido = p.cod_pedido
WHERE g.cod_pagamento IS NULL
ORDER BY p.cod_pedido;

-- Consulta 14 (valorização)
-- Pergunta: qual a margem de cada produto, comparando preço de venda e menor custo de fornecedor?
-- Conceitos: JOIN com tabela de PK composta, MIN, CASE WHEN
SELECT pr.nome_produto,
       pr.preco,
       MIN(pf.custo) AS menor_custo,
       ROUND((pr.preco - MIN(pf.custo)) / pr.preco * 100, 1) AS margem_percentual,
       CASE
           WHEN (pr.preco - MIN(pf.custo)) / pr.preco >= 0.30 THEN 'Alta'
           ELSE 'Normal'
       END AS faixa_margem
FROM produtos pr
INNER JOIN produto_fornecedor pf ON pf.cod_produto = pr.cod_produto
GROUP BY pr.cod_produto, pr.nome_produto, pr.preco
ORDER BY margem_percentual DESC;