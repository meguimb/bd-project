-- Qual o nome do retalhista (ou retalhistas) responsáveis pela reposição do maior número de categorias? 
SELECT nome
FROM retalhista
INNER JOIN responsavel_por
ON (retalhista.tin = responsavel_por.tin)
GROUP BY nome_cat
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Qual o nome do ou dos retalhistas que são responsáveis por todas as categorias simples? 
SELECT nome
FROM retalhista
INNER JOIN responsavel_por
ON (retalhista.tin = responsavel_por.tin)
WHERE nome_cat
IN (SELECT nome
    FROM categoria_simples);

-- Quais os produtos (ean) que nunca foram repostos? 
SELECT ean
FROM produto
WHERE produto.ean
NOT IN (SELECT ean
        FROM evento_reposicao);

-- Quais os produtos (ean) que foram repostos sempre pelo mesmo retalhista?
SELECT ean
FROM evento_reposicao
GROUP BY 

